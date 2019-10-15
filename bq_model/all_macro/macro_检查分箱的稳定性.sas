%macro check_stab(in_mapiv, out_var_stab);
/*proc sql;*/
/*   create table check_stab as*/
/*   select * from &in_mapiv.*/
/*   where var in(select var from iv3);*/
/*quit;*/

proc sort data=in_mapiv;by var woe ;run;
data check_stab1;
    set in_mapiv;
    by var woe ;
	if first.var then fg=1;
    else fg+1;
 run;
proc sort data=check_stab1;by var descending woe ;run;
data check_stab2;
    set check_stab1;
    by var descending woe ;
	if first.var then fg1=1;
    else fg1+1;
 run;
 proc sql;
    create table check_stab3 as
	 select var,max(bin) as bin,sum(case when bin=fg then 1 else 0 end) as m1,
	             sum(case when bin=fg1 then 1 else 0 end)as  m2
	  from  check_stab2
    group by 1
	having bin^=m1 and bin^=m2;
 quit;

 data &out_var_stab.;
     set check_stab3;
	 keep var;
 run;

/* proc datasets lib=work nolist nodetails; delete check_stab: ;run;quit;*/
%mend;
