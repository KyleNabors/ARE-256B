clear all

*ssc install estout, replace

set seed 8675309

cd"/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 1"

use EAWE01.dta 

replace URBAN=1 if URBAN==2

*1.1
* Estimate linear probability model of being married based on AGE
regress MARRIED AGE, robust

* Estimate linear probability model of being married based on years of schooling
regress MARRIED S, robust

*1.2
* Estimate probit model of being married based on AGE
probit MARRIED AGE, robust

* Estimate probit model of being married based on years of schooling
probit MARRIED S, robust

*1.3 No Code

*1.4
* Married Age 
regress MARRIED AGE, robust
predict mar_age_lin

probit MARRIED AGE, robust
predict mar_age_prob

scatter MARRIED AGE || scatter mar_age_prob AGE || line mar_age_prob AGE || lfit MARRIED AGE,  title("AGE Linear and Probit Model")

* Married S 
regress MARRIED S, robust
predict mar_s_lin

probit MARRIED S, robust
predict mar_s_prob

scatter MARRIED S || scatter mar_s_prob S || line mar_s_prob S || lfit MARRIED S, title("Schooling Linear and Probit Model")

*1.5
*Generate Subsample
generate rand_draw = runiform()
sort rand_draw
generate subsample = _n <= 5

*List if in subsample 
list ID AGE MARRIED mar_age_lin mar_age_prob if subsample==1
list ID S MARRIED mar_s_lin mar_s_prob if subsample==1


* Linear probability model Age
gen error1s = MARRIED - mar_age_lin if subsample==1
gen square_error1s = error1s^2
egen mse1s = mean(square_error1s)
scalar rmse1s = sqrt(mse1s)
display rmse1s

* Probit model Age 
gen error2s = MARRIED - mar_age_prob if subsample==1
gen square_error2s = error2s^2
egen mse2s = mean(square_error2s)
scalar rmse2s = sqrt(mse2s)
display rmse2s

* Linear probability model S
gen error3s = MARRIED - mar_s_lin if subsample==1
gen square_error3s = error3s^2
egen mse3s = mean(square_error3s)
scalar rmse3s = sqrt(mse3s)
display rmse3s

* Probit model S
gen error4s = MARRIED - mar_s_prob if subsample==1
gen square_error4s = error4s^2
egen mse4s = mean(square_error4s)
scalar rmse4s = sqrt(mse4s)
display rmse4s

*Compare 
* Linear probability model Age
display rmse1s
* Probit model Age 
display rmse2s
* Linear probability model S
display rmse3s
* Probit model S
display rmse4s

*1.6
* Linear probability model Age
gen error1 = MARRIED - mar_age_lin
gen square_error1 = error1^2
egen mse1 = mean(square_error1)
scalar rmse1 = sqrt(mse1)
display rmse1

* Probit model Age 
gen error2 = MARRIED - mar_age_prob
gen square_error2 = error2^2
egen mse2 = mean(square_error2)
scalar rmse2 = sqrt(mse2)
display rmse2

* Linear probability model S
gen error3 = MARRIED - mar_s_lin
gen square_error3 = error3^2
egen mse3 = mean(square_error3)
scalar rmse3 = sqrt(mse3)
display rmse3

* Probit model S
gen error4 = MARRIED - mar_s_prob
gen square_error4 = error4^2
egen mse4 = mean(square_error4)
scalar rmse4 = sqrt(mse4)
display rmse4

*Compare 
display rmse1
display rmse2
display rmse3
display rmse4

*1.7 No Code

*1.8
* Linear prediction model AGE 
regress MARRIED AGE, robust
predict mar_age_lin_pr, xb
tabstat mar_age_lin_pr, statistics(mean) by(AGE)

* Probit prediction model AGE 
probit MARRIED AGE, robust
predict mar_age_prob_pr, pr
tabstat mar_age_prob_pr, statistics(mean) by(AGE)

* Linear prediction model S 
regress MARRIED S, robust
predict mar_s_lin_pr, xb
tabstat mar_s_lin_pr, statistics(mean) by(AGE)

* Probit prediction model S
probit MARRIED S, robust
predict mar_s_prob_pr, pr
tabstat mar_s_prob_pr, statistics(mean) by(AGE)

*1.9
*Marginal Effect Linear
regress MARRIED AGE, robust
margins, dydx(AGE) at(AGE = (27 29 31))

*Marginal Effect Probit
probit MARRIED AGE, robust
margins, dydx(AGE) at(AGE = (27 29 31))

*2.1
*Logit Model
logit MARRIED AGE S HEIGHT EARNINGS URBAN, robust
predict Logit 
esttab

*2.2 No Code

*2.3
*Caculate MSE
gen errorL = MARRIED - Logit
gen square_errorL = errorL^2
egen mseL = mean(square_errorL)
scalar rmseL = sqrt(mseL)
display rmseL

*Compare
display rmseL
display rmse1
display rmse2
display rmse3
display rmse4

*2.4

mfx compute, dydx at (27,16,66,18,0)
mfx compute, dydx at (27,16,66,18,1)





*3.1 
*generate needed variables 
gen lny = ln(EARNINGS)
gen S_URB = S*URBAN
gen EXP2 = EXP^2

*tobit lny S S_URB EXP EXP2 
tobit lny S S_URB EXP EXP2, ll(log(2))
predict t1



eststo clear
eststo model_l: tobit lny S S_URB EXP EXP2

esttab model_l


esttab model_l using model_l.rtf, replace ///
se onecell width(\hsize) ///
addnote() ///
label title(Estimation Reslt of Linear Model)

*3.2 No Code 





