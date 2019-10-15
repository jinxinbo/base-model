
data dt.data2;
  set dt.data1;
  where agr_fpd30_1=1;
 format app_date yymmdd10. ;

app_date=input(create_time,yymmdd10.);

app_week=week(app_date);
app_mon=substr(create_time,1,7);
	drop cpd white_type  payment_num row_num create_time status net_time id_no id_person rn
	app_no_br2  serialno app_no_risk app_no_tz cert_seq cust_id  loan_date contract_no app_no_ind
   request_date request_time  id_no4  id_no6 app_no_br_apply app_no_br_score app_no_td_decision app_no_tx
   business_id: app_no_rh
   t1_app_no _c1  t2_app_no t3_app_no t4_app_no pre2_pd30 
; 
rename app_no=user_sid def_fpd30_1=target;
run;

data dt.data3;
 set dt.data2;
 drop agr_fpd: def_fpd:;
run;

proc freq data=dt.data3;table m12_id_nbank_allnum;run;

data dt.data3;
   set dt.data3;
   is_fstbank_inteday=fst_id_bank_inteday=fst_cell_bank_inteday;
is_fstnbank_inteday=fst_id_nbank_inteday=fst_cell_nbank_inteday;
is_lstbank_inteday=lst_id_bank_inteday=lst_cell_bank_inteday;
is_lstbank_consnum=lst_id_bank_consnum=lst_cell_bank_consnum;
is_lstbank_csinteday=lst_id_bank_csinteday=lst_cell_bank_csinteday;
is_lstnbank_inteday=lst_id_nbank_inteday=lst_cell_nbank_inteday;
is_lstnbank_consnum=lst_id_nbank_consnum=lst_cell_nbank_consnum;
is_lstnbank_csinteday=lst_id_nbank_csinteday=lst_cell_nbank_csinte;
is_d7bank_selfnum=d7_id_bank_selfnum=d7_cell_bank_selfnum;
is_d7bank_allnum=d7_id_bank_allnum=d7_cell_bank_allnum;
is_d7bank_orgnum=d7_id_bank_orgnum=d7_cell_bank_orgnum;
is_d7nbank_selfnum=d7_id_nbank_selfnum=d7_cell_nbank_selfnum;
is_d7nbank_allnum=d7_id_nbank_allnum=d7_cell_nbank_allnum;
is_d7nbank_orgnum=d7_id_nbank_orgnum=d7_cell_nbank_orgnum;
is_d7nbank_p2p_allnum=d7_id_nbank_p2p_allnum=d7_cell_nbak_p2p_allnum;
is_d7nbank_mc_allnum=d7_id_nbank_mc_allnum=d7_cell_nbank_mc_allnum;
is_d7nbank_ca_allnum=d7_id_nbank_ca_allnum=d7_cell_nbank_ca_allnum;
is_d7nbank_cf_allnum=d7_id_nbank_cf_allnum=d7_cell_nbank_cf_allnum;
is_d7nbank_com_allnum=d7_id_nbank_com_allnum=d7_cell_nbak_com_allnum;
is_d7nbank_oth_allnum=d7_id_nbank_oth_allnum=d7_cell_nbak_oth_allnum;
is_d7nbank_p2p_orgnum=d7_id_nbank_p2p_orgnum=d7_cell_nbak_p2p_orgnum;
is_d7nbank_mc_orgnum=d7_id_nbank_mc_orgnum=d7_cell_nbank_mc_orgnum;
is_d7nbank_ca_orgnum=d7_id_nbank_ca_orgnum=d7_cell_nbank_ca_orgnum;
is_d7nbank_cf_orgnum=d7_id_nbank_cf_orgnum=d7_cell_nbank_cf_orgnum;
is_d7nbank_com_orgnum=d7_id_nbank_com_orgnum=d7_cell_nbak_com_orgnum;
is_d7nbank_oth_orgnum=d7_id_nbank_oth_orgnum=d7_cell_nbak_oth_orgnum;
is_d15bank_selfnum=d15_id_bank_selfnum=d15_cell_bank_selfnum;
is_d15bank_allnum=d15_id_bank_allnum=d15_cell_bank_allnum;
is_d15bank_orgnum=d15_id_bank_orgnum=d15_cell_bank_orgnum;
is_d15nbank_selfnum=d15_id_nbank_selfnum=d15_cell_nbank_selfnum;
is_d15nbank_allnum=d15_id_nbank_allnum=d15_cell_nbank_allnum;
is_d15nbank_orgnum=d15_id_nbank_orgnum=d15_cell_nbank_orgnum;
is_d15nbank_p2p_allnum=d15_id_nbank_p2p_allnum=d15_cell_nbk_p2p_allnum;
is_d15nbank_mc_allnum=d15_id_nbank_mc_allnum=d15_cell_nbak_mc_allnum;
is_d15nbank_ca_allnum=d15_id_nbank_ca_allnum=d15_cell_nbak_ca_allnum;
is_d15nbank_cf_allnum=d15_id_nbank_cf_allnum=d15_cell_nbak_cf_allnum;
is_d15nbank_com_allnum=d15_id_nbank_com_allnum=d15_cell_nbk_com_allnum;
is_d15nbank_oth_allnum=d15_id_nbank_oth_allnum=d15_cell_nbk_oth_allnum;
is_d15nbank_p2p_orgnum=d15_id_nbank_p2p_orgnum=d15_cell_nbk_p2p_orgnum;
is_d15nbank_mc_orgnum=d15_id_nbank_mc_orgnum=d15_cell_nbak_mc_orgnum;
is_d15nbank_ca_orgnum=d15_id_nbank_ca_orgnum=d15_cell_nbak_ca_orgnum;
is_d15nbank_cf_orgnum=d15_id_nbank_cf_orgnum=d15_cell_nbak_cf_orgnum;
is_d15nbank_com_orgnum=d15_id_nbank_com_orgnum=d15_cell_nbk_com_orgnum;
is_d15nbank_oth_orgnum=d15_id_nbank_oth_orgnum=d15_cell_nbk_oth_orgnum;
is_m1bank_selfnum=m1_id_bank_selfnum=m1_cell_bank_selfnum;
is_m1bank_allnum=m1_id_bank_allnum=m1_cell_bank_allnum;
is_m1bank_orgnum=m1_id_bank_orgnum=m1_cell_bank_orgnum;
is_m1nbank_selfnum=m1_id_nbank_selfnum=m1_cell_nbank_selfnum;
is_m1nbank_allnum=m1_id_nbank_allnum=m1_cell_nbank_allnum;
is_m1nbank_orgnum=m1_id_nbank_orgnum=m1_cell_nbank_orgnum;
is_m1nbank_p2p_allnum=m1_id_nbank_p2p_allnum=m1_cell_nbak_p2p_allnum;
is_m1nbank_mc_allnum=m1_id_nbank_mc_allnum=m1_cell_nbank_mc_allnum;
is_m1nbank_ca_allnum=m1_id_nbank_ca_allnum=m1_cell_nbank_ca_allnum;
is_m1nbank_cf_allnum=m1_id_nbank_cf_allnum=m1_cell_nbank_cf_allnum;
is_m1nbank_com_allnum=m1_id_nbank_com_allnum=m1_cell_nbak_com_allnum;
is_m1nbank_oth_allnum=m1_id_nbank_oth_allnum=m1_cell_nbak_oth_allnum;
is_m1nbank_p2p_orgnum=m1_id_nbank_p2p_orgnum=m1_cell_nbak_p2p_orgnum;
is_m1nbank_mc_orgnum=m1_id_nbank_mc_orgnum=m1_cell_nbank_mc_orgnum;
is_m1nbank_ca_orgnum=m1_id_nbank_ca_orgnum=m1_cell_nbank_ca_orgnum;
is_m1nbank_cf_orgnum=m1_id_nbank_cf_orgnum=m1_cell_nbank_cf_orgnum;
is_m1nbank_com_orgnum=m1_id_nbank_com_orgnum=m1_cell_nbak_com_orgnum;
is_m1nbank_oth_orgnum=m1_id_nbank_oth_orgnum=m1_cell_nbak_oth_orgnum;
is_m3bank_selfnum=m3_id_bank_selfnum=m3_cell_bank_selfnum;
is_m3bank_allnum=m3_id_bank_allnum=m3_cell_bank_allnum;
is_m3bank_orgnum=m3_id_bank_orgnum=m3_cell_bank_orgnum;
is_m3nbank_selfnum=m3_id_nbank_selfnum=m3_cell_nbank_selfnum;
is_m3nbank_allnum=m3_id_nbank_allnum=m3_cell_nbank_allnum;
is_m3nbank_orgnum=m3_id_nbank_orgnum=m3_cell_nbank_orgnum;
is_m3nbank_p2p_allnum=m3_id_nbank_p2p_allnum=m3_cell_nbak_p2p_allnum;
is_m3nbank_mc_allnum=m3_id_nbank_mc_allnum=m3_cell_nbank_mc_allnum;
is_m3nbank_ca_allnum=m3_id_nbank_ca_allnum=m3_cell_nbank_ca_allnum;
is_m3nbank_cf_allnum=m3_id_nbank_cf_allnum=m3_cell_nbank_cf_allnum;
is_m3nbank_com_allnum=m3_id_nbank_com_allnum=m3_cell_nbak_com_allnum;
is_m3nbank_oth_allnum=m3_id_nbank_oth_allnum=m3_cell_nbak_oth_allnum;
is_m3nbank_p2p_orgnum=m3_id_nbank_p2p_orgnum=m3_cell_nbak_p2p_orgnum;
is_m3nbank_mc_orgnum=m3_id_nbank_mc_orgnum=m3_cell_nbank_mc_orgnum;
is_m3nbank_ca_orgnum=m3_id_nbank_ca_orgnum=m3_cell_nbank_ca_orgnum;
is_m3nbank_cf_orgnum=m3_id_nbank_cf_orgnum=m3_cell_nbank_cf_orgnum;
is_m3nbank_com_orgnum=m3_id_nbank_com_orgnum=m3_cell_nbak_com_orgnum;
is_m3nbank_oth_orgnum=m3_id_nbank_oth_orgnum=m3_cell_nbak_oth_orgnum;
is_m6bank_selfnum=m6_id_bank_selfnum=m6_cell_bank_selfnum;
is_m6bank_allnum=m6_id_bank_allnum=m6_cell_bank_allnum;
is_m6bank_orgnum=m6_id_bank_orgnum=m6_cell_bank_orgnum;
is_m6nbank_selfnum=m6_id_nbank_selfnum=m6_cell_nbank_selfnum;
is_m6nbank_allnum=m6_id_nbank_allnum=m6_cell_nbank_allnum;
is_m6nbank_orgnum=m6_id_nbank_orgnum=m6_cell_nbank_orgnum;
is_m6nbank_p2p_allnum=m6_id_nbank_p2p_allnum=m6_cell_nbak_p2p_allnum;
is_m6nbank_mc_allnum=m6_id_nbank_mc_allnum=m6_cell_nbank_mc_allnum;
is_m6nbank_ca_allnum=m6_id_nbank_ca_allnum=m6_cell_nbank_ca_allnum;
is_m6nbank_cf_allnum=m6_id_nbank_cf_allnum=m6_cell_nbank_cf_allnum;
is_m6nbank_com_allnum=m6_id_nbank_com_allnum=m6_cell_nbak_com_allnum;
is_m6nbank_oth_allnum=m6_id_nbank_oth_allnum=m6_cell_nbak_oth_allnum;
is_m6nbank_p2p_orgnum=m6_id_nbank_p2p_orgnum=m6_cell_nbak_p2p_orgnum;
is_m6nbank_mc_orgnum=m6_id_nbank_mc_orgnum=m6_cell_nbank_mc_orgnum;
is_m6nbank_ca_orgnum=m6_id_nbank_ca_orgnum=m6_cell_nbank_ca_orgnum;
is_m6nbank_cf_orgnum=m6_id_nbank_cf_orgnum=m6_cell_nbank_cf_orgnum;
is_m6nbank_com_orgnum=m6_id_nbank_com_orgnum=m6_cell_nbak_com_orgnum;
is_m6nbank_oth_orgnum=m6_id_nbank_oth_orgnum=m6_cell_nbak_oth_orgnum;
is_m12bank_selfnum=m12_id_bank_selfnum=m12_cell_bank_selfnum;
is_m12bank_allnum=m12_id_bank_allnum=m12_cell_bank_allnum;
is_m12bank_orgnum=m12_id_bank_orgnum=m12_cell_bank_orgnum;
is_m12nbank_selfnum=m12_id_nbank_selfnum=m12_cell_nbank_selfnum;
is_m12nbank_allnum=m12_id_nbank_allnum=m12_cell_nbank_allnum;
is_m12nbank_orgnum=m12_id_nbank_orgnum=m12_cell_nbank_orgnum;
is_m12nbank_p2p_allnum=m12_id_nbank_p2p_allnum=m12_cell_nbk_p2p_allnum;
is_m12nbank_mc_allnum=m12_id_nbank_mc_allnum=m12_cell_nbak_mc_allnum;
is_m12nbank_ca_allnum=m12_id_nbank_ca_allnum=m12_cell_nbak_ca_allnum;
is_m12nbank_cf_allnum=m12_id_nbank_cf_allnum=m12_cell_nbak_cf_allnum;
is_m12nbank_com_allnum=m12_id_nbank_com_allnum=m12_cell_nbk_com_allnum;
is_m12nbank_oth_allnum=m12_id_nbank_oth_allnum=m12_cell_nbk_oth_allnum;
is_m12nbank_p2p_orgnum=m12_id_nbank_p2p_orgnum=m12_cell_nbk_p2p_orgnum;
is_m12nbank_mc_orgnum=m12_id_nbank_mc_orgnum=m12_cell_nbak_mc_orgnum;
is_m12nbank_ca_orgnum=m12_id_nbank_ca_orgnum=m12_cell_nbak_ca_orgnum;
is_m12nbank_cf_orgnum=m12_id_nbank_cf_orgnum=m12_cell_nbak_cf_orgnum;
is_m12nbank_com_orgnum=m12_id_nbank_com_orgnum=m12_cell_nbk_com_orgnum;
is_m12nbank_oth_orgnum=m12_id_nbank_oth_orgnum=m12_cell_nbk_oth_orgnum;
is_m3tot_mons=m3_id_tot_mons=m3_cell_tot_mons;
is_m3avg_monnum=m3_id_avg_monnum=m3_cell_avg_monnum;
is_m3max_monnum=m3_id_max_monnum=m3_cell_max_monnum;
is_m3min_monnum=m3_id_min_monnum=m3_cell_min_monnum;
is_m3max_inteday=m3_id_max_inteday=m3_cell_max_inteday;
is_m3min_inteday=m3_id_min_inteday=m3_cell_min_inteday;
is_m3bank_tot_mons=m3_id_bank_tot_mons=m3_cell_bank_tot_mons;
is_m3bank_avg_monnum=m3_id_bank_avg_monnum=m3_cell_bank_avg_monnum;
is_m3bank_max_monnum=m3_id_bank_max_monnum=m3_cell_bank_max_monnum;
is_m3bank_min_monnum=m3_id_bank_min_monnum=m3_cell_bank_min_monnum;
is_m3bank_max_inteday=m3_id_bank_max_inteday=m3_cell_bak_max_inteday;
is_m3bank_min_inteday=m3_id_bank_min_inteday=m3_cell_bak_min_inteday;
is_m3nbank_tot_mons=m3_id_nbank_tot_mons=m3_cell_nbank_tot_mons;
is_m3nbank_avg_monnum=m3_id_nbank_avg_monnum=m3_cell_nbak_avg_monnum;
is_m3nbank_max_monnum=m3_id_nbank_max_monnum=m3_cell_nbak_max_monnum;
is_m3nbank_min_monnum=m3_id_nbank_min_monnum=m3_cell_nbak_min_monnum;
is_m3nbank_max_inteday=m3_id_nbank_max_inteday=m3_cell_nbk_max_inteday;
is_m3nbank_min_inteday=m3_id_nbank_min_inteday=m3_cell_nbk_min_inteday;
is_m6tot_mons=m6_id_tot_mons=m6_cell_tot_mons;
is_m6avg_monnum=m6_id_avg_monnum=m6_cell_avg_monnum;
is_m6max_monnum=m6_id_max_monnum=m6_cell_max_monnum;
is_m6min_monnum=m6_id_min_monnum=m6_cell_min_monnum;
is_m6max_inteday=m6_id_max_inteday=m6_cell_max_inteday;
is_m6min_inteday=m6_id_min_inteday=m6_cell_min_inteday;
is_m6bank_tot_mons=m6_id_bank_tot_mons=m6_cell_bank_tot_mons;
is_m6bank_avg_monnum=m6_id_bank_avg_monnum=m6_cell_bank_avg_monnum;
is_m6bank_max_monnum=m6_id_bank_max_monnum=m6_cell_bank_max_monnum;
is_m6bank_min_monnum=m6_id_bank_min_monnum=m6_cell_bank_min_monnum;
is_m6bank_max_inteday=m6_id_bank_max_inteday=m6_cell_bnk_max_inteday;
is_m6bank_min_inteday=m6_id_bank_min_inteday=m6_cell_bak_min_inteday;
is_m6nbank_tot_mons=m6_id_nbank_tot_mons=m6_cell_nbank_tot_mons;
is_m6nbank_avg_monnum=m6_id_nbank_avg_monnum=m6_cell_nbak_avg_monnum;
is_m6nbank_max_monnum=m6_id_nbank_max_monnum=m6_cell_nbak_max_monnum;
is_m6nbank_min_monnum=m6_id_nbank_min_monnum=m6_cell_nbak_min_monnum;
is_m6nbank_max_inteday=m6_id_nbank_max_inteday=m6_cell_nbk_max_inteday;
is_m6nbank_min_inteday=m6_id_nbank_min_inteday=m6_cell_nbk_min_inteday;
is_m12tot_mons=m12_id_tot_mons=m12_cell_tot_mons;
is_m12avg_monnum=m12_id_avg_monnum=m12_cell_avg_monnum;
is_m12max_monnum=m12_id_max_monnum=m12_cell_max_monnum;
is_m12min_monnum=m12_id_min_monnum=m12_cell_min_monnum;
is_m12max_inteday=m12_id_max_inteday=m12_cell_max_inteday;
is_m12min_inteday=m12_id_min_inteday=m12_cell_min_inteday;
is_m12bank_tot_mons=m12_id_bank_tot_mons=m12_cell_bank_tot_mons;
is_m12bank_avg_monnum=m12_id_bank_avg_monnum=m12_cell_bak_avg_monnum;
is_m12bank_max_monnum=m12_id_bank_max_monnum=m12_cell_bak_max_monnum;
is_m12bank_min_monnum=m12_id_bank_min_monnum=m12_cell_bak_min_monnum;
is_m12bank_max_inteday=m12_id_bank_max_inteday=m12_cell_bk_max_inteday;
is_m12bank_min_inteday=m12_id_bank_min_inteday=m12_cell_bk_min_inteday;
is_m12nbank_tot_mons=m12_id_nbank_tot_mons=m12_cell_nbank_tot_mons;
is_m12nbank_avg_monnum=m12_id_nbank_avg_monnum=m12_cell_nbk_avg_monnum;
is_m12nbank_max_monnum=m12_id_nbank_max_monnum=m12_cell_nbk_max_monnum;
is_m12nbank_min_monnum=m12_id_nbank_min_monnum=m12_cell_nbk_min_monnum;
is_m12nbak_max_inteday=m12_id_nbak_max_inteday=m12_cell_nbank_max_inte;
is_m12nbak_min_inteday=m12_id_nbak_min_inteday=m12_cell_nbank_min_inte;
is_aldbank_selfnum=ald_id_bank_selfnum=ald_cell_bank_selfnum;
is_aldbank_allnum=ald_id_bank_allnum=ald_cell_bank_allnum;
is_aldbank_orgnum=ald_id_bank_orgnum=ald_cell_bank_orgnum;
is_aldnbank_selfnum=ald_id_nbank_selfnum=ald_cell_nbank_selfnum;
is_aldnbank_allnum=ald_id_nbank_allnum=ald_cell_nbank_allnum;
is_aldnbank_p2p_allnum=ald_id_nbank_p2p_allnum=ald_cell_nbk_p2p_allnum;
is_aldnbank_mc_allnum=ald_id_nbank_mc_allnum=ald_cell_nbak_mc_allnum;
is_aldnbk_ca_on_allnum=ald_id_nbk_ca_on_allnum=ald_cell_nbk_ca_on_alln;
is_aldnbk_ca_off_allnu=ald_id_nbk_ca_off_allnu=ald_cell_nbk_ca_off_all;
is_aldnbk_cf_on_allnum=ald_id_nbk_cf_on_allnum=ald_cell_nbk_cf_on_alln;
is_aldnbk_cf_off_allnu=ald_id_nbk_cf_off_allnu=ald_cell_nbk_cf_off_all;
is_aldnbank_com_allnum=ald_id_nbank_com_allnum=ald_cell_nbk_com_allnum;
is_aldnbank_oth_allnum=ald_id_nbank_oth_allnum=ald_cell_nbk_oth_allnum;
is_aldnbank_orgnum=ald_id_nbank_orgnum=ald_cell_nbank_orgnum;
is_aldnbank_p2p_orgnum=ald_id_nbank_p2p_orgnum=ald_cell_nbk_p2p_orgnum;
is_aldnbank_mc_orgnum=ald_id_nbank_mc_orgnum=ald_cell_nbak_mc_orgnum;
is_aldnbk_ca_on_orgnum=ald_id_nbk_ca_on_orgnum=ald_cell_nbk_ca_on_orgn;
is_aldnbk_ca_off_orgnu=ald_id_nbk_ca_off_orgnu=ald_cell_nbk_ca_off_org;
is_aldnbk_cf_on_orgnum=ald_id_nbk_cf_on_orgnum=ald_cell_nbk_cf_on_orgn;
is_aldnbk_cf_off_orgnu=ald_id_nbk_cf_off_orgnu=ald_cell_nbk_cf_off_org;
is_aldnbank_com_orgnum=ald_id_nbank_com_orgnum=ald_cell_nbk_com_orgnum;
is_aldnbank_oth_orgnum=ald_id_nbank_oth_orgnum=ald_cell_nbk_oth_orgnum;
;run;



/*探知因为t3_app_no不为空，其他缺失的不能中位数填充，都补位0*/
data dt.data4;
set dt.data3;
  array ar[*]
m1_id_loan
m1_cell_loan
m1_loan_sum
m1_loan_max
m3_id_loan
m3_cell_loan
m3_loan_sum
m3_loan_max
m6_id_loan
m6_cell_loan
m6_loan_sum
m6_loan_max
m12_id_loan
m12_cell_loan
m12_loan_sum
m12_loan_max
m18_id_loan
m18_cell_loan
m18_loan_sum
m18_loan_max
;
do i=1 to dim(ar);
  if ar[i]=. then ar[i]=0;
end;
drop i;
run;


data dt.data4;
   set dt.data4;
  is_weekday=weekday(app_date) in(1,7);

  td_div_1m=m1_id_loan-m1_cell_loan;
td_div_3m=m3_id_loan-m3_cell_loan;
td_div_6m=m6_id_loan-m6_cell_loan;
td_div_12m=m12_id_loan-m12_cell_loan;
td_div_18m=m18_id_loan-m18_cell_loan;

td_std_mon_id1=std(m3_id_loan,m6_id_loan-m3_id_loan);
td_std_mon_cell1=std(m3_cell_loan,m6_cell_loan-m3_cell_loan);
td_std_mon_id2=std(m6_id_loan,m12_id_loan-m6_id_loan,m18_id_loan-m12_id_loan);
td_std_mon_cell2=std(m6_cell_loan,m12_cell_loan-m6_cell_loan,m18_cell_loan-m12_cell_loan);
run;


 
proc sql;
   create table xx1 as
    select app_week,count(*) as cnt,avg(target) as badrate
	from dt.data4
	group by 1
    order by 1;
quit;




/*对所有数据保留6位小数*/
data dt.data4;
  set dt.data4;
  array ar _numeric_;
  do over ar;
    ar=round(ar,1e-6);
  end;
run;



/*划分样本*/


	
data data_train;
    set dt.data4;
	where app_date<='17jul2019'd;
run;

proc freq data=dt.data4;table target;run;

proc sort data=data_train;by app_week target ;run;

proc surveyselect data=data_train out=temp1(drop=SelectionProb SamplingWeight) noprint method=srs seed=1234
samprate=0.8 outall;
strata app_week target ;
run;



data dt.data_train dt.data_test;
  set temp1;
   if Selected=1 then output dt.data_train;
     else output dt.data_test;
   drop Selected app_week app_mon app_date;
run;

ods listing;
ods results off;
proc freq data=dt.data_train;table target;run;
proc freq data=dt.data_test;table target;run;



data dt.data_valid;
   set dt.data4;
	where app_date>'17jul2019'd;
run;

proc freq data=data_train;table target;run;

proc freq data=dt.data_valid;table target;run;


proc sql;
   create table xx as 
    select app_week,min(app_date) format yymmdd10., max(app_date) format yymmdd10.
	from dt.data4
	group by 1;
 quit;




/*设定宏地址*/
%let dir_mac=%str(E:\python代码及论文\合影\all_macro);
%put &dir_mac.;


%inc "&dir_mac.\检查空缺情况_macro.sas";

 %count_nullobs(inDS=dt.data_train,outDS=dt.nullobs2);
proc sort data=dt.nullobs2;
	by descending null_percent;
run;quit;




filename dp catalog 'work.t1.dp.source';
data _null_;
   set dt.nullobs2 end=last;
   where null_percent>=0.9;
   file dp;
   if _n_=1 then put 'drop ';
  put varname;
  if last then put ';';
run;



ods results off;
ods listing;


%macro nullobs(nulltab, stattab, outtab);
data &outtab.;
	length var $32. pvalue_0 pvalue_25 pvalue_50 pvalue_75 pvalue_95 pvalue_100 8.;
	stop;
run;

data _null_;
  set &stattab. end=last;
   where null_percent<0.01 and nullnum>0 and vartype='num';
   call symputx('invar'||left(_n_),varname);
   if last then call symputx('n',_n_);
run;
%do i=1 %to &n.;
%let invar=&&invar&i..;
	data err;
	set &nulltab.;
	where &invar.^=.;
	keep &inVAR. user_sid;
	run;

	proc univariate data=err noprint;
	var &inVAR.;
	output out=err1 pctlpts=0 25 50 75 95 100
					pctlpre=pvalue
					pctlname=_0 _25 _50 _75 _95 _100;
	run;quit;

	data err1;
	set err1;
	var="&invar.";	
	run;
proc append base=&outtab. data=err1 force;run;quit;
%end;

%mend;


proc printto log=".\null.txt" new;run;quit;
%nullobs(dt.Data_train, dt.Nullobs2, dt.null_fill);
proc printto;run;quit;

filename null catalog 'work.t1.null.source';
data _null_;
  set dt.null_fill;
  file null;
  put 'if ' var '=. then ' var '=' pvalue_50';';
run;



/*缺失值处理之后*/
data dt.data_train1;
  set dt.data_train;
%inc dp;
%inc null;
;
run;



/*分布检验*/
%inc "&dir_mac.\c_5_1_统计连续型分布_macro.sas";
%inc "&dir_mac.\c_5_2_统计属性分布_macro.sas";

%table_freq(inDS=dt.data_train1,outDS=fenbu1,uniquenum=30);
proc sort data=fenbu1;
	by myvar descending count ;
run;quit;

/*连续变量分布情况*/

%table_univariate(inDS=dt.data_train1,outDS=dt.univ1);

data err;
   set dt.univ1;
   where pvalue_100=999999;
run;

data univ1;
  set dt.univ1;
  where pvalue_0=pvalue_90;
run;




/*类别变量分箱*/
 proc contents data=dt.data_train1 out=xx(keep=name type) noprint;run;

filename fl catalog 'work.t1.fl.source';
data cnt2;
   set xx end=last;
   where type=2 and name not in('white_level','white_type','id_no','request_time','app_mon');
   file fl;
   if _n_=1 then put 'keep user_sid target';
   put name;
   if last then put ';';
run;

data test;
  set dt.data_train1;
   %inc fl;
;run;



%inc "&dir_mac.\macro_分组方法.sas";
%calcwoe_catevar(inDS=test,outDS=test_1);

/*%Bestgrouping(test_1,target,7,dt.new_fl_mapiv,dt.new_fl_woetab,0.05);*/

%calWoeIV_and_apply(inDS=test_1,adj_num=0.1,
                           min_grpNum=0.1,
                           outDS=dt.new_fl_woetab,
                           outMapSum=dt.new_fl_map,outIVSum=dt.new_fl_iv,max_group=6,my_woe=1);


proc sql;
  create table dt.new_fl_mapiv as
   select a.*,b.ll,b.ul
   from dt.new_fl_iv a
   left join dt.new_fl_map b
   on a.varname=b.varname and a.grp_var=b.bin;
quit;

proc sort data=dt.new_fl_mapiv;by varname grp_var;run;
data iv1;
   set dt.new_fl_mapiv;by varname grp_var;
   if last.varname and iv>=0.018;
   put varname;
run;

data newwoe;
   set dt.new_fl_woetab;
   keep user_sid target w_:;
 run;

proc sql;
  create table test2 as
  select a.*,b.*
  from test as a
  left join newwoe as b on a.user_sid=b.user_sid;
quit;


%macro xx();
data _null_;
    set iv1 end=last;
	call symputx('name'||left(_n_),varname);
	if last then call symputx('n',_n_);
run;
%do i=1 %to &n.;
%let varname=&&name&i.;
proc sort data=test2 out=dt.wds_&varname.(keep=&varname. w_&varname.) nodupkey;by &varname.;run;
%end;
%mend;
%xx();

proc freq data=dt.data4;table cus_sex*target;run;




/*连续变量分箱*/

proc contents data=dt.data_train1 out=cnt(keep=name type) noprint;run;

filename lx catalog 'work.t1.lx.source';
data cnt2;
   set cnt end=last;
   where type=1;
   file lx;
   if _n_=1 then put 'keep user_sid target';
   put name;
   if last then put ';';
run;

data dt.data_train1_lx;
  set dt.data_train1;
  %inc lx;
;run;



%inc "&dir_mac.\macro_分组方法.sas";
%inc "&dir_mac.\macro_检查分箱的稳定性.sas";


/*-----------------*/
%macro select_var_bywoe;
%do wi=1 %to 1;
 %do bi=7 %to 7;
proc printto log=".\变量分箱_&wi..txt" new;run;quit;
%calWoeIV_and_apply(inDS=dt.data_train1_lx,adj_num=0.1,
                           min_grpNum=0.05,
                           outDS=nan,
                           outMapSum=dt._05_per_new_lx_map_&wi._&bi.,outIVSum=dt._05_per_new_lx_iv_&wi._&bi.,max_group=&bi.,my_woe=&wi.);

proc printto;run;quit;

proc sql;
  create table dt._05_per_new_lx_mapiv_&wi._&bi. as
   select a.*,b.ll,b.ul
   from dt._05_per_new_lx_iv_&wi._&bi. a
   left join dt._05_per_new_lx_map_&wi._&bi. b
   on a.varname=b.varname and a.grp_var=b.bin;
quit;
%end;
%end;

%mend;

%select_var_bywoe;








proc sort data=dt._10_per_new_lx_mapiv_1_7;by varname grp_var;run;
data iv3;
   set dt._10_per_new_lx_mapiv_1_7;
   by varname grp_var;
   if last.varname and iv>=0.02;
run;
proc sort data=iv3;by descending iv;run;


proc sql;
   create table mapiv as
    select * from dt._10_per_new_lx_mapiv_1_7
	where varname in(select varname from iv3);
quit;

/*调整最小分组数*/
 proc sort data=dt._05_per_new_lx_mapiv_1_7;by varname grp_var;run;
data iv3;
   set dt._05_per_new_lx_mapiv_1_7;
   by varname grp_var;
   if last.varname and iv>=0.02;
run;
proc sort data=iv3;by descending iv;run;


proc sql;
   create table mapiv as
    select * from dt._05_per_new_lx_mapiv_1_7
	where varname in(select varname from iv3);
quit;


;
/*检验分箱稳定性*/


proc sql;
   create table test as
    select a.user_sid,a.target,a.W_f2552,b.month
	from alltab2 a
    left join dt.data_all_1 b on a.user_sid=b.id;
quit;

data test1;
   set test;
   where month='2018-02';
run;


data test1;
  set dt.data_test;
  if min_concate_cnt_5m<=17.5 then bin=1;
    else if min_concate_cnt_5m<=132.5 then bin=2;
	 else if min_concate_cnt_5m<=205.5 then bin=3;
	  else bin=4;
 run;

%let tab=dt.data3;
%let name=add_check;
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
   put woe;
run;
	


/*分月份检查变量分箱稳定性*/

/*data dt.data_bin_mon;*/
/*   set dt.data4;*/
/* run;*/

/*proc sql;*/
/*   create table data_bin_mon as*/
/*    select a.*,b.W_cus_sex,c.Account_time_ad,c.MAX_CON_MONTH,c.SUM_CON_MONTH,c.SUM_CON_MONTH_E,*/
/*	d.**/
/*	from dt.data4(drop=MAX_CON_MONTH SUM_CON_MONTH SUM_CON_MONTH_E) a*/
/*	left join dt.wds_cus_sex b on a.cus_sex=b.cus_sex*/
/*    left join dt.Account_time2 c on a.user_sid=c.user_sid*/
/*    left join dt.Mobile_base1 d on a.user_sid=d.user_sid;*/
/*quit;*/


proc sql;
    create table data_bin_mon_0 as 
	 select a.*,b.*
	 from dt.data4 a
	 left join dt.data_mg_1 b on a.user_sid=b.user_sid;
quit;

data data_bin_mon;
    set data_bin_mon_0;
	%inc null;
	%inc bin;
/*	蜜罐分箱*/
	%inc bin1;
	if cus_sex='男' then W_cus_sex=0.1115319691;
	   else W_cus_sex=-0.347728707;
	keep target user_sid w_: app_week ;
run;

proc sql;
   create table data_bin_mon as
    select a.*,b.*
	from data_bin_mon a
	left join dt.data_xgb_select b on a.user_sid=b.user_sid;
 quit;


   

data data_bin_1 data_bin_2 data_bin_3 ;
    set data_bin_mon;
	if app_week<=25 then output data_bin_1;
	   else if app_week<=27 then output data_bin_2;
	     else output data_bin_3;
	drop app_week app_mon;
run;





%macro supiv(tab,outtab);
data &outtab.;
   length var$32. iv iv1 maptotal pcttotal mod_woe p0 p0t p1 p1t woe 8.;
   stop;
run;

proc contents data=&tab. out=v_cnt(keep=name) noprint;run;
data _null_;
    set v_cnt end=last;
/*    where index(upcase(name),'W_');*/
/*	where index(name,'tree');*/
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
	   pcttotal=maptotal/sum(&p0.,&p1.);
	   p1t=p1/&p1.;
	   p0t=p0/&p0.;
	   woe=log(p1t/p0t);
	   iv1=(p1t-p0t)*woe;
	   iv+iv1;
	   var="&name.";
     rename  &name.=mod_woe;
	run;
 proc append base=&outtab. data=cc1 force;run;quit;

  %end;

  %mend;


%supiv(data_bin_1, valid1_iv);

%supiv(data_bin_2, valid2_iv);

%supiv(data_bin_3, valid3_iv);




proc sort data=valid1_iv;by var iv;run;
data valid1_iv1;
   set valid1_iv;
    by var iv;
	if last.var;
run;

proc sort data=valid2_iv;by var iv;run;
data valid2_iv1;
   set valid2_iv;
    by var iv;
	if last.var;
run;

proc sort data=valid3_iv;by var iv;run;
data valid3_iv1;
   set valid3_iv;
    by var iv;
	if last.var;
run;


data iv_all;
   set iv3 iv4(rename=(var=varname bin=grp_var)) iv5;
 run;




proc sql;
   create table sup_iv as
    select a.varname,a.iv ,b.iv as iv1,c.iv as iv2,d.iv as iv3
	from iv_all a
	left join Valid1_iv1 b on a.varname=substr(b.var,3) or a.varname=b.var
   left join Valid2_iv1 c on a.varname=substr(c.var,3) or a.varname=c.var
   left join Valid3_iv1 d on a.varname=substr(d.var,3) or a.varname=d.var
   order by iv desc
;quit;


data sup_iv;
   set sup_iv;
   div_1=abs(iv1-iv)/max(iv,iv1);
   div_2=abs(iv2-iv)/max(iv,iv2);
   div_3=abs(iv3-iv)/max(iv,iv3);
/*   div_4=(iv4-iv)/iv;*/
   max_div=max(of div:);
   min_iv=min(of iv1-iv3);
run;
proc sort data=sup_iv;by max_div;run;


data mapiv1;
   set dt._05_per_gbdt_mapiv_1_7;
   rename var=varname p0=cnt_0 p1=cnt_1;
   drop maptotal;
 run;

data mapiv2;
   set mapiv mapiv1 mapiv_mg;
 run;



proc sql;
   create table sup_mapiv as 
   select a.*
   ,b.p0 as p0_1,b.p1 as p1_1,b.pcttotal as pcttotal_1
   ,c.p0 as p0_2,c.p1 as p1_2,c.pcttotal as pcttotal_2
   ,d.p0 as p0_3,d.p1 as p1_3,d.pcttotal as pcttotal_3
 from mapiv2 a
 left join valid1_iv b on (compress(cats('W_',a.varname))=compress(b.var) or a.varname=b.var)and round(a.woe,1e-6)=round(b.mod_woe,1e-6)
 left join valid2_iv c on (compress(cats('W_',a.varname))=compress(c.var) or a.varname=b.var) and round(a.woe,1e-6)=round(c.mod_woe,1e-6)
  left join valid3_iv d on (compress(cats('W_',a.varname))=compress(d.var) or a.varname=b.var) and round(a.woe,1e-6)=round(d.mod_woe,1e-6)
;
 quit;


data sup_mapiv;
    set sup_mapiv;
   percent=sum(cnt_0,cnt_1)/11078;
run;
data sup_mapiv;
   set sup_mapiv;
   psi1=log(pcttotal_1/percent)*(pcttotal_1-percent);
   psi2=log(pcttotal_2/percent)*(pcttotal_2-percent);
   psi3=log(pcttotal_3/percent)*(pcttotal_3-percent);
run;
proc sql;
   create table sup_mapiv1 as
    select varname,sum(psi1) as psi1,sum(psi2) as psi2,sum(psi3) as psi3 
	from sup_mapiv
	group by 1
	having psi1<=0.1 and psi2<=0.1 and psi3<=0.1
	;
quit;

/*data t1;*/
/*  set sup_mapiv1;*/
/* if max(of psi1-psi3)>0.05;*/
/*run;*/



data sup_var;
   set sup_iv;
   where  iv3>=0.02 ;
   if index(varname,'tree') then var=varname;
       else var=cats("W_",varname);
   put var;
run;


proc sql;
   create table sup_var1 as
    select * from sup_var
	where compress(varname) in(select compress(varname) from sup_mapiv1);
quit;

filename kp1 catalog 'work.t1.kp_1.source';
data _null_;
   set  sup_var1 end=last;
   file kp1 ;
   if _n_=1 then put 'keep user_sid target';
   put var;
   if last then put ';';
run;



data _null_;
  set sup_var1;
  put var;
run;



proc sort data=sup_var;by descending iv;run;
