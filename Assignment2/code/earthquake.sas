LIBNAME ClasData 'Class Data';

data Earthquake;
 set ClasData.earthquakes;
run; 

data top2state;
set Earthquake;
if state = 'California' OR state = 'Alaska'  then output top2state;

proc print data=top2state;
run;

proc sort data=Work.top2state;;
 by state;
run;


ODS RTF FILE='SummaryStatstop2states.rtf';
proc means data= Work.top2state n mean stddev min p25 median p75 max maxdec= 2;
 by State;
 var Magnitude ;
 title 'Summary Statistics of Top 2 States';
run;
ODS RTF CLOSE;


ODS RTF FILE='SummaryStats200211.rtf';
proc means data= Earthquake n mean stddev min p25 median p75 max maxdec= 2;
  where 2001< Year <2012;
  class year state;
  var Magnitude;
  title 'Summary Statistics from 2002 to 2011';
run;
ODS RTF CLOSE;

proc sort data=Work.Earthquake;;
 by Year;
run;
ODS RTF FILE='SeperateYrSummaryStats200211.rtf';
proc means data= Work.Earthquake n mean stddev min p25 median p75 max maxdec= 2;
 where 2001 < Year < 2012;
 by Year;
 class State;
 var Magnitude;
 title 'Separate Table Summary Statistics from 2002 to 2011';
run;
ODS RTF CLOSE;




/*Question D */
ODS RTF FILE='SummaryStats200211StateYr.rtf';
proc Tabulate data = Earthquake;
	class Year state;
	var Magnitude;
	Table Year*(Magnitude),state*(mean median stddev min max p25 p75);
	where Year >= 2002 AND Year <= 2011;
	title 'State wise Earthquake data for different years';
run;
ODS RTF CLOSE;

*Question e;


proc sort data= Work.Earthquake; 
 by state Year;
run;

proc means data= Work.Earthquake mean maxdec= 2 noprint;
 class year; 
 by state;
 var Magnitude;
 output out=means 
  		mean= AvgMagnitude;
run;

proc sgpanel  data= means;
 panelby State;
 series x=Year y=AvgMagnitude;
 title 'Earthquake Magnitude Yearly by States';
run;



*question F;
ODS RTF FILE='t-TEST tOP2 sTATES .rtf';
proc ttest data=top2state alpha = 0.05;
 class state; 
 var Magnitude; 
 run;
 ODS RTF CLOSE;


