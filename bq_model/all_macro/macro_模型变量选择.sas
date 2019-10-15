/*20190318修改入参sp_var*/

%macro select_var(intab,max_var,sp_var,sle_hold);

    %let tp_n=1;
    
/*	#对woe转化的变量修改变量名*/
	proc contents data=&intab. out=init_name(where=(type=1) keep=name type varnum) noprint;run;
	 proc sort data=init_name;by varnum;run;
	data init_name;
	  set init_name;
	  where upcase(name) not in('TARGET','CUS_ID','WEIGHT','USER_SID') and substr(name,1,2)='W_';
	  new_name='name_'||left(_n_);
	run;
/*	重命名变量，因为逐步选择变量长度最大20*/

    filename lg1 catalog 'work.t1.lg1.source';
	data _null_;
	      set init_name end=last;
		  file lg1;
		  if _n_=1 then put 'rename ';
          put name '=' new_name;
		  if last then put ';';
	run;

	filename lg2 catalog 'work.t1.lg2.source';
	data _null_;
	      set init_name end=last;
		  file lg2;
		  if _n_=1 then put 'rename ';
          put new_name '=' name;
		  if last then put ';';
	run;
   
	 data temp_tab;
          set  &intab.;
		  %Inc lg1;
	 run;

	%do %while(&tp_n>0);
			proc contents data=temp_tab out=cnt(where=(type=1) keep=name type) noprint;run;
			data cnt;
			  set cnt;
			  where upcase(name) not in('TARGET','CUS_ID','WEIGHT','USER_SID');
			/*  varname=cats('woe_',name);*/
			  new_name='name_'||left(_n_);
			run;
             
			filename logic catalog "work.v1.vars.source";
			data _null_;
				set cnt end=last;
				file logic;	
				if _n_=1 then put "model target=" ;
				if name^="target" then put name;
				if last then put "/SELECTION=s details lackfit stb sls=&sle_hold. sle=&sle_hold. maxstep=&max_var.;";
			run;

			proc printto print=".\model_train_output.txt" new;
			run;	

			ods results off;	
			ods output
			ParameterEstimates=pe;
			proc logistic data=temp_tab desc outest=dt.test_model_tr;
				%inc logic;
				output out=dt.test_model_logi p=fraud_p;
				weight weight;
			run;quit;

			proc sql;
			   create table pe as
			    select a.*,case when b.name^='' then b.name else a.variable end as name
				from pe a
				left join cnt b on a.variable=substr(b.name,1,20);
			 quit;

			proc sql noprint; 
			     select max(Step) into :final_step from pe;
			quit;
			data pe1;
			    set pe;
				where step=&final_step.;
			   keep name Estimate WaldChiSq ProbChiSq StandardizedEst;
			run;
			/*proc sort data=pe1;by descending StandardizedEst;run;*/
			/**/
			/*proc sort data=pe;by name step;run;*/

			proc sql;
			  create table pe2 as
			   select name,min(step) as first_step
			   from pe 
			   where name^='Intercept'
			   group by 1
			   order by first_step
			    ; 
			 create table pe3 as 
			   select a.*,b.first_step
			   from pe1 a
			   left join pe2 b on a.name=b.name
/*			   where Estimate<0 and a.name^='Intercept' and index(a.name,"&sp_var.")=0 */
			   where Estimate<0 and a.name^='Intercept' and substr(a.name,1,4)='name'
			   order by first_step
			   ;
			quit;
			proc sql outobs=1 noprint;
			   select name ,count(*) into :var_drop1 ,:tp_n from pe3;
			quit;
			%put &var_drop1. &tp_n.;

			%let tp_n=&tp_n.;

			data temp_tab;
			     set temp_tab;
				 drop &var_drop1.;
			run;
	%end;

/*    循环结束，换回原变量*/
     data dt.test_model_tr;
	       set dt.test_model_tr;
		   %inc lg2;
	  data dt.Test_model_logi;
	       set dt.Test_model_logi;
		     %inc lg2;
	  run;
     proc sql;
	     create table pe1 as
		  select case when b.name^='' then b.name else a.name end as name,a.Estimate,a.WaldChiSq,a.ProbChiSq,a.StandardizedEst
		  from pe1 a
		  left join init_name b on a.name=b.new_name;
	  quit;
%mend;
