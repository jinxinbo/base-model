proc sort data=rank;by rk descending fraud_p;run;
data rank1;
   set rank;
   by rk descending fraud_p;
   if last.rk;
   put fraud_p;
run;
filename pt catalog 'work.t1.plot.source';
data _null_;
   set rank1 end=last;
   file pt;
   if _n_=1 then put 'if fraud_p>='fraud_p 'then rk=' rk';';
    else if last=0 then put 'else if fraud_p>='fraud_p 'then rk=' rk';';
	 else put 'else rk='rk';';
run;
proc sql;
   create table rank2 as
    select rk,max(fraud_p) as H_pred,min(fraud_p) as L_pred
	from rank
	group by 1;
quit;


ods listing;
ods results off;
%let tab=rank;
data &tab.;
   set &tab.;
    %Inc pt;
run;

proc npar1way data=&tab.;
class target;
var fraud_p;
run;

proc sql noprint;
 select sum(target),avg(target) into:P, :random from &tab.;
quit;
%put &random;

proc sql;
   create table cc_&tab. as
   select rk,count(*) as tot,sum(target)/&P. as percent,avg(target) as percent1
   from &tab.
   group by rk;
quit;
ods results on;

/*提升图*/

proc sgplot data=cc_&tab.;
REFLINE &random/axis=y label='random' TRANSPARENCY=0.3;
series x=rk y=percent1/lineattrs=(color=blue thickness=2 pattern=solid) datalabel
markers markerattrs=(color=red symbol=trianglefilled);
xaxis label='bin';
yaxis label='bad per bin';
run;	



/*每段逾期率*/
proc sgplot data=cc_&tab.;
REFLINE 0.1/axis=y label='random' TRANSPARENCY=0.3;
series x=rk y=percent/lineattrs=(color=blue thickness=2 pattern=solid) datalabel
markers markerattrs=(color=red symbol=trianglefilled);
xaxis label='bin';
yaxis label='bad per bin';
/*yaxis grid values=(0.05);*/ 
/*设置刻度标记，也可作为基准线*/
run;


proc freq data=valid2_1;table rk*target/nopercent nocol;run;quit;




proc sql;
   create table cc as
    select a.*,b.percent1 as train,c.percent1 as test,&random. as random
	from rank2 a
    left join cc_rank b on a.rk=b.rk
	left join cc_valid1_1 c on a.rk=c.rk;
quit;


ods output
ParameterEstimates=pe;
proc logistic data=alltab2 desc outest=dt.test_model_tr_0720;
	%inc logic;
	output out=dt.test_model_logi_0720 p=fraud_p;
run;quit;
proc sql noprint; 
     select max(Step) into :final_step from pe;
quit;
data pe1;
    set pe;
	where step=&final_step.;
   keep Variable Estimate WaldChiSq ProbChiSq StandardizedEst;
run;

/*导出为csv,然后再用excel打开*/
proc export data=pe1 outfile="E:\pe1.csv" replace label;
run;

