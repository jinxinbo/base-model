/*----------------------------*/
/*macro name : count_nullobs  */
/*macro func : count the null records of one table */
/*Input para : 1.inDS : 要进行统计的表，
	           2.outDS : 输出表名 */
/*----------------------------*/
%macro count_nullobs(
inDS=,
outDS=
);
	
	proc contents data=&inDS
					out=content_table(keep=name type nobs label varnum) noprint;
	run;
	proc sort data=content_table;
		by varnum;
	run;
	data _null_;
		set content_table end=last_obs;

		call symput('col'||left(_N_),name);
		call symput('col_type'||left(_n_),type);
		if last_obs then 
			call symput('n',_n_);
	run;
	data nullobs1(keep=null:);
		set &inDS end=last_obs;
		retain null1-null%left(&n.);
		%do colnum=1 %to &n;
			if &&col_type&colnum=1 then
			do;
				if &&col&colnum=. then
					null&colnum=sum(null&colnum.,1);
			end;
			else if &&col_type&colnum.=2 then 
			do;
				if &&col&colnum='' then
					null&colnum=sum(null&colnum.,1);
			end;
		%end;
		if last_obs;
	run;
	proc transpose data=nullobs1
					out=nullobs2;
	run;
	data nullobs2;
		set nullobs2;
		varnum=_n_;
	run;
	data &outDS.;
		length tablename varname varlabel vartype $1000
				nullnum recordsnum null_percent 8;
		merge content_table nullobs2;
		by varnum;
		tablename="&inDS";
		varname=name;
		varlabel=label;
		if type=1 then 
			vartype='num';
		else if type=2 then 
			vartype='char';
		nullnum=col1;
		recordsnum=nobs;
		array num _numeric_;
		do over num;
			if num=. then num=0;
		end;
		null_percent=nullnum/recordsnum;
		keep tablename varname varlabel vartype nullnum recordsnum null_percent;
		format null_percent percent10.1;
	run;

%mend count_nullobs;

/*----------------------------*/
/*macro name : count_nullobs_batch  */
/*macro func : count the null records of many tables */
/*Input para : 1.inDS : 输入表，记录要处理的表名
	           2.outDS : 输出表名 */
/*----------------------------*/
%macro count_nullobs_batch
(
inDS=,
outDS=
);
	%let sid=%sysfunc(open(&inDS));
	%let nobs=%sysfunc(attrn(&sid,nobs));
	%let rc=%sysfunc(close(&sid));

	data &outDS.;
		length tablename varname vartype $1000 nullnum recordsnum null_percent 8;
		stop;
	run;

	%do batchnums=1 %to &nobs.;
		data _null_;
			set &inDS(firstobs=&batchnums. obs=&batchnums.);
			call symput('intable',tabname);
			call symput('outtable','out'||left(&batchnums));
		run;
		%count_nullobs(inDS=&intable,outDS=&outtable);

		proc append base=&outDS data=&outtable force;run;quit;
	%end;

%mend count_nullobs_batch;
/**/
/*例子*/
/*data inDS;*/
/*	length tabname $50;*/
/*	input tabname;*/
/*	datalines;*/
/*sourlib.Right_case*/
/*;*/
/*run;*/
