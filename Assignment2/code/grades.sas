LIBNAME ClasData 'Class Data';


/* Create a working dataset so that we don't accidently alter the original data */
data grade;
 set ClasData.study_gpa;
run; 

proc contents data=grade;
   title  'The Contents of the grade Data Set';
run;
proc sgplot data= grade;
 histogram AveTime / binstart = 0 binwidth = 5 ; 
 density AveTime; 						* Just Normal distribution;
 density AveTime / type = kernel;		* Kernel smoothing of histogram;
run;


proc sort data=Work.grade;;
 by Section;
run;

ODS RTF FILE='Correlation Causation.rtf';
proc corr data=Work.grade;
 var AveTime GPA Units;
 by Section;
run;
ODS RTF CLOSE; 
