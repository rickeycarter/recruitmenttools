%macro poidist(loopnum);
/* Declare local variables */
/*
SS = Sample Size 
lam{i} is the estimated rate per month
*/
%let ss = 360;

%let lam1 =  2; /* this could be changed to be a random normal otherwise adjusted */
%let lam2 =  2 ;
%let lam3 = 2;
%let lam4 = 2;
%let lam5 = 2;
%let lam6 = 2;
%let lam7 = 2;
%let lam8 = 2;
%let lam9 = 2;
%let lam10 = 2;

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

/* Random poisson values are generated with a random seed (0), if you want to make them reproducible
   change the zero to another value (it will still be random, but now will always 
   generate the same sequence)
*/

do until(n>=SS);
   t1 = ranpoi(0,lam1); *random number of participants per day for site 1;
   t2 = ranpoi(0,lam2);
   t3 = ranpoi(0,lam3);
   t4 = ranpoi(0,lam4);
   t5 = ranpoi(0,lam5);
   t6 = ranpoi(0,lam6);
   t7 = ranpoi(0,lam7);
   t8 = ranpoi(0,lam8);
   t9 = ranpoi(0,lam9);
   t10 = ranpoi(0,lam10);

   /* test if site is active. If not active, set number of participants on that day to 0*/
   if t < 0 then t1 = 0; *first to start , 1 in first month;
   if t < 90 then t2 = 0; * second site starts 90 days after 1st;
   if t < 90 then t3 = 0; * third site starts 90 days after 1st;
   if t < 150 then t4 = 0; *etc.;
   if t < 150 then t5 = 0;
   if t < 150 then t6 = 0;
   if t < 180 then t7 = 0;
   if t < 180 then t8 = 0;
   if t < 240 then t9 = 0;
   if t < 240 then t10 = 0;
   tempt = t1 + t2+t3+t4+t5+t6+t7+t8+t9+t10;
   if t>=6 then do; /* this do loop zeros the totals for weekends...could be removed*/
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

/* erases the dataset */
data output;
run;

%poidist(500);

proc capability data=output;
   var nmonth months;
  * histogram;
run;
title'';

/* After the simulation, you may want to output the "output" dataset to a permanent 
   data file
*/