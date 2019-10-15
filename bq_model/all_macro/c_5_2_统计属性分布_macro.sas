/*--------------------------------*/
/*统计属性变量分布情况            */
/*Created by : yaoyan             */
/*Created at : 2014-07-24         */
/*Updated by :                    */
/*Updated at :                    */
/*--------------------------------*/


%macro one_var_uniquenum(inDS=,inVAR=,outDS=);
	%put inDS=&inDS inVar=&inVar;
	proc sql;
		create table &outDS as
		select count(distinct "&inVAR"n) as uniquenum
		from &inDS
		;
	run;quit;
	data &outDS;
		set &outDS;
		tablename="&inDS";
		varname=cats("'","&inVAR","'n");
	run;quit;

%mend one_var_uniquenum;

%macro table_uniquenum(inDS=,outDS=);

	proc contents data=&inDS out=cnts(keep=varnum name ) noprint;
	run;quit;
	%let a=%sysfunc(sleep(0.02,1));
	proc sort data=cnts;
		by varnum;
	run;quit;

	%let sid=%sysfunc(open(cnts));
	%let varNum=%sysfunc(attrn(&sid,nobs));
	%let rc=%sysfunc(close(&sid));

	%do varI=1 %to &varNum;
		proc delete data=uniquetab;run;quit;
		data _null_;
			varnum=&varI;
			set cnts point=varnum;
			call symput('name',name);
			stop;
		run;quit;
		%let name=&name;
		%put name=&name;
		%one_var_uniquenum(inDS=&inDS,inVAR=&name,outDS=uniquetab);

		proc append base=&outDS data=uniquetab force;run;quit;
	
	%end;

%mend table_uniquenum;

%macro one_var_freq(inDS=,inVAR=,outDS=);
	%let inVar=&inVar;
	%put inVar=&inVar;
	proc freq data=&inDS.(keep=&inVAR) noprint;
		table &inVAR/missing out=&outDS.;
	run;quit;

%mend one_var_freq;

%macro table_freq(inDS=,outDS=,uniquenum=);

	data all_var_unique;
		length tablename varname $100 uniquenum 8;
		stop;
	run;quit;

	%table_uniquenum(inDS=&inDS,outDS=all_var_unique);

	data all_var_unique1;
		set all_var_unique end=eof;
		where uniquenum<= &uniquenum.;
		if eof then 
			call symput('uniqvarNum',_n_);
	run;quit;

	data &outDS;
		length mytable myvar fenlei $50 count percent 8;
		stop;
	run;quit;

	%do uniqI=1 %to &uniqvarNum;
		data _null_;
			uniqNum=&uniqI.;
			set all_var_unique1 point=uniqNum;
			call symput('myvar',varname);
			stop;
		run;quit;
		%let myvar=&myvar;
		%put myvar=&myvar;
		%one_var_freq(inDS=&inDS,inVAR=&myVAR,outDS=freqtab);

		data freqtab;
			set freqtab;
			mytable="&inDS";
			myvar="&myvar";
			fenlei=""||&myvar;
		run;quit;

		proc append base=&outDS data=freqtab force;run;quit;
	%end;

%mend table_freq;

%macro table_freq_batch(
inDS=,
outDS=
);
	%let sid=%sysfunc(open(&inDS));
	%let nobs=%sysfunc(attrn(&sid,nobs));
	%let rc=%sysfunc(close(&sid));

	data &outDS;
		length mytable myvar fenlei $50 count percent 8;
		stop;
	run;quit;

	%do batchnums=1 %to &nobs;
		data _null_;
			set &inDS(firstobs=&batchnums. obs=&batchnums.);
			call symput('intable',tabname);
			call symput('uniqnum',uniquenum);
			call symput('outtable','out'||left(&batchnums));
		run;quit;

		%table_freq(inDS=&intable,outDS=&outtable,uniquenum=&uniqnum);

		proc append base=&outDS data=&outTABLE force;run;quit;
	%end;

%mend table_freq_batch;


/*例子*/
/*data inDS;*/
/*	length tabname $50 uniquenum 8;*/
/*	input tabname uniquenum;*/
/*	datalines;*/
/*sourlib.Right_case 300*/
/*;*/
/*run;*/
