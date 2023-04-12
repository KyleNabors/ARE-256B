//HW 3

clear all

//ssc install estout, replace
//ssc install outreg2, replace

set seed 8675309

global path = "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 3"

cd "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 3"

use cement.dta

*extract month and year
gen mth = month
gen yr = year

gen month2 = ym(yr,mth)
format month2 %tm
tsset month2, monthly

//2.a
*seasonal?
tsline gcem
tsline gcem if inrange(yr, 1964, 1989)

gen seasonal = 1 if mth == 1
replace seasonal = 0 if seasonal == .

reg gcem L(0/10).seasonal,robust

*use January as a base case
reg gcem i.mth, robust
dis .1008837+.0001877

*Directly calculate the means
reg gcem L(0/11).seasonal, nocons robust

//2.b

*for simplicity set x as white noise
gen x = grres 

*i) Perform the OLS regression.
reg gcem x, robust
*ii) Obtain residuals from that regression.
predict resid, residuals
ac resid
*iii) Generate the lagged residual.
gen resid_lag1 = resid[_n-1]
*iv)Perform the auxiliary regression of the residual on its own lag and the regressor grres.
reg resid x  resid_lag

reg L(0/1).resid x
reg resid x L(1/1).resid
estimates store lag1, title(1 Lag)
reg resid x L(1/3).resid
estimates store lag3, title(3 Lag)
reg resid x L(1/5).resid
estimates store lag5, title(5 Lag)

estout lag1 lag3 lag5, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))

esttab, se r2

*v) Compute the Breusch-Godfrey statistic using nR2 from the above regression.	
dis 484 * 0.997

reg resid x
estat bgodfrey, lags(1,3,5)

estat bgodfrey, lags(20)

//2.c
*compute the T you need

newey gcem x, lag(5) force
estimates store new, title(Newey SE)

reg L(0/26).gcem
estat bgodfrey, lags(26)
estimates store bgod, title(Bgodfrey SE)

estout new bgod, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))


//2.d

reg gcem jan, robust 

reg gcem feb, robust 

ttest gcem if month==1 | month==2, by(month)




