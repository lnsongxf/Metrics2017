**===========================================================================**
**===========================================================================**
**                                                                                
**       Topic 9: Oaxaca_Blinder Decomposition                                                                                                     
**       Author: Zhaopeng Qu 
**       Date  : Dec.3 2017                                                                           
**===========================================================================**
**===========================================================================**

cap log close
cap cmdlog close

clear all
set matsize  8000

global root /Users/byelenin/Dropbox/NJU/Teaching/2017Fall/Econometrics/Lab4
global dof  $root/Dofiles
global logf $root/Logfiles
global work $root/WorkData
global raw  $root/RawData
global savd $root/SaveData
global figs $root/Figures
global tabs $root/Tables

local c_date = c(current_date)
display "`c_date'"
local date = subinstr("`c_date'", " ", "_", .)

log using $logf/lab4`date',replace


cd ${work}
*=========================================================*


/* [> Install following commands <] */ 

ssc install estout,replace 

help estout

ssc install outreg2,replace

help outreg2

ssc install oaxaca,replace 

help oaxaca

/* [> open a data set<] */ 


use $raw/caschool.dta,clear

/* [> generate NEW variables <] */ 

gen loginc=log(avginc) // logarithm value of average income

generate high_el=(el_pct>18)  // higher percent english-learner class 

tab high_el,m // check the generated variable 

gen large =(str>=20)

tab large,m // check the generated variable 


*keep testscr str high_el meal_pct loginc // keep necessary variables 

format testscr str large el_pct meal_pct loginc %9.2f // two digitals

/* [> Summary Table 1: large v.s small <] */ 

bysort large: sum testscr el_pct meal_pct loginc,f 


outreg2 using "$tabs/Table1" if large==1, sum(log)          ///
        keep(testscr str loginc el_pct meal_pct)  ///  
        excel replace eqkeep(mean sd) dec(2)                 ///
		sortvar(testscr str meal_pct el_pct loginc)



outreg2 using "$tabs/Table1" if large==0, sum(log)          ///
        keep(testscr str loginc el_pct meal_pct)  ///  
        excel append eqkeep(mean sd) dec(2)                 ///
		sortvar(testscr str meal_pct el_pct loginc)



/* [> Alternative T-test for group mean<] */ 


estpost tabstat testscr str loginc el_pct meal_pct,by(large) statistics(mean sd)   ///
		col(statistics)  
		
esttab using "$tabs/Table1.csv", main(mean %9.2f) ///
       aux(sd %9.2f) replace nogap compress unstack obslast


estpost ttest testscr str loginc el_pct meal_pct,by(large) 

esttab using "$tabs/Table1.csv", main(b %9.2f) append ///
aux(se %9.2f) compress nogap star obslast  



/* Regressions by group: Large size class v.s Small Class*/

reg testscr large loginc el_pct meal_pct,r
est store reg1 

*reg testscr loginc el_pct meal_pct if large==0,r
*est store reg2 

*reg testscr loginc el_pct meal_pct if large==1,r
*est store reg3 

*esttab reg1 reg2 reg3 using "$tabs/Table2.csv", ///
*compress nogap star obslast replace 

* Oaxaca-Blinder Decomposition: Large size class v.s Small Class*/


sum large if large==1 

scalar NA = r(N)

sum large if large==0 

scalar NB = r(N)

sum large 

scalar NT = r(N)

scalar w1 =  NA/NT
scalar w2 =  NB/NT

sca list w1 w2 

oaxaca testscr loginc el_pct meal_pct,by(large) weight(0)

est store oa1 

oaxaca testscr loginc el_pct meal_pct,by(large) weight(1)

est store oa2 

oaxaca testscr loginc el_pct meal_pct,by(large) weight(0.5)

est store oa3 

oaxaca testscr loginc el_pct meal_pct,by(large) weight(0.4333,0.5666)

est store oa4

oaxaca testscr loginc el_pct meal_pct,by(large) omega

est store oa5

oaxaca testscr loginc el_pct meal_pct,by(large) pool

est store oa6

esttab oa1 oa2 oa3 oa4 oa5 oa6 using "$tabs/Table3.csv", ///
compress nogap star obslast replace 

 
/*----------------------------------------------------*/
   /* [>   Introduction to Boostrap    <] */ 
/*----------------------------------------------------*/


bootstrap,reps(100): reg testscr large loginc el_pct meal_pct

est store bt1

esttab reg1 bt1,























