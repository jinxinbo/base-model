data DT.all_sup_data    ;
 infile 'E:\商城白名单申请评分\all_sup_data.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
informat app_no $24.;
informat create_time $24.;
informat status $24.;
informat white_level $24.;
informat cust_id $24.;
informat loan_date $24.;
informat contract_no $24.;
informat app_no_ind $24.;
informat cus_sex $24.;
informat education $24.;
informat marital_status $24.;
informat app_no_br_apply $24.;
informat app_no_br_score $24.;
informat app_no_td_decision $24.;
informat td_decision $24.;
informat serialno $24.;
informat app_no_tx $24.;
informat app_no_tz $24.;
informat business_id2 $24.;
informat business_id3 $24.;
informat business_id4 $24.;
informat var_out_91 $24.;
informat var_out_92 $24.;
informat var_out_93 $24.;
informat var_out_94 $24.;
informat var_out_95 $24.;
informat var_out_96 $24.;
informat var_out_97 $24.;
informat var_out_98 $24.;
informat var_out_99 $24.;
informat var_out_100 $24.;
informat var_out_101 $24.;
informat var_out_102 $24.;
informat var_out_103 $24.;
informat var_out_104 $24.;
informat var_out_105 $24.;
informat var_out_106 $24.;
informat var_out_107 $24.;
informat var_out_108 $24.;
informat var_out_109 $24.;
informat var_out_110 $24.;
informat var_out_111 $24.;
informat var_out_112 $24.;
informat var_out_113 $24.;
informat var_out_114 $24.;
informat var_out_115 $24.;
informat var_out_116 $24.;
informat var_out_117 $24.;
informat var_out_118 $24.;
informat var_out_119 $24.;
informat var_out_120 $24.;
informat var_out_121 $24.;
informat var_out_122 $24.;
informat var_out_123 $24.;
informat var_out_124 $24.;
informat var_out_125 $24.;
informat var_out_126 $24.;
informat var_out_127 $24.;
informat var_out_128 $24.;
informat var_out_129 $24.;
informat var_out_130 $24.;
informat var_out_131 $24.;
informat var_out_132 $24.;
informat var_out_133 $24.;
informat var_out_134 $24.;
informat var_out_135 $24.;
informat var_out_136 $24.;
informat var_out_137 $24.;
informat var_out_138 $24.;
informat var_out_139 $24.;
informat var_out_140 $24.;
informat var_out_141 $24.;
informat var_out_142 $24.;
informat var_out_143 $24.;
informat var_out_144 $24.;
informat var_out_145 $24.;
informat var_out_146 $24.;
informat var_out_147 $24.;
informat var_out_148 $24.;
informat var_out_149 $24.;
informat var_out_150 $24.;
informat var_out_151 $24.;
informat var_out_152 $24.;
informat var_out_153 $24.;
informat var_out_154 $24.;
informat var_out_155 $24.;
informat var_out_156 $24.;
informat var_out_157 $24.;
informat var_out_158 $24.;
informat var_out_159 $24.;
informat var_out_160 $24.;
informat app_no_rh $24.;
informat reasoncode_dt $24.;
informat reasonlist_fraud $24.;
 input 
app_no	$
create_time $
status	$
white_level	$
cust_id	$
contract_no	$
loan_date	$
agr_fpd30	
def_fpd30	
rn	
app_no_ind	$
cus_sex	$
cus_age	
education	$
marital_status	$
app_no_br_apply	$
fst_id_bank_inteday	
fst_id_nbank_inteday	
fst_cell_bank_inteday	
fst_cell_nbank_inteday	
lst_id_bank_inteday	
lst_id_bank_consnum	
lst_id_bank_csinteday	
lst_id_nbank_inteday	
lst_id_nbank_consnum	
lst_id_nbank_csinteday	
lst_cell_bank_inteday	
lst_cell_bank_consnum	
lst_cell_bank_csinteday	
lst_cell_nbank_inteday	
lst_cell_nbank_consnum	
lst_cell_nbank_csinte	
d7_id_bank_selfnum	
d7_id_bank_allnum	
d7_id_bank_orgnum	
d7_id_nbank_selfnum	
d7_id_nbank_allnum	
d7_id_nbank_orgnum	
d7_id_nbank_p2p_allnum	
d7_id_nbank_mc_allnum	
d7_id_nbank_ca_allnum	
d7_id_nbank_cf_allnum	
d7_id_nbank_com_allnum	
d7_id_nbank_oth_allnum	
d7_id_nbank_p2p_orgnum	
d7_id_nbank_mc_orgnum	
d7_id_nbank_ca_orgnum	
d7_id_nbank_cf_orgnum	
d7_id_nbank_com_orgnum	
d7_id_nbank_oth_orgnum	
d7_cell_bank_selfnum	
d7_cell_bank_allnum	
d7_cell_bank_orgnum	
d7_cell_nbank_selfnum	
d7_cell_nbank_allnum	
d7_cell_nbank_orgnum	
d7_cell_nbak_p2p_allnum	
d7_cell_nbank_mc_allnum	
d7_cell_nbank_ca_allnum	
d7_cell_nbank_cf_allnum	
d7_cell_nbak_com_allnum	
d7_cell_nbak_oth_allnum	
d7_cell_nbak_p2p_orgnum	
d7_cell_nbank_mc_orgnum	
d7_cell_nbank_ca_orgnum	
d7_cell_nbank_cf_orgnum	
d7_cell_nbak_com_orgnum	
d7_cell_nbak_oth_orgnum	
d15_id_bank_selfnum	
d15_id_bank_allnum	
d15_id_bank_orgnum	
d15_id_nbank_selfnum	
d15_id_nbank_allnum	
d15_id_nbank_orgnum	
d15_id_nbank_p2p_allnum	
d15_id_nbank_mc_allnum	
d15_id_nbank_ca_allnum	
d15_id_nbank_cf_allnum	
d15_id_nbank_com_allnum	
d15_id_nbank_oth_allnum	
d15_id_nbank_p2p_orgnum	
d15_id_nbank_mc_orgnum	
d15_id_nbank_ca_orgnum	
d15_id_nbank_cf_orgnum	
d15_id_nbank_com_orgnum	
d15_id_nbank_oth_orgnum	
d15_cell_bank_selfnum	
d15_cell_bank_allnum	
d15_cell_bank_orgnum	
d15_cell_nbank_selfnum	
d15_cell_nbank_allnum	
d15_cell_nbank_orgnum	
d15_cell_nbk_p2p_allnum	
d15_cell_nbak_mc_allnum	
d15_cell_nbak_ca_allnum	
d15_cell_nbak_cf_allnum	
d15_cell_nbk_com_allnum	
d15_cell_nbk_oth_allnum	
d15_cell_nbk_p2p_orgnum	
d15_cell_nbak_mc_orgnum	
d15_cell_nbak_ca_orgnum	
d15_cell_nbak_cf_orgnum	
d15_cell_nbk_com_orgnum	
d15_cell_nbk_oth_orgnum	
m1_id_bank_selfnum	
m1_id_bank_allnum	
m1_id_bank_orgnum	
m1_id_nbank_selfnum	
m1_id_nbank_allnum	
m1_id_nbank_orgnum	
m1_id_nbank_p2p_allnum	
m1_id_nbank_mc_allnum	
m1_id_nbank_ca_allnum	
m1_id_nbank_cf_allnum	
m1_id_nbank_com_allnum	
m1_id_nbank_oth_allnum	
m1_id_nbank_p2p_orgnum	
m1_id_nbank_mc_orgnum	
m1_id_nbank_ca_orgnum	
m1_id_nbank_cf_orgnum	
m1_id_nbank_com_orgnum	
m1_id_nbank_oth_orgnum	
m1_cell_bank_selfnum	
m1_cell_bank_allnum	
m1_cell_bank_orgnum	
m1_cell_nbank_selfnum	
m1_cell_nbank_allnum	
m1_cell_nbank_orgnum	
m1_cell_nbak_p2p_allnum	
m1_cell_nbank_mc_allnum	
m1_cell_nbank_ca_allnum	
m1_cell_nbank_cf_allnum	
m1_cell_nbak_com_allnum	
m1_cell_nbak_oth_allnum	
m1_cell_nbak_p2p_orgnum	
m1_cell_nbank_mc_orgnum	
m1_cell_nbank_ca_orgnum	
m1_cell_nbank_cf_orgnum	
m1_cell_nbak_com_orgnum	
m1_cell_nbak_oth_orgnum	
m3_id_bank_selfnum	
m3_id_bank_allnum	
m3_id_bank_orgnum	
m3_id_nbank_selfnum	
m3_id_nbank_allnum	
m3_id_nbank_orgnum	
m3_id_nbank_p2p_allnum	
m3_id_nbank_mc_allnum	
m3_id_nbank_ca_allnum	
m3_id_nbank_cf_allnum	
m3_id_nbank_com_allnum	
m3_id_nbank_oth_allnum	
m3_id_nbank_p2p_orgnum	
m3_id_nbank_mc_orgnum	
m3_id_nbank_ca_orgnum	
m3_id_nbank_cf_orgnum	
m3_id_nbank_com_orgnum	
m3_id_nbank_oth_orgnum	
m3_cell_bank_selfnum	
m3_cell_bank_allnum	
m3_cell_bank_orgnum	
m3_cell_nbank_selfnum	
m3_cell_nbank_allnum	
m3_cell_nbank_orgnum	
m3_cell_nbak_p2p_allnum	
m3_cell_nbank_mc_allnum	
m3_cell_nbank_ca_allnum	
m3_cell_nbank_cf_allnum	
m3_cell_nbak_com_allnum	
m3_cell_nbak_oth_allnum	
m3_cell_nbak_p2p_orgnum	
m3_cell_nbank_mc_orgnum	
m3_cell_nbank_ca_orgnum	
m3_cell_nbank_cf_orgnum	
m3_cell_nbak_com_orgnum	
m3_cell_nbak_oth_orgnum	
m6_id_bank_selfnum	
m6_id_bank_allnum	
m6_id_bank_orgnum	
m6_id_nbank_selfnum	
m6_id_nbank_allnum	
m6_id_nbank_orgnum	
m6_id_nbank_p2p_allnum	
m6_id_nbank_mc_allnum	
m6_id_nbank_ca_allnum	
m6_id_nbank_cf_allnum	
m6_id_nbank_com_allnum	
m6_id_nbank_oth_allnum	
m6_id_nbank_p2p_orgnum	
m6_id_nbank_mc_orgnum	
m6_id_nbank_ca_orgnum	
m6_id_nbank_cf_orgnum	
m6_id_nbank_com_orgnum	
m6_id_nbank_oth_orgnum	
m6_cell_bank_selfnum	
m6_cell_bank_allnum	
m6_cell_bank_orgnum	
m6_cell_nbank_selfnum	
m6_cell_nbank_allnum	
m6_cell_nbank_orgnum	
m6_cell_nbak_p2p_allnum	
m6_cell_nbank_mc_allnum	
m6_cell_nbank_ca_allnum	
m6_cell_nbank_cf_allnum	
m6_cell_nbak_com_allnum	
m6_cell_nbak_oth_allnum	
m6_cell_nbak_p2p_orgnum	
m6_cell_nbank_mc_orgnum	
m6_cell_nbank_ca_orgnum	
m6_cell_nbank_cf_orgnum	
m6_cell_nbak_com_orgnum	
m6_cell_nbak_oth_orgnum	
m12_id_bank_selfnum	
m12_id_bank_allnum	
m12_id_bank_orgnum	
m12_id_nbank_selfnum	
m12_id_nbank_allnum	
m12_id_nbank_orgnum	
m12_id_nbank_p2p_allnum	
m12_id_nbank_mc_allnum	
m12_id_nbank_ca_allnum	
m12_id_nbank_cf_allnum	
m12_id_nbank_com_allnum	
m12_id_nbank_oth_allnum	
m12_id_nbank_p2p_orgnum	
m12_id_nbank_mc_orgnum	
m12_id_nbank_ca_orgnum	
m12_id_nbank_cf_orgnum	
m12_id_nbank_com_orgnum	
m12_id_nbank_oth_orgnum	
m12_cell_bank_selfnum	
m12_cell_bank_allnum	
m12_cell_bank_orgnum	
m12_cell_nbank_selfnum	
m12_cell_nbank_allnum	
m12_cell_nbank_orgnum	
m12_cell_nbk_p2p_allnum	
m12_cell_nbak_mc_allnum	
m12_cell_nbak_ca_allnum	
m12_cell_nbak_cf_allnum	
m12_cell_nbk_com_allnum	
m12_cell_nbk_oth_allnum	
m12_cell_nbk_p2p_orgnum	
m12_cell_nbak_mc_orgnum	
m12_cell_nbak_ca_orgnum	
m12_cell_nbak_cf_orgnum	
m12_cell_nbk_com_orgnum	
m12_cell_nbk_oth_orgnum	
m3_id_tot_mons	
m3_id_avg_monnum	
m3_id_max_monnum	
m3_id_min_monnum	
m3_id_max_inteday	
m3_id_min_inteday	
m3_id_bank_tot_mons	
m3_id_bank_avg_monnum	
m3_id_bank_max_monnum	
m3_id_bank_min_monnum	
m3_id_bank_max_inteday	
m3_id_bank_min_inteday	
m3_id_nbank_tot_mons	
m3_id_nbank_avg_monnum	
m3_id_nbank_max_monnum	
m3_id_nbank_min_monnum	
m3_id_nbank_max_inteday	
m3_id_nbank_min_inteday	
m3_cell_tot_mons	
m3_cell_avg_monnum	
m3_cell_max_monnum	
m3_cell_min_monnum	
m3_cell_max_inteday	
m3_cell_min_inteday	
m3_cell_bank_tot_mons	
m3_cell_bank_avg_monnum	
m3_cell_bank_max_monnum	
m3_cell_bank_min_monnum	
m3_cell_bak_max_inteday	
m3_cell_bak_min_inteday	
m3_cell_nbank_tot_mons	
m3_cell_nbak_avg_monnum	
m3_cell_nbak_max_monnum	
m3_cell_nbak_min_monnum	
m3_cell_nbk_max_inteday	
m3_cell_nbk_min_inteday	
m6_id_tot_mons	
m6_id_avg_monnum	
m6_id_max_monnum	
m6_id_min_monnum	
m6_id_max_inteday	
m6_id_min_inteday	
m6_id_bank_tot_mons	
m6_id_bank_avg_monnum	
m6_id_bank_max_monnum	
m6_id_bank_min_monnum	
m6_id_bank_max_inteday	
m6_id_bank_min_inteday	
m6_id_nbank_tot_mons	
m6_id_nbank_avg_monnum	
m6_id_nbank_max_monnum	
m6_id_nbank_min_monnum	
m6_id_nbank_max_inteday	
m6_id_nbank_min_inteday	
m6_cell_tot_mons	
m6_cell_avg_monnum	
m6_cell_max_monnum	
m6_cell_min_monnum	
m6_cell_max_inteday	
m6_cell_min_inteday	
m6_cell_bank_tot_mons	
m6_cell_bank_avg_monnum	
m6_cell_bank_max_monnum	
m6_cell_bank_min_monnum	
m6_cell_bnk_max_inteday	
m6_cell_bak_min_inteday	
m6_cell_nbank_tot_mons	
m6_cell_nbak_avg_monnum	
m6_cell_nbak_max_monnum	
m6_cell_nbak_min_monnum	
m6_cell_nbk_max_inteday	
m6_cell_nbk_min_inteday	
m12_id_tot_mons	
m12_id_avg_monnum	
m12_id_max_monnum	
m12_id_min_monnum	
m12_id_max_inteday	
m12_id_min_inteday	
m12_id_bank_tot_mons	
m12_id_bank_avg_monnum	
m12_id_bank_max_monnum	
m12_id_bank_min_monnum	
m12_id_bank_max_inteday	
m12_id_bank_min_inteday	
m12_id_nbank_tot_mons	
m12_id_nbank_avg_monnum	
m12_id_nbank_max_monnum	
m12_id_nbank_min_monnum	
m12_id_nbak_max_inteday	
m12_id_nbak_min_inteday	
m12_cell_tot_mons	
m12_cell_avg_monnum	
m12_cell_max_monnum	
m12_cell_min_monnum	
m12_cell_max_inteday	
m12_cell_min_inteday	
m12_cell_bank_tot_mons	
m12_cell_bak_avg_monnum	
m12_cell_bak_max_monnum	
m12_cell_bak_min_monnum	
m12_cell_bk_max_inteday	
m12_cell_bk_min_inteday	
m12_cell_nbank_tot_mons	
m12_cell_nbk_avg_monnum	
m12_cell_nbk_max_monnum	
m12_cell_nbk_min_monnum	
m12_cell_nbank_max_inte	
m12_cell_nbank_min_inte	
flag_applyloan_d	
ald_id_bank_selfnum	
ald_id_bank_allnum	
ald_id_bank_orgnum	
ald_id_nbank_selfnum	
ald_id_nbank_allnum	
ald_id_nbank_p2p_allnum	
ald_id_nbank_mc_allnum	
ald_id_nbk_ca_on_allnum	
ald_id_nbk_ca_off_allnu	
ald_id_nbk_cf_on_allnum	
ald_id_nbk_cf_off_allnu	
ald_id_nbank_com_allnum	
ald_id_nbank_oth_allnum	
ald_id_nbank_orgnum	
ald_id_nbank_p2p_orgnum	
ald_id_nbank_mc_orgnum	
ald_id_nbk_ca_on_orgnum	
ald_id_nbk_ca_off_orgnu	
ald_id_nbk_cf_on_orgnum	
ald_id_nbk_cf_off_orgnu	
ald_id_nbank_com_orgnum	
ald_id_nbank_oth_orgnum	
ald_cell_bank_selfnum	
ald_cell_bank_allnum	
ald_cell_bank_orgnum	
ald_cell_nbank_selfnum	
ald_cell_nbank_allnum	
ald_cell_nbk_p2p_allnum	
ald_cell_nbak_mc_allnum	
ald_cell_nbk_ca_on_alln	
ald_cell_nbk_ca_off_all	
ald_cell_nbk_cf_on_alln	
ald_cell_nbk_cf_off_all	
ald_cell_nbk_com_allnum	
ald_cell_nbk_oth_allnum	
ald_cell_nbank_orgnum	
ald_cell_nbk_p2p_orgnum	
ald_cell_nbak_mc_orgnum	
ald_cell_nbk_ca_on_orgn	
ald_cell_nbk_ca_off_org	
ald_cell_nbk_cf_on_orgn	
ald_cell_nbk_cf_off_org	
ald_cell_nbk_com_orgnum	
ald_cell_nbk_oth_orgnum	
app_no_br_score	$
scorecashon	
scorepettycashv1	
app_no_td_decision	$
td_decision	$
td_score	
serialno	$
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
app_no_tx	$
risk_score	
app_no_tz	$
business_id2	$
var_out_1	
var_out_2	
var_out_3	
var_out_4	
var_out_5	
var_out_6	
var_out_7	
var_out_8	
var_out_9	
var_out_10	
var_out_11	
var_out_12	
var_out_13	
var_out_14	
var_out_15	
var_out_16	
var_out_17	
var_out_18	
var_out_19	
var_out_20	
var_out_21	
var_out_22	
var_out_23	
var_out_24	
var_out_25	
var_out_26	
var_out_27	
var_out_28	
var_out_29	
var_out_30	
var_out_31	
var_out_32	
var_out_33	
var_out_34	
var_out_35	
var_out_36	
var_out_37	
var_out_38	
var_out_39	
var_out_40	
var_out_41	
var_out_42	
var_out_43	
var_out_44	
var_out_45	
business_id3	$
var_out_46	
var_out_47	
var_out_48	
var_out_49	
var_out_50	
var_out_51	
var_out_52	
var_out_53	
var_out_54	
var_out_55	
var_out_56	
var_out_57	
var_out_58	
var_out_59	
var_out_60	
var_out_61	
var_out_62	
var_out_63	
var_out_64	
var_out_65	
var_out_66	
var_out_67	
var_out_68	
var_out_69	
var_out_70	
var_out_71	
var_out_72	
var_out_73	
var_out_74	
var_out_75	
var_out_76	
var_out_77	
var_out_78	
var_out_79	
var_out_80	
var_out_81	
var_out_82	
var_out_83	
var_out_84	
var_out_85	
var_out_86	
var_out_87	
var_out_88	
var_out_89	
var_out_90	
business_id4	$
var_out_91	$
var_out_92	$
var_out_93	$
var_out_94	$
var_out_95	$
var_out_96	$
var_out_97	$
var_out_98	$
var_out_99	$
var_out_100	$
var_out_101	$
var_out_102	$
var_out_103	$
var_out_104	$
var_out_105	$
var_out_106	$
var_out_107	$
var_out_108	$
var_out_109	$
var_out_110	$
var_out_111	$
var_out_112	$
var_out_113	$
var_out_114	$
var_out_115	$
var_out_116	$
var_out_117	$
var_out_118	$
var_out_119	$
var_out_120	$
var_out_121	$
var_out_122	$
var_out_123	$
var_out_124	$
var_out_125	$
var_out_126	$
var_out_127	$
var_out_128	$
var_out_129	$
var_out_130	$
var_out_131	$
var_out_132	$
var_out_133	$
var_out_134	$
var_out_135	$
var_out_136	$
var_out_137	$
var_out_138	$
var_out_139	$
var_out_140	$
var_out_141	$
var_out_142	$
var_out_143	$
var_out_144	$
var_out_145	$
var_out_146	$
var_out_147	$
var_out_148	$
var_out_149	$
var_out_150	$
var_out_151	$
var_out_152	$
var_out_153	$
var_out_154	$
var_out_155	$
var_out_156	$
var_out_157	$
var_out_158	$
var_out_159	$
var_out_160	$
score_l	
score_s	
app_no_rh	$
multiscore	
reasoncode_dt	$
rh_fraud_score	
reasonlist_fraud	$
creditscore	
literacylevel	
ishit	
crtinstalllevel	
lminstalllevel	
lmuninstalllevel	
lm3installlevel	
lm3uninstalllevel	
lm6installlevel	
lm6uninstalllevel	
crtuninstalllevel	
;run;


data dt.all_sup_data1;
   set dt.all_sup_data;
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
data dt.all_sup_data1;
set dt.all_sup_data1;
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


data dt.all_sup_data1;
   set dt.all_sup_data1;
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


/*对所有数据保留6位小数*/
data dt.all_sup_data1;
  set dt.all_sup_data1;
  array ar _numeric_;
  do over ar;
    ar=round(ar,1e-6);
  end;
run;

proc sql;
    create table dt.all_sup_data2 as
	 select a.*,b.*
	 from dt.all_sup_data1 a
	 left join dt.data_mg b on a.app_no=b.app_no;
quit;

proc contents data=data_bin_mon_0 out=cnt(keep=name) noprint;run;

filename kp2 catalog 'work.t1.kp_2.source';
data _null_;
   set  cnt end=last;
   file kp2 ;
   if _n_=1 then put 'keep app_no';
   put name;
   if last then put ';';
run;

data dt.all_sup_data3;
   set dt.all_sup_data2;
   %inc  kp2;
   rename app_no=user_sid;
run;



proc sql;
    create table dt.all_sup_tree1 as
	 select a.*,substr(b.create_time,1,7) as app_date
	 from dt.all_sup_tree a
	 left join dt.all_sup_data b on a.user_sid=b.app_no;
  quit;

data data1 data2 data3 data4;
   set dt.all_sup_tree1;
   %inc vd;
    fraud_p=tmp/(1+tmp);
   %inc pt;
   if app_date='2019-06' then output data1;
     else if app_date='2019-07' then output data2;
     else if app_date='2019-08' then output data3;
     else  output data4;
  drop app_date  tmp;
run;




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

%wdx(data1,wdx_1);

%wdx(data2,wdx_2);

%wdx(data3,wdx_3);

%wdx(data4,wdx_4);

proc sql;
    create table wdx_all as
    select a.*,
       b1.count as count_1,b1.percent as percent_1,
       b2.count as count_2,b2.percent as percent_2,
       b3.count as count_3,b3.percent as percent_3,
       b4.count as count_4,b4.percent as percent_4,
       c.target as coef
	from wdx_train a
	left join wdx_1 b1 on a.var=b1.var and round(a.woe,1e-5)=round(b1.woe,1e-5)
	left join wdx_2 b2 on a.var=b2.var and round(a.woe,1e-5)=round(b2.woe,1e-5)
	left join wdx_3 b3 on a.var=b3.var and round(a.woe,1e-5)=round(b3.woe,1e-5)
	left join wdx_4 b4 on a.var=b4.var and round(a.woe,1e-5)=round(b4.woe,1e-5)
	left join inmod1 c on a.var=c._NAME_;
quit;

data wdx_all;
   set wdx_all;
   psi1=log(percent_1/percent)*(percent_1-percent)/100;
   psi2=log(percent_2/percent)*(percent_2-percent)/100;
   psi3=log(percent_3/percent)*(percent_3-percent)/100;
   psi4=log(percent_4/percent)*(percent_4-percent)/100;
run;
proc sql;
   create table wdx_all1 as
    select var,abs(sum(psi1)) as psi_1,abs(sum(psi2)) as psi_2
                  ,abs(sum(psi3)) as psi_3,abs(sum(psi4)) as psi_4
	from wdx_all
	group by 1
    ;
quit;


proc freq data=data1 noprint ;table rk/out=aa;run; 

proc freq data=data4 noprint ;table rk/out=xx;run; 

proc sql;
   create table xx1 as
     select a.*,b.PERCENT as PERCENT1
	 from aa a
	 left join xx b on a.rk=b.rk;
quit;
data xx1;
   set xx1;
   psi=(PERCENT-PERCENT1)*log(PERCENT/PERCENT1)/100;
run;

proc sql;
   select sum(psi) from xx1;
quit;

