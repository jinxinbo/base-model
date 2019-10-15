%macro varclus(inDS,maxeigen,outstat,outtree,outcluster,outr2);

ods listing close;
ods results off;
proc contents data=&inDS out=varname(keep=name type) noprint;run;

filename var catalog "work.var.var.source";
data _null_;
	set varname end=last;
	where type=1 and name not in('target','uid','user_sid') ;
	file var;
	if _n_=1 then put "var ";
	put name;
	if last then put ";";
run;

ods output 
RSquare=r2;
proc varclus data=&inDS maxeigen=&maxeigen
	outstat=&outstat
	outtree=&outtree
	hi  ;

	%inc var;
run;quit;

proc sql noprint;
	select max(_NCL_) into: max_cluster_num from &outstat;
quit;
data tmp;
	set &outstat;
	if _NCL_=&max_cluster_num and _TYPE_='GROUP';
run;
proc transpose data=tmp out=&outcluster(drop=_label_) name=varname prefix=cluster_;
/*	id _NCL_ ;*/
/*	var woe_:;*/
run;
data &outcluster;
    set &outcluster;
	where varname not in('_NCL_');
proc sort data=&outcluster;by cluster_: varname;run;


data &outr2;
   set r2;
   where NumberOfClusters=&max_cluster_num;
run;

proc datasets lib=work nolist nodetails;delete R2 tmp;run;quit;
%mend;



