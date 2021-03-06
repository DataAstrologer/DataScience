# Census Income Analysis

The **Census_Income_Analysis.ipynb** file above contains the Python code for the entire modeling process, with observations, outputs and visualizations. The dataset is downloaded from the link: https://archive.ics.uci.edu/ml/machine-learning-databases/adult/ 

# Project Workflow & Data Dictionary

The modeling approach has been broken down into the following steps:
![project workflow](./Data/census_data_workflow.JPG)

Listing of attributes/features in the dataset and their description:
* age: continuous.
* workclass: Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked.
* fnlwgt: continuous.
* education: Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool.
* education-num: continuous.
* marital-status: Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse.
* occupation: Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces.
* relationship: Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried.
* race: White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black.
* sex: Female, Male.
* capital-gain: continuous.
* capital-loss: continuous.
* hours-per-week: continuous.
* native-country: United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, Hong, Holand-Netherlands.
* salary: >50K, <=50K.
* **?: missing values**

# Prediction & Accuracy
![Prediction and Accuracy](./Data/accuracy.JPG)

# Improvements/Future Work
* Feature selection & importance testing using statistical techniques (such as chi-sq or correlation based feature selection).
* Fitting different classification models (SVM, Decision Tree, KNN, etc.) and comparing accuracy.
* Examining more feature interactions (such as education vs. education_num) to eliminate un-wanted variables.
* Ensemble modeling & handling of class imbalance (over-sampling or under-sampling).
* Hyper-parameter tuning based on different score criterions & model stability evaluation.