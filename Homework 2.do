clear all

//ssc install estout, replace
//ssc install outreg2, replace

set seed 8675309

global path = "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 2"

cd "/Users/kylenabors/Library/CloudStorage/Dropbox/UC Davis/Winter 2023/ECN 256B/Homework/Homework 2"

use AEJfigs_MM_RD.dta
summarize

gen age = agecell - 21
gen age21 = agecell >= 21

gen age2 = age^2
gen over21 = age21*age
gen over212 = age21*age2

reg all age age21
predict reg1
reg all age age21 over21
predict reg2

reg all age age2 age21
predict reg3
reg all age age2 age21 over21 over212
predict reg4

label variable all "Mortality Rate All"
label variable reg1 "Mortality rate above 21"
label variable reg4 "Mortality rate below 21"

//Figure 4.2
scatter all agecell, xline(21, lpattern(dash) lcolor(gray))||line reg1 agecell if age < 0||line reg1 agecell if age >= 0

//Figure 4.4		 
scatter all agecell, xline(21, lpattern(dash) lcolor(gray))||line reg1 reg4 agecell if age < 0||line reg1 reg4 agecell if age >= 0
							 
//Table 4.1
gen exactly21 = agecell >= 21 & agecell < 21.1

drop if agecell>20.99 & agecell<21.01

gen ext_oth = external - homicide - suicide - mva

foreach x in all mva suicide homicide ext_oth internal alcohol {

reg `x' age age21, robust
if ("`x'"=="all"){
	outreg2 age21 using ../table41.xls, replace bdec(2) sdec(2) noaster 
}
else{
	outreg2 age21 using ../table41.xls, append  bdec(2) sdec(2) noaster 
}

reg `x' age age2 age21 over21 over212, robust
outreg2 age21 using ../table41.xls, append bdec(2) sdec(2) noaster 

reg `x' age age21 if agecell >= 20 & agecell <= 22, robust
outreg2 age21 using ../table41.xls, append bdec(2) sdec(2) noaster 

reg `x' age age2 age21 over21 over212 if agecell >= 20 & agecell <= 22, robust
outreg2 age21 using ../table41.xls, append bdec(2) sdec(2) noaster 

}

clear
use deaths.dta,clear
set more off
xi: reg mrate legal
outreg2 beertax using "../table52.xls", replace bdec(2) sdec(2) excel noaster
//Table 5.2
foreach i in 1 2 3 6{

xi: reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "../table52.xls", append bdec(2) sdec(2) excel noaster 

xi: reg mrate legal i.state*year i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "../table52.xls", append bdec(2) sdec(2) excel noaster 

xi: reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "../table52.xls", append bdec(2) sdec(2) excel noaster 

xi: reg mrate legal i.state*year i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "../table52.xls", append bdec(2) sdec(2) excel noaster 
}

