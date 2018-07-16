%macro poidist(loopnum);
/* Declare local variables */
/*
SS = Sample Size 
lam{i} is the estimated rate per month
*/
%let ss = 360;
%let lam1 =  2*(1-ranuni(0) );
%let lam2 =  2 *(1-ranuni(0) );
%let lam3 = 2*(1-ranuni(0) );
%let lam4 = 2*(1-ranuni(0) );
%let lam5 = 2*(1-ranuni(0) );
%let lam6 = 2*(1-ranuni(0) );
%let lam7 = 2*(1-ranuni(0) );
%let lam8 = 2*(1-ranuni(0) );
%let lam9 = 2*(1-ranuni(0) );
%let lam10 = 2*(1-ranuni(0) );

%do j=1 %to &loopnum;
data sim;
lam1 = &lam1/30.4375; /* rate converted to daily */
lam2 = &lam2/30.4375;
lam3 = &lam3/30.4375;
lam4 = &lam4/30.4375;
lam5 = &lam5/30.4375;
lam6 = &lam6/30.4375;
lam7 = &lam7/30.4375;
lam8 = &lam8/30.4375;
lam9 = &lam9/30.4375;
lam10 = &lam10/30.4375;
ss = &ss;
n=0;
t=0;
do until(n>=SS);
   t1 = ranpoi(0,lam1);
   t2 = ranpoi(0,lam2);
   t3 = ranpoi(0,lam3);
   t4 = ranpoi(0,lam4);
   t5 = ranpoi(0,lam5);
   t6 = ranpoi(0,lam6);
   t7 = ranpoi(0,lam7);
   t8 = ranpoi(0,lam8);
   t9 = ranpoi(0,lam9);
   t10 = ranpoi(0,lam10);
   if t < 0 then t1 = 0; *first to start , 1 in first month;
   if t < 90 then t2 = 0;
   if t < 90 then t3 = 0;
   if t < 150 then t4 = 0; 
   if t < 150 then t5 = 0;
   if t < 150 then t6 = 0;
   if t < 180 then t7 = 0;
   if t < 180 then t8 = 0;
   if t < 240 then t9 = 0;
   if t < 240 then t10 = 0;
   tempt = t1 + t2+t3+t4+t5+t6+t7+t8+t9+t10;
   if t>=6 then do;
   if ceil((t-6)/7) = 0 or ceil((t-7)/7) = 0 then tempt=0;
   end;
   n = n + tempt;
   t = t + 1;
   end; /* ends the do until loop */
   months = t/30.4375;
   nmonth =ceil(months);
   label nmonth='Months Rounded Up'
         months='Number of Months';
run;
data output;
 set output sim;
 if months = . then delete;
run;
%end;
%mend poidist;
dm "output" clear; dm "log" clear;
/* erases the dataset */
data output;
run;
options nonotes nostimer;
%poidist(500);

proc capability data=output;
   var nmonth months;
  * histogram;
run;
title'';
