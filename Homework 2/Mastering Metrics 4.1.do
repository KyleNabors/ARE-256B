*** Metrics
*** Figures 4.2 4.4 4.5
*** Tables 4.1
*** MLDA Regression Discontinuity (based on data from Carpenter and Dobkin 2009)
* Gabriel Kreindler, June 13, 2014
* Modified (lightly) by Jon Petkun, January 20, 2015

clear

// set to directory where data is located
cd "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 2"

use AEJfigs_MM_RD.dta

* All = all deaths
gen age = agecell - 21
gen over21 = agecell >= 21

gen age2 = age^2
gen over_age = over21*age
gen over_age2 = over21*age2

* Regressions for Figure 4.2.
* linear trend, and linear on each side
reg all age over21
predict reg1
reg all age over21 over_age
predict reg2

* Regressions for Figure 4.4.
* Quadratic, and quadratic on each side
reg all age age2 over21
predict allfitq
reg all age age2 over21 over_age over_age2
predict allfitqi

label variable all       "Mortality rate from all causes (per 100,000)"
label variable reg1 "Mortality rate from all causes (per 100,000)"
label variable allfitqi  "Mortality rate from all causes (per 100,000)"

* Figure 4.2. 
twoway (scatter all agecell) (line reg1 agecell if age < 0,  lcolor(black)     lwidth(medthick)) ///
                             (line reg1 agecell if age >= 0, lcolor(black red) lwidth(medthick medthick)), legend(off)
graph save "../fig42", replace
graph save "../fig42.eps", replace

* Figure 4.4.		 
twoway (scatter all agecell) (line reg1 allfitqi agecell if age < 0,  lcolor(red black) lwidth(medthick medthick) lpattern(dash)) ///
                             (line reg1 allfitqi agecell if age >= 0, lcolor(red black) lwidth(medthick medthick) lpattern(dash)), legend(off)

graph save "../fig44", replace
graph save "../fig44.eps", replace

* Regressions for Fig 4.5
* "Motor Vehicle Accidents" on linear, and quadratic on each side
reg mva age over21
predict exfitlin
reg mva age age2 over21 over_age over_age2
predict exfitqi

reg suicide age over21
predict sufitlin

* "Internal causes" on linear, and quadratic on each side
reg internal age over21
predict infitlin
reg internal age age2 over21 over_age over_age2
predict infitqi

label variable mva  "Mortality rate (per 100,000)"
label variable infitqi  "Mortality rate (per 100,000)"
label variable exfitqi  "Mortality rate (per 100,000)"

* figure 4.5
twoway (scatter  mva internal agecell) (line exfitqi infitqi agecell if agecell < 21) ///
                                       (line exfitqi infitqi agecell if agecell >= 21), ///
									   legend(off) text(28 20.1 "Motor Vehicle Fatalities") ///
									               text(17 22 "Deaths from Internal Causes")

graph save "../fig45", replace
graph save "../fig45.eps", replace

* Table 4.1
* dummy for first month after 21st birthday
gen exactly21 = agecell >= 21 & agecell < 21.1

* doesn't change 
* drop if agecell>20.99 & agecell<21.01

* Other causes
gen ext_oth = external - homicide - suicide - mva

foreach x in all mva suicide homicide ext_oth internal alcohol {

reg `x' age over21, robust
if ("`x'"=="all"){
	outreg2 over21 using ../table41.xls, replace bdec(2) sdec(2) noaster excel
}
else{
	outreg2 over21 using ../table41.xls, append  bdec(2) sdec(2) noaster excel
}

reg `x' age age2 over21 over_age over_age2, robust
outreg2 over21 using ../table41.xls, append bdec(2) sdec(2) noaster excel

reg `x' age over21 if agecell >= 20 & agecell <= 22, robust
outreg2 over21 using ../table41.xls, append bdec(2) sdec(2) noaster excel

reg `x' age age2 over21 over_age over_age2 if agecell >= 20 & agecell <= 22, robust
outreg2 over21 using ../table41.xls, append bdec(2) sdec(2) noaster excel

}


*** Metrics
*** Figure 5.1, 5.2, 5.3
*** Richardson and Troost bank failure data and results

version 10
clear

// set to directory where this do file is located
cd "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 2"

insheet using banks.csv

drop date
gen date = mdy(month,day,year)
format %td date

gen lbib6 = ln(bib6)
gen lbib8 = ln(bib8)
gen lbio6 = ln(bio6)
gen lbio8 = ln(bio8)

label var year "Year"

line lbio6 lbio8 date, xline(-10647 -10472)
line lbib6 lbib8 date, xline(-10647 -10472)


/* create counterfactual */

keep if month == 7 & day == 1

 gen diff = bib8 - bib6
 gen bibc = bib6*(year==1929) + (bib8 - diff[2])*(year>=1930) 

 gen ldiff = lbib8 - lbib6
 gen lbibc = lbib6*(year==1929) + (lbib8 - ldiff[2])*(year>=1930) 
 
/* plot levels -- add counterfactual to fig 2 */

scatter bib8 bib6 bibc year if year > 1929 & year < 1932, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
xscale(range(1929 1932)) yscale(range(95 170)) xlabels(#4) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig51", replace)
graph export "../Output/banks_fig51.png", replace

scatter bib8 bib6 year if year > 1928 & year < 1935, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
yscale(range(70 180)) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig52", replace)
graph export "../Output/banks_fig52.png", replace

scatter bib8 bib6 bibc year if year > 1928 & year < 1935, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
yscale(range(70 180)) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig53", replace)
graph export "../Output/banks_fig53.png", replace



