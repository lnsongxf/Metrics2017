**=============================================================**
**            Econometrics 2017(fall)- Stata-  HW3             **
**                      Nanjing University                     **
**                        Xiaoguang Ling                       **
**					        2017.12.02                         **
**=============================================================**

cap log close
global root C:\Users\Xiaoguang\OneDrive\2017Econometrics\Comment
cd $root/RawData
log using $root/Stata/log/hw3, replace

*E9.1 Average Hourly Earnings (AHE) and Age
*a.
	clear
	use cps08
	qui reg ahe age female bachelor,r
	estimate store ahe1 
	
	gen lnahe=ln(ahe)
	qui reg lnahe age female bachelor,r
	estimate store ahe2 
	
	gen lnage=ln(age)
	qui reg lnahe lnage female bachelor,r
	estimate store ahe3 
	
	gen age2=age^2
	qui reg lnahe age age2 female bachelor,r
	estimate store ahe4 
	
	gen fxb=female*bachelor
	qui reg lnahe age age2 female bachelor fxb,r
	estimate store ahe5 
	
	gen axf=female*age
	qui reg lnahe age age2 female bachelor axf,r
	estimate store ahe6 
	
	gen axb=bachelor*age
	qui reg lnahe age age2 female bachelor axb,r
	estimate store ahe7 
	*outreg2 [ahe*] using "$root\Stata\table\AHE&age.xls",  bdec(3) sdec(3) replace
*b.
	clear all
	use cps92_08
	keep if year==1992
	gen cpi=215.2/140.3
	gen rahe=ahe/cpi
	
	qui reg rahe age female bachelor,r
	estimate store rahe1 
	
	gen lnrahe=ln(rahe)
	qui reg lnrahe age female bachelor,r
	estimate store rahe2 
	
	gen lnage=ln(age)
	qui reg lnrahe lnage female bachelor,r
	estimate store rahe3 
	
	gen age2=age^2
	qui reg lnrahe age age2 female bachelor,r
	estimate store rahe4 
	
	gen fxb=female*bachelor
	qui reg lnrahe age age2 female bachelor fxb,r
	estimate store rahe5 
	
	gen axf=female*age
	qui reg lnrahe age age2 female bachelor axf,r
	estimate store rahe6 
	
	gen axb=bachelor*age
	qui reg lnrahe age age2 female bachelor axb,r
	estimate store rahe7 
	*outreg2 [rahe*] using "$root\Stata\table\AHE&age_92.xls",  bdec(3) sdec(3) replace

*******************************************************************************

*E9.2 Beauty and Rating
clear all
use TeachingRatings

twoway scatter course_eval beauty, msize(small) title(Beauty and Rating) ///
legend(off) ytitle("Rating") xtitle("Beauty")|| lfit course_eval beauty || ///
qfit course_eval beauty
graph export "$root/Stata/pic/beauty.png", replace



reg course_eval beauty,r
estimate store beauty1
gen age2=age^2
gen beauty2=beauty^2
reg course_eval beauty age age2 female minority nnenglish,r
estimate store beauty2 
reg course_eval beauty age female minority nnenglish intro onecredit,r
estimate store beauty3 
reg course_eval beauty beauty2 age female minority nnenglish intro ///
onecredit,r
estimate store beauty4 
gen fxb=female*beauty
reg course_eval beauty fxb beauty2 age female minority nnenglish intro ///
onecredit,r
estimate store beauty5

*outreg2 [beauty*] using "$root\Stata\table\beauty.xls",  bdec(3) sdec(3) replace


*******************************************************************************

*E9.3 School distance
*a.
clear all
use CollegeDistance
qui reg ed dist female bytest tuition black hispanic incomehi ownhome dadcoll ///
momcoll cue80 stwmfg80,r
estimate store dist1
gen lned=ln(ed)
qui reg lned dist female bytest tuition black hispanic incomehi ownhome dadcoll ///
momcoll cue80 stwmfg80,r
estimate store dist2
gen dist2=dist^2
qui reg ed dist dist2 female bytest tuition black hispanic incomehi ownhome  ///
dadcoll momcoll cue80 stwmfg80,r
estimate store dist3
gen dadxmom=dadcoll*momcoll
qui reg ed dist dist2 female bytest tuition black hispanic incomehi ownhome  ///
dadcoll momcoll dadxmom cue80 stwmfg80,r
estimate store dist4
gen distxincome=dist*incomehi
gen dist2xincome=dist2*incomehi
qui reg ed dist dist2 distxincome dist2xincome female bytest tuition black  ///
hispanic incomehi ownhome dadcoll momcoll cue80 stwmfg80,r
estimate store dist5

outreg2 [dist*] using "$root\Stata\table\dist.xls",  bdec(3) sdec(3) replace

*b.
clear all
use CollegeDistancewest
gen dist2=dist^2
gen distxincome=dist*incomehi
gen dist2xincome=dist2*incomehi
gen dadxmom=dadcoll*momcoll

qui reg ed dist dist2 distxincome dist2xincome female bytest tuition black  ///
hispanic incomehi ownhome dadcoll momcoll dadxmom cue80 stwmfg80,r
estimate store west
outreg2 [west] using "$root\Stata\table\dist.xls",  bdec(3) sdec(3) append


*******************************************************************************



log close
