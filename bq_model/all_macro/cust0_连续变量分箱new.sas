if dd1_pos <=1.16 then WOE_dd1_pos =-0.403120447 ;                                                                                                                     
else if dd1_pos <=6.09 then WOE_dd1_pos =0.6076670227 ;                                                                                                                
else WOE_dd1_pos =1.6795093468 ;                                                                                                                                       
if dd2_pos <=-0.7 then WOE_dd2_pos =0.1816062018 ;                                                                                                                     
else if dd2_pos <=1.1 then WOE_dd2_pos =-0.522115453 ;                                                                                                                 
else if dd2_pos <=4.1 then WOE_dd2_pos =0.4563956044 ;                                                                                                                 
else WOE_dd2_pos =1.4598059016 ;                                                                                                                                       
if dd3_pos <=-0.7 then WOE_dd3_pos =0.1313679862 ;                                                                                                                     
else if dd3_pos <=2.3 then WOE_dd3_pos =-0.590066846 ;                                                                                                                 
else WOE_dd3_pos =0.8256667045 ;                                                                                                                                       
if dd4_pos <=-0.7 then WOE_dd4_pos =0.0718407055 ;                                                                                                                     
else if dd4_pos <=2.3 then WOE_dd4_pos =-0.662353452 ;                                                                                                                 
else WOE_dd4_pos =0.7787116429 ;                    
if pos_dd_fail_cnt <=0.11 then WOE_pos_dd_fail_cnt =-0.770162064 ;                                                                                                     
else if pos_dd_fail_cnt <=1.22 then WOE_pos_dd_fail_cnt =-0.318428072 ;                                                                                                
else if pos_dd_fail_cnt <=3.07 then WOE_pos_dd_fail_cnt =0.1675829628 ;                                                                                                
else if pos_dd_fail_cnt <=5.29 then WOE_pos_dd_fail_cnt =0.8558200736 ;                                                                                                
else WOE_pos_dd_fail_cnt =1.8588301591 ;
if pos_finished_periods_cnt <=1.02 then WOE_pos_finished_periods_cnt =0.331294713 ;                                                                                    
else if pos_finished_periods_cnt <=2.04 then WOE_pos_finished_periods_cnt =0.0460647004 ;                                                                              
else if pos_finished_periods_cnt <=3.06 then WOE_pos_finished_periods_cnt =-0.079107905 ;                                                                              
else if pos_finished_periods_cnt <=4.02 then WOE_pos_finished_periods_cnt =-0.172615898 ;                                                                              
else WOE_pos_finished_periods_cnt =-0.4997121 ;
if pos_in_time_pay_cnt <=1.02 then WOE_pos_in_time_pay_cnt =0.5694159946 ;                                                                                             
else if pos_in_time_pay_cnt <=2.04 then WOE_pos_in_time_pay_cnt =0.0186264825 ;                                                                                        
else if pos_in_time_pay_cnt <=3.06 then WOE_pos_in_time_pay_cnt =-0.314764611 ;                                                                                        
else if pos_in_time_pay_cnt <=4.02 then WOE_pos_in_time_pay_cnt =-0.627041899 ;                                                                                        
else WOE_pos_in_time_pay_cnt =-0.946985923 ;                                                                                                                           
if pos_on_time_pay_cnt <=0.06 then WOE_pos_on_time_pay_cnt =1.3316415147 ;                                                                                             
else if pos_on_time_pay_cnt <=1.02 then WOE_pos_on_time_pay_cnt =0.0860583596 ;                                                                                        
else if pos_on_time_pay_cnt <=2.04 then WOE_pos_on_time_pay_cnt =-0.287918712 ;                                                                                        
else if pos_on_time_pay_cnt <=3.06 then WOE_pos_on_time_pay_cnt =-0.689942247 ;                                                                                        
else if pos_on_time_pay_cnt <=4.02 then WOE_pos_on_time_pay_cnt =-0.955463695 ;                                                                                        
else WOE_pos_on_time_pay_cnt =-1.268511325 ;                                                                                                                           
if pos_period_cnt <=9.08 then WOE_pos_period_cnt =-0.525888009 ;                                                                                                       
else if pos_period_cnt <=10.04 then WOE_pos_period_cnt =-0.355034538 ;                                                                                                 
else if pos_period_cnt <=12.12 then WOE_pos_period_cnt =0.0924162272 ;                                                                                                 
else WOE_pos_period_cnt =0.4302015196 ;   
if pos_total_delay_day_cnt <=2.28 then WOE_pos_total_delay_day_cnt =-0.443666297 ;                                                                                     
else if pos_total_delay_day_cnt <=5.7 then WOE_pos_total_delay_day_cnt =0.0408515946 ;                                                                                 
else if pos_total_delay_day_cnt <=9.12 then WOE_pos_total_delay_day_cnt =0.4121792158 ;                                                                                
else if pos_total_delay_day_cnt <=15.96 then WOE_pos_total_delay_day_cnt =0.764907409 ;                                                                                
else WOE_pos_total_delay_day_cnt =1.451679962 ; 

if sa_p_r1pd30_pos <=0 then WOE_sa_p_r1pd30_pos =-0.12976376 ;                                                                                                         
else if sa_p_r1pd30_pos <=0.0290322581 then WOE_sa_p_r1pd30_pos =-0.165983852 ;                                                                                        
else WOE_sa_p_r1pd30_pos =0.1587050914 ; 
if pos_due_periods_ratio <=0.0833 then WOE_pos_due_periods_ratio =0.3032584864 ;                                                                                       
else if pos_due_periods_ratio <=0.1333 then WOE_pos_due_periods_ratio =0.0898518674 ;                                                                                  
else if pos_due_periods_ratio <=0.1667 then WOE_pos_due_periods_ratio =0.1417859407 ;                                                                                  
else if pos_due_periods_ratio <=0.3 then WOE_pos_due_periods_ratio =-0.028658993 ;                                                                                     
else if pos_due_periods_ratio <=0.4 then WOE_pos_due_periods_ratio =-0.168142636 ;                                                                                     
else if pos_due_periods_ratio <=0.4444 then WOE_pos_due_periods_ratio =-0.168555653 ;                                                                                  
else WOE_pos_due_periods_ratio =-0.697411579 ; 


if round(max_hist_cpd_pos ,1e-6)<=0.5 then woe_max_hist_cpd_pos =-0.790370044 ;                                                                                                      
else if round(max_hist_cpd_pos ,1e-6)<=1.5 then woe_max_hist_cpd_pos =-0.590598887 ;                                                                                                 
else if round(max_hist_cpd_pos ,1e-6)<=4.5 then woe_max_hist_cpd_pos =0.0611556803 ;                                                                                                 
else if round(max_hist_cpd_pos ,1e-6)<=8.5 then woe_max_hist_cpd_pos =0.4991519312 ;                                                                                                 
else woe_max_hist_cpd_pos =1.7634222721 ;
if round(pos_cur_banlance ,1e-6)<=1330.880005 then woe_pos_cur_banlance =-0.287880592 ;                                                                                              
else if round(pos_cur_banlance ,1e-6)<=1437.600098 then woe_pos_cur_banlance =-0.479356553 ;                                                                                         
else if round(pos_cur_banlance ,1e-6)<=2069.475098 then woe_pos_cur_banlance =-0.114324569 ;                                                                                         
else if round(pos_cur_banlance ,1e-6)<=3697.680176 then woe_pos_cur_banlance =0.0462755255 ;                                                                                         
else if round(pos_cur_banlance ,1e-6)<=4130.174805 then woe_pos_cur_banlance =0.3529206608 ;                                                                                         
else woe_pos_cur_banlance =0.6791901881 ; 
if round(pos_dd_fail_ratio ,1e-6)<=0.118056 then woe_pos_dd_fail_ratio =-0.770168281 ;                                                                                               
else if round(pos_dd_fail_ratio ,1e-6)<=0.345238 then woe_pos_dd_fail_ratio =-0.38495062 ;                                                                                          
else if round(pos_dd_fail_ratio ,1e-6)<=0.449495 then woe_pos_dd_fail_ratio =0.101938997 ;                                                                                          
else if round(pos_dd_fail_ratio ,1e-6)<=0.559028 then woe_pos_dd_fail_ratio =0.4235377967 ;                                                                                          
else if round(pos_dd_fail_ratio ,1e-6)<=0.721111 then woe_pos_dd_fail_ratio =0.9683767792 ;                                                                                          
else woe_pos_dd_fail_ratio =1.9792980494 ;
if round(pos_sales_commission ,1e-6)<=1.65 then woe_pos_sales_commission =-0.681632319 ;                                                                                             
else if round(pos_sales_commission ,1e-6)<=1.9 then woe_pos_sales_commission =-0.358204077 ;                                                                                         
else if round(pos_sales_commission ,1e-6)<=2.35 then woe_pos_sales_commission =-0.148317556 ;                                                                                        
else if round(pos_sales_commission ,1e-6)<=2.75 then woe_pos_sales_commission =0.1268443242 ;                                                                                        
else if round(pos_sales_commission ,1e-6)<=4.15 then woe_pos_sales_commission =0.3218751327 ;                                                                                        
else woe_pos_sales_commission =0.3968474822 ;  
if round(sa_p_r2pd30_pos ,1e-6)<=-0.5 then woe_sa_p_r2pd30_pos =0.1906704966 ;                                                                                                       
else if round(sa_p_r2pd30_pos ,1e-6)<=0.019404 then woe_sa_p_r2pd30_pos =-0.162769658 ;                                                                                              
else if round(sa_p_r2pd30_pos ,1e-6)<=0.034001 then woe_sa_p_r2pd30_pos =0.0078006444 ;                                                                                              
else if round(sa_p_r2pd30_pos ,1e-6)<=0.043937 then woe_sa_p_r2pd30_pos =0.1326481742 ;                                                                                              
else if round(sa_p_r2pd30_pos ,1e-6)<=0.056936 then woe_sa_p_r2pd30_pos =0.2195609232 ;                                                                                              
else woe_sa_p_r2pd30_pos =0.4256355373 ;
if round(sa_pos_appr_rate_pos ,1e-6)<=0.00735 then woe_sa_pos_appr_rate_pos =0.372918772 ;                                                                                          
else if round(sa_pos_appr_rate_pos ,1e-6)<=0.00905 then woe_sa_pos_appr_rate_pos =0.3140853096 ;                                                                                     
else if round(sa_pos_appr_rate_pos ,1e-6)<=0.01325 then woe_sa_pos_appr_rate_pos =0.1712383199 ;                                                                                     
else if round(sa_pos_appr_rate_pos ,1e-6)<=0.01685 then woe_sa_pos_appr_rate_pos =0.0553998059 ;                                                                                     
else if round(sa_pos_appr_rate_pos ,1e-6)<=0.02335 then woe_sa_pos_appr_rate_pos =-0.022698852 ;                                                                                     
else if round(sa_pos_appr_rate_pos ,1e-6)<=0.02995 then woe_sa_pos_appr_rate_pos =-0.083774642 ;                                                                                     
else woe_sa_pos_appr_rate_pos =-0.198412682 ;   
