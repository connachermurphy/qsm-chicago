import numpy as np
import pandas as pd


def calc_real_wage_hat(w_hat, kappa_hat):
    """
    Calculate changes in real wages
    Arguments:
        w_hat: wage changes
        kappa_hat: commuting cost changes
    """

    return w_hat / kappa_hat


def calc_sub_phi_hat(theta, w_hat, kappa_hat):
    """
    Scale the changes in real wages by theta
    Arguments:
        theta: preference shock dispersion parameter
        w_hat: wage changes
        kappa_hat: commuting cost changes
    """
    real_wage_hat = calc_real_wage_hat(w_hat, kappa_hat)

    return np.power(real_wage_hat, theta)


def calc_Phi_hat(theta, pi_cond_init, w_hat, kappa_hat):
    """
    Calculate Phi_hat
    Arguments:
        theta: preference shock dispersion parameter
        pi_cond_init: conditional commuting probabilities
        w_hat: wage changes
        kappa_hat: commuting cost changes
    """
    sub_phi_hat = calc_sub_phi_hat(theta, w_hat, kappa_hat)

    return np.sum(pi_cond_init * sub_phi_hat, axis=1, keepdims=True)


def calc_pi_cond_hat(theta, pi_cond_init, w_hat, kappa_hat):
    """
    Calculate pi_cond_hat
    Arguments:
        theta: preference shock dispersion parameter
        pi_cond_init: conditional commuting probabilities
        w_hat: wage changes
        kappa_hat: commuting cost changes
    """
    sub_phi_hat = calc_sub_phi_hat(theta, w_hat, kappa_hat)
    Phi_hat = calc_Phi_hat(theta, pi_cond_init, w_hat, kappa_hat)

    return sub_phi_hat / Phi_hat


def calc_L_hat_supply(theta, pi_cond_init, w_hat, kappa_hat, R_hat, R_init, L_init):
    """
    Calculate changes in labor supply
    Arguments:
        theta: preference shock dispersion parameter
        pi_cond_init: conditional commuting probabilities
        w_hat: wage changes
        kappa_hat: commuting cost changes
        R_hat: residential population changes
        R_init: residential population
        L_init: workplace population
    """
    pi_cond_hat = calc_pi_cond_hat(theta, pi_cond_init, w_hat, kappa_hat)

    L_hat_supply = (
        np.sum(pi_cond_init * R_init * pi_cond_hat * R_hat, axis=0, keepdims=True)
        / L_init
    )

    return L_hat_supply


def calc_Z(w_tilde, theta, beta, pi_cond_init, R_init, L_init, A_hat, kappa_hat, R_hat):
    """
    Calculate calligraphic Z for candidate wage changes
    Arguments:
        w_tilde: candidate wage changes
        theta: preference shock dispersion parameter
        beta: elasticity of output with respect to labor
        pi_cond_init: conditional commuting probabilities
        R_init: residential population
        L_init: workplace population
        A_hat: productivity changes
        kappa_hat: commuting cost changes
        R_hat: residential population changes
    """

    L_hat_demand = np.power(A_hat / w_tilde, 1 / (1 - beta))

    L_hat_supply = calc_L_hat_supply(
        theta, pi_cond_init, w_tilde, kappa_hat, R_hat, R_init, L_init
    )

    return L_hat_demand - L_hat_supply


def solve_counterfactual(
    num_nbhd, theta, alpha, pi_cond_init, R_init, L_init, A_hat, kappa_hat, R_hat
):
    """
    Solve for a counterfactual equilibrium with the exact hat system
    Arguments:
        num_nbhd: number of neighborhoods
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_cond_init: conditional commuting probabilities
        R_init: residential population
        L_init: workplace population
        A_hat: productivity changes
        kappa_hat: commuting cost changes
        R_hat: residential population changes
    """
    w_tilde = np.ones((1, num_nbhd))  # initial guess for wage changes
    i = 0  # iteration counter
    error = 1.0  # initialize error
    tol = 1e-10  # error tolerance
    kappa = 0.1  # step size

    while error > tol:  # iterate until error is below tolerance
        Z = calc_Z(
            w_tilde, theta, alpha, pi_cond_init, R_init, L_init, A_hat, kappa_hat, R_hat
        )

        w_tilde = w_tilde + (Z * kappa)  # update wage

        error = np.absolute(Z).max()  # calculate error
        print("Step", i, "error:", round(error, 10))
        i += 1

    return w_tilde


def summarize_counterfactual(
    num_nbhd,
    neighborhoods_shp,
    w_hat,
    theta,
    pi_cond_init,
    kappa_hat,
    R_hat,
    R_init,
    L_init,
):
    """
    Summarize exact hat results of counterfactual simulation
    Arguments:
        num_nbhd: number of neighborhoods
        neighborhoods_shp: geopandas dataframe of neighborhoods
        w_hat: wage changes
        theta: preference shock dispersion parameter
        pi_cond_init: conditional commuting probabilities
        kappa_hat: commuting cost changes
        R_hat: residential population changes
        R_init: residential population
        L_init: workplace population
    """
    L_hat = calc_L_hat_supply(
        theta, pi_cond_init, w_hat, kappa_hat, R_hat, R_init, L_init
    )
    U_hat = np.power(calc_Phi_hat(theta, pi_cond_init, w_hat, kappa_hat), 1 / theta)
    df_hat = pd.DataFrame(  # stack wage and productivity changes into a dataframe
        np.column_stack(
            (
                w_hat.reshape((num_nbhd)),
                L_hat.reshape((num_nbhd)),
                U_hat.reshape((num_nbhd)),
            )
        ),
        columns=["w_hat", "L_hat", "U_hat"],
    )

    df_hat["id"] = df_hat.index + 1

    df_hat_shp = neighborhoods_shp.merge(  # merge with geopandas df
        df_hat, on="id"
    )

    return df_hat_shp
