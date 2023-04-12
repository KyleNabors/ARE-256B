clear all

//ssc install estout, replace


cd"/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 1"

use EAWE01.dta 
summarize

*1.1
* Estimate linear probability model of being married based on AGE
regress MARRIED AGE, robust

* Estimate linear probability model of being married based on years of schooling
regress MARRIED S, robust

*1.2
* Estimate probit model of being married based on AGE
probit MARRIED AGE, nolog

* Estimate probit model of being married based on years of schooling
probit MARRIED S, nolog

//1.3 NO CODE

//1.4

* Linear probability model
regress MARRIED AGE, robust
predict yhat1
scatter yhat1 AGE, msymbol(circle) mcolor(black) msize(medium) title("Linear probability model")

* Probit model
probit MARRIED AGE, nolog
predict yhat2
scatter yhat2 AGE, msymbol(circle) mcolor(red) msize(medium) title("Probit model")

//1.5





//1.6
* Linear probability model

gen error1 = MARRIED - yhat1
gen square_error1 = error1^2
egen mse1 = mean(square_error1)
scalar rmse1 = sqrt(mse1)
display rmse1

* Probit model

gen error2 = MARRIED - yhat2
gen square_error2 = error2^2
egen mse2 = mean(square_error2)
scalar rmse2 = sqrt(mse2)
display rmse2


//1.7 NO CODE



//1.8

* Linear probability model
regress MARRIED AGE, robust
predict yhat1, xb

* Probit model
probit MARRIED AGE, nolog
predict yhat2, xb

* Compute probability of being married for age 27
predict p1, pr
predict p2, pr

display p1 if AGE==27
display p2 if AGE==27

* Compute probability of being married for age 29
predict p1, pr
predict p2, pr

display p1 if AGE==29
display p2 if AGE==29

* Compute probability of being married for age 31
predict p1, pr
predict p2, pr

display p1 if AGE==31
display p2 if AGE==31

//1.9

* For age 27
predict p1_27, pr
predict p2_27, pr

* For age 28
predict p1_28, pr
predict p2_28, pr

* Change in probability for linear model
display (p1_28-p1_27)

* Change in probability for probit model
display (p2_28-p2_27)

* For age 29
predict p1_29, pr
predict p2_29, pr

* For age 30
predict p1_30, pr
predict p2_30, pr

* Change in probability for linear model
display (p1_30-p1_29)

* Change in probability for probit model
display (p2_30-p2_29)

* For age 31
predict p1_31, pr
predict p2_31, pr

* For age 32
predict p1_32, pr
predict p2_32, pr

* Change in probability for linear model
display (p1_32-p1_31)

* Change in probability for probit model
display (p2_32-p2_31)


//2.1 

logit MARRIED AGE S HEIGHT EARNINGS URBAN, robust

coef, robust





