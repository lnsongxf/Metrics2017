**==============================================================**
**                 2017（秋）计量经济学- Stata 操作入门         **
**                       南京大学经济学系 凌晓光                **
**					        2017年9月18日                       **
**==============================================================**



**==============================================================**
**                        1. 关于Stata                          **
**==============================================================**
(1)什么是Stata
Stata是经济学研究主流的数据分析软件，它功能强大，程序包丰富，可以说几乎涵盖了应
用计量经济学领域所有的功能，另外Stata的help文件非常详细，完全可以自学。
可以说，想要完成规范的现代经济学实证研究，像Stata这样的计量软件是必不可少的工具。

Stata由StataCorp LLC 研发维护，该公司同时通过其出版社Stata Press出版季刊
Stata Journal（2017年影响因子为1.092）。
目前Stata的最新版本是15.0版，根据性能差异分为以下几种类型：

Stata/IC For mid-sized datasets.

Stata/SE For large datasets.

Stata/MP 2-core Fast & for the largest datasets.

Stata/MP 4-core Faster.

Stata/MP + cores Even faster.

商用版根据性能不同售价在$1000~$6500，学生版顶配为Stata/MP 4-core，售价$995.



（2）为什么选择Stata？
*以下对比基于我之前接触软件时的版本功能以及自己的人生经验，可能过时或者存在错误
其他软件与Stata相比：

>SPSS 的图像化界面非常友好（同时操作也比较繁琐。当然，它也可以输入命令或编程开发），
它更侧重于数据的统计描述，貌似在社会学、心理学领域中比较常用，比较大的缺点是其输
出结果冗杂；

>SAS 数据分析界的史诗级存在，美国一些政府机构钦定的数据分析工具，权威而全面，但感
觉它的思路是把电脑改造成一个数据处理工作站，软件安装包10几GB左右，功能极其冗杂，
不太适合学术界学习使用；

>Eviews 是以前孙宁华老师课上用的软件，它的特点是专业（时间序列、横截面）但不全面，
图形化界面也很友好，但面板数据的导入很麻烦，感觉用的人不多；

>matlab 以处理速度快、语言简洁、自由度高著称，但语言不够友好。正如其种类繁多的工
具包所示，它更适合工程、金融（如高频交易数据分析）、宏观经济学（Stata15.0已经有了
动态随机一般均衡分析工具）、大数据分析等；

>R 与以上收费软件不同，R是开源软件，因此在企业界普及度较高，R的程序包也十分丰富，
操作难度适中，绘图十分精美，处理速度也较快，且与Office的兼容性非常好，可以作为
Stata的替代软件。

总之，对于经济专业的学习者（尤其是初学者）而言，Stata和R是最佳选择，而Stata比R更
易上手。


**==============================================================**
**                2. Stata的图形化操作界面                      **
**==============================================================**

菜单栏

工具栏

窗口布局

个性化：配色、字符

**==============================================================**
**                      4. 数据的导入                           **
**==============================================================**
我们使用计量软件的目的是对“数据”施加“命令”，以得到结果。相应地，在Stata中，最主要
的文件类型包括数据（.dta）和命令（.do），下面我们分别介绍如何在Stata中对二者进行
操作。

1. Stata所直接处理的是扩展名为.dta文件，类似txt文档，占用存储空间小
*可以在菜单栏打开
2.其他兼容的数据类型 csv,txt
*use Training.csv, clear
clear
insheet using Tr aining.csv

clear
insheet using Training.txt
这一方法不兼容.xlsx文件
clear
insheet using Training.xlsx //结果窗口显示(1 var, 3 obs)，显然存在问题

3.复制粘贴
4.stat transfer
stat/transfer 12.0 似乎不能在win10 1703版上正常运行，请大家试一下并反馈是否出现
“a debug report has been generated”这样的报错；
我装了9.0版本，目前正常运行

数据的保存
save $root/workingdata/Training_cleaned,replace


**==============================================================**
**                      4. do文件的编辑                         **
**==============================================================**

*3.1 为什么要使用do文件

-图形化界面的局限：
>命令不易保存、修改，软件关闭，命令即消失；
>操作繁琐,每次操作都要不断重复点击界面；
>功能组合有限，自由度低，不能进行软件开发。

-command窗口的局限：
>命令历史记录保存在Review窗口中，查找苦难；
>零碎的命令没有条理，无法组织起复杂的操作；
>与图形化界面类似，command窗口的命令也无法长期保存。

因此我们需要一个记录、编辑命令的编辑器，Stata自带的命令编辑器叫“do文件编辑器”，
其功能类似txt文档，所生成的文件扩展名为.do，也就是do文件。

*3.2 do文件的基本编辑规则

do文件中的命令默认为蓝色，字符串为红色，尽量避免使用系统预留字段作为变量名
do文件中的命令可以直接执行：选中，Ctrl+D
【修改工作路径】
clear all
set more off , perm
global root "C:/Users/Xiaoguang/Desktop/9.18计量经济学-Stata入门" 
cd "$root/rawdata"
use Training   //这时命令注释-设置好工作路径后直接使用 use filename 即可调取文件

*行首为星号的命令为红色，表示不会被执行
如果没有星号，Stata会识别此行的命令、变量名称，如果识别失败则会报错

/*如果不想执行多行的命令
（如注释、说明），
可以
这样*/

比较长的命令可以利用 /// 进行分行，比如
sum train  age educ black hisp married nodegree mosinex re74 re75 re78 unem74 ///
    unem75 unem78 lre74 lre75 lre78 agesq mostrn



**==============================================================**
**                      4. 数据描述与t检验                      **
**==============================================================**
（1）简单的数据描述
clear all // 清空数据、变量
set more off , perm //关闭more功能
global root "C:/Users/Xiaoguang/Desktop/9.18计量经济学-Stata入门"  // 利用全局宏变量设置根目录
cd "$root/rawdata" //设置工作路径
use Training, clear  //调取数据文件

sum train  age educ black hisp married nodegree mosinex re74 re75 re78 unem74 ///
unem75 unem78 lre74 lre75 lre78 agesq mostrn //摘要

tab mostrn train //列联表
collapse re74 re75 re78 ,by(train) //按照train分组并保留均值
list //列示每个样本的各个变量值

（2）t检验
i.单样本t检验
Ho: age 均值为25

ttest age == 24 //默认置信度为95%

t=(Ybar-m)/std dev(Ybar)

-Ybar act:已知为 【25.37079】
	sum age
-m:由原假设，m=【24】
-std dev(Ybar)=总体标准差西格玛/sqrt(n), 西格玛：【未知】
	样本标准差 【S】 作为“西格玛”的估计量：S=sum（Yi-Ybar）/sqrt(n-1)
	故std dev(Ybar)的估计量【std error】=S/sqrt(n),计算为 【0.3428148】
	gen ei2=(age-24)^2 //残差平方记为ei2
	egen summation=total(ei2)
	gen stdev=sqrt(summation/444)
		tab stdev
	gen stderr=stdev/sqrt(445)
		tab stderr
	
综上，t的估计值为（25.37079-24）/stderr =【3.998631】
gen t=(25.37079-24)/stderr 
tab t

ttest age == 25, level(95)

ttest age == 25.3, level(99)

ttest age == 25.37

ttest age == 26

ttest age == 27

ii.双样本均值t检验

use Training, clear

Ho:培训前，处理组和控制组收入均值无差异
ttest  re74 , by(train) 
Ho:培训后，处理组和控制组收入均值无差异
ttest  re78 , by(train) 
*关于黑人
ttest  re74 , by(black) 
ttest  re78 , by(black) 

(3)变量相关性
twoway scatter re74 educ, msize(small)
correlate re74 educ,covariance //协方差
correlate re74 educ //相关系数

**==============================================================**
**                      5. 一点微小的建议                       **
**==============================================================**

(1)文件夹：分类保存不同类型的文件
(2)习惯利用do文件进行操作：编辑、修改更容易，操作可保存、复制
(3)定义宏变量：简化命令，方便修改
(4)充分利用搜索引擎、人大经济论坛、help文档等资源
(5)注意中英文字符的切换，尤其是逗号、引号









