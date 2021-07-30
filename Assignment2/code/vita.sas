LIBNAME ClasData 'Class Data';


/* Create a working dataset so that we don't accidently alter the original data */
data vita;
 set ClasData.vite;
run; 


ODS RTF FILE='VitaContent.rtf';
/* View content of the original data */
proc contents data=vita;
   title  'The Contents of the grade Data Set';
run;
ODS RTF CLOSE; 


proc transpose data=vita out=vitawide prefix=plaque;
  by id treatment;
  id visit ;
  var plaque;
run;


ODS RTF FILE='VitaWide.rtf';
proc print data=Work.vitawide;
run;
ODS RTF CLOSE; 

proc contents data=vitawide;
   title  'The Contents of the grade Data Set';
run;


/* c */ 
data noplacebo;
   set Work.vitawide;
   if Treatment = 1 then output noplacebo;
;

proc print data=noplacebo;
   title "Data Set with Treatment";
;

proc sort data=noplacebo; 
by treatment ;
run;
/* Paired Sample T-Tests */

ODS RTF FILE='Ttests without control group.rtf';
proc ttest data=noplacebo; 	*two-sided test as default;
 paired plaque0*plaque2;  *paired;
 by treatment;
run;
ODS RTF CLOSE; 



/*Question D*/
proc sort data=vitawide; 
by treatment ;
run;


ODS RTF FILE='Ttests with control group.rtf';
/* Paired Sample T-Tests */

proc ttest data=vitawide; 	*two-sided test as default;
 paired plaque0*plaque2;  *paired;
 by treatment;
run;
ODS RTF CLOSE; 





/*Question F*/
proc sort data=vita; 
by alcohol ;
run;


ODS RTF FILE='Ttests Alcohol.rtf';
/*  T-Tests */
proc ttest data=vita;
 class treatment;
 var plaque;
 by alcohol;
run;

ODS RTF CLOSE; 



proc sort data=vita; 
by smoke ;
run;


ODS RTF FILE='Ttests Smoke.rtf';
/*  T-Tests */

proc ttest data=vita;
 class treatment;
 var plaque;
 by smoke;
run;
ODS RTF CLOSE; 


