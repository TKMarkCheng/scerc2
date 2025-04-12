import numpy as np
import pandas as pd
from pymare import core, estimators, stats
from pymare.estimators import VarianceBasedLikelihoodEstimator, SampleSizeBasedLikelihoodEstimator
from pymare.stats import var_to_ci
import seaborn as sns
import math
sns.set_style("whitegrid")
pd.set_option("display.max_columns", 14)
pd.set_option("display.max_rows", 204)

file = pd.read_csv('raw_data.csv')

def meta(cohort, outcome, statistic, determine_var_from, covid_strain='any', log_transform=False, show_data=False):
    from math import log
    
    # If standard errors are given for the natural logarithm of the effect size, then log_transform = True
    # If standard error is given for the absolute effect size, then log_transform = False
    #Statistic can be either 'OR' or 'HR'
    
    df = pd.DataFrame(file[['Reference',
                            'Cohort',
                            'outcome',
                            'statistic',
                            'value',
                            'se',
                            'n',
                            'ncancer',
                            'ncontrol',
                            'vax50',
                            'wt',
                            'alpha',
                            'delta',
                            'omicron']])
    statistic_options = ['or','OR','hr','HR']
    if statistic not in statistic_options:
        raise ValueError("Invalid statistic. Expected one of: %s" % statistic_options)
    
    if statistic.lower()=='or':
        statistic = 'mor'
        method_output = 'Odds Ratio'
    elif statistic.lower()=='hr':
        statistic = 'mhr'
        method_output = 'Hazard Ratio'
        
    covid_strain_options = ['wt','alpha','delta','omicron','any']
    if covid_strain not in covid_strain_options:
        raise ValueError("Invalid covid strain. Expected one of: %s" % covid_strain_options)
    
    cohort_display = 0
    while cohort_display == 0:
        if covid_strain == 'any':
            selection_df = df[((df.Cohort == cohort) & (df.outcome == outcome) & (df.statistic==statistic))]
            cohort_display = cohort
        elif covid_strain == 'wt':
            selection_df = df[((df.Cohort == 'Total Cancer Cohort') & (df.wt == 'Yes') & (df.outcome == outcome) & (df.statistic==statistic))]
            cohort_display = 'Wild-Type'
        elif covid_strain == 'alpha':
            selection_df = df[((df.Cohort == 'Total Cancer Cohort') & (df.alpha == 'Yes') & (df.outcome == outcome) & (df.statistic==statistic))]
            cohort_display = 'Alpha'
        elif covid_strain == 'delta':
            selection_df = df[((df.Cohort == 'Total Cancer Cohort') & (df.delta == 'Yes') & (df.outcome == outcome) & (df.statistic==statistic))]
            cohort_display = 'Delta'
        elif covid_strain == 'omicron':
            selection_df = df[((df.Cohort == 'Total Cancer Cohort') & (df.omicron == 'Yes') & (df.outcome == outcome) & (df.statistic==statistic))]
            cohort_display = 'Omicron'
    
    outcome_label = outcome
    
    list_es = []
    for x in range(len(selection_df.values)):
        rowx = selection_df.values[x][selection_df.columns.get_loc("value")]
        list_es.append(rowx)
        
    array_es = np.array(list_es)
    
    if log_transform == True:
        array_lnes = np.log(array_es)
        es = array_lnes
        
    elif log_transform == False:
        es = array_es
    
    list_se = []
    for x in range(len(selection_df.values)):
        rowx = selection_df.values[x][selection_df.columns.get_loc("se")]
        list_se.append(rowx)
    array_se = np.array(list_se)
    
    list_n = []
    for x in range(len(selection_df.values)):
        rowx = selection_df.values[x][selection_df.columns.get_loc("n")]
        list_n.append(rowx)
    array_n = np.array(list_n)
    
    determine_var_from_options = ['se','n']
    if determine_var_from not in determine_var_from_options:
        raise ValueError("Invalid determine_var_from. Expected one of: %s" % determine_var_from_options)
    
    if determine_var_from == 'se':
        dataset = core.Dataset(es, array_se)
        estimator = VarianceBasedLikelihoodEstimator(method='reml')
    elif determine_var_from =='n':
        dataset = core.Dataset(es, n=array_n)
        estimator = SampleSizeBasedLikelihoodEstimator(method='reml')
    
    estimator.fit_dataset(dataset)
    estimator_summary = estimator.summary()
    het = estimator_summary.get_heterogeneity_stats()
    Q = het['Q'].item
    p_value = het['p(Q)'].item
    I2 = het['I^2'].item
    
    results = estimator_summary.to_df(alpha=0.05).T
    estimate = results.loc['estimate'].iat[0]
    se_output = results.loc['se'].iat[0]
    upper = estimate + 1.95996 * se_output
    lower = estimate - 1.95996 * se_output
    estimate = math.e**(estimate)
    estimate = format(estimate,'.2f')
    lower = format(math.e**lower,'.2f')
    upper = format(math.e**upper,'.2f')

    if show_data==False:
        selection_df_display = selection_df.iloc[0:0]
    elif show_data==True:
        selection_df_display = selection_df
        
    print(f'{method_output} of {outcome_label} in {cohort_display} = {estimate} [{lower}-{upper}]')
    print(f'Number of study arms: {selection_df.shape[0]}')
    
    p_formatted = float(format(p_value(),'.2f'))
    if p_formatted < 0.01:
        p_formatted = ".01"
        sign = '<'
    else:
        p_formatted = str(p_formatted)[1::]
        sign = "="
    
    Q_calc = selection_df.shape[0] / (1- (I2()/100))
    print(f"Heterogeneity: X²({selection_df.shape[0]-1}), p{sign}{p_formatted}")
    print(" ")
    return selection_df_display
    
def show_data():
    
    return pd.DataFrame(file[['Reference',
                              'Cohort',
                              'outcome',
                              'statistic',
                              'value',
                              'se',
                              'n',
                              'ncancer',
                              'ncontrol',
                              'vax50',
                              'wt',
                              'alpha',
                              'delta',
                              'omicron']])
