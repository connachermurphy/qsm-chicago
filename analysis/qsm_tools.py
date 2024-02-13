import pandas as pd
import numpy as np
import geopandas as gpd
import matplotlib.pyplot as plt


def calibrate():
    """
    Return objects for calibrating the QSMs
    """
    # Read commuting flows from csv
    flows_pd = pd.read_csv("../data/chi_flows_nbhd_matrix.csv")

    # Convert to numpy array
    flows = flows_pd.values[:, 1:]

    num_nbhd = flows.shape[0]  # number of neighborhoods

    # Calculate population by workplace and residence
    residents = np.sum(flows, axis=1, keepdims=True)  # residence
    workers = np.sum(flows, axis=0, keepdims=True)  # workplace
    R_bar = np.sum(residents)  # total employment

    # Normalize by residential population to get conditional commuting probabilities
    pi = flows / np.sum(flows)
    pi_cond = flows / residents

    # Import Chicago neighborhoods characteristics
    char_pd = pd.read_csv("../data/chi_nbhd_char.csv")

    # Identify neighborhood clusters
    neighborhoods_pd = pd.read_csv("../data/id_nbhd.csv").merge(char_pd, on="community")

    far_southeast_indices = (
        neighborhoods_pd[neighborhoods_pd["far_southeast"] == 1]["id"].values - 1
    )

    employment_core_indices = (
        neighborhoods_pd[neighborhoods_pd["employment_core"] == 1]["id"].values - 1
    )

    # Extract wage index
    wages = np.array(neighborhoods_pd.sort_values(by="id")["wrk_wage"].values).reshape(
        (1, num_nbhd)
    )

    # Import Chicago neighborhoods shapefile
    neighborhoods_shp = gpd.read_file("../data/neighborhoods").merge(
        neighborhoods_pd, on="community"
    )

    # Parameter values
    theta = 6.83  # from Ahlfeldt et al. (2015)
    alpha = 0.67  # non-housing share
    beta = 0.6  # labor share

    return (
        pi,
        pi_cond,
        residents,
        workers,
        R_bar,
        wages,
        num_nbhd,
        far_southeast_indices,
        employment_core_indices,
        neighborhoods_shp,
        theta,
        alpha,
        beta,
    )


def map(shp, var, vmin, vmax, title, filename):
    """
    Create a map of a variable
        shp: geopandas dataframe
        var: variable to map
        vmin: minimum value for color scale
        vmax: maximum value for color scale
        title: panel title
        filename: name of the output file
    """
    shp.plot(
        column=var,
        legend=True,
        edgecolor="lightslategray",
        linewidth=0.5,
        vmin=vmin,
        vmax=vmax,
        cmap="cividis",
        # cmap="inferno",
    )
    plt.xticks([])
    plt.yticks([])
    plt.title(title)
    plt.tight_layout(pad=0)
    plt.savefig(f"../out/{filename}.png", bbox_inches="tight")
    plt.show()


def compare_maps(shp_list, var, panel_titles, filenames):
    """
    Create a series of maps for comparison (with a common color scale)
        shp_list: list of geopandas dataframes
        var: variable to map
        panel_titles: list of panel titles
        filenames: list of output file names
    """

    # Find bounds
    vmin = min(shp[var].min() for shp in shp_list)
    vmax = min(shp[var].max() for shp in shp_list)

    # Create maps
    for i in range(len(shp_list)):
        map(shp_list[i], var, vmin, vmax, panel_titles[i], f"{var}_{filenames[i]}")
