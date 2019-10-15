/*随机*/

%inc "&dir_mac.\macro_模型变量选择.sas";

%macro combine(intab=,res=,out=,ns1=,ns2=,group=,var_keep=,sp_var=);
 data &res.;
  length num ks1 ks2 ks3 8;
  stop;
 run;
 data &out.;
  length num rk m1 m0 v1 v0  n1 n0 8;
  stop;
 run;
data _null_;
  set &ns1. end=last;
  call symputx('var'||left(_n_),&ns2.);
  if last then call symput('n',_n_);
run;
%put &var1.  &n.;

%do i=1 %to &n.;

data learn_off_clu;
  set &intab.;
/*  keep &var_keep. &&var&i..;*/
  drop &&var&i..
  ;
 run;

 /*
proc contents data=learn_off_clu out=cnt(where=(type=1) keep=name type) noprint;run;
data cnt;
  set cnt;
  where upcase(name) not in('TARGET','CUS_ID','CONTRACT_NO');
  put name;
run;
filename logic catalog "work.v1.vars.source";
data _null_;
	set cnt end=last;
	file logic;
	if _n_=1 then put "model target=" ;
	if name^="target" then put name;
	if last then put '/SELECTION=b details lackfit stb sls=0.07;';
run;
proc logistic data=learn_off_clu desc outest=dt.test_model_tr;
	%inc logic;
	output out=dt.test_model_logi p=fraud_p;
run;quit;
 */

/*自动挑选系数不为负的模型*/

%select_var(learn_off_clu,25,&sp_var.,0.07);

proc transpose data=dt.test_model_tr out=inmod(drop=_label_);run;quit;
data inmod1;
   set inmod;
   where target^=.;
   put _NAME_;
run;


%KSStat(dt.test_model_logi, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :M_KS from DSKS;
run; quit;
%put m_ks=&m_ks;


proc sort data=dt.test_model_logi; by descending fraud_p;run;
proc rank data=dt.test_model_logi groups=&group. descending out=rank; 
var fraud_p; 
ranks rk; 
run; 
proc freq data=rank; 
table rk*target/missing out=m1; 
run; 
proc transpose data=m1 out=m2(drop=_name_ _label_) prefix=m;
by rk;
id target;
var count;
run;quit;


 filename vd catalog 'work.vd.vd.source';
data yz;
   set inmod1 end=last;
   file vd;
   where _name_^='_LNLIKE_';
   if _n_=1 then put 'tmp=exp(sum(';
   if _name_='Intercept' then put target;
    else do;
   line1=catx('*',target,_name_);
   line=cats(',',line1);
   put line;
   end;
  if last then put '));';
run;
*计算逻辑值;


/*同时间验证*/
data valid0_1;
	set valid0;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

proc sort data=valid0_1;by descending fraud_p;run;

%KSStat(valid0_1, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :M_KS from DSKS;
run; quit;
%put m_ks=&m_ks;

proc sort data=valid0_1; by descending fraud_p;run;
proc rank data=valid0_1 groups=&group. descending out=rank; 
var fraud_p; 
ranks rk; 
run; 
proc freq data=rank; 
table rk*target/missing out=m1; 
run; 
proc transpose data=m1 out=m2(drop=_name_ _label_) prefix=m;
by rk;
id target;
var count;
run;quit;


/*同时间验证*/
data valid1_1;
	set valid1;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

proc sort data=valid1_1;by descending fraud_p;run;

%KSStat(valid1_1, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :V_KS from DSKS;
run; quit;
%put v_ks=&v_ks;

proc rank data=valid1_1 groups=&group. descending out=rank1; 
var fraud_p; 
ranks rk; 
run; 

proc freq data=rank1 noprint; 
table rk*target/missing out=v1; 
run;

proc transpose data=v1 out=v2(drop=_name_ _label_)prefix=v;
by rk;
id target;
var count;
run;quit;


/*跨时间验证*/
data valid2_1;
	set valid2;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

proc sort data=valid2_1;by descending fraud_p;run;

%KSStat(valid2_1, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :N_KS from DSKS;
run; quit;
%put n_ks=&n_ks;

proc rank data=valid2_1 groups=&group. descending out=rank1; 
var fraud_p; 
ranks rk; 
run; 

proc freq data=rank1 noprint; 
table rk*target/missing out=n1; 
run;

proc transpose data=n1 out=n2(drop=_name_ _label_)prefix=n;
by rk;
id target;
var count;
run;quit;


data res1;
  num=&i.;
  ks1=&m_ks.;
  ks2=&v_ks.;
  ks3=&n_ks.;
run;
data res2;
 set m2; set v2;set n2;
 num=&i.;
run;

proc append base=&res. data=res1 force;run;quit;
proc append base=&out. data=res2 force;run;quit;

 %end;
%mend combine;
