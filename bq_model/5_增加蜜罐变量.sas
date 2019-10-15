
proc sql;
   create table dt.data_mg_1(drop=business_id_mg app_no) as
   select a.*,b.target,b.user_sid
   from dt.data_mg a
   join dt.data4 b on a.app_no=b.user_sid;
quit;

proc sql;
     create table dt.data_mg_1_train(drop=business_id_mg app_no) as
   select a.*,b.target,b.user_sid
   from dt.data_mg a
   join dt.Data_train1_lx b on a.app_no=b.user_sid;
quit; 

%inc "&dir_mac.\检查空缺情况_macro.sas";

 %count_nullobs(inDS=dt.data_mg_1_train,outDS=dt.nullobs2);
proc sort data=dt.nullobs2;
	by descending null_percent;
run;quit;




%macro select_var_bywoe;
%do wi=1 %to 1;
 %do bi=7 %to 7;
proc printto log=".\变量分箱_&wi..txt" new;run;quit;
%calWoeIV_and_apply(inDS=dt.data_mg_1_train,adj_num=0.1,
                           min_grpNum=0.05,
                           outDS=nan,
                           outMapSum=dt._05_per_mg_map_&wi._&bi.,outIVSum=dt._05_per_mg_iv_&wi._&bi.,max_group=&bi.,my_woe=&wi.);

proc printto;run;quit;

proc sql;
  create table dt._05_per_mg_mapiv_&wi._&bi. as
   select a.*,b.ll,b.ul
   from dt._05_per_mg_iv_&wi._&bi. a
   left join dt._05_per_mg_map_&wi._&bi. b
   on a.varname=b.varname and a.grp_var=b.bin;
quit;
%end;
%end;

%mend;

%select_var_bywoe;








proc sort data=dt._05_per_mg_mapiv_1_7;by varname grp_var;run;
data iv5;
   set dt._05_per_mg_mapiv_1_7;
   by varname grp_var;
   if last.varname and iv>=0.02;
run;
proc sort data=iv5;by descending iv;run;


proc sql;
   create table mapiv_mg as
    select * from dt._05_per_mg_mapiv_1_7
	where varname in(select varname from iv5);
quit;

 filename bin1 catalog 'work.t1.bin1.source';
data mapiv_mg;
    set mapiv_mg;
	rename GRP_VAR=bin;
proc sort data=mapiv_mg;by varname bin;run;

data _null_;
   set mapiv_mg;
   by varname bin;
   file bin1;
   if first.varname then put 'if ' varname'<=' ul 'then W_' varname '=' woe';';
     else if last.varname=0 then  put 'else if ' varname'<=' ul 'then W_' varname'=' woe';' ;
	   else put 'else W_' varname '=' woe';';
run;
