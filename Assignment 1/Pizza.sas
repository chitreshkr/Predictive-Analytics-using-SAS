
 /**********************************************************************
 *   PRODUCT:   SAS
 *   VERSION:   9.4
 *   CREATOR:   External File Interface
 *   DATE:      07SEP20
 *   DESC:      Generated SAS Datastep Code
 *   TEMPLATE SOURCE:  (None Specified.)
 ***********************************************************************/
    data WORK.PIZZA1    ;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'Pizza.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
       informat SurveyNum best32. ;
       informat Arugula best32. ;
       informat PineNut best32. ;
       informat Squash best32. ;
       informat Shrimp best32. ;
       informat Eggplant best32. ;
       format SurveyNum best32. ;
       format Arugula best32. ;
       format PineNut best32. ;
       format Squash best32. ;
       format Shrimp best32. ;
       format Eggplant best32. ;
    input
                SurveyNum
                Arugula
                PineNut
                Squash
                Shrimp  
                Eggplant  
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;
PROC PRINT data=Work.PIZZA1;
TITLE "Pizza dataset with correct datatype";
RUN;
PROC IMPORT OUT= WORK.pizza 
            DATAFILE= "Pizza.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
PROC PRINT data=Work.Pizza;
TITLE "Pizza dataset with incorrect datatype";
RUN;
Proc Means Data=Work.Pizza1 Mean;
Var Arugula PineNut Squash Shrimp Eggplant  ;
Run;
proc contents data=Work.PIZZA1;
title 'Contents of Pizza Dataset';
run;

