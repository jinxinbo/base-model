/*--------------------------------*/
/*统计连续变量分布情况            */
/*Created by : yaoyan             */
/*Created at : 2014-07-24         */
/*Updated by :                    */
/*Updated at :                    */
/*--------------------------------*/



%macro one_var_univariate(inDS=,inVAR=,outDS=);

	proc univariate data=&inDS(keep=&inVAR) noprint;
		var &inVAR;
		output out=&outDS. pctlpts=0 5 10 15 25 50 75 90 95 96 98 100
						pctlpre=pvalue
						pctlname=_0 _5 _10 _15 _25 _50 _75 _90 _95 _96 _98 _100
						mean=my_mean
						n=my_n
						nobs=my_nobs
						kurtosis=my_kurtosis
						mode=my_mode
						nmiss=my_nmiss
						range=my_range
						skewness=my_skewness
						std=my_std
						stdmean=my_stdmean
						var=my_var;
	run;quit;
/*	data _null_;*/
/*		set &outDS.1;*/
/*		call symput('max',pvalue_100);*/
/*		call symput('min',pvalue_0);*/
/*	run;*/
/*	%let max=&max;*/
/*	%let min=&min;*/
/*	data t;*/
/*		set &inDS(keep=&inVAR);*/
/*		if &inVAR>=&max then delete;*/
/*		if &inVAR<=&min then delete;*/
/*	run;*/
/*	proc univariate data=t noprint;*/
/*		var &inVAR;*/
/*		output out=&outDS.2 */
/*						mean=my_mean_exc*/
/*						nobs=my_nobs_exc*/
/*						std=my_std_exc*/
/*						var=my_var_exc;*/
/*	run;quit;*/
/*	data &outDS;*/
/*		set &outDS.1;*/
/*		set &outDS.2;*/
/*	run;*/


%mend one_var_univariate;

%macro table_univariate(inDS=,outDS=);

	data &outDS;
/*		length mytable myvar $50 my_n my_mean my_mean_exc my_std my_std_exc my_skewness */
/*				my_var my_var_exc my_kurtosis my_stdmean my_nmiss my_nobs my_nobs_exc*/
/*				my_range my_mode pvalue_0 pvalue_5 pvalue_10 pvalue_15 */
/*				pvalue_25 pvalue_50	pvalue_75 pvalue_90 pvalue_95 pvalue_96*/
/*				pvalue_98 pvalue_100 8;*/
		length mytable myvar $50 my_n my_mean  my_std  my_skewness 
				my_var my_kurtosis my_stdmean my_nmiss my_nobs
				my_range my_mode pvalue_0 pvalue_5 pvalue_10 pvalue_15 
				pvalue_25 pvalue_50	pvalue_75 pvalue_90 pvalue_95 pvalue_96
				pvalue_98 pvalue_100 8;

		stop;
	run;quit;

	%let sid=%sysfunc(open(&inDS.));
	%let univNum=%sysfunc(attrn(&sid,nvars));
	%do univI=1 %to &univNum.;
		%let myvar=%sysfunc(varname(&sid,&univI));
		%let myvartype=%sysfunc(vartype(&sid,&univI));
		%let myvarformat=%sysfunc(varformat(&sid,&univI));

		%if 		&myvartype = N 
				and %sysfunc(index(&myvarformat.,$))=0
				and %sysfunc(index(&myvarformat.,DATE))=0
				and %sysfunc(index(&myvarformat.,DATETIME))=0
				and %sysfunc(index(&myvarformat.,YYMMDD))=0
		%then %do;
            
/*		data temp; */
/*		     set &inDS;*/
/*			 keep &myvar;*/
/*		 run;*/
		    
			%one_var_univariate(inDS=&inDS,inVAR=&myvar,outDS=uni_temp);
			%let myt=%sysfunc(sleep(0.01,1));
			data uni_temp;
				set uni_temp;
				mytable="&inDS";
				myvar="&myVAR";
			run;quit;
			%let myt=%sysfunc(sleep(0.01,1));
			proc append base=&outDS data=uni_temp force;run;quit;

		%end;
	%end;



%mend table_univariate;


%macro table_univariate_batch(
inDS=,
outDS=
);
	%let sid=%sysfunc(open(&inDS));
	%let nobs=%sysfunc(attrn(&sid,nobs));
	%let rc=%sysfunc(close(&sid));

	data &outDS;
		length mytable myvar $50 my_n my_mean my_mean_exc my_std my_std_exc my_skewness 
				my_var my_var_exc my_kurtosis my_stdmean my_nmiss my_nobs my_nobs_exc
				my_range my_mode pvalue_0 pvalue_5 pvalue_10 pvalue_15 
				pvalue_25 pvalue_50	pvalue_75 pvalue_90 pvalue_95 pvalue_96
				pvalue_98 pvalue_100 8;
		stop;
	run;quit;

	%do batchnums=1 %to &nobs;
		data _null_;
			set &inDS(firstobs=&batchnums obs=&batchnums);
			call symput('intable',tabname);
			call symput('outtable','out'||left(&batchnums));
		run;quit;

		%table_univariate(inDS=&intable,outDS=&outtable);

		proc append base=&outDS data=&outtable force;run;quit;

	%end;

%mend table_univariate_batch;

/*例子*/
/*data inDS;*/
/*	length tabname $50;*/
/*	input tabname;*/
/*	datalines;*/
/*sourlib.Right_case*/
/*;*/
/*run;*/




