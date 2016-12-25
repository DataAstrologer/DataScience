# Regression

The main goal of regression is to **model the joint relationship** between the dependent variable (response variable, target variable, or *Y*), which is **quantitative**, and the independent variables (features, inputs, predictors, or *X*), using the function:

![](https://latex.codecogs.com/gif.latex?Y%20%3D%20f%28X%29%20&plus;%20e)
                                        
Here, *X* is a column vector containing *p* features, as shown below:

![](https://latex.codecogs.com/gif.latex?%24%24%5Cmathbf%7BX%7D%20%3D%20%5Cleft%28%5Cbegin%7Barray%7D%20%7Brrr%7D%20X_1%20%5C%5C%20X_2%5C%5C%20.%20%5C%5C%20.%20%5C%5C%20X_p%20%5Cend%7Barray%7D%5Cright%29%20%24%24)

Since our function *f(X)* is never going to model *Y* perfectly, the error term *e* captures the measurement errors and other discrepancies.

Using the above regression model, we can understand:
* The relevant and important predictors *Xp* explaining *Y* 
* How each component *Xp* affects *Y*

## Understanding Regression Modeling

To understand how regression models work, let’s analyze a simple scenario involving only *one* independent and dependent variable having a relationship as seen in the plot below (the plot is assumed to represent a very large population):

![](./data/images/fun_1.png)

Since the function *Y = f(X) + e* can deliver only *one* value of *Y* for a given *X*, the function at a value of *X* returns the **expected value (average)** of *Y* given *X = x*. As an example, for *x = 4*, the average of the points (*y*) coinciding with the vertical line are returned. Thus, in a regression model, the regression function gives the conditional expectation (or average) of *Y* given *X*, at each value of *X*. 

The same idea is now extended to functions having more independent variables (a vector *X*). For example, if *X* has 3 components, then *Y* will be the conditional expectation given 3 instances of the 3 components of *X*:

![](https://latex.codecogs.com/gif.latex?f%28X%29%20%3D%20f%28X_1%2C%20X_2%2C%20X_3%29%20%3D%20E%28Y%20%7C%20X_1%20%3D%20x_1%2C%20X_2%20%3D%20x_2%2C%20X_3%20%3D%20x_3%29)

Since the function *Y = f(X) + e* can deliver only *one* value of *Y* for a given *X*, the function at a value of *X* returns the **expected value (average)** of *Y* given *X = x*. As an example, for *x = 4*, the average of the points (*y*) coinciding with the vertical line are returned. Thus, in a regression model, the regression function gives the conditional expectation (or average) of *Y* given *X*, at each value of *X*. 

The same idea is now extended to functions having more independent variables (a vector *X*). For example, if *X* has 3 components, then *Y* will be the conditional expectation given 3 instances of the 3 components of *X*:

![](https://latex.codecogs.com/gif.latex?f%28X%29%20%3D%20f%28X_1%2C%20X_2%2C%20X_3%29%20%3D%20E%28Y%20%7C%20X_1%20%3D%20x_1%2C%20X_2%20%3D%20x_2%2C%20X_3%20%3D%20x_3%29)

For any *f-hat(x)*, the MSPE above can be decomposed into two terms:

![](https://latex.codecogs.com/gif.latex?MSPE%20%3D%20E%20%5B%28Y%20-%20%5Chat%7Bf%7D%28x%29%29%5E2%20%7C%20X%20%3D%20x%5D%20%3D%20%5Bf%28x_i%29-%20%5Chat%7Bf%7D%28x_i%29%5D%5E2%20&plus;%20Var%28%5Cepsilon%29)

* **Reducible**: Squared-difference between the estimate *f-hat(x)* and *f(x)*
* **Irreducible**: Variance of the error *𝑉𝑎𝑟(∈)*

To understand the proof of the above decomposition, visit (page no. 3) of the document in the link: http://www.cs.uu.nl/docs/vakken/lfd/biasvar.pdf. In order to improve our model, we can only minimize the MSPE by improving the reducible term.


## Local Averaging

Conditional averaging might not always work because at any given point in our dataset, we might not have any points to average. An example plot for such a situation is shown below:

![](./data/images/fun_2.png)

In the plot above, the solid green point has no exact values for *x*. Thus we have to relax the idea of conditional averaging  (taking the avergae of the points coninciding with the vertical line) to the **neighborhood of points *x* **, which are the points around the target point. This is called **Local Averaging**. In the plot above, the dotted lines show the points considered when averaging (local). This is a flexible technique for fitting the function.

This technique, however, works only when the number of **predictors are < 4**. This is because **nearest neighbors tend to be far away in high dimensions** (this is known as the **curse of dimensionality**). For large number of predictors, we will need to average a larger number of points in each neighborhood so that the estimate has a reasonably small variance.  However, to capture more points for averaging in higher dimensions, the neighborhood points maybe less local (farther away). Thus, it is really hard to find near neighborhood points in high dimensions and stay local. As a result more sophisticated techniques are required for dealing with higher dimensions of data. 

## Structured Modeling

To deal with the curse of dimensionality, we use the following structured models to fit the data:

**Linear Model:** A linear model has *p* features (predictors) and *p+1* parameters. The function *f(X)* is approximated by a linear function.

![](https://latex.codecogs.com/gif.latex?f_l%28X%29%20%3D%20%5Cbeta_0%20&plus;%20%5Cbeta_1X_1%20&plus;%20%5Cbeta_2X_2%20&plus;%20...%20&plus;%20%5Cbeta_pX_p)

This structured model avoids the curse of dimensionality since it does not rely on any local properties or nearest neighbor averaging. A linear model often serves as a good and interpretable approximation to the unknown true function *f(X)*, however, might not be highly accurate.

**Polynomial Model:** A polynomial model is a form of linear model in which the relationship between *X* (predictor) and *Y* (response) is modeled as an **nth degree** polynomial. 

![](https://latex.codecogs.com/gif.latex?f_p%28X%29%20%3D%20%5Cbeta_0%20&plus;%20%5Cbeta_1X%5E1&plus;%20%5Cbeta_2X%5E2%20&plus;%20..%20&plus;%20%5Cbeta_pX%5Ep)

An example of the Polynomial Model is the Quadratic model. Here, the linear model is augmented to include a quadratic term in order to fit the data better. The Quadratic model is given by the equation:

![](https://latex.codecogs.com/gif.latex?f_q%28X%29%20%3D%20%5Cbeta_0%20&plus;%20%5Cbeta_1X%20&plus;%20%5Cbeta_2X%5E2)


## How to decide the Modeling technique?

There are 2 aspects of deciding the optimal modeling technique:

**Assessing Model Accuracy:** To evaluate the performance of a model on a dataset, we need to quantify the extent to which the predicted response value for a given observation is close to the true response value for that observation. One such measure is the **Mean Squared Error (discussed above: MSPE)**. We can compute the mean-squared error over both training and testing data. 

To calculate MSE over the training data, we find the squared difference between the observed y and subtract the *f-hat(x)* of the model fitted to the training set. However, the **MSE for training data is biased towards over-fit models** (for example, MSE training will be zero if the training data fits exactly). Thus, we instead calculate the MSE over testing data.

The MSE over **testing data** (which contains the actual unseen responses) is given by the equation: 

![](https://latex.codecogs.com/gif.latex?MSE%20%3D%20E%5B%5Csum_%7Bi%3D1%7D%5En%20%28y_i%20-%20%5Chat%7Bf%7D%28x_i%29%29%5E2%5D%20%24%24%uD835%uDC40%uD835%uDC46%uD835%uDC38%20%3D%20%uD835%uDC38%20%5B%u2211_%7B%uD835%uDC56%20%3D%201%7D%5E%uD835%uDC5B%20%28y_i%20%u2212%20%5Chat%7B%uD835%uDC53%7D%28x_i%29%29%5E2%5D%24%24)

where *y(i)* is the observed value and *f-hat(x(i))* is the value predicted using the model. The goal here should be to **minimize the MSE** (which in turn means the model has a better predictive power).

** Bias Variance Trade-off:** To understand bias and variance, let a model *f-hat(x)* be fit to some training data, and let *(x0,y0)* be a *single test observation* drawn from the *testing data* to evaluate the model. If the **true model** is given by *Y = f(X) + e*, then the **MSE** can be expressed as:

![](https://latex.codecogs.com/gif.latex?E%5B%28y_0%20-%20%5Chat%7Bf%7D%28x_0%29%29%5D%5E2%20%3D%20Var%28%5Chat%7Bf%7D%28x_0%29%29%20&plus;%20%5BBias%28%5Chat%7Bf%7D%28x_0%29%29%5D%5E2%20&plus;%20Var%28%5Cvarepsilon%20%29%20%24%24%uD835%uDC38%5B%28%uD835%uDC66_0%20%u2212%20%5Chat%7Bf%7D%28%uD835%uDC65_0%29%29%5D%5E2%20%3D%20%uD835%uDC49%uD835%uDC4E%uD835%uDC5F%28%5Chat%7B%uD835%uDC53%7D%28%uD835%uDC65_0%29%29&plus;%20%5B%uD835%uDC35%uD835%uDC56%uD835%uDC4E%uD835%uDC60%28%5Chat%7B%uD835%uDC53%7D%28%uD835%uDC65_0%29%29%5D%5E2%20&plus;%20%uD835%uDC49%uD835%uDC4E%uD835%uDC5F%28%uD835%uDC52%29%24%24)

Here, *𝑉𝑎𝑟(𝑒)* is the irreducible error** discussed previously. The **reducible part of the MSE** is broken down into 2 components:
* *𝑉𝑎𝑟(f-hat(x0))*:  Variance that comes from fitting different training sets to the model (if you fit many many different training sets to the model, there will be variability in the prediction of *f-hat(x0)*
* *𝐵𝑖𝑎𝑠(f-hat(x0))*: Difference between the average prediction of *x0* (average from fitting many many different training sets and predicting *x0*) and the true *f(x0)*. Furthermore, notice that the error is expressed in terms of Bias squared.

Typically, as the **flexibility** of the model **increases** (the model has more parameters), its **variance increases** and **bias decreases**. Thus, depending on the nature of the problem, this trade-off is made at different places using the testing set.

Algorithms with **high bias** (and thus low variance) typically produce simpler models that may **underfit** their training data, failing to capture important regularities. In contrast, **low bias** learning methods (think in terms of the model having more parameters to represent the data) may be able to represent their training set well, but are at risk of **overfitting** to noisy or unrepresentative training data. Thus, the relative rate of change of these two quantities determines whether the Mean Square Error increases or decreases. 

To further understand bias and variance, Bias can thought of as the error that is introduced due to the assumptions made when modeling a real life complicated problem to a much simpler problem, and Variance refers to the error from sensitivity to small fluctuations in the training set.

We can visualize the four different cases representing combinations of both bias and variance using the plot below:

![](./data/images/bias_variance.png)


## Notes

* A fitted model with more predictors will **NOT** necessarily have a lower Training Set Error than a model with fewer predictors
* If the **sample size n is extremely large**, and **the number of predictors is small**, we should **fit a flexible model** since it will allow us to take full advantage of our large sample size.
* If the **sample size is small**, and the **number of predictors is large**, then we **should not fit a flexible model** since it will overfit our small sample data.
* If the variance of the error terms is too high (*Var(E)*), a flexible model will be worse since we will model the noise in the data.