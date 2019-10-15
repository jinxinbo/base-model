%inc "&dir_mac.\c_6_4_CalcKS_macro.sas";
ods listing;
ods results off;

proc printto;run;


/* 最终分组*/
 filename bin catalog 'work.t1.bin.source';
data mapiv;
    set mapiv;
	rename GRP_VAR=bin;
proc sort data=mapiv;by varname bin;run;

data _null_;
   set mapiv;
   by varname bin;
   file bin;
   if first.varname then put 'if ' varname'<=' ul 'then W_' varname '=' woe';';
     else if last.varname=0 then  put 'else if ' varname'<=' ul 'then W_' varname'=' woe';' ;
	   else put 'else W_' varname '=' woe';';
run;

proc sql;
   create table allwoetab as
    select * from data_bin_mon
	where user_sid in(select user_sid from dt.Data_train1_lx);
 quit;


data allwoetab;
    set allwoetab;
%inc kp1;
;
run;



proc sql;
   create table alltab1 as
    select a.*,b.w_cus_sex 
	from allwoetab a
	left join dt.New_fl_woetab b on a.user_sid=b.user_sid;
quit; 

/*变量聚类*/
%inc "&dir_mac.\c_6_1_变量聚类_macro.sas";

%varclus(alltab1,0.7,outstat,outtree,outcluster,outr2);

proc sql;
    create table outcluster1 as
	 select a.*,b.iv,d.RSquareRatio
	 from outcluster a
	 left join iv_all b on substr(a.varname,3)=b.varname or a.varname=b.varname
	 left join outr2 d on a.varname=d.Variable
    order by cluster_1,iv desc;
 quit;


 data outcluster1;
    set outcluster1;
	by cluster_1 descending iv;
	if first.cluster_1 then grp=0;
	grp+1;
run;

proc sort data=outcluster1;by cluster_1 RSquareRatio;run;
data outcluster1;
   set outcluster1;
   by cluster_1 RSquareRatio;
	if first.cluster_1 then r2bin=0;
	r2bin+1;
run;


filename clu catalog 'work.t1.clu.source';
data outcluster2;
   set outcluster1 end=last;;
   where grp<=2 or r2bin<=2;
   file clu;
   if _n_=1 then put 'keep user_sid target weight';
   put varname;
   if last then put ';';
run;




ods listing;
ods results off;



;

proc freq data=alltab1;table target;run;
 

data alltab2;
    set alltab1;
	if target=1 then weight=10747/ 331;
	   else weight=1;
/*	   %inc clu;*/
;run;

data alltab2;
  set alltab2;
  drop W_var_out tree:
; 
run;





%inc "&dir_mac.\macro_模型变量选择.sas";

proc printto log=".\model_train_log.txt" new;run;
%select_var(alltab2,25,tree_,0.1);
proc printto;run;

proc sort data=pe1;by descending WaldChiSq;run;

proc sql;
   create table pp as
    select a.*,b.iv
	from pe1 a
	left join iv3 b on substr(a.name,3)=b.varname
    order by b.iv desc;
 quit;

proc printto;run;
proc transpose data=dt.test_model_tr out=inmod(drop=_label_);run;quit;
data inmod1;
   set inmod;
   where target^=.;
   put _NAME_;
run;

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


%KSStat(dt.test_model_logi, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :M_KS from DSKS;
run; quit;
%put m_ks=&m_ks;

/*proc sort data=pe;by step descending WaldChiSq;run;*/


proc sql;
   create table mod_mapiv as
    select * from mapiv_all 
	where varname in(select substr(name,3) from pe1);
quit;
 

data temp;
	set data_bin_mon;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

ods listing;
proc sort data=dt.test_model_logi;by descending fraud_p;run;
proc rank data=dt.test_model_logi groups=10 descending out=rank; 
var fraud_p; 
ranks rk; 
run; 
proc freq data=rank;table rk*target/nopercent nocol;run;



/*模型验证*/

filename bin catalog 'work.t1.t3.source';
data _null_;
   set mapiv;
   by varname bin;
   file bin;
   if first.varname then put 'if ' varname'<=' ul 'then W_' varname '=' woe';';
     else if last.varname=0 then  put 'else if ' varname'<=' ul 'then W_' varname'=' woe';' ;
	   else put 'else W_' varname '=' woe';';
run;


/*模型验证*/

/*data valid1;*/
/*   set dt.Data_test;*/
/*   %inc null;*/
/*   %inc bin;*/
/*run;*/
/**/
/*proc sql;*/
/*   create table valid1 as*/
/*    select a.*,b.W_cus_sex*/
/*	from valid1 a*/
/*	left join dt.wds_cus_sex b on a.cus_sex=b.cus_sex;*/
/* quit;*/
data valid0;
   set Data_bin_1;
run;

data valid0_1;
	set valid0;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

proc sort data=valid0_1;by descending fraud_p;run;

%KSStat(valid0_1, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :V_KS from DSKS;
run; quit;
%put v_ks=&v_ks;




data valid1;
   set Data_bin_2;
run;

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



/*跨时间验证数据*/


/*data valid2;*/
/*   set dt.Data_valid;*/
/*/*    if count_flag>1 then count_flag1=1;else count_flag1=0;*/*/
/*/*   %inc null;*/*/
/*   %inc bin;*/
/*run;*/
/**/
/*proc sql;*/
/*   create table valid2 as*/
/*    select a.*,b.W_cus_sex*/
/*	from valid2 a*/
/*	left join dt.wds_cus_sex b on a.cus_sex=b.cus_sex;*/
/* quit;*/

;

data valid2;
   set Data_bin_3;
run;

data valid2_1;
	set valid2;
	%Inc vd;
	fraud_p=tmp/(1+tmp);
run;

proc sort data=valid2_1;by descending fraud_p;run;

%KSStat(valid2_1, fraud_p, target, DSKS, M_KS);
proc sql noprint;
 select max(KS) into :V_KS from DSKS;
run; quit;
%put v_ks=&v_ks;



%let var=fraud_p;

proc sql;
   create table err as
    select a.user_sid,a.&var.,b.&var. as &var._1
	from valid1_1 a
	left join valid2_1 b on a.user_sid=b.user_sid
    having &var.^=&var._1;
quit;


/*模型变量分布稳定性分析*/
%macro wdx(intab,outtab);
data &outtab.;
    length var $32. count percent woe 8.;
    stop;
 run;
data _null_;
    set inmod1 end=last;
	where _name_ not in('Intercept','_LNLIKE_');
	call symputx('var'||left(_n_),_name_);
	if last then call symputx('n',_n_);
 run;
%do i=1 %to &n.;
       %put &&var&i..;
		%let varname=&&var&i..;
		proc freq data=&intab. noprint ;table &varname./out=cc;run;
		data cc;
		    set cc;
			rename &varname.=woe;
			var="&varname.";
		run;
      proc append base=&outtab. data=cc force;run;quit;
%end;
%mend;

%wdx(dt.test_model_logi,wdx_train);

%wdx(valid0_1,wdx_0);

%wdx(valid1_1,wdx_1);

%wdx(valid2_1,wdx_2);

proc sql;
    create table wdx_all as
    select a.*,
	   b0.count as count_0,b0.percent as percent_0,
       b1.count as count_1,b1.percent as percent_1,
       b2.count as count_2,b2.percent as percent_2,
       c.target as coef
	from wdx_train a
	left join wdx_0 b0 on a.var=b0.var and round(a.woe,1e-5)=round(b0.woe,1e-5)
	left join wdx_1 b1 on a.var=b1.var and round(a.woe,1e-5)=round(b1.woe,1e-5)
	left join wdx_2 b2 on a.var=b2.var and round(a.woe,1e-5)=round(b2.woe,1e-5)
	left join inmod1 c on a.var=c._NAME_;
quit;

data wdx_all;
   set wdx_all;
   psi0=log(percent_0/percent)*(percent_0-percent)/100;
   psi1=log(percent_1/percent)*(percent_1-percent)/100;
   psi2=log(percent_2/percent)*(percent_2-percent)/100;
run;
proc sql;
   create table wdx_all1 as
    select var,abs(sum(psi0)) as psi_0,abs(sum(psi1)) as psi_1,abs(sum(psi2)) as psi_2
	from wdx_all
	group by 1
    ;
quit;



/*检验iv值稳定性*/
%macro supiv(tab,outtab);
data &outtab.;
   length var$32. iv iv1 maptotal mod_woe p0 p0t p1 p1_p0 p1t woe 8.;
   stop;
run;

proc contents data=&tab. out=v_cnt(keep=name) noprint;run;
data _null_;
    set v_cnt end=last;
    where index(upcase(name),'W_') or index(name,'tree');
    call symputx('name'||left(_n_),name);
    if last then call symputx('n',_n_);
run;
 
%do ii=1 %to &n.;
   
	%let name=&&name&ii..;
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
	   p1_p0=p1/p0;
	   woe=log(p1t/p0t);
	   iv1=(p1t-p0t)*woe;
	   iv+iv1;
	   var="&name.";
     rename  &name.=mod_woe;
	run;
 proc append base=&outtab. data=cc1 force;run;quit;

  %end;

  %mend;

data _null_;
  set inmod1;
  put _name_;
run;

filename stb_iv catalog 'work.vd.iv.source';
data yz;
   set inmod1 end=last;
   file stb_iv;
   where _name_ not in('_LNLIKE_', 'Intercept');
   if _n_=1 then put 'keep user_sid target';
   put _name_;
  if last then put ';';
run;

data stb_data_1;
   set dt.Test_model_logi;
   %inc stb_iv;
 data stb_data_2;
   set Valid1_1;
   %Inc stb_iv;
 data stb_data_3;
   set Valid2_1;
   %Inc stb_iv;
run;


%supiv(stb_data_1, stb_data_1_iv);
%supiv(stb_data_2, stb_data_2_iv);
%supiv(stb_data_3, stb_data_3_iv);


proc sort data=stb_data_1_iv;by var iv;run;
data stb_data_1_iv1;
   set stb_data_1_iv;
    by var iv;
	if last.var;
run;

proc sort data=stb_data_2_iv;by var iv;run;
data stb_data_2_iv1;
   set stb_data_2_iv;
    by var iv;
	if last.var;
run;

proc sort data=stb_data_3_iv;by var iv;run;
data stb_data_3_iv1;
   set stb_data_3_iv;
    by var iv;
	if last.var;
run;

proc sql;
   create table stb_sup_iv as
    select a.var,a.iv,b.iv as iv1,c.iv as iv2,(a.iv-b.iv) as div1,(a.iv-c.iv) as div2
	from stb_data_1_iv1 a
	left join stb_data_2_iv1 b on a.var=b.var
   left join stb_data_3_iv1 c on a.var=c.var
   order by div2
;quit;




 /*随机生成模型*/

%inc "&dir_mac.\macro_随机挑选模型.sas";



/*权重设置为1*/

data alltab2;
    set alltab1;
	if target=1 then weight=10747/ 331;
	   else weight=1;
	keep user_sid target weight
/*W_var_out_15*/
/*tree_144_3*/
/*tree_144_5*/
/*tree_150_6*/
/*tree_165_6*/
/*tree_167_4*/
/*tree_175_6*/
/*tree_182_5*/
/*tree_194_5*/
/*tree_199_6*/
/*tree_212_5*/
/*tree_214_3*/
/*tree_223_6*/
/*tree_237_3*/
/*tree_243_5*/
/*tree_247_5*/
/*tree_264_4*/
/*tree_272_5*/
/*tree_279_3*/
/*tree_280_5*/
/*tree_288_4*/
/*tree_299_3*/
/*tree_299_5*/
/*tree_31_5*/
/*tree_92_3*/

W_lst_cell_nbank_inteday
tree_106_3
tree_107_5
tree_134_6
tree_160_4
tree_178_4
tree_186_6
tree_193_6
tree_215_5
tree_246_4
tree_250_5
tree_256_3
tree_259_3
tree_26_5
tree_270_3
tree_284_6
tree_302_6
tree_326_5
tree_333_5
tree_336_5
tree_340_5
tree_370_4
tree_377_4
tree_66_4
tree_97_3

;run;

134 -->190-->187-->137-->50
134 -->190-->187-->137-->16-->103
/*剔除变量*/
%put &num.;
data _null_;
   set dt.rod2_var&num.;
   if _n_=103;
   put v1 v2;
run;
;

data alltab2;
   set alltab2;
   drop 

/*W_var_out_15 tree_144_3*/
/*tree_279_3 tree_299_3*/
/*tree_167_4 tree_288_4*/
/*tree_175_6 tree_243_5*/  
/*tree_247_5 tree_299_5*/
tree_186_6 tree_370_4
tree_259_3 tree_66_4
tree_284_6 tree_336_5
tree_256_3 tree_97_3
W_lst_cell_nbank_inteday tree_107_5
tree_333_5 tree_340_5

;run;


/*--------------------------------------*/

/*剔除变量后开始*/
proc contents data=alltab2 out=var(keep=name) noprint;run;
data var;
  set var end=last;
  where name not in('user_sid','target','weight');
  if last then call symputx('num',_n_);
  rename name=varname;
run;

%put &num.;
%let num=&num.;


proc transpose data=var out=var1(drop=_name_ _label_) prefix=v;var varname;run;quit;


data dt.rod1_var&num.;
    set var1;
   array x[&num.] v1-v&num.;
   n=dim(x);
   k=1;
   ncomb=comb(n,k);
   do j=1 to ncomb;
      call allcomb(j, k, of x[*]);
	  output;
   end;
run;


data dt.rod2_var&num.;
    set var1;
   array x[&num.] v1-v&num.;
   n=dim(x);
   k=2;
   ncomb=comb(n,k);
   do j=1 to ncomb;
      call allcomb(j, k, of x[*]);
	  output;
   end;
run;

%put &num.;



proc printto log=".\model_train_log.txt"  new;run;		

%put start at %sysfunc(time(),time.);
ods results off;
%combine(intab=alltab2,res=dt.re_resk2_var&num.,out=dt.re_outk2_var&num.,ns1=dt.rod2_var&num.,ns2=catx('',v1,v2),group=10,sp_var=tree_);
/*%combine(intab=alltab2,res=dt.re_resk1_var&num.,out=dt.re_outk1_var&num.,ns1=dt.rod1_var&num.,ns2=v1,group=10,sp_var=tree_);*/

ods results on;
%put end at %sysfunc(time(),time.);
proc printto;run;quit;



/*%let num=17;*/
proc sort data=dt.re_outk2_var&num. out=outmod3;by num descending v1 rk;run;
data outmod3_1;
   set outmod3;
   by num descending v1 rk;
   if first.num then rk_v=0;
    else rk_v+1;
run;
 
proc sort data=outmod3_1;by num descending m1 rk;run;
data outmod3_1;
   set outmod3_1;
   by num descending m1 rk;
   if first.num then rk_m=0;
    else rk_m+1;
run;
proc sql;
   create table xx as
    select num,sum(case when rk=rk_m and rk<=4 then 1 else 0 end) as count1,sum(case when rk=rk_v and rk<=4 then 1 else 0 end) as count2
	from outmod3_1
	group by 1
	;
quit;
proc sql;
   create table xx1 as
    select a.*,b.*,ks1-ks2 as div,std(ks1,ks2,ks3) as std
	from xx as a
	left join dt.Re_resk2_var&num. as b
	on a.num=b.num 
/*	having  count2>=7 and count1>=6 an ks1>0.3*/
   order by ks2 desc   ;
 quit;


data err;
   set dt.rod2_var&num.;
   num=_n_;
run;    
proc sql;
  create table err1 as 
  select a.v1,a.v2,b.*
  from err a
  left join xx1 b on a.num=b.num;
quit;
proc sort data=err1(where=(ks1>=0.28 and ks2>=0.28 and ks3>=0.27));by descending ks3;run;


