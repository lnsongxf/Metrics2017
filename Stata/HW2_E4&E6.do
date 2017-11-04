**=============================================================**
**       Econometrics 2017(fall)- Stata-  HW2                  **
**                      Nanjing University                     **
**                        Xiaoguang Ling                       **
**					        2017.10.29                         **
**=============================================================**
* http://data.princeton.edu/stata/markdown/ 
*or markdoc
cap log close
global root C:\Users\Xiaoguang\OneDrive\2017Econometrics\Comment
cd $root/RawData
log using $root/Stata/log/hw2, replace

*E4.1 Hourly Wage and Age
clear
use cps08
reg ahe age 

/*
      Source |       SS           df       MS      Number of obs   =     7,711
-------------+----------------------------------   F(1, 7709)      =    230.43
       Model |  23005.7375         1  23005.7375   Prob > F        =    0.0000
    Residual |  769645.718     7,709  99.8372964   R-squared       =    0.0290
-------------+----------------------------------   Adj R-squared   =    0.0289
       Total |  792651.456     7,710   102.80823   Root MSE        =    9.9919

------------------------------------------------------------------------------
         ahe |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
-------------+----------------------------------------------------------------
         age |   .6049863   .0398542    15.18   0.000     .5268613    .6831113
       _cons |   1.082275   1.184255     0.91   0.361    -1.239187    3.403737
------------------------------------------------------------------------------
*/
gen n=7711 //obs==7711
gen k=1  //No. of beta==1
egen Yb=total(ahe/n) //Ybar
egen Xb=total(age/n) //Xbar

*beta
egen nume=total((age-Xb)*(ahe-Yb))  //numerator==(X-Xbar)'*(Y-Ybar)
egen deno=total((age-Xb)*(age-Xb))  //denominator==(X-Xbar)'*(X-Ybar)
gen beta1=nume/deno
tab beta1 //beta1

gen beta0=Yb-beta1*Xb
tab beta0 //beta0

* Y-hat,residual(u) & R square
gen Yh= beta0+beta1*age //Yhat
gen uh=ahe-Yh  //residual
egen ESS=total((Yh-Yb)^2)
tab ESS
egen SSR=total(u^2) 
tab SSR
egen TSS=total((ahe-Yb)^2) 
tab TSS
gen Rs=ESS/TSS
tab Rs
gen adjRs=1-[(n-1)/(n-k-1)]*(SSR/TSS) //P236
tab adjRs

*sdE1 see also equation (4.30), (5.4)
gen VarXs=(deno/n)^2 // var(X) square
egen summation=total((age-Xb)^2*uh^2)
gen VarVb=summation/(n-k-1)/n //Var(V bar)
gen sdE1=sqrt(VarVb/VarXs)
tab sdE1

*use std. dev. as the relative "unit"

*******************************************************************************

*E4.2 Beauty and Rating
clear
use TeachingRatings
*a.
scatter course_eval beauty, msize(small) title(Beauty and Rating) ///
legend(off) ytitle("Rating") xtitle("Beauty")
graph save $root/Stata/pic/beauty ,replace
*b.
reg course_eval beauty

*******************************************************************************

*E4.3 School distance
*a.
clear
use CollegeDistance
reg ed dist
*d. Root MSE //P163
*******************************************************************************

*E6.1 beauty and rating
*a,b
clear all
use TeachingRatings
reg course_eval beauty
estimate store beauty1
reg course_eval beauty intro onecredit female minority nnenglish
estimate store beauty2
outreg2 [beauty*] using "$root\Stata\table\beauty.xls",  bdec(3) sdec(3) replace
*c
reg beauty intro onecredit female minority nnenglish
predict Xt, residuals // seperate beauty into (b1,b2),where b1 is orthogonal to other Xs

reg course_eval intro onecredit female minority nnenglish
predict Yt, residuals //Y tilde

reg Yt Xt
*d
reg  course_eval beauty intro onecredit female minority nnenglish
input
	minority age female onecredit beauty course_eval intro nnenglish
	1 . 0 0 0 . 0 0 
end
predict Yhat,xb

*******************************************************************************

*E6.2 School distance
clear
use CollegeDistance
reg ed dist

outreg2 using "$root\Stata\table\dist.xls", addstat(Adj R-squared, ///
`e(r2_a)')  bdec(3) sdec(3) replace 

reg ed dist bytest female black hispanic incomehi ownhome dadcoll cue80 stwmfg80
outreg2  using "$root\Stata\table\dist.xls", addstat(Adj R-squared, ///
`e(r2_a)')  bdec(3) sdec(3) append  /*to include the adj R squared derived from
the former regression, append should be used */

*******************************************************************************

*E6.3
*a.
clear
use Growth
drop if country_name=="Malta"
global variable growth tradeshare yearsschool oil rev_coups assasinations rgdp60

label var growth "Growth(%)"
label var tradeshare "Trade Share"
label var yearsschool "Education(Years)"
label variable oil "Oil(Dummy)"
label variable rev_coups "Coups per Year"
label variable assasinations "Assassinations per Year"
label variable rgdp60 "GDP per Capita($ in 1960)"

outreg2 using "$root\Stata\table\growth.xls", replace sum(log) ///
keep($variables) eqkeep(mean sd min max) label  //show label in the first column

*b.
reg growth tradeshare yearsschool rev_coups assasinations rgdp60

*c.
reg growth tradeshare yearsschool rev_coups assasinations rgdp60
input
	country_name growth oil rgdp60 tradeshare yearsschool rev_coups assasinations
	"Predicted1" . . 3131 0.542 3.959 0.170 0.282
end
predict Yhat,xb
sum Yhat if country_name=="Predicted1"

*d.
drop if country_name=="Predicted1"
reg growth tradeshare yearsschool rev_coups assasinations rgdp60
input
	country_name growth oil rgdp60 tradeshare yearsschool rev_coups assasinations
	"Predicted2"    .    .   3131	 0.77	     3.959	    0.170	     0.282
end
predict Yhat2,xb
sum Yhat2 if country_name=="Predicted2"

*e.
reg growth oil tradeshare yearsschool rev_coups assasinations rgdp60

log close



