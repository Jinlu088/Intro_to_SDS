import pandas as pd
import os
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
from matplotlib.patches import Patch
from matplotlib.lines import Line2D
import seaborn as sns

csfont = {'fontname': 'Arial'}

def gender_over_time(gender_time_df):
    """ Create a figure to plot gender over time

        Input: a dataframe with percentages, index as years
        Output: A .pdf of the figure
    """

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 7))
    color = ['#377eb8', '#ffb94e']
    ax1.plot(gender_time_df.index, gender_time_df['pc_detect_fem_10_lower'] * 100,
             color=color[1], linewidth=0.3, linestyle='--', dashes=(12, 6))
    ax1.plot(gender_time_df.index, gender_time_df['pc_detect_fem_10_upper'] * 100,
             color=color[1], linewidth=0.3, linestyle='--', dashes=(12, 6))
    ax1.plot(gender_time_df.index, gender_time_df['pc_detect_fem_10'] * 100, color=color[0])
    ax2.plot(gender_time_df.index, gender_time_df['pc_guess_fem_10_lower'] * 100,
             color=color[1], linewidth=0.3, linestyle='--', dashes=(12, 6))
    ax2.plot(gender_time_df.index, gender_time_df['pc_guess_fem_10_upper'] * 100,
             color=color[1], linewidth=0.3, linestyle='--', dashes=(12, 6))
    ax2.plot(gender_time_df.index, gender_time_df['pc_guess_fem_10'] * 100, color=color[0])

    for ax in [ax1, ax2]:
        ax.set_ylim(7.5, 55)
        ax.set_xlim(1951, 2020)
        ax.spines['bottom'].set_bounds(1955, 2020)
        ax.spines['left'].set_bounds(10, 55)
        ax.yaxis.set_major_formatter(mtick.PercentFormatter(decimals=0))
        ax.xaxis.grid(linestyle='--', alpha=0.2)
        ax.yaxis.grid(linestyle='--', alpha=0.2)
        ax.set_ylabel('Female Authorship: Ten Year Rolling Interval', **csfont, fontsize=13)

    ax1.set_title('A.', fontsize=24, loc='left', y=1.035, x=0, **csfont)
    ax2.set_title('B.', fontsize=24, loc='left', y=1.035, x=0, **csfont);

    ax2.fill_between(gender_time_df.index.to_list(),
                     gender_time_df['pc_guess_fem_10_lower'].astype(float) * 100,
                     gender_time_df['pc_guess_fem_10_upper'].astype(float) * 100,
                     alpha=0.2, color=color[1])
    ax1.fill_between(gender_time_df.index.to_list(),
                     gender_time_df['pc_detect_fem_10_lower'].astype(float) * 100,
                     gender_time_df['pc_detect_fem_10_upper'].astype(float) * 100,
                     alpha=0.2, color=color[1])
    legend_elements = [Line2D([0], [0], color=color[0], lw=1,
                              label='Detector: F/(M+F)', alpha=1),
                       Patch(facecolor=(255 / 255, 185 / 255, 78 / 255, 0.3),
                             lw=0.5, label="Detector: CI's", edgecolor=(0, 0, 0, 1))]
    ax1.legend(handles=legend_elements, loc='upper left', frameon=False,
               fontsize=12)
    legend_elements = [Line2D([0], [0], color=color[0], lw=1,
                              label='Guesser: F/(M+F)', alpha=1),
                       Patch(facecolor=(255 / 255, 185 / 255, 78 / 255, 0.3),
                             lw=0.5, label="Guesser: CI's", edgecolor=(0, 0, 0, 1))]
    ax2.legend(handles=legend_elements, loc='upper left', frameon=False,
               fontsize=12)

    sns.despine()
    plt.tight_layout(pad=3)
    fig_path = os.path.join(os.getcwd(), '..', 'figures')
    plt.savefig(os.path.join(fig_path, 'gender_over_time.png'),
                bbox_inches='tight')

if __name__ == '__main__':
    gender_time_df = pd.read_csv(os.path.join(os.getcwd(), '..', 'data',
                                 'gender_over_time.csv'), index_col=0)
gender_over_time(gender_time_df)
