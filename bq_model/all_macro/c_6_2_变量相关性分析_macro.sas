/*--------------------------------*/
/*��������Է���            */
/*Created by : yaoyan             */
/*Created at : 2015-08-11         */
/*Updated by :                    */
/*Updated at :                    */
/*--------------------------------*/

/*������������*/
/*Ƥ��ɭ���ϵ��*/
proc corr data=&inDS pearson nopirnt outp=&outp;
	var ;
run;
/*˹Ƥ����*/
proc corr data=&inDS spearman nopirnt outs=&outs;
	var ;
run;

/*�����������*/
/*Ƥ��ɭ����ͳ����*/
/*��Ȼ��*/
/*P_PCHI��P_LRCHI*/
proc freq data=&inDS noprint;
	table &var1.*&var2./ chisq ;
	output out=&statout chisq ;
run;quit;

/*���ʱ�*/
/*�������������������2*2��*/
/*_RROR_��L_RROR��U_RROR*/
proc freq data=&inDS noprint;
	table &var1.*&var2./ measures ;
	output out=&statout measures ;
run;quit;

/*F����*/
/*�����������������*/
/*fԽ��������Խ�󣬹�����Խǿ*/
/*pֵ����x��y֮���޹����Եĸ���*/
