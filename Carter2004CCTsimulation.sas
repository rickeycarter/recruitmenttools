/************************************************/
/* Example 2 SAS Code for Carter 2004 CCT       */
/************************************************/
data example2;
 do i = 1 to 5000;
     n=0;
     d=0;
     k = 2;
     do while (n<50);
        n=n+ranpoi(0, (k*.0328542));
        d=d+1;
        if d=7 then k=3;
          else if d=14 then k=4;
           else if d=28 then k=5;
     end;
     output;
  end;
run;

proc univariate data=example2;
 var d;
run;

/***********************************************/
/* Random Uniform Adjustment                   */
data model_randuni;
 do i = 1 to 5000;
     n=0;
     d=0;
     k = 2;
     do while (n<50);
	    rate = k*.0328542 * ranuni(0);
        n=n+ranpoi(0, rate);
        d=d+1;
        if d=7 then k=3;
          else if d=14 then k=4;
           else if d=28 then k=5;
     end;
     output;
  end;
run;

proc univariate data=model_randuni;
 var d;
run;


/***********************************************/
/* Unpublished example illustrating additional */
/* Model flexibility                           */
/* NIDA CTN Protocol 0026                      */
/* 10 site multicenter trial                   */
/*  Program written such that each individual  */
/*   site can have its own accrual rate and    */
/*   individual starting time                  */
/***********************************************/


%macro poidist(loopnum);
/* Declare local variables */
/*
SS = Sample Size 
lam{i} is the estimated rate per month
*/
%let ss = 360;
%let lam1 =  1.5 ;
%let lam2 =  1.5 ;
%let lam3 = 1.5;
%let lam4 = 1.5;
%let lam5 = 1.5;
%let lam6 = 1.5;
%let lam7 = 1.5;
%let lam8 = 1.5;
%let lam9 = 1.5;
%let lam10 = 1.5;

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
   if t < 0 then t1 = 0; *first to start , 1 in first month, 2 next, 2 next, 2 next;
   if t < 30 then t2 = 0;
   if t < 30 then t3 = 0;
   if t < 60 then t4 = 0; 
   if t < 60 then t5 = 0;
   if t < 90 then t6 = 0;
   if t < 90 then t7 = 0;
   if t < 120 then t8 = 0;
   if t < 120 then t9 = 0;
   if t < 120 then t10 = 0;
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

/* erases the dataset */
data output;
run;

%poidist(250);

proc capability data=output;
   var nmonth months;
  * histogram;
run;
title'';
