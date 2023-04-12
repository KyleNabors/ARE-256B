*--------------------------------------------------
*ARE 256b W23 -- Section 9
*0310.do
*Mar/10/2023
*Mahdi Shams (mashams@ucdavis.edu)
*Based on Bulat's Slides, and previous work by Armando Rangel Colina & Zhiran Qin
*This code is prepared for the Week 9 of ARE 256B TA Sections. 
*--------------------------------------------------

*--------------------------------------------------
*Program Setup
*--------------------------------------------------

clear all

//ssc install estout, replace
//ssc install outreg2, replace

set seed 8675309

//global path = "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 4"

//cd "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 4"

global path = "/Users/kwnabors/Desktop/Homework 4"

cd "/Users/kwnabors/Desktop/Homework 4"

use Guns.dta,clear
		
xtset stateid year, yearly



/*
*--------------------------------------------------
* Part 1: Slides 92 - 93: FE in Stata
*--------------------------------------------------




*Let us look at the data over time
*State 11 has very very large numbers so it looks weird in the same
*graph
//twoway (line vio year), by(stateid)
//twoway (line vio year if stateid!=11), by(stateid)
twoway (line vio year if stateid==11), by(stateid)


*plain-vanilla:
xtreg vio shall, fe


*plain-vanilla with robust standard errors:
*Robust standard errors cluster over cross-sectional units
*allowing for arbitrary heteroskedasticity and serial correlation within cross-sectional units
xtreg vio shall, fe vce(robust)



*Least Squares Dummy Variable Regression
reg vio shall i.stateid


*including time fixed effects:
*i.year creates a dummy variable for each unique value of year
eststo: qui reg vio shall i.stateid i.year
esttab, se 

eststo: qui xtreg vio shall i.year, fe
esttab, se 

eststo: xtreg vio shall i.year, fe vce(robust)
esttab, se 


*including time fixed effects and state-level time trends: 
xtreg vio shall i.year c.year#i.stateid, fe

*c.year deals with year as a continuous variable, whereas i.stateid creates a dummy variable for each unique value of stateid. 
*# interacts each state dummy variable with the continuous year trend.
reg vio shall c.year 
reg vio shall year

reg vio shall c.year#i.stateid
reg vio shall c.year#stateid

reg vio shall year#i.stateid
reg vio shall i.year#i.stateid



*including the time-invariant regressor z:
gen z = 10*sqrt(stateid)
xtreg vio shall i.year#c.z, fe vce(robust)

*The above create year-specific coefficients for z. 
*Of course you can also include the time fixed effects and state-level time trends.
*/
*--------------------------------------------------
* Part 2: HW4 Gun Control 
*--------------------------------------------------

*1a
*Regular regressions
eststo clear
eststo: quietly reg vio shall year avginc pm1029 density pop, robust
estimates store reg1a1, title(1a1)
eststo: quietly reg rob shall year avginc pm1029 density pop, robust
estimates store reg1a2, title(1a2)
eststo: quietly reg mur shall year avginc pm1029 density pop, robust
estimates store reg1a3, title(1a3)

estout reg1a1 reg1a2 reg1a3, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))

*1b
*Random Effect regressions
eststo: quietly xtreg vio shall year avginc pm1029 density pop, re vce(robust)
estimates store reg1b1, title(1b1)
eststo: quietly xtreg rob shall year avginc pm1029 density pop, re vce(robust)
estimates store reg1b2, title(1b2)
eststo: quietly xtreg mur shall year avginc pm1029 density pop, re vce(robust)
estimates store reg1b3, title(1b3)

estout reg1b1 reg1b2 reg1b3, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))
   
*1c
eststo: quietly xtreg vio shall year avginc pm1029 density pop, fe vce(robust)
estimates store reg1c1, title(1c1)
eststo: quietly xtreg rob shall year avginc pm1029 density pop, fe vce(robust)
estimates store reg1c2, title(1c2)
eststo: quietly xtreg mur shall year avginc pm1029 density pop, fe vce(robust)
estimates store reg1c3, title(1c3)

estout reg1c1 reg1c2 reg1c3, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))



*1e

*Fixed effects regressions
xtreg vio shall year avginc pm1029 density pop, fe
estimates store fe_vio

*Random effects regressions
xtreg vio shall year avginc pm1029 density pop, re
estimates store re_vio

hausman fe_vio re_vio, sigmamore
*RE assumption is rejected

*Fixed effects regressions
xtreg rob shall year avginc pm1029 density pop, fe
estimates store fe_rob

*Random effects regressions
xtreg rob shall year avginc pm1029 density pop, re
estimates store re_rob

hausman fe_rob re_rob, sigmamore
*RE assumption is rejected

*Fixed effects regressions
xtreg mur shall year avginc pm1029 density pop, fe
estimates store fe_mur

*Random effects regressions
xtreg mur shall year avginc pm1029 density pop, re
estimates store re_mur

hausman fe_mur re_mur, sigmamore
*RE assumption is rejected

*--------------------------------------------------
* Part 3: HW4 Seat Belt  
*--------------------------------------------------

use SeatBelts.dta,clear

*Declare the dataset as a panel
xtset fips year, yearly

*2a
generate dk_spd=drinkage21*speed70

eststo clear
*first case (without time fixed effects)
eststo:  xtreg fatalityrate sb_useage drinkage21 dk_spd, fe vce(robust)
estimates store reg2a1, title(2a1)
*second case (include time fixed effects) (+ i.year)
eststo:  xtreg fatalityrate sb_useage drinkage21 dk_spd i.year, fe vce(robust)
estimates store reg2a2, title(2a2)
*third case (include time fixed effects & state-level trends) (+ i.year and c.year#fips)
eststo:  xtreg fatalityrate sb_useage drinkage21 dk_spd i.year c.year#fips, fe vce(robust)
estimates store reg2a3, title(2a3)

*esttab, se r2

estout reg2a1 reg2a2 reg2a3, keep(sb_useage drinkage21 dk_spd _cons) cells(b(star fmt(4)) se(par fmt(4)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))

***sidenote1***
*another way for interaction term, using # ... almost the same
reg fatalityrate sb_useage drinkage21 drinkage21#speed70
reg fatalityrate sb_useage drinkage21 dk_spd

*why?
br drinkage21 if speed70 ==1
reg  fatalityrate sb_useage  drinkage21#speed70

*drinkage21 and speed70 are treated as categorical values. 
*Although we see a 0 and a 1 STATA reads the zero as a "NO" and the 1 as a "YES". 
*Then, when we ask STATA to do an operation *like YES-YES it doesn't know what to do.
*So we can do a quick workaround:    
gen yy  = (drinkage21==1 & speed70==1)
gen yn  = (drinkage21==1 & speed70==0)
gen ny  = (drinkage21==0 & speed70==1)
gen nn  = (drinkage21==0 & speed70==0)
reg  fatalityrate sb_useage yy yn
***end of sidenote1***

*2b
*Create a variable that indicates the driver had a higher 
*alcohol content in the blood 
* known as DUI (driving under the influence)
gen dui = 1- ba08

*repeat regressions for 3 cases
eststo clear

*first case (without time fixed effects)
eststo:  xtreg fatalityrate speed65#speed70 if dui==1 ,fe vce(robust)
estimates store reg2b1
*second case (include time fixed effects)
eststo:  xtreg fatalityrate speed65#speed70 i.year if dui==1,fe vce(robust)
estimates store reg2b2
*third case (include time fixed effects & state-level trends)
eststo:  xtreg fatalityrate speed65#speed70 i.year c.year#fips if dui==1,fe vce(robust)
estimates store reg2b3



estout reg2b1 reg2b2 reg2b3, drop(*year, relax) cells(b(star fmt(4)) se(par fmt(4)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))

*keep(speed65=0#speed7=0 speed65=0#speed7=1 speed65=1#speed7=0 speed65=1#speed7=1 _cons) ///
*double check
br speed65 if speed70==1

*2c 
*year dummies
*why omit 1983?
foreach t of numlist 1984/1997 {
gen  yr`t'=1 if year == `t'
replace yr`t'=0 if yr`t' == .
}

*both with constant, equal to beta_0 + year fixed effect of 1983
reg D.(fatalityrate sb_useage drinkage21 dk_spd)
reg D.(fatalityrate sb_useage drinkage21 dk_spd), nocons vce(cluster fips)
estimates store reg2c1

*omit 1983 since take first difference
*this is for case 2
reg D.(fatalityrate sb_useage drinkage21 dk_spd) i.year , vce(cluster fips)
reg D.(fatalityrate sb_useage drinkage21 dk_spd yr*), nocons vce(cluster fips)
estimates store reg2c2

*case 3
reg D.(fatalityrate sb_useage drinkage21 dk_spd) i.year i.fips,   vce(cluster fips)
xtreg D.(fatalityrate sb_useage drinkage21 dk_spd) i.year, fe vce(cluster fips)
estimates store reg2c3

estout reg2c1 reg2c2 reg2c3, keep(D.sb_useage D.drinkage21 D.dk_spd ) cells(b(star fmt(6)) se(par fmt(6)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 df_r N, fmt(3 0 1) label(R-sqr dfres N))
