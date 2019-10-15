%macro supiv(tab,outtab);
data &outtab.;
   length var$32. iv iv1 maptotal mod_woe p0 p0t p1 p1_p0 p1t woe 8.;
   stop;
run;

proc contents data=&tab. out=v_cnt(keep=name) noprint;run;
data _null_;
    set v_cnt end=last;
    where index(upcase(name),'W_');
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


%supiv(valid3_1, valid3_1_iv);
%supiv(valid3_2, valid3_2_iv);
%supiv(valid3_3, valid3_3_iv);

proc sort data=valid3_1_iv;by var iv;run;
data valid3_1_iv1;
   set valid3_1_iv;
    by var iv;
	if last.var;
run;

proc sort data=valid3_2_iv;by var iv;run;
data valid3_2_iv1;
   set valid3_2_iv;
    by var iv;
	if last.var;
run;

proc sort data=valid3_3_iv;by var iv;run;
data valid3_3_iv1;
   set valid3_3_iv;
    by var iv;
	if last.var;
run;

proc sql;
   create table sup_iv as
    select a.var,a.iv,b.iv as iv1,c.iv as iv2,(a.iv-c.iv) as div
	from valid3_1_iv1 a
	left join valid3_2_iv1 b on a.var=b.var
   left join valid3_3_iv1 c on a.var=c.var
   order by div
;quit;

