import numpy as np
import pandas as pd


def calc_sub_phi_hat(theta, alpha, w_hat, q_hat, kappa_hat, B_hat):
    """
    Calculate small phi
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
    """
    sub_phi_hat = (
        np.power(w_hat * np.power(q_hat, alpha - 1) / kappa_hat, theta) * B_hat
    )

    return sub_phi_hat


def calc_pi_hat(theta, alpha, pi_init, w_hat, q_hat, kappa_hat, B_hat):
    """
    Calculate change in unconditional commuting probabilities
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_init: unconditional commuting probabilities
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
    """
    sub_phi_hat = calc_sub_phi_hat(theta, alpha, w_hat, q_hat, kappa_hat, B_hat)
    pi_hat = sub_phi_hat / np.sum(pi_init * sub_phi_hat)

    return pi_hat


def calc_R_hat(
    theta, alpha, pi_init, R_init, R_bar_init, w_hat, q_hat, kappa_hat, B_hat, R_bar_hat
):
    """
    Calculate change in residential population
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_init: unconditional commuting probabilities
        R_init: residential population
        R_bar_init: population
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
        R_bar_hat: population change
    """
    pi_hat = calc_pi_hat(theta, alpha, pi_init, w_hat, q_hat, kappa_hat, B_hat)

    R_hat = (
        np.sum(pi_init * pi_hat, axis=1, keepdims=True)
        * R_bar_init
        * R_bar_hat
        / R_init
    )

    return R_hat


def calc_L_hat_supply(
    theta, alpha, pi_init, L_init, R_bar_init, w_hat, q_hat, kappa_hat, B_hat, R_bar_hat
):
    """
    Calculate change in labor supply
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_init: unconditional commuting probabilities
        L_init: workplace population
        R_bar_init: population
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
        R_bar_hat: population change
    """
    pi_hat = calc_pi_hat(theta, alpha, pi_init, w_hat, q_hat, kappa_hat, B_hat)

    L_hat = (
        np.sum(pi_init * pi_hat, axis=0, keepdims=True)
        * R_bar_init
        * R_bar_hat
        / L_init
    )

    return L_hat


def calc_agg_income_hat(
    theta,
    alpha,
    pi_init,
    w_init,
    w_hat,
    q_hat,
    kappa_hat,
    B_hat,
    R_bar_hat,
):
    """
    Calculate change in aggregate neighborhood income
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_init: unconditional commuting probabilities
        w_init: wages
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
        R_bar_hat: population change
    """
    pi_hat = calc_pi_hat(theta, alpha, pi_init, w_hat, q_hat, kappa_hat, B_hat)

    agg_income_hat = (
        R_bar_hat
        * np.sum(pi_init * pi_hat * w_init * w_hat, axis=1, keepdims=True)
        / np.sum(pi_init * w_init, axis=1, keepdims=True)
    )

    return agg_income_hat


def calc_q_hat(
    theta,
    alpha,
    pi_init,
    w_init,
    w_hat,
    q_hat,
    kappa_hat,
    B_hat,
    L_bar_hat,
    H_hat,
):
    """
    Calculate change in rents
    Arguments:
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        pi_init: unconditional commuting probabilities
        w_init: wages
        w_hat: wage changes
        q_hat: rent changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
        L_bar_hat: population change
        H_hat: housing stock changes
    """
    agg_income_hat = calc_agg_income_hat(
        theta, alpha, pi_init, w_init, w_hat, q_hat, kappa_hat, B_hat, L_bar_hat
    )

    q_hat = agg_income_hat / H_hat

    return q_hat


def calc_Z(
    w_tilde,
    q_tilde,
    theta,
    alpha,
    beta,
    pi_init,
    L_init,
    R_bar_init,
    A_hat,
    kappa_hat,
    B_hat,
    R_bar_hat,
):
    """
    Calculate calligraphic Z for candidate wage changes
    Arguments:
        w_tilde: candidate wage changes
        q_tilde: candidate rent changes
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        beta: elasticity of output with respect to labor
        pi_init: unconditional commuting probabilities
        L_init: workplace population
        R_bar_init: initial population
        A_hat: productivity changes
        kappa_hat: commuting cost changes
        H_hat: housing stock changes
    """

    demand_term = np.power(A_hat / w_tilde, 1 / (1 - beta))

    supply_term = calc_L_hat_supply(
        theta,
        alpha,
        pi_init,
        L_init,
        R_bar_init,
        w_tilde,
        q_tilde,
        kappa_hat,
        B_hat,
        R_bar_hat,
    )

    return demand_term - supply_term


def solve_counterfactual(
    num_nbhd,
    theta,
    alpha,
    beta,
    pi_init,
    w_init,
    L_init,
    R_bar_init,
    A_hat,
    kappa_hat,
    B_hat,
    R_bar_hat,
    H_hat,
):
    """
    Solve for a counterfactual equilibrium with the exact hat system
    Arguments:
        num_nbhd: number of neighborhoods
        theta: preference shock dispersion parameter
        alpha: final good consumption share
        beta: elasticity of output with respect to labor
        pi_init: initial unconditional commuting probabilities
        L_init: initial workplace population
        R_bar_init: initial population
        A_hat: productivity changes
        kappa_hat: commuting cost changes
        B_hat: bilateral amenity changes
        R_bar_hat: population change
    """
    w_tilde = np.ones((1, num_nbhd))  # initial guess for wage changes
    q_tilde = np.ones((num_nbhd, 1))

    i = 0  # iteration counter
    error = 1.0  # initialize error
    tol = 1e-10  # error tolerance
    kappa = 0.1  # step size

    while error > tol:  # iterate until error is below tolerance
        Z = calc_Z(
            w_tilde,
            q_tilde,
            theta,
            alpha,
            beta,
            pi_init,
            L_init,
            R_bar_init,
            A_hat,
            kappa_hat,
            B_hat,
            R_bar_hat,
        )

        q_tilde_guess = calc_q_hat(
            theta,
            alpha,
            pi_init,
            w_init,
            w_tilde,
            q_tilde,
            kappa_hat,
            B_hat,
            R_bar_hat,
            H_hat,
        )

        w_tilde = w_tilde + (Z * kappa)  # update wage
        q_tilde = ((1 - kappa) * q_tilde) + (q_tilde_guess * kappa)

        error = np.absolute(Z).max()  # calculate error
        print("Step", i, "error:", round(error, 10))
        i += 1

    return w_tilde, q_tilde


def summarize_counterfactual(num_nbhd, neighborhoods_shp, w_hat, q_hat):
    df_hat = pd.DataFrame(  # stack wage and productivity changes into df
        np.column_stack(
            (w_hat.reshape((num_nbhd)), q_hat.reshape((num_nbhd)))
        ),
        columns=["w_hat", "q_hat"],
    )

    df_hat["id"] = df_hat.index + 1

    df_hat_shp = neighborhoods_shp.merge(  # merge with shapefile
        df_hat, on="id"
    )

    return df_hat_shp