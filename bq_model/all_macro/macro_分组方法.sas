/*
data outdata;
   set bh.newTrain_in_model1_lx;
   array ar _numeric_;
   do over ar;
     if ar=. then ar=0;
   end;
;run;
/*分组方法一：决策树分组*/
/*利用python sklearn中的决策树返回分组结果*/
/*PROC EXPORT DATA= outdata */
/*            OUTFILE= "E:\python工程\cash_tree\tmp.xlsx" */
/*            DBMS=EXCEL REPLACE;*/
/*     SHEET="Sheet"; */
/*RUN;*/

/*proc import datafile='E:\python工程\cash_tree\allbin.xlsx' out=allbin*/
/*   dbms=excel replace;*/
/*   getnames=yes;*/
/* run;*/
 %macro bin_from_py(intab,dtbin,outtab,woetab);
 data bintab;
    length varname $32 COL1 8.;
	stop;
  run;
   data &outtab.;
    length varname $32 p0 p1 bin maptotal woe iv1 iv 8;
	stop;
   run;
	data _null_;
	   set &dtbin. end=last;
	   call symputx('name'||left(_n_),varname);
	   if last then call symputx('n',_n_);
	run;
	%do i=1 %to &n.;
	 proc transpose data=&dtbin.(where=(varname="&&name&i..")) out=l1(drop=_name_ _label_);run;
	data l2;
	   set l1;
	   varname="&&name&i..";
	run;
   proc append base=bintab data=l2 force;run;
   %end;
	data bintab1;
	   set bintab;
	   where col1^=.;
	   col1=round(col1,1e-6);
	 run;
	proc sort data=bintab1;by varname col1;run;
	data bintab1;
	   set bintab1;
	   by varname col1;
	   if first.varname then bin=1;
	     else bin+1;
	   bin1=bin+1;
	   newname=cats("_",varname);
	run;

	filename nb catalog 'work.t1.t1.source';
	proc sort data=bintab1;by varname bin;run;
	data _null_;
	   set bintab1;
	   by varname bin;
	   file nb;
	   if first.varname then put "if round(" varname ",1e-6)<=" col1 "then " newname "=" bin";";
	     else put "else if round(" varname ",1e-6)<=" col1 "then " newname "=" bin";";
		  if last.varname then put "else " newname "=" bin1";";
	  run;

		data outdata_temp &woetab.;
		   set &intab.;
		   %inc nb;
		   keep cus_id target _:;
		run;
		proc contents data=outdata_temp out=cnt(keep=name) noprint;run;
		data cnt;
		   set cnt;
		  where upcase(name) not in('CUS_ID','TARGET');
		run;
	data _null_;
	   set cnt end=last;
	   call symputx('name'||left(_N_),name);
	   if last then call symputx('n',_n_);
	run;
	proc sql noprint; 
	   select sum(target) , count(*)-sum(target) into : p1 , :p0 from &intab.;
	quit;
	%do bi=1 %to &n.;
	proc freq data=outdata_temp noprint;table &&name&bi..*target/out=cc;
	proc transpose data=cc out=cc1(drop=_name_ _label_) prefix=p;
	 by &&name&bi..;
	 id target;
	 var count;
	data cc1;
	   set cc1;
	   varname="&&name&bi..";
	   rename &&name&bi..=bin;
	   retain iv;
	   maptotal=sum(p0,p1);
	   p1t=p1/&p1.;
       p0t=p0/&p0.;
	   woe=log(p1t/p0t);
	   iv1=(p1t-p0t)*woe;
	   iv+iv1;
	run;
	 proc sql;
	  create table &woetab. as
      select a.*,b.woe as woe&&name&bi..
	   from  &woetab. a
	   left join cc1 b
	   on a.&&name&bi..=b.bin
	   ;
	 quit;
   proc append base=&outtab. data=cc1 force;run;
    %end;
proc sql;
   create table &outtab. as
    select a.*,b.col1 as ul
	from &outtab. a
	left join bintab1 b on a.varname=b.newname and a.bin=b.bin;
quit;
data &outtab.;
   set &outtab.;
   varname=substr(varname,2);
run;
%mend;

/*
%bin_from_py(outdata,allbin,dt.py_mapiv,dt.py_woetab);

proc sort data=dt.py_mapiv;by varname bin;run;
data iv;
   set dt.py_mapiv;by varname bin;
   if last.varname and iv>=0.02 ;
   put varname;
run;
*/

/*分组方法二:*/
%inc "&dir_mac.\c_6_4_GroupVar_macro.sas";

%macro calWoeIV_and_apply(inDS=,adj_num=,min_grpNum=,outDS=,outMapSum=,outIVSum=,max_group=,my_woe=);
data &outMapSum.;
	length VARNAME $50 LL UL Bin BinTotal 8;
	stop;
run;
data &outIVSum.;
	length VARNAME $50 GRP_VAR cnt_0 cnt_1 WOE IV 8;
	stop;
run;
proc contents data=&inDS out=dt.temp_cnt(keep=name type ) noprint;
run;
data dt.temp_cnt1;
	set dt.temp_cnt;
	where type=1;
	if name not in ('ID_PERSON' 'cardno' 'target' 'userid','uid','contract_no','app_no','user_sid');
run;

data &outDS.;
	set &inDS.;
run;

%do vari=1 %to %Get_ds_rec_num(in_ds=dt.temp_cnt1);
	data _null_;
		set dt.temp_cnt1(firstobs=&vari obs=&vari);
		call symputx('binvar',name);
	run;

   /*不输出变换后的数据集，只输出分箱*/
	%if %eval(&outDS.=nan) %then %do;
      %bestgrouping_lone(target=target,
		group_var=&binvar.,
		in_ds=&outDS.,
		adj=&adj_Num.,min_group_num=&min_grpNum.,
		DSVarMap=dt.&binvar._map,
		DSVarIv=dt.&binvar._IV,
		max_group=&max_group.,method=1,m_woe=&my_woe.);
	%end;

	%else %do;
		%bestgrouping(target=target,
		group_var=&binvar.,
		in_ds=&outDS.,
		adj=&adj_Num.,min_group_num=&min_grpNum.,
		DSVarMap=dt.&binvar._map,
		DSVarIv=dt.&binvar._IV,
		out_group_DS=&outDS.,max_group=&max_group.,method=1,m_woe=&my_woe.);
	 %end;

	data dt.&binvar._map;
		set dt.&binvar._map;
		VARNAME="&binvar";
	run;
	proc append base=&outMapSum. data=dt.&binvar._map force;run;quit;
	data dt.&binvar._IV;
		set dt.&binvar._IV;
		VARNAME="&binvar";
		rename GRP_&binvar.=GRP_VAR;
	run;
	proc append base=&outIVSum. data=dt.&binvar._IV force;run;quit;
	proc datasets lib=dt nolist nodetails;
		delete &binvar._map &binvar._IV ;
	run;quit;
%end;
proc datasets lib=dt nolist nodetails;
	delete temp_cnt temp_cnt1 &binvar._map;
run;quit;

%mend;


/*
libname dt 'E:\pos贷行为评分卡\变量开发\数据集';
%calWoeIV_and_apply(inDS=outdata,
adj_num=0.05,min_grpNum=0.05,max_group=7,
outDS=dt.varnew_out1,
outMapSum=dt.varnew_map1,
outIVSum=dt.varnew_IV1);
proc sql;
  create table dt.varnew_mapiv as
   select a.*,b.ll,b.ul
   from dt.Varnew_iv1 a
   left join dt.Varnew_map1 b
   on a.varname=b.varname and a.grp_var=b.bin;
quit;
*/
/*方法三：*/
%inc "&dir_mac.\c_6_4_GroupVar_macro.sas";

%macro oldbin(intab,target,max_group,outtab,woetab,mingrouprate);
data &outtab.;
   length var $32. bin BinTotal iv iv1 LL maptotal p0 p1 UL woe 8.;
   stop;
run;
proc contents data=&intab. out=cnt(keep=name) noprint;run;
data _null_;
   set cnt end=last;
   where upcase(name) not in("ID_PERSON","TARGET","CUS_ID","CONTRACT_NO");
   call symputx('var'||left(_n_),name);
   if last then call symputx('n',_n_);
run;
data &woetab.;
   set &intab.;
run;
%do ni=1 %to &n.;

%bincontvar(2,&intab.,&&var&ni..,&target.,4,&max_group.,0.01,map,&mingrouprate.);
filename xx catalog 'work.t1.t1.source';
proc sort data=map;by bin;run;
data map;
   set map end=last;
   by bin;
   file xx;
   if _n_=1 then put "if round(&&var&ni..,1e-10)<=" ul "then bin=" bin";";
     else  if last=0 then put "else if round(&&var&ni..,1e-10)<=" ul "then bin=" bin";";
	  else put "else bin=" bin";";
data &woetab.;
   set &woetab.;
 %inc xx;  
 run;
proc freq data=&woetab. noprint; 
	table bin*&target. /missing out=tmp_varbin_crosscnt;
	table &target. /missing out=tmp_varbin_totcnt;
run;quit; 
data _null_;
    set tmp_varbin_totcnt;
	call symputx('p'||left(target),COUNT);
 run;
proc transpose data=tmp_varbin_crosscnt out=cc(drop=_name_ _label_) prefix=p;
 by bin;
 id target;
 var count;
run;
data cc1;
   set cc;
   retain iv;
   maptotal=sum(p0,p1);
   woe=log(p1*&p0./&p1./p0);
   iv1=(p1/&p1.-p0/&p0.)*woe;
   iv+iv1;
run;


proc sql;
   create table mapiv as
    select a.*,b.* 
	from cc1 a
	left join map b
	on a.bin=b.bin
   ;
   create table &woetab. as
      select a.*,b.woe as woe_&&var&ni..
	   from &woetab. a
	   left join cc1 b
	   on a.bin=b.bin
	   ;
 quit;
data mapiv;
   set mapiv;
   var="&&var&ni..";
run;

proc append base=&outtab. data=mapiv force;run;quit;
%end;
%mend;
/*
%oldbin(outdata,target,7,dt.out_mapiv,dt.out_woetab,0.05)
*/
/*分类变量分组*/
%inc "&dir_mac.\c_6_3_CalcWOE_macro.sas";

%macro calcwoe_catevar(inDS=,outDS=);
data &outDS;
	set &inDS;
run;
proc contents data=&inDS. out=catevar(keep=name) noprint;run;
data catevar;
   set catevar;
   where upcase(name) not in("CUS_ID","TARGET","CONTRACT_NO","UID","APP_NO","USER_SID");
run;
%let sid=%sysfunc(open(catevar));
%let nobs=%sysfunc(attrn(&sid,nobs));
%let rc=%sysfunc(close(&sid));
%put nobs=&nobs;
%do i=1 %to &nobs;
data _null_;
	set catevar(firstobs=&i obs=&i);
	call symput('catevar',trim(name));
run;
%put &catevar.;
%CalcWOE(&outDS, &catevar., target,
		&catevar._WDS, 
		&catevar._War,
		&outDS);
%end;
%mend;




%inc "&dir_mac.\macro_检查分箱的稳定性.sas";


%macro auto_mapiv(intab,id,outmapiv,max_group);

%let bi=&max_group.;
%let unstab_cnt=99;

proc contents data=&intab. out=out_var_stab(keep=name type) noprint;run;

data out_var_stab;
     set out_var_stab;
	 rename name=var;
 run;
%do %while(&bi>=3);
   %if %eval(&unstab_cnt.>0) %then %do; 
    %put &bi.;
	filename bin&bi. catalog "work.t1.bin&bi..source";
	data _null_;
	   set out_var_stab end=last;
	   file bin&bi.;
	   if _n_=1 then put "keep &id. target";
	   put var;
	   if last then put ';';
	run;

	data outdata;
	      set &intab.;
	      %inc bin&bi.;
	run; 

	proc printto log='.\连续变量分箱_log.txt' new;run;
	%calWoeIV_and_apply(inDS=outdata,adj_num=0.05,
	                           min_grpNum=0.05,
	                           outDS=dt.new_out_woetab&bi.,
	                           outMapSum=dt.new_out_map&bi.,outIVSum=dt.new_out_iv&bi.,max_group=&bi.);
	proc printto ;run;quit;

	proc sql;
	  create table dt.new_out_mapiv&bi. as
	   select a.*,b.ll,b.ul
	   from dt.new_out_iv&bi. a
	   left join dt.new_out_map&bi. b
	   on a.varname=b.varname and a.grp_var=b.bin;
	quit;
    proc sort data=dt.new_out_mapiv&bi.;by varname grp_var;run;
     data iv_tp;
	   set dt.new_out_mapiv&bi.;
        by varname grp_var;
	   if last.varname and iv>=0.02;
	run;

    %put  -------------------------------;
    %put 检查分箱稳定性;
	%put  -------------------------------;
	proc sql;
	   create table mapiv as 
	   select * from dt.new_out_mapiv&bi.
	   where varname in(select varname from iv_tp);
	quit;

	data in_mapiv;
	    set mapiv;
		where grp_var^=0;
		rename grp_var=bin varname=var; 
	 run;
   
	%check_stab(in_mapiv, out_var_stab);
	proc sql noprint;
		select count(*) into:unstab_cnt from Out_var_stab;
		quit;
	%put unstab_cnt=&unstab_cnt.;
      
     %if %eval(&bi.>3) %then %do;
    %put  -------------------------------;
    %put 保存分箱稳定的分组;
	%put --------------------------------;

    proc sql;
	    create table save_mapiv as
		  select * from mapiv  
		  where varname not in(select var from out_var_stab);
	quit;
    %end;
	%else %do;
	    data save_mapiv;
		     set mapiv;
		  run;
	  %end;
	proc append base=&outmapiv. data=save_mapiv force;run;quit;

   %end;
    %let bi=%eval(&bi-1);
%end;

%mend;



/*名义变量woe分组
%calcwoe_catevar(inDS=test,outDS=test_1);
后面再当做连续变量，用以上三种方法*/


/*求手动分组的变量woe值
%let tab=bh.newTrain_in_model1;
%let name=cus_sex;
proc sql noprint; 
   select sum(target) , count(*)-sum(target) into : p1 , :p0 from &tab.;
quit;
proc freq data=&tab. noprint;table &name.*target/out=cc;
proc transpose data=cc out=cc1(drop=_name_ _label_) prefix=p;
 by &name.;
 id target;
 var count;
data cc1;
   set cc1;
   retain iv;
   maptotal=sum(p0,p1);
   p1t=p1/&p1.;
   p0t=p0/&p0.;
   woe=log(p1t/p0t);
   iv1=(p1t-p0t)*woe;
   iv+iv1;
run;
*/
