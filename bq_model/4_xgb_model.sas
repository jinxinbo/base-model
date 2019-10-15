proc sql;
  create table dt.data_train_xgb as
   select a.*,b.cus_sex 
   from dt.Data_train1_lx a
   left join dt.Data_train1 b on a.user_sid=b.user_sid;
quit;

/*1008xgb模型*/

proc sql;
   create table dt.data_train_xgb as 
   select a.*,b.target
   from dt.data_xgb a
   join dt.Data_train1_lx b on a.user_sid=b.user_sid;
quit;


/*1009xgb模型*/

proc sql;
   create table dt.data_train_xgb as 
   select a.*,b.target
   from dt.data_xgb_1009 a
   join dt.Data_train1_lx b on a.user_sid=b.user_sid;
quit;



%macro supiv(tab,outtab);
data &outtab.;
   length var$32. bin  maptotal  p0  p1  woe iv 8.;
   stop;
run;

proc contents data=&tab. out=v_cnt(keep=name) noprint;run;
data _null_;
    set v_cnt end=last;
/*    where index(upcase(name),'W_');*/
	where name not in('user_sid', 'target');
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
     rename  &name.=bin;
	 keep var &name. iv maptotal p0 p1 woe;
	run;
 proc append base=&outtab. data=cc1 force;run;quit;

  %end;

  %mend;


 proc printto log=".\变量分箱_1.txt" new ;run;
%supiv(dt.data_train_xgb, dt._05_per_gbdt_mapiv_1_7);

 proc printto;run;




proc sort data=dt._05_per_gbdt_mapiv_1_7;by var bin;run;
data iv4;
   set dt._05_per_gbdt_mapiv_1_7;
   by var bin;
   if last.var and iv>=0.02 and maptotal/11078>=0.05 and maptotal/11078<=0.95;
run;
proc sort data=iv4;by descending iv;run;



filename kp catalog 'work.t1.gbdt.source';
data _null_;
   set  iv4 end=last;
   file kp ;
   if _n_=1 then put 'keep user_sid';
   put var;
   if last then put ';';
run;


data dt.data_xgb_select;
   set dt.data_xgb_1009;
   %inc kp;
run;


/*proc sql;*/
/*    create table mapiv_gbdt as*/
/*	select * from dt._10_per_gbdt_mapiv_1_7*/
/*	where var in(select var from iv3)*/
/*;quit;*/

   
/*gbdt衍生变量的稳定性*/
data var_from_gbdt;
   set dt.Var_from_gbdt_0528 dt.Var_from_gbdt_test dt.Var_from_gbdt_valid;
   %inc kp;
run;
proc freq data=var_from_gbdt;table target;run;


proc sql;
   create table var_from_gbdt as 
   select a.*,b.target,b.app_mon
   from var_from_gbdt a
   left join dt.data4 b on a.user_sid=b.user_sid;
quit;

proc sort data=var_from_gbdt nodupkey;by user_sid;run;

data data_bin_1 data_bin_2 data_bin_3 data_bin_4;
    set var_from_gbdt;
	if app_mon='2018-12' then output data_bin_1;
	  else if app_mon='2019-01' then output data_bin_2;
	   else if app_mon='2019-02' then output data_bin_3;
	   else output data_bin_4;
	drop app_mon;
run;


proc sql;
   create table sup_iv as
    select a.var,a.iv ,b.iv as iv1,c.iv as iv2,d.iv as iv3,e.iv as iv4
	from iv3 a
	left join Valid1_iv1 b on a.var=b.var
   left join Valid2_iv1 c on a.var=c.var
   left join Valid3_iv1 d on a.var=d.var
   left join valid4_iv1 e on a.var=e.var
   order by iv desc
;quit;

data sup_iv;
   set sup_iv;
   div_1=(iv1-iv)/iv;
   div_2=(iv2-iv)/iv;
   div_3=(iv3-iv)/iv;
   div_4=(iv4-iv)/iv;
   min_div=min(of div:);
   max_iv=max(of iv1-iv4);
   min_iv=min(of iv1-iv4);
   drop div_:;
run;

proc sort data=sup_iv;by  descending iv;run;


data sup_var;
   set sup_iv;
   where min_div>-0.5 and min_iv>=0.018;
/*   var=cats("w_",varname);*/
   put var;
run;


proc sort data=sup_var;by descending iv;run;




ods listing;
ods results off;
proc freq data=dt.Var_from_gbdt;table tree_3_6*target;run;

data a ;
   set dt.Data_train1_lx;
   if net_age>63.5 and mob_month2_var6>0.0861385  then a=1;
     else a=0;
 run;
 proc freq data=a;table a*target;run;


tree_215_5	m12_id_avg_monnum>=1.87 or missing & td_div_6m<1 or missing
tree_377_4	scorepettycashv1<669 or missing & m18_id_loan>=6  
tree_106_3	multiscore<9.5 & cnt_cash_d_7<1 or missing  
tree_26_5	phone_gray_score>=20.905 or missing & cnt_org_cash_d_60<3 or missing
tree_178_4	risk_score<68 or missing & creditscore>=0.018532  
tree_160_4	m6_cell_max_inteday<0.5 or missing & creditscore>=0.066768 or missing
tree_302_6	d15_id_nbank_orgnum>=1.5 & lst_id_bank_inteday>=12.5    
tree_193_6	fst_cell_nbank_inteday>=153.5 & phone_gray_score>=51.655    
tree_326_5	cus_sex='女' & score_s<461 or missing  
tree_246_4	is_fstnbank_inteday<1 or missing & m12_id_avg_monnum>=1.415  
tree_134_6	rh_fraud_score>=59 & m12_cell_min_inteday>=264.5 or missing  
tree_250_5	cnt_cf_m_9>=2 & weight_black<50.655 or missing  
tree_270_3	phone_gray_score<53.685 & cnt_cf_m_9<3 or missing  

;;

 data a;
   set dt.data_xgb_1009;
  where tree_270_3=1;
run;

data a1;
  set data_bin_mon_0;
  where 
/*(m12_id_avg_monnum>=1.87 or m12_id_avg_monnum=.) & (td_div_6m<1 or td_div_6m=.);*/
/*(scorepettycashv1<669 or scorepettycashv1=.) & m18_id_loan>=6 ;*/
/*(multiscore<9.5 & multiscore^=.) & (cnt_cash_d_7<1 or cnt_cash_d_7=.) ;*/
/*(phone_gray_score>=20.905 or phone_gray_score=.) & (cnt_org_cash_d_60<3 or cnt_org_cash_d_60=.);*/
/*(risk_score<68 or risk_score=.) & creditscore>=0.018532  ;*/
/*(m6_cell_max_inteday<0.5 or m6_cell_max_inteday=.) & (creditscore>=0.066768 or creditscore=.);*/
/*d15_id_nbank_orgnum>=1.5 & lst_id_bank_inteday>=12.5   ;*/
/*fst_cell_nbank_inteday>=153.5 & phone_gray_score>=51.655   ; */
/*cus_sex='女' & (score_s<461 or score_s=.);  */
/*(is_fstnbank_inteday<1 or is_fstnbank_inteday=.) & m12_id_avg_monnum>=1.415  ;*/
/*rh_fraud_score>=59 & (m12_cell_min_inteday>=264.5 or m12_cell_min_inteday=.);  */
/*cnt_cf_m_9>=2 & (weight_black<50.655 or weight_black=.);  */
(phone_gray_score<53.685 & phone_gray_score^=.) & (cnt_cf_m_9<3 or cnt_cf_m_9=.);  
run;



