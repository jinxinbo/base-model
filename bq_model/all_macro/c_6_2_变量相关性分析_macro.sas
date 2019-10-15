/*--------------------------------*/
/*变量相关性分析            */
/*Created by : yaoyan             */
/*Created at : 2015-08-11         */
/*Updated by :                    */
/*Updated at :                    */
/*--------------------------------*/

/*两个连续变量*/
/*皮尔森相关系数*/
proc corr data=&inDS pearson nopirnt outp=&outp;
	var ;
run;
/*斯皮尔曼*/
proc corr data=&inDS spearman nopirnt outs=&outs;
	var ;
run;

/*两个名义变量*/
/*皮尔森卡方统计量*/
/*似然比*/
/*P_PCHI、P_LRCHI*/
proc freq data=&inDS noprint;
	table &var1.*&var2./ chisq ;
	output out=&statout chisq ;
run;quit;

/*概率比*/
/*两个名义变量，并且是2*2的*/
/*_RROR_、L_RROR、U_RROR*/
proc freq data=&inDS noprint;
	table &var1.*&var2./ measures ;
	output out=&statout measures ;
run;quit;

/*F检验*/
/*连续变量与名义变量*/
/*f越大，组间差异越大，关联性越强*/
/*p值代表x和y之间无关联性的概率*/
