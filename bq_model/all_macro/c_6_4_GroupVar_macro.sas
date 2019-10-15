/*******
  Credit Risk Scorecards: Development and Implementation using SAS
  (c)  Mamdouh Refaat
********/
/*获取数据集记录数*/
%macro Get_ds_rec_num(in_ds=);
	%local _ds _ret;
	%let _ret=-1;
	/*打开数据集*/
	%let _ds=%sysfunc(open(&in_ds));
	
	%if &_ds>0 %then %do;
		/*获得记录集属性*/
		%let _ret=%sysfunc(ATTRN(&_ds,NLOBS ));
		/*关闭数据集*/
		%let _ds=%sysfunc(close(&_ds));
	%end;
	/*直接输出值*/
	&_ret
%mend;



/*******************************************************/
/* The macros: GValue, CalcMerit, BestSplit, CandSplits,
   BinContVar
   macro BinContVar needs all the above 4 macros to run
   and to apply the binning maps, use ApplyMap2. 
/*******************************************************/



/*******************************************************/
/* Macro GValue */
/*******************************************************/
%macro GValue(BinDS, Method, M_Value);
/* Calculation of the value of current split  */

/* Extract the frequency table values */
proc sql noprint;
  /* Count the number of obs and categories of X and Y */
   %local i j R N; /* C=2, R=Bmax+1 */
   select max(bin) into : R from &BinDS;
   select sum(total) into : N from &BinDS; 

   /* extract n_i_j , Ni_star*/
   %do i=1 %to &R; 
      %local N_&i._1 N_&i._2 N_&i._s N_s_1 N_s_2;
   Select sum(Ni1) into :N_&i._1 from &BinDS where Bin =&i ;
   Select sum(Ni2) into :N_&i._2 from &BinDS where Bin =&i ;
   Select sum(Total) into :N_&i._s from &BinDS where Bin =&i ;
   Select sum(Ni1) into :N_s_1 from &BinDS ;
   Select sum(Ni2) into :N_s_2 from &BinDS ;
%end;
quit;
%if (&method=1) %then %do; /* Gini */
	/* substitute in the equations for Gi, G */

	  %do i=1 %to &r;
	     %local G_&i;
	     %let G_&i=0;
	       %do j=1 %to 2;
	          %let G_&i = %sysevalf(&&G_&i + &&N_&i._&j * &&N_&i._&j);
	       %end;
	      %let G_&i = %sysevalf(1-&&G_&i/(&&N_&i._s * &&N_&i._s));
	   %end;

	   %local G; 
	    %let G=0;
	    %do j=1 %to 2;
	       %let G=%sysevalf(&G + &&N_s_&j * &&N_s_&j);
	    %end;
	    %let G=%sysevalf(1 - &G / (&N * &N));

	/* finally, the Gini ratio Gr */
	%local Gr;
	%let Gr=0; 
	 %do i=1 %to &r;
	   %let Gr=%sysevalf(&Gr+ &&N_&i._s * &&G_&i / &N);
	 %end;

	%let &M_Value=%sysevalf(1 - &Gr/&G); 
    %return;
					%end;
%if (&Method=2) %then %do; /* Entropy */
/* Check on zero counts or missings */
   %do i=1 %to &R; 
    %do j=1 %to 2;
	      %local N_&i._&j;
	      %if (&&N_&i._&j=.) or (&&N_&i._&j=0) %then %do ; /* return a missing value */ 
	         %let &M_Value=.;
	      %return; 
		                          %end;
     %end;
   %end;
/* substitute in the equations for Ei, E */
  %do i=1 %to &r;
     %local E_&i;
     %let E_&i=0;
       %do j=1 %to 2;
          %let E_&i = %sysevalf(&&E_&i - (&&N_&i._&j/&&N_&i._s)*%sysfunc(log(%sysevalf(&&N_&i._&j/&&N_&i._s))) );
       %end;
      %let E_&i = %sysevalf(&&E_&i/%sysfunc(log(2)));
   %end;

   %local E; 
    %let E=0;
    %do j=1 %to 2;
       %let E=%sysevalf(&E - (&&N_s_&j/&N)*%sysfunc(log(&&N_s_&j/&N)) );
    %end;
    %let E=%sysevalf(&E / %sysfunc(log(2)));

/* finally, the Entropy ratio Er */

	%local Er;
	%let Er=0; 
	 %do i=1 %to &r;
	   %let Er=%sysevalf(&Er+ &&N_&i._s * &&E_&i / &N);
	 %end;
	%let &M_Value=%sysevalf(1 - &Er/&E); 
	 %return;
					   %end;
%if (&Method=3)%then %do; /* The Pearson's X2 statistic */
 %local X2;
	%let N=%eval(&n_s_1+&n_s_2);
	%let X2=0;
	%do i=1 %to &r;
	  %do j=1 %to 2;
		%local m_&i._&j;
		%let m_&i._&j=%sysevalf(&&n_&i._s * &&n_s_&j/&N);
		%let X2=%sysevalf(&X2 + (&&n_&i._&j-&&m_&i._&j)*(&&n_&i._&j-&&m_&i._&j)/&&m_&i._&j  );  
	  %end;
	%end;
	%let &M_value=&X2;
	%return;
%end; /* end of X2 */
%if (&Method=4) %then %do; /* Information value */
/* substitute in the equation for IV */
     %local IV;
     %let IV=0;
   /* first, check on the values of the N#s */
	%do i=1 %to &r;
	   	      %if (&&N_&i._1=.) or (&&N_&i._1=0) or 
                  (&&N_&i._2=.) or (&&N_&i._2=0) or
                  (&N_s_1=) or (&N_s_1=0)    or  
				  (&N_s_2=) or (&N_s_2=0)     
				%then %do ; /* return a missing value */ 
	               %let &M_Value=.;
	                %return; 
		              %end;
	    %end;
       %do i=1 %to &r;
          %let IV = %sysevalf(&IV + (&&N_&i._1/&N_s_1 - &&N_&i._2/&N_s_2)*%sysfunc(log(%sysevalf(&&N_&i._1*&N_s_2/(&&N_&i._2*&N_s_1)))) );
       %end;
    %let &M_Value=&IV; 
						%end;

%mend;



/*******************************************************/
/* Macro CalcMerit */
/*******************************************************/
%macro CalcMerit(BinDS, ix, method, M_Value);
/* claculation of the merit function for the current  */
/*   Use SQL to find the frquencies of the contingency table  */
%local n_11 n_12 n_21 n_22 n_1s n_2s n_s1 n_s2; 
proc sql noprint;
 select sum(Ni1) into :n_11 from &BinDS where i<=&ix;
 select sum(Ni1) into :n_21 from &BinDS where i> &ix;
 select sum(Ni2) into : n_12 from &BinDS where i<=&ix ;
 select sum(Ni2) into : n_22 from &binDS where i> &ix ;
 select sum(total) into :n_1s from &BinDS where i<=&ix ;
 select sum(total) into :n_2s from &BinDS where i> &ix ;
 select sum(Ni1) into :n_s1 from &BinDS;
 select sum(Ni2) into :n_s2 from &BinDS;
quit;
/* Calcualte the merit functino according to its type */
/* The case of Gini */
%if (&method=1) %then %do;
    %local N G1 G2 G Gr;
	%let N=%eval(&n_1s+&n_2s);
	%let G1=%sysevalf(1-(&n_11*&n_11+&n_12*&n_12)/(&n_1s*&n_1s));
	%let G2=%sysevalf(1-(&n_21*&n_21+&n_22*&n_22)/(&n_2s*&n_2s));
	%let G =%sysevalf(1-(&n_s1*&n_s1+&n_s2*&n_s2)/(&N*&N));
	%let GR=%sysevalf(1-(&n_1s*&G1+&n_2s*&G2)/(&N*&G));
	%let &M_value=&Gr;
	%return;
				%end;
/* The case of Entropy */
%if (&method=2) %then %do;
   %local N E1 E2 E Er;
	%let N=%eval(&n_1s+&n_2s);
	%let E1=%sysevalf(-( (&n_11/&n_1s)*%sysfunc(log(%sysevalf(&n_11/&n_1s))) + 
						 (&n_12/&n_1s)*%sysfunc(log(%sysevalf(&n_12/&n_1s)))) / %sysfunc(log(2)) ) ;
	%let E2=%sysevalf(-( (&n_21/&n_2s)*%sysfunc(log(%sysevalf(&n_21/&n_2s))) + 
						 (&n_22/&n_2s)*%sysfunc(log(%sysevalf(&n_22/&n_2s)))) / %sysfunc(log(2)) ) ;
	%let E =%sysevalf(-( (&n_s1/&n  )*%sysfunc(log(%sysevalf(&n_s1/&n   ))) + 
						 (&n_s2/&n  )*%sysfunc(log(%sysevalf(&n_s2/&n   )))) / %sysfunc(log(2)) ) ;
	%let Er=%sysevalf(1-(&n_1s*&E1+&n_2s*&E2)/(&N*&E));
	%let &M_value=&Er;
	%return;
				%end;
/* The case of X2 pearson statistic */
%if (&method=3) %then %do;
 %local m_11 m_12 m_21 m_22 X2 N i j;
	%let N=%eval(&n_1s+&n_2s);
	%let X2=0;
	%do i=1 %to 2;
	  %do j=1 %to 2;
		%let m_&i.&j=%sysevalf(&&n_&i.s * &&n_s&j/&N);
		%let X2=%sysevalf(&X2 + (&&n_&i.&j-&&m_&i.&j)*(&&n_&i.&j-&&m_&i.&j)/&&m_&i.&j  );  
	  %end;
	%end;
	%let &M_value=&X2;
	%return;
%end;
/* The case of the information value */
%if (&method=4) %then %do;
  %local IV;
  %let IV=%sysevalf( ((&n_11/&n_s1)-(&n_12/&n_s2))*%sysfunc(log(%sysevalf((&n_11*&n_s2)/(&n_12*&n_s1)))) 
                    +((&n_21/&n_s1)-(&n_22/&n_s2))*%sysfunc(log(%sysevalf((&n_21*&n_s2)/(&n_22*&n_s1)))) );
   %let &M_Value=&IV;
   %return;
%end;
%mend;


/*******************************************************/
/* Macro BestSplit */
/*******************************************************/
%macro BestSplit(BinDs, Method, BinNo,MinbinNum);
/* find the best split for one bin dataset */
/* the bin size=mb */
%local mb i value BestValue BestI;
proc sql noprint;
 select count(*) into: mb from &BinDs where Bin=&BinNo; 
quit;
/* find the location of the split on this list */
%let BestValue=0;
%let BestI=0;/*2017/07/07改1到0，若不满足条件则不分组*/
%do i=1 %to %eval(&mb-1);
  %let value=;
  %CalcMerit(&BinDS, &i, &method, Value);
  proc sql noprint;
      select sum(total) into :np_1s from &BinDS where i<=&i;
      select sum(total) into :np_2s from &BinDS where i> &i ;
 quit;
  %if %sysevalf(&BestValue<&value) and %sysevalf(&np_1s. >= &MinbinNum.)  and  %sysevalf(&np_2s. >= &MinbinNum.)  %then %do;
      %let BestValue=&Value;
	  %let BestI=&i;
	%end;
%end;
/* Number the bins from 1->BestI =BinNo, and from BestI+1->mb =NewBinNo */
/* split the BinNo into two bins */ 
data &BinDS;
 set &BinDS;
  if i<=&BestI then Split=1;
  else Split=0;
drop i;
run;
proc sort data=&BinDS; 
by Split;
run;
/* reorder i within each bin */
data &BinDS;
retain i 0;
set &BinDs;
 by Split;
 if first.split then i=1;
 else i=i+1;
run;
%mend;


/*******************************************************/
/* Macro CandSplits */
/*******************************************************/
%macro CandSplits(BinDS, Method, NewBins, MinbinNum);
/* Generate all candidate splits from current
   Bins and select the best new bins */
/* first we sort the dataset OldBins by PDV1 and Bin */
proc sort data=&BinDS;
by Bin PDV1;
run;
/* within each bin, separate the data into a candidate dataset */
%local Bmax i value;
proc sql noprint;
 select max(bin) into: Bmax from &BinDS;
%do i=1 %to &Bmax; 
%local m&i;
   create table Temp_BinC&i as select * from &BinDS where Bin=&i;
   select count(*) into:m&i from Temp_BinC&i; 
%end;
   create table temp_allVals (BinToSplit num, DatasetName char(80), Value num);
run;quit;
/* for each of these bins,*/
%do i=1 %to &Bmax;
 %if (&&m&i>1) %then %do;  /* if the bin has more than one category */
 /* find the best split possible  */
  %BestSplit(Temp_BinC&i, &Method, &i ,&MinbinNum);
 /* try this split and calculate its value */
  data temp_trysplit&i;
    set temp_binC&i;
	if split=1 then Bin=%eval(&Bmax+1);
  run;
  Data temp_main&i;
   set &BinDS;
   if Bin=&i then delete; 
  run;
  Data Temp_main&i;
    set temp_main&i temp_trysplit&i;
  run;
 /* Evaluate the value of this split 
    as the next best split */
  %let value=;
 %GValue(temp_main&i, &Method, Value);
 proc sql noprint; 
  insert into temp_AllVals values(&i, "temp_main&i", &Value); 
 run;quit; 
 %end; /* end of trying for a bin wih more than one category */
%end;
/* find the best split  and return the new bin dataset */
proc sort data=temp_allVals;
by descending value;
run;
data _null_;
 set temp_AllVals(obs=1);
 call symput("bin", compress(BinToSplit));
run;
/* the return dataset is the best bin Temp_trySplit&bin */
Data &NewBins;
 set Temp_main&Bin;
 drop split;
run;
/* Clean the workspace */
proc datasets nodetails nolist library=work;
 delete temp_AllVals %do i=1 %to &Bmax; Temp_BinC&i  temp_TrySplit&i temp_Main&i %end; ; 
run;
quit;
%mend;


/*******************************************************/
/* Macro BinContVar */
/*******************************************************/
%macro BinContVar(Channel, DSin, IVVar, DVVar, Method, MMax, Acc, DSVarMap, Min_grpRate);
/* Optimal binning of the continuous variable */


/*calculate the count of the Dsin*/
%if &Min_grpRate.<1 %then %do;
	%let min_group_num=%sysfunc(int(%sysevalf(%Get_ds_rec_num(in_ds=&DSin)*&Min_grpRate)));
	%put &min_group_num;
%end;

%else %do;
    %let min_group_num=&Min_grpRate.;
	%put &min_group_num;
 %end;


%if &Channel.=1 %then %do;

/* find the maximum and minimum values */
%local VarMax VarMin;
proc sql noprint;
 select min(&IVVar), max(&IVVar) into :VarMin, :VarMax from &DSin;
quit;
/* divide the range to a number of bins as needed by Acc */
%local Mbins i MinBinSize;
%let Mbins=%sysfunc(int(%sysevalf(1.0/&Acc)));
%let MinBinSize=%sysevalf((&VarMax-&VarMin)/&Mbins);
/* calculate the bin boundaries between the max, min */
%do i=1 %to %eval(&Mbins);
 %local Lower_&i Upper_&i;
 %let Upper_&i = %sysevalf(&VarMin + &i * &MinBinSize);
 %let Lower_&i = %sysevalf(&VarMin + (&i-1)*&MinBinSize);
%end;
%let Lower_1 = %sysevalf(&VarMin-0.0001);  /* just to make sure that no digits get trimmed */
%let Upper_&Mbins=%sysevalf(&VarMax+0.0001);
/* separate the IVVar, DVVAr in a small dataset for faster operation */
data Temp_DS;
 set &DSin;
/* %do i=1 %to %eval(&Mbins-1);*/
/*  if &IVVar>=&&Lower_&i and &IVVar < &&Upper_&i Then Bin=&i;*/
/* %end;*/
/*  if &IVVar>=&&Lower_&Mbins and &IVVar <= &&Upper_&MBins Then Bin=&MBins;*/
   %do i=1 %to %eval(&Mbins-1);
  if &IVVar>&&Lower_&i and &IVVar <=&&Upper_&i Then Bin=&i;
 %end;
  if &IVVar>&&Lower_&Mbins and &IVVar <=&&Upper_&MBins Then Bin=&MBins;
 keep &IVVar &DVVar Bin;
run;
/* Generate a dataset with the initial upper, lower limits per bin */
data temp_blimits;
 %do i=1 %to %Eval(&Mbins-1);
   Bin_LowerLimit=&&Lower_&i;
   Bin_UpperLimit=&&Upper_&i;
   Bin=&i;
   output;
 %end;
   Bin_LowerLimit=&&Lower_&Mbins;
   Bin_UpperLimit=&&Upper_&Mbins;
   Bin=&Mbins;
   output;
run;
proc sort data=temp_blimits;
by Bin;
run;
/* Find the frequencies of DV=1, DV=0 using freq */
proc freq data=Temp_DS noprint;
 table Bin*&DVvar /out=Temp_cross;
 table Bin /out=Temp_binTot;
 run;
/* Rollup on the level of the Bin */
proc sort data=temp_cross;
 by Bin;
run;
proc sort data= temp_BinTot;
by Bin;
run;
data temp_cont; /* contingency table */
merge Temp_cross(rename=count=Ni2 ) temp_BinTot(rename=Count=total) temp_BLimits ;
by Bin; 
Ni1=total-Ni2;
PDV1=bin; /* just for conformity with the case of nominal iv */
label  Ni2= total=;
if Ni1=0 then output;
else if &DVVar=1 then output;
drop percent &DVVar;
run;
%end;

/*遍历所有的节点*/
%if &Channel.=2 %then %do;
proc sql;
    create table temp_data2 as
	 select &IVVar.,&DVvar.,count(*) as cnt
	 from &DSin.
	 group by 1,2;
quit;
proc transpose data=temp_data2 out=temp_data3(drop=_name_ _label_) prefix=p;
by &IVVar.;
id &DVvar.;
var cnt;
run;quit;
data temp_cont;
   set temp_data3;
   array ar _numeric_;
   do over ar;
      if ar=. then ar=0;
	end;
   bin=_n_;
   PDV1=_n_;
   total=sum(p0,p1);
   Bin_LowerLimit=lag(&IVVar.);
   rename p0=Ni1 p1=Ni2 &IVVar.=Bin_UpperLimit;
run;

proc sql noprint;
 select max(bin) into :Mbins  from temp_cont;
quit;

%end;

/*按照分位数预分组*/
%if &Channel.=3 %then %do;

proc univariate data=&DSin.  noprint;var &IVVar.;output out=temp_a1 pctlpts=1 to 100 by 1 pctlpre=p;run;quit;
proc transpose data=temp_a1 out=temp_a2(drop=_label_ _name_) prefix=cnt_;run;
proc sort data=temp_a2 out=temp_a3 nodupkey;by cnt_1;run;
data temp_a3;
   set temp_a3;
  bin=_n_;
run;

filename tmp_bin catalog 'work.t1.tmp_bin.source';
data _null_;
   set temp_a3 end=last;
   file tmp_bin;
   if _n_=1 then put 'if %str(&IVVar.)<=' cnt_1 'then bin=' _n_ ';';
    else if last=0 then put 'else if %str(&IVVar.)<=' cnt_1 'then bin=' _n_ ';';
     else put 'else bin=' _n_ ';';
run;

data temp_data2;
   set &DSin.;
   %inc tmp_bin;
run;
proc sql;
   create table temp_data3 as
    select bin,&DVvar.,count(*) as cnt
	 from temp_data2
	 group by 1,2;
quit;
proc transpose data=temp_data3 out=temp_data4(drop=_name_ _label_) prefix=p;
by bin;
id &DVvar.;
var cnt;
run;quit;
proc sql;
   create table temp_data5 as
    select a.*,b.*
	from Temp_data4 a
	left join Temp_a3 b on a.bin=b.bin;
 quit;
data temp_cont;
   set temp_data5;
   array ar _numeric_;
   do over ar;
      if ar=. then ar=0;
	end;
   PDV1=bin;
   total=sum(p0,p1);
   Bin_LowerLimit=lag(cnt_1);
   rename p0=Ni1 p1=Ni2 cnt_1=Bin_UpperLimit;
run;
proc sql noprint;
 select max(bin) into :Mbins  from temp_cont;
quit;
%end;

data temp_contold;
set temp_cont;
run;

/* merge all bins that have either Ni1 or Ni2 or total =0 */
proc sql noprint;
%local mx;
%do i=1 %to &Mbins;
  /* get all the values */
	select count(*) into : mx from Temp_cont where Bin=&i;
	%if (&mx>0) %then %do;
		select Ni1, Ni2, total, bin_lowerlimit, bin_upperlimit into 
		     :Ni1,:Ni2,:total, :bin_lower, :bin_upper 
		from temp_cont where Bin=&i;
		%if (&i=&Mbins) %then %do;
			select max(bin) into :i1 from temp_cont where Bin<&Mbins;
		%end;
		%else %do;
			select min(bin) into :i1 from temp_cont where Bin>&i;
		%end;
		%if (&Ni1=0) or (&Ni2=0) or (&total=0) %then %do;
			update temp_cont set 
			           Ni1=Ni1+&Ni1 ,
					   Ni2=Ni2+&Ni2 , 
					   total=total+&Total 
			where bin=&i1;
			%if (&i<&Mbins) %then %do;
				update temp_cont set Bin_lowerlimit = &Bin_lower where bin=&i1;
			%end;
			%else %do;
				update temp_cont set Bin_upperlimit = &Bin_upper where bin=&i1;
			%end;
			delete from temp_cont where bin=&i;
		%end; 
	%end;
%end;
quit;
proc sort data=temp_cont;
by pdv1;
run;
%local m;
/* put all the category in one node as a string point */
data temp_cont;
 set temp_cont;
 i=_N_;
 Var=bin;
 Bin=1;
 call symput("m", compress(_N_)); /* m=number of categories */
run;
/* loop until  the maximum number of nodes has been reached */
%local Nbins ;
%let Nbins=1; /* Current number of bins */ 
%DO %WHILE (&Nbins <&MMax);
	%CandSplits(temp_cont, &method, Temp_Splits,&min_group_num.);
	Data Temp_Cont;
  		set Temp_Splits;
	run;
	%let NBins=%eval(&NBins+1);
%end; /* end of the WHILE splitting loop  */
/* shape the output map */
data temp_Map1 ;
 set temp_cont(Rename=Var=OldBin);
 drop Ni2 PDV1 Ni1 i ;
 run;
proc sort data=temp_Map1;
by Bin OldBin ;
run;
/* merge the bins and calculate boundaries */
data temp_Map2;
 retain  LL 0 UL 0 BinTotal 0;
 set temp_Map1;
by Bin OldBin;
Bintotal=BinTotal+Total;
if first.bin then do;
  LL=Bin_LowerLimit;
  BinTotal=Total;
    End;
if last.bin then do;
 UL=Bin_UpperLimit;
 output;
end;
drop Bin_lowerLimit Bin_upperLimit Bin OldBin total;
 run;
proc sort data=temp_map2;
by LL;
run;
data &DSVarMap;
set temp_map2;
Bin=_N_;
run;

/*proc sql;*/
/*	create table temp_varbin as*/
/*	select a.&IVVar.,a.&DVVar.,b.Bin as &IVVar._Bin*/
/*	from &DSin as a*/
/*	left join &DSVarMap as b*/
/*	on 1=1*/
/*	where b.ll<=a.&IVVar<b.ul*/
/*	;*/
/*quit;*/
/*proc freq data=temp_varbin noprint;*/
/*	table &IVVar._Bin*&DVVar. /missing out=temp_varbin_crosscnt;*/
/*	table &DVVar. /missing out=temp_varbin_totcnt;*/
/*	table &IVVar._Bin /missing out=temp_varbin_varcnt;*/
/*run;quit; */
/*proc sql;*/
/*	create table temp_varbin_woe as*/
/*	select a.&IVVar._Bin,a.&DVVar.,a.COUNT as varcnt,b.COUNT as varbincnt,c.COUNT as tarcnt*/
/*	from temp_varbin_crosscnt as a*/
/*	left join temp_varbin_varcnt as b*/
/*	on a.&IVVar._Bin=b.&IVVar._Bin*/
/*	left join temp_varbin_totcnt as c*/
/*	on a.&DVVar.=c.&DVVar.*/
/*	order by a.&IVVar._Bin,a.&DVVar.*/
/*	;*/
/*quit;*/
/**/
/*data &DSVarIv.;*/
/*	set temp_varbin_woe;*/
/*	by &IVVar._Bin &DVVar.;*/
/*	retain iv_tmp 0;*/
/*	if last.&IVVar._Bin then do;*/
/*		if &DVVar.=0 then do;*/
/*			cnt_0=varcnt;*/
/*			cnt_1=varbincnt-cnt_0;*/
/*			tot_0=tarcnt;*/
/*			tot_1=resolve(%Get_ds_rec_num(in_ds=temp_varbin))-tot_0;*/
/*			p0=cnt_0/tot_0;*/
/*			p1=cnt_1/tot_1;*/
/*			woe=log(p1/p0);*/
/*			iv=iv_tmp+(p1-p0)*woe;			*/
/*		end;*/
/*		else if &DVVar.=1 then do;*/
/*			cnt_1=varcnt;*/
/*			cnt_0=varbincnt-cnt_1;*/
/*			tot_1=tarcnt;*/
/*			tot_0=resolve(%Get_ds_rec_num(in_ds=temp_varbin))-tot_1;*/
/*			p0=cnt_0/tot_0;*/
/*			p1=cnt_1/tot_1;*/
/*			woe=log(p1/p0);*/
/*			iv=iv_tmp+(p1-p0)*woe;			*/
/*		end;*/
/*		output;*/
/*	end;*/
/*	keep &IVVar._Bin cnt_0 cnt_1 tot_0 tot_1 woe iv;*/
/*run;*/

/* Clean the workspace */

/*proc datasets nodetails library=work nolist;*/
/* delete temp_:;*/
/*run; quit;*/
%mend;

/*
变量分箱
	目前只支持对 连续型 变量进行分组
target：目标变量名，目前只支持2值目标变量
group_var:需分组变量名 
in_ds：数据集名
adj:当区间中为只有一个目标变量值时，计算占比的修正指数
min_group_num:组内最小记录数最少占比
DSVarMap:分组后各组的上下限
DSVarIv:分组后各组的woe和iv值
*/


%macro bestgrouping(target=,group_var=,in_ds=,adj=,min_group_num=,DSVarMap=,DSVarIv=,
out_group_DS=,max_group=,method=1,m_woe=0);

%let start_time=%sysfunc(datetime());
%put 0--------------------------------------------------------------;
%put DateTime:%sysfunc(datetime(),datetime20.);
%put 0--------------------------------------------------------------;

data save_in_ds;
	set &in_ds;
run;

%let all_count=%Get_ds_rec_num(in_ds=&in_ds);

%put all_count:&all_count;

%put proc sort &in_ds &group_var;
proc sort data=&in_ds(keep= &group_var &target) out=tmp_sort;
by &group_var &target;
run;
%if &syserr>6 %then %abort;


data tmp_sort0 tmp_sort1;
	set tmp_sort;
	if missing(&group_var)^=1 then output tmp_sort0;
	else output tmp_sort1;
run;
data group_record;
length cut_off splitno 8. ;
stop;
run;

data grouping_split_ds_queue;
length ds_name $40.;
ds_name='tmp_sort0';
run;

%let split_ds_num=1;
%let split_num=1;

%let woe_increase=-1;
                             
%do %until(&split_ds_num=0);

	%put 1----------------------------------------------------------------------;
	%put Read the first data set of the queue;
	%put 1----------------------------------------------------------------------;

	data grouping_split_ds_queue;
	set grouping_split_ds_queue;
	if _n_=1 then do;
		call symputx('split_ds',ds_name);
		delete;
	end;
	run;
%put "split_ds=" &split_ds.;
/*%if &split_num=3 %then %abort;*/

	%symdel disgrpvarNum/nowarn;
	%local disgrpvarNum;
	proc sql noprint;
		select count(distinct &group_var.) into: disgrpvarNum from &split_ds.;
	quit;
	%put disgrpvarNum=&disgrpvarNum;
	%put all_count=&all_count.;
	%put in_ds=&split_ds.;
	%put in_ds_num=%Get_ds_rec_num(in_ds=&split_ds);

	%put "disgrpvarNum=" &disgrpvarNum.;
/*	%if &split_num=3 %then %abort;*/

	%if %sysevalf(&disgrpvarNum>1) and
		 %sysevalf(%Get_ds_rec_num(in_ds=&split_ds)>=%sysevalf(&all_count.*&min_group_num.*2)) %then %do;

		%put 2----------------------------------------------------------------------;
		%put Calculated the frequency of the &split_ds.;
		%put 2----------------------------------------------------------------------;

		%let split_ds_count=%Get_ds_rec_num(in_ds=&split_ds.);
		proc freq data=&split_ds. noprint;
			table &group_var.*&target. /missing out=tmp_varbin_crosscnt;
			table &target. /missing out=tmp_varbin_totcnt;
			table &group_var. /missing out=tmp_varbin_varcnt;
		run;quit; 

		proc sql;
			create table tmp_varbin_woe as
			select a.&group_var.,a.&target.,a.COUNT as varcnt,b.COUNT as varbincnt,c.COUNT as tarcnt
			from tmp_varbin_crosscnt as a
			left join tmp_varbin_varcnt as b
			on a.&group_var.=b.&group_var.
			left join tmp_varbin_totcnt as c
			on a.&target.=c.&target.
			order by a.&group_var.,a.&target.
			;
		quit;
		%let IV=0;
		%let max_cut_off=;
/*		%if &split_num=3 %then %abort;*/

		data tmp_varbin_woe1;
			set tmp_varbin_woe;
			by &group_var.;
			retain cnt_0 cnt_1 tot_0 tot_1 0;
			if &target.=0 then do;
				cnt_0 =varcnt;
				tot_0=tarcnt;
			end;
			else if &target.=1 then do;
				cnt_1=varcnt;
				tot_1=tarcnt;
			end;
			if last.&group_var. then do;
				output;
				cnt_0=0;
				cnt_1=0;
			end;
			keep &group_var. cnt_0 cnt_1 tot_0 tot_1 varbincnt;
		run;

		data grouping_tmp_woe;
			set tmp_varbin_woe1 end=last;
			by &group_var.;
			retain cal_varcnt tmp_0 tmp_1 IV_max GR_max ER_max 0;
			&group_var.=round(&group_var.,1e-10);
			lag_group = lag(&group_var.);
/*			format &group_var. 20.10;*/
			if _n_=1 then do;
				tmp_0=cnt_0;
				tmp_1=cnt_1;
				cal_varcnt=varbincnt;
			end;
/*			当有0有1才进行分割*/

			/* 方向和woe第一次切割方向相同*/
			if tmp_0 >0 and tmp_1 >0 and _n_^=1 then do;
				if cal_varcnt>&all_count.*&min_group_num. 
				and (&split_ds_count.-cal_varcnt)>=&all_count.*&min_group_num. 
				then do;
/*------------------------------------------------------------------------------*/
/*				计算IV值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的事件占比和非事件占比*/
					cnt_0_lower=tmp_0;
					cnt_1_lower=tmp_1;
					p0_lower=cnt_0_lower/tot_0;
					p1_lower=cnt_1_lower/tot_1;
					woe_lower=log(p1_lower/p0_lower);

/*					临界点以上（包括当前点）的事件占比和非事件占比*/
					cnt_0_upper=tot_0-tmp_0;
					cnt_1_upper=tot_1-tmp_1;
					p0_upper=cnt_0_upper/tot_0;
					p1_upper=cnt_1_upper/tot_1;
					woe_upper=log(p1_upper/p0_upper);

					iv = (p1_lower-p0_lower)*woe_lower + (p1_upper-p0_upper)*woe_upper;
/*                    m_woe=1 是woe顺序排列分箱，m_woe=0是自由分箱*/
                   %if &m_woe.=1 %then %do;
        
					if iv>iv_max and (1000*(woe_upper-woe_lower)*%sysevalf(&woe_increase)>0 or %sysevalf(&split_ds.=tmp_sort0)) then do;
					put woe_upper woe_lower;
					 %put &woe_increase.;

					 %end;
                      %if &m_woe.=0 %then %do;
                        if iv>iv_max then do;
                      %end;

						iv_max=iv;
						cut_off=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off',cut_off);
						call symputx('IV',IV_max);
						call symputx('woe_l',woe_lower);
						call symputx('woe_u',woe_upper);
					end;
/*------------------------------------------------------------------------------*/
/*				计算IV值：END*/
/*------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------*/
/*				计算Gini值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的Gini*/
					G_lower=1-(cnt_0_lower**2+cnt_1_lower**2)/cal_varcnt**2;

/*					临界点以上（包括当前点）的Gini*/
					G_upper=1-(cnt_0_upper**2+cnt_1_upper**2)/(tot_0+tot_1-cal_varcnt)**2;

/*					总体的Gini*/
					G_all=1-(tot_0**2+tot_1**2)/(tot_0+tot_1)**2;

					GR = 1-(cal_varcnt*G_lower+(tot_0+tot_1-cal_varcnt)*G_upper)/((tot_0+tot_1)*G_all);

					if GR>GR_max then do;
						GR_max=GR;
						cut_off_Gini=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off_Gini',cut_off_Gini);
						call symputx('GR',GR_max);
					end;
/*------------------------------------------------------------------------------*/
/*				计算Gini值：END*/
/*------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------*/
/*				计算Entropy值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的Entropy*/
					E_lower=-(cnt_0_lower/cal_varcnt)*log2(cnt_0_lower/cal_varcnt)
									-(cnt_1_lower/cal_varcnt)*log2(cnt_1_lower/cal_varcnt);

/*					临界点以上（包括当前点）的Entropy*/
					E_upper=-(cnt_0_upper/(tot_0+tot_1-cal_varcnt))*log2(cnt_0_upper/(tot_0+tot_1-cal_varcnt))
									-(cnt_1_upper/(tot_0+tot_1-cal_varcnt))*log2(cnt_1_upper/(tot_0+tot_1-cal_varcnt));

/*					总体的Entropy*/
					E_all=-(tot_0/(tot_0+tot_1))*log2(tot_0/(tot_0+tot_1))
							  -(tot_1/(tot_0+tot_1))*log2(tot_1/(tot_0+tot_1));

					ER = 1-(cal_varcnt*E_lower+(tot_0+tot_1-cal_varcnt)*E_upper)/((tot_0+tot_1)*E_all);

					if ER>ER_max then do;
						ER_max=ER;
						cut_off_E=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off_E',cut_off_E);
						call symputx('ER',ER_max);
					end;
/*------------------------------------------------------------------------------*/
/*				计算Entropy值：END*/
/*------------------------------------------------------------------------------*/

				end;
			end;
			if _n_^=1 then do;
				cal_varcnt=cal_varcnt+varbincnt;
				tmp_0=tmp_0+cnt_0;
				tmp_1=tmp_1+cnt_1;
			end;
			keep &group_var. cnt_0_lower cnt_1_lower p0_lower p1_lower woe_lower
			cnt_0_upper cnt_1_upper p0_upper p1_upper woe_upper 
			tot_0 tot_1 iv iv_max cut_off
			G_lower G_upper G_all GR GR_max cut_off_Gini
			E_lower E_upper E_all ER ER_max cut_off_E
			tmp_0 tmp_1
			;

		run;
/*		%if &split_num=1 %then %abort;*/

/*		%let max_cut_off=%sysevalf(&max_cut_off+10**(-10));*/
		%put 4----------------------------------------------------------------------------------------;
		%put The &split_num th split;
		%put Split data set					:&split_ds.;
		%put IV:;
		%put max_cut_off					:&max_cut_off.;
		%put IV								:&IV.;

		%put Gini:;
		%put max_cut_off					:&max_cut_off_Gini.;
		%put GR								:&GR.;

		%put Entropy:;
		%put max_cut_off					:&max_cut_off_E.;
		%put ER								:&ER.;
		%put 4----------------------------------------------------------------------------------------;

		%if &method=1 %then %do;
			%let value=&IV.;
			%let low_limit=0.001;
			%let cut_off=&max_cut_off;
		%end;
		%else %if &method=2 %then %do;
			%let value=&GR.;
			%let low_limit=0.0001;
			%let cut_off=&max_cut_off_Gini;
		%end;
		%else %if &method=3 %then %do;
			%let value=&ER.;
			%let low_limit=0.0001;
			%let cut_off=&max_cut_off_E;
		%end;

/*	确定woe第一次切割的方向*/
       %if %sysevalf(&split_ds.=tmp_sort0) %then %do;
	        %if %sysevalf(&woe_u. > &woe_l.) %then %do;
			     %let woe_increase=1;
			  %end;
	   %end;
/*-------------------------------*/
		  
		%if &value.>&low_limit.  %then %do;

			data split_lower_&split_num. split_upper_&split_num.;
				set &split_ds(keep =&group_var &target);
				if round(&group_var.,1e-10)<=&cut_off then output split_lower_&split_num.;
				else output split_upper_&split_num.;
			run;
/*%if &split_num=2 %then %abort;*/
/*%abort;*/

			%put 5----------------------------------------------------------------------------------------;
			%put Split finish ;
			%put split_lower_&split_num.:%Get_ds_rec_num(in_ds=split_lower_&split_num.);
			%put split_upper_&split_num.:%Get_ds_rec_num(in_ds=split_upper_&split_num.);
			%put 5----------------------------------------------------------------------------------------;

			%if %Get_ds_rec_num(in_ds=split_lower_&split_num.)>0
			and %Get_ds_rec_num(in_ds=split_upper_&split_num.)>0 %then %do;
			%put ----------------------------------------------------------------------------------------------;
			%put Put in the queue;
			%put ----------------------------------------------------------------------------------------------;

				data grouping_split_ds_append;
				length ds_name $40.;
				ds_name="split_lower_&split_num.";
				output;
				ds_name="split_upper_&split_num.";
				output;
				run;

				proc append base=grouping_split_ds_queue data=grouping_split_ds_append force;
				run;

				data grouping_group_record_append;
				length cut_off splitno 8.;
				cut_off=&cut_off;
				splitno=&split_num;
				run;
/*				%if &split_num=1 %then %abort;*/

				proc append base=group_record data=grouping_group_record_append force;
				run;
			%end;

		%end;

/*		%let split_num=%eval(&split_num.+1);*/

	%end;

   %let split_num=%eval(&split_num.+1);

	%let split_ds_num=%Get_ds_rec_num(in_ds=grouping_split_ds_queue);

/* 测试只跑第一次*/
/*	 %let split_ds_num=0;*/
 
	%put 6-------------------------------------------------------------------------;
	%put Remaining number of  split data set  : &split_ds_num.;
	%put The &split_num th split;
	%put 6-------------------------------------------------------------------------;
	%put 6*************************************************************************;
%end;

proc datasets lib=work nolist nodetails;
  delete split: temp_varbin: tmp_varbin: grouping: ;
run;quit;
/*			%abort;*/

/*根据临界值对数据分组,并计算最后分组的WOE值和IV值*/


/*选择最大分组数，此时不能排序，因为靠前的分组iv值越高*/
data Group_record1;
   set Group_record;
   if _n_<=&max_group.-1;
run;

proc sort data=Group_record1;
by cut_off;
run;
%if %Get_ds_rec_num(in_ds=Group_record1)>0 %then %do;
	data _null_;
	set Group_record1 end=last nobs=Number_cut_off;
	call symputx('cut_off'||left(put(_n_,best.)),cut_off);
	if last then do; 
		call symputx('Number_cut_off',Number_cut_off);
	end;
	run;

	data &out_group_DS.(drop=&group_var.) temp_map(keep=GRP_&group_var. &group_var. );
	set &in_ds;
	if missing(&group_var.)=1 then GRP_&group_var.=0;
	else if round(&group_var.,1e-10)<=&cut_off1 then GRP_&group_var.=1;
	%do i=2 %to &Number_cut_off.;
		else if round(&group_var.,1e-10)<=&&cut_off&i then GRP_&group_var.=&i;
	%end;
	else if round(&group_var.,1e-10)>&&cut_off&Number_cut_off. then GRP_&group_var.=&Number_cut_off.+1;
	run;
%end;
%else %do;
/*若是没有划分，就直接用原有的分组	*/
	proc sql;
		create table temp_grpvar as
		select distinct &group_var.
		from &in_ds
		order by 1
		;
	quit;
	data temp_grpvar1;
		set temp_grpvar;
		by &group_var.;
		retain GRP_&group_var. 0;
		if missing(&group_var.)=1 and _n_=1 then GRP_&group_var.=0;
		else GRP_&group_var.+1;
	run;
	proc sql;
		create table &out_group_DS. as 
		select a.*,b.GRP_&group_var.
		from &in_ds as a
		left join temp_grpvar1 as b
		on a.&group_var.=b.&group_var.
		;
	quit;
	data &out_group_DS.(drop=&group_var.) temp_map(keep=GRP_&group_var. &group_var. );
	set &out_group_DS.;
	run;
   
%end;	

proc freq data=&out_group_DS. noprint;
	table GRP_&group_var.*&target. /missing out=temp_varbin_crosscnt;
	table &target. /missing out=temp_varbin_totcnt;
	table GRP_&group_var. /missing out=temp_varbin_varcnt;
run;quit; 
proc sql;
	create table temp_varbin_woe as
	select a.GRP_&group_var.,a.&target.,a.COUNT as varcnt,b.COUNT as varbincnt,c.COUNT as tarcnt
	from temp_varbin_crosscnt as a
	left join temp_varbin_varcnt as b
	on a.GRP_&group_var.=b.GRP_&group_var.
	left join temp_varbin_totcnt as c
	on a.&target.=c.&target.
	order by a.GRP_&group_var.,a.&target.
	;
quit;

/*data &DSVarIv.;*/
/*	set temp_varbin_woe end=last;*/
/*	by GRP_&group_var. ;*/
/*	retain iv_tmp tmp_0 tmp_1 0;*/
/*	tot_1=&target_event_count_all;*/
/*	tot_0=&target_nonevent_count_all;*/
/*	if last.GRP_&group_var.=first.GRP_&group_var. then do;*/
/*		if &target.=0 then tmp_0=varcnt+tmp_0;*/
/*		else tmp_1=varcnt+tmp_1;*/
/*		if last.GRP_&group_var. then do;*/
/*			cnt_1=tmp_1;*/
/*			cnt_0=tmp_0;*/
/*			p0=cnt_0/tot_0;*/
/*			p1=cnt_1/tot_1;*/
/*			woe=log(p1/p0);*/
/*			iv=iv_tmp+(p1-p0)*woe;			*/
/*			if iv=. then iv=iv_tmp;*/
/*			output;*/
/*			tmp_0=0;*/
/*			tmp_1=0;*/
/*		end;*/
/*	end;*/
/*	else do;*/
/*		if last.GRP_&group_var. then do;*/
/*			cnt_1=varcnt+tmp_1;*/
/*			cnt_0=varbincnt-cnt_1+tmp_0+tmp_1;*/
/*			p0=cnt_0/tot_0;*/
/*			p1=cnt_1/tot_1;*/
/*			woe=log(p1/p0);*/
/*			iv=iv_tmp+(p1-p0)*woe;			*/
/*			iv_tmp=iv;*/
/*			output;*/
/*			tmp_0=0;*/
/*			tmp_1=0;*/
/*		end;*/
/*	end;*/
/*	keep GRP_&group_var. cnt_0 cnt_1 tot_0 tot_1 woe iv;*/
/*run;*/

data temp_varbin_woe1;
	set temp_varbin_woe;
	by GRP_&group_var.;
	retain cnt_0 cnt_1 tot_0 tot_1 0;
	if &target.=0 then do;
		cnt_0 =varcnt;
		tot_0=tarcnt;
	end;
	else if &target.=1 then do;
		cnt_1=varcnt;
		tot_1=tarcnt;
	end;
	if last.GRP_&group_var. then do;
		output;
		cnt_0=0;
		cnt_1=0;
	end;
	keep GRP_&group_var. cnt_0 cnt_1 tot_0 tot_1 varbincnt;
run;
/*%abort;*/
data &DSVarIv.;
	set temp_varbin_woe1 end=last;
	by GRP_&group_var. ;
	retain iv 0;
	p0=cnt_0/tot_0;
	p1=cnt_1/tot_1;
	woe=log(p1/p0);
	iv=iv+(p1-p0)*woe;	
   keep GRP_&group_var. cnt_0 cnt_1 tot_0 tot_1 woe iv;
run;


proc sort data=temp_map;by GRP_&group_var. &group_var.;run;
data temp_map1;
	set temp_map ;
	length ll ul bin BinTotal 8;
	by GRP_&group_var.;
	retain ll BinTotal 0;
	if first.GRP_&group_var. then do;
		ll=&group_var.;
		BinTotal=0;
	end;
	BinTotal+1;
	if last.GRP_&group_var. then do;
		ul=&group_var.;
		bin=GRP_&group_var.;
		output;
	end;
	keep ll ul bin BinTotal;
run;
proc sql;
	create table temp_map2 as
	select a.*,b.GRP_&group_var.
	from temp_map1 as a
	left join &DSVarIv. as b
	on a.bin=b.GRP_&group_var.
	;
quit;
/*上下限以切割点为准*/
proc sort data=temp_map2;by descending GRP_&group_var.;run;
data temp_map2;
   set temp_map2;
   ll1=lag(ll);
   if ll1^=. then ul=sum(ll1,ul)/2;
   drop ll1;
run;
proc sort data=temp_map2;by GRP_&group_var.;run;

data &DSVarMap.;
	set temp_map2;
	length ll ul bin BinTotal 8;
	retain tmp_ll tmp_tot .;
	if GRP_&group_var=. then do;
		tmp_tot+BinTotal;
		if tmp_ll=. then tmp_ll=ll;
	end;
	else do;
		if tmp_ll^=. then do;
			ll=tmp_ll;
			BinTotal=BinTotal+tmp_tot;
		end;
		output;
		tmp_ll=.;
		tmp_tot=0;
	end;
	keep ll ul bin BinTotal;
run;



data _null_;
	set &DSVarIv. ;
	call symputx('woe_'||left(put(_n_,best.)),woe);
run;
data _null_;
	set &DSVarMap. end=last;
	call symputx('ul_'||left(put(_n_,best.)),round(ul,1e-10));
	if last then call symputx('grp_num',_n_);
run;

data &out_group_DS. ;
set save_in_ds;
	if round(&group_var.,1e-10)<=&UL_1 then W_&group_var.=&WOE_1;
%do i=2 %to &grp_num.-1;
	else if round(&group_var.,1e-10)<=&&UL_&i then W_&group_var.=&&WOE_&i;
%end;
	else W_&group_var.=&&WOE_&grp_num.;
	drop &group_var;
run;
proc datasets lib=work nolist nodetails;
  delete save_in_ds temp_: tmp_: Group_record: ;
run;quit;

%let end_time=%sysfunc(datetime());
%let use_time=%sysevalf(&end_time.-&start_time.);
%put 0--------------------------------------------------------------;
%put DateTime:%sysfunc(datetime(),datetime20.);
%put Use time:&use_time.;
%put 0--------------------------------------------------------------;
%mend;

%macro bestgrouping_lone(target=,group_var=,in_ds=,adj=,min_group_num=,DSVarMap=,DSVarIv=,
max_group=,method=1,m_woe=0);

%let start_time=%sysfunc(datetime());
%put 0--------------------------------------------------------------;
%put DateTime:%sysfunc(datetime(),datetime20.);
%put 0--------------------------------------------------------------;

/*data save_in_ds;*/
/*	set &in_ds;*/
/*run;*/

%let all_count=%Get_ds_rec_num(in_ds=&in_ds);

%put all_count:&all_count;

%put proc sort &in_ds &group_var;
proc sort data=&in_ds(keep= &group_var &target) out=tmp_sort;
by &group_var &target;
run;
%if &syserr>6 %then %abort;


data tmp_sort0 tmp_sort1;
	set tmp_sort;
	if missing(&group_var)^=1 then output tmp_sort0;
	else output tmp_sort1;
run;
data group_record;
length cut_off splitno 8. ;
stop;
run;

data grouping_split_ds_queue;
length ds_name $40.;
ds_name='tmp_sort0';
run;

%let split_ds_num=1;
%let split_num=1;

%let woe_increase=-1;
                             
%do %until(&split_ds_num=0);

	%put 1----------------------------------------------------------------------;
	%put Read the first data set of the queue;
	%put 1----------------------------------------------------------------------;

	data grouping_split_ds_queue;
	set grouping_split_ds_queue;
	if _n_=1 then do;
		call symputx('split_ds',ds_name);
		delete;
	end;
	run;
%put "split_ds=" &split_ds.;
/*%if &split_num=3 %then %abort;*/

	%symdel disgrpvarNum/nowarn;
	%local disgrpvarNum;
	proc sql noprint;
		select count(distinct &group_var.) into: disgrpvarNum from &split_ds.;
	quit;
	%put disgrpvarNum=&disgrpvarNum;
	%put all_count=&all_count.;
	%put in_ds=&split_ds.;
	%put in_ds_num=%Get_ds_rec_num(in_ds=&split_ds);

	%put "disgrpvarNum=" &disgrpvarNum.;
/*	%if &split_num=3 %then %abort;*/

	%if %sysevalf(&disgrpvarNum>1) and
		 %sysevalf(%Get_ds_rec_num(in_ds=&split_ds)>=%sysevalf(&all_count.*&min_group_num.*2)) %then %do;

		%put 2----------------------------------------------------------------------;
		%put Calculated the frequency of the &split_ds.;
		%put 2----------------------------------------------------------------------;

		%let split_ds_count=%Get_ds_rec_num(in_ds=&split_ds.);
		proc freq data=&split_ds. noprint;
			table &group_var.*&target. /missing out=tmp_varbin_crosscnt;
			table &target. /missing out=tmp_varbin_totcnt;
			table &group_var. /missing out=tmp_varbin_varcnt;
		run;quit; 

		proc sql;
			create table tmp_varbin_woe as
			select a.&group_var.,a.&target.,a.COUNT as varcnt,b.COUNT as varbincnt,c.COUNT as tarcnt
			from tmp_varbin_crosscnt as a
			left join tmp_varbin_varcnt as b
			on a.&group_var.=b.&group_var.
			left join tmp_varbin_totcnt as c
			on a.&target.=c.&target.
			order by a.&group_var.,a.&target.
			;
		quit;
		%let IV=0;
		%let max_cut_off=;
/*		%if &split_num=3 %then %abort;*/

		data tmp_varbin_woe1;
			set tmp_varbin_woe;
			by &group_var.;
			retain cnt_0 cnt_1 tot_0 tot_1 0;
			if &target.=0 then do;
				cnt_0 =varcnt;
				tot_0=tarcnt;
			end;
			else if &target.=1 then do;
				cnt_1=varcnt;
				tot_1=tarcnt;
			end;
			if last.&group_var. then do;
				output;
				cnt_0=0;
				cnt_1=0;
			end;
			keep &group_var. cnt_0 cnt_1 tot_0 tot_1 varbincnt;
		run;

		data grouping_tmp_woe;
			set tmp_varbin_woe1 end=last;
			by &group_var.;
			retain cal_varcnt tmp_0 tmp_1 IV_max GR_max ER_max 0;
			&group_var.=round(&group_var.,1e-10);
			lag_group = lag(&group_var.);
/*			format &group_var. 20.10;*/
			if _n_=1 then do;
				tmp_0=cnt_0;
				tmp_1=cnt_1;
				cal_varcnt=varbincnt;
			end;
/*			当有0有1才进行分割*/

			/* 方向和woe第一次切割方向相同*/
			if tmp_0 >0 and tmp_1 >0 and _n_^=1 then do;
				if cal_varcnt>&all_count.*&min_group_num. 
				and (&split_ds_count.-cal_varcnt)>=&all_count.*&min_group_num. 
				then do;
/*------------------------------------------------------------------------------*/
/*				计算IV值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的事件占比和非事件占比*/
					cnt_0_lower=tmp_0;
					cnt_1_lower=tmp_1;
					p0_lower=cnt_0_lower/tot_0;
					p1_lower=cnt_1_lower/tot_1;
					woe_lower=log(p1_lower/p0_lower);

/*					临界点以上（包括当前点）的事件占比和非事件占比*/
					cnt_0_upper=tot_0-tmp_0;
					cnt_1_upper=tot_1-tmp_1;
					p0_upper=cnt_0_upper/tot_0;
					p1_upper=cnt_1_upper/tot_1;
					woe_upper=log(p1_upper/p0_upper);

					iv = (p1_lower-p0_lower)*woe_lower + (p1_upper-p0_upper)*woe_upper;
/*                    m_woe=1 是woe顺序排列分箱，m_woe=0是自由分箱*/
                   %if &m_woe.=1 %then %do;
        
					if iv>iv_max and (1000*(woe_upper-woe_lower)*%sysevalf(&woe_increase)>0 or %sysevalf(&split_ds.=tmp_sort0)) then do;
					put woe_upper woe_lower;
					 %put &woe_increase.;

					 %end;
                      %if &m_woe.=0 %then %do;
                        if iv>iv_max then do;
                      %end;

						iv_max=iv;
						cut_off=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off',cut_off);
						call symputx('IV',IV_max);
						call symputx('woe_l',woe_lower);
						call symputx('woe_u',woe_upper);
					end;
/*------------------------------------------------------------------------------*/
/*				计算IV值：END*/
/*------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------*/
/*				计算Gini值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的Gini*/
					G_lower=1-(cnt_0_lower**2+cnt_1_lower**2)/cal_varcnt**2;

/*					临界点以上（包括当前点）的Gini*/
					G_upper=1-(cnt_0_upper**2+cnt_1_upper**2)/(tot_0+tot_1-cal_varcnt)**2;

/*					总体的Gini*/
					G_all=1-(tot_0**2+tot_1**2)/(tot_0+tot_1)**2;

					GR = 1-(cal_varcnt*G_lower+(tot_0+tot_1-cal_varcnt)*G_upper)/((tot_0+tot_1)*G_all);

					if GR>GR_max then do;
						GR_max=GR;
						cut_off_Gini=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off_Gini',cut_off_Gini);
						call symputx('GR',GR_max);
					end;
/*------------------------------------------------------------------------------*/
/*				计算Gini值：END*/
/*------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------*/
/*				计算Entropy值：START*/
/*------------------------------------------------------------------------------*/
/*					临界点以下（不包括当前点）的Entropy*/
					E_lower=-(cnt_0_lower/cal_varcnt)*log2(cnt_0_lower/cal_varcnt)
									-(cnt_1_lower/cal_varcnt)*log2(cnt_1_lower/cal_varcnt);

/*					临界点以上（包括当前点）的Entropy*/
					E_upper=-(cnt_0_upper/(tot_0+tot_1-cal_varcnt))*log2(cnt_0_upper/(tot_0+tot_1-cal_varcnt))
									-(cnt_1_upper/(tot_0+tot_1-cal_varcnt))*log2(cnt_1_upper/(tot_0+tot_1-cal_varcnt));

/*					总体的Entropy*/
					E_all=-(tot_0/(tot_0+tot_1))*log2(tot_0/(tot_0+tot_1))
							  -(tot_1/(tot_0+tot_1))*log2(tot_1/(tot_0+tot_1));

					ER = 1-(cal_varcnt*E_lower+(tot_0+tot_1-cal_varcnt)*E_upper)/((tot_0+tot_1)*E_all);

					if ER>ER_max then do;
						ER_max=ER;
						cut_off_E=sum(&group_var.,lag_group)/2;
						call symputx('max_cut_off_E',cut_off_E);
						call symputx('ER',ER_max);
					end;
/*------------------------------------------------------------------------------*/
/*				计算Entropy值：END*/
/*------------------------------------------------------------------------------*/

				end;
			end;
			if _n_^=1 then do;
				cal_varcnt=cal_varcnt+varbincnt;
				tmp_0=tmp_0+cnt_0;
				tmp_1=tmp_1+cnt_1;
			end;
			keep &group_var. cnt_0_lower cnt_1_lower p0_lower p1_lower woe_lower
			cnt_0_upper cnt_1_upper p0_upper p1_upper woe_upper 
			tot_0 tot_1 iv iv_max cut_off
			G_lower G_upper G_all GR GR_max cut_off_Gini
			E_lower E_upper E_all ER ER_max cut_off_E
			tmp_0 tmp_1
			;

		run;
/*		%if &split_num=1 %then %abort;*/

/*		%let max_cut_off=%sysevalf(&max_cut_off+10**(-10));*/
		%put 4----------------------------------------------------------------------------------------;
		%put The &split_num th split;
		%put Split data set					:&split_ds.;
		%put IV:;
		%put max_cut_off					:&max_cut_off.;
		%put IV								:&IV.;

		%put Gini:;
		%put max_cut_off					:&max_cut_off_Gini.;
		%put GR								:&GR.;

		%put Entropy:;
		%put max_cut_off					:&max_cut_off_E.;
		%put ER								:&ER.;
		%put 4----------------------------------------------------------------------------------------;

		%if &method=1 %then %do;
			%let value=&IV.;
			%let low_limit=0.001;
			%let cut_off=&max_cut_off;
		%end;
		%else %if &method=2 %then %do;
			%let value=&GR.;
			%let low_limit=0.0001;
			%let cut_off=&max_cut_off_Gini;
		%end;
		%else %if &method=3 %then %do;
			%let value=&ER.;
			%let low_limit=0.0001;
			%let cut_off=&max_cut_off_E;
		%end;

/*	确定woe第一次切割的方向*/
       %if %sysevalf(&split_ds.=tmp_sort0) %then %do;
	        %if %sysevalf(&woe_u. > &woe_l.) %then %do;
			     %let woe_increase=1;
			  %end;
	   %end;
/*-------------------------------*/
		  
		%if &value.>&low_limit.  %then %do;

			data split_lower_&split_num. split_upper_&split_num.;
				set &split_ds(keep =&group_var &target);
				if round(&group_var.,1e-10)<=&cut_off then output split_lower_&split_num.;
				else output split_upper_&split_num.;
			run;
/*%if &split_num=2 %then %abort;*/
/*%abort;*/

			%put 5----------------------------------------------------------------------------------------;
			%put Split finish ;
			%put split_lower_&split_num.:%Get_ds_rec_num(in_ds=split_lower_&split_num.);
			%put split_upper_&split_num.:%Get_ds_rec_num(in_ds=split_upper_&split_num.);
			%put 5----------------------------------------------------------------------------------------;

			%if %Get_ds_rec_num(in_ds=split_lower_&split_num.)>0
			and %Get_ds_rec_num(in_ds=split_upper_&split_num.)>0 %then %do;
			%put ----------------------------------------------------------------------------------------------;
			%put Put in the queue;
			%put ----------------------------------------------------------------------------------------------;

				data grouping_split_ds_append;
				length ds_name $40.;
				ds_name="split_lower_&split_num.";
				output;
				ds_name="split_upper_&split_num.";
				output;
				run;

				proc append base=grouping_split_ds_queue data=grouping_split_ds_append force;
				run;

				data grouping_group_record_append;
				length cut_off splitno 8.;
				cut_off=&cut_off;
				splitno=&split_num;
				run;
/*				%if &split_num=1 %then %abort;*/

				proc append base=group_record data=grouping_group_record_append force;
				run;
			%end;

		%end;

/*		%let split_num=%eval(&split_num.+1);*/

	%end;

   %let split_num=%eval(&split_num.+1);

	%let split_ds_num=%Get_ds_rec_num(in_ds=grouping_split_ds_queue);

/* 测试只跑第一次*/
/*	 %let split_ds_num=0;*/
 
	%put 6-------------------------------------------------------------------------;
	%put Remaining number of  split data set  : &split_ds_num.;
	%put The &split_num th split;
	%put 6-------------------------------------------------------------------------;
	%put 6*************************************************************************;
%end;

proc datasets lib=work nolist nodetails;
  delete split: temp_varbin: tmp_varbin: grouping: ;
run;quit;

/*			%abort;*/

/*根据临界值对数据分组,并计算最后分组的WOE值和IV值*/



%if %Get_ds_rec_num(in_ds=Group_record)>0 %then %do;

	/*选择最大分组数，此时不能排序，因为靠前的分组iv值越高*/
/*   20190704修改U_I从0开始，测试第一次不删除切割点*/
   %do U_i=0 %to %eval(&max_group.-2);
			data Group_record1;
				set Group_record nobs=t_obs;
				t_obs1=min(max(t_obs,2),&max_group.);
				if _n_<=t_obs1-&U_i.;
				drop t_obs:;
			run;
           %put U_i=&U_i.;
			proc sort data=Group_record1;
			   by cut_off;
			run;

			data _null_;
			set Group_record1 end=last nobs=Number_cut_off;
			call symputx('cut_off'||left(put(_n_,best.)),cut_off);
			if last then do; 
				call symputx('Number_cut_off',Number_cut_off);
			end;
			run;

		  data temp_map(keep=GRP_&group_var. &group_var. &target.);
				set tmp_sort;
				if missing(&group_var.)=1 then GRP_&group_var.=0;
				else if round(&group_var.,1e-10)<=&cut_off1 then GRP_&group_var.=1;
				%do i=2 %to &Number_cut_off.;
					else if round(&group_var.,1e-10)<=&&cut_off&i then GRP_&group_var.=&i;
				%end;
				else if round(&group_var.,1e-10)>&&cut_off&Number_cut_off. then GRP_&group_var.=&Number_cut_off.+1;
			run;

		/*%else %do;*/
		/*      %abort;*/
		/* %end;*/
		     
		proc sql noprint; 
		   select sum(&target.) , count(*)-sum(&target.) into : p1 , :p0 from temp_map;
		quit;

		proc freq data=temp_map noprint;table GRP_&group_var.*&target./out=cc;
		proc transpose data=cc out=cc1(drop=_name_ _label_) prefix=cnt_;
		 by GRP_&group_var.;
		 id &target.;
		 var count;

		data tempiv;
		   set cc1;
		   retain iv;
		   maptotal=sum(cnt_0,cnt_1);
		   p1t=cnt_1/&p1.;
		   p0t=cnt_0/&p0.;
		   woe=log(p1t/p0t);
		   iv1=(p1t-p0t)*woe;
		   iv+iv1;
		   put woe;
		   keep GRP_&group_var. cnt_0 cnt_1 woe iv;
		run;
   
/*	调用是否U型宏*/
     %mapiv_is_U(tempiv,GRP_&group_var.);

      %if &U_value.=1 %then %do;
	      data &DSVarIv.;
		      set tempiv;
		   run;
		  %goto exit;
	   %end;

    %end;
%end;
%exit: ;

proc sort data=temp_map;by GRP_&group_var. &group_var.;run;
data temp_map1;
	set temp_map ;
	length ll ul bin BinTotal 8;
	by GRP_&group_var.;
	retain ll BinTotal 0;
	if first.GRP_&group_var. then do;
		ll=&group_var.;
		BinTotal=0;
	end;
	BinTotal+1;
	if last.GRP_&group_var. then do;
		ul=&group_var.;
		bin=GRP_&group_var.;
		output;
	end;
	keep ll ul bin BinTotal ;
run;
/*proc sql;*/
/*	create table temp_map2 as*/
/*	select a.*,b.GRP_&group_var.*/
/*	from temp_map1 as a*/
/*	left join &DSVarIv. as b*/
/*	on a.bin=b.GRP_&group_var.*/
/*	;*/
/*quit;*/
/*上下限以切割点为准*/
proc sort data=temp_map1;by descending bin;run;
data &DSVarMap.;
   set temp_map1;
   ll1=lag(ll);
   if ll1^=. then ul=sum(ll1,ul)/2;
   if bin=0 then do;ll=.; ul=.;end;
   keep ll ul bin BinTotal;
run;
proc sort data=&DSVarMap.;by bin;run;


/*proc datasets lib=work nolist nodetails;*/
/*  delete save_in_ds temp_: tmp_: Group_record: ;*/
/*run;quit;*/

%let end_time=%sysfunc(datetime());
%let use_time=%sysevalf(&end_time.-&start_time.);
%put 0--------------------------------------------------------------;
%put DateTime:%sysfunc(datetime(),datetime20.);
%put Use time:&use_time.;
%put 0--------------------------------------------------------------;
%mend;


%macro mapiv_is_U(in_mapiv,GRP_VAR);
%global U_value;
data mp;
   set &in_mapiv.;
   where &GRP_VAR.^=0;
run;
proc sort data=mp;by &GRP_VAR.;run;
data mp1;
   set mp;
   by &GRP_VAR.;
   retain woe_fg 0;
   if _n_=1 then woe_fg=woe;
    else do; 
	   if woe_fg>woe then fg=-1;
	     else fg=1;
	   woe_fg=woe;
	  end;
 run;

 proc sql;
    create table mp2 as
	 select max(iv) as iv,
             max(case when fg=1 then &GRP_VAR. else 0 end) as a_rank,
			 min(case when fg=1 then &GRP_VAR. else 999 end) as a_rank_min,
	          sum(case when fg=1 then fg else 0 end) as a_sum,
              max(case when fg=-1 then &GRP_VAR. else 0 end) as d_rank,
			  min(case when fg=-1 then &GRP_VAR. else 999 end) as d_rank_min,
			  sum(case when fg=-1 then -fg else 0 end) as d_sum,
			  max(&GRP_VAR.) as GRP_VAR
	   from mp1;
  quit;


data mp3;
   set mp2;
   if (d_rank_min-a_rank=1 or a_rank_min-d_rank=1)  or a_sum=0 or d_sum=0 then call symputx('if_U',1);
      else call symputx('if_U',0);
run;
%let U_value=&if_U.;
%put &U_value.;
%mend;


