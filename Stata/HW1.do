**=============================================================**
**       Econometrics 2017(fall)- Stata-HW1    	               **
**                Nanjing University                           **
**                  Xiaoguang Ling        		               **
**					  2017.10.29         	                   **
**=============================================================**
cap log close
global root C:\Users\Xiaoguang\OneDrive\2017Econometrics\Comment
cd $root/RawData
log using $root/Stata/log/hw1, replace

clear
use rand



sum any_ins female blackhisp educper ghindx cholest

bysort any_ins : sum female blackhisp educper ghindx cholest 

log close
