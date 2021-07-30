data swineflu;
	infile 'E:\Users\cxk190003\Downloads\SwineFlu2009.dat';
	input fcid 1-13 fccid 14-27 country $28-60 fcd yymmdd10. april 79-88 may 89-98 june 99-108 july 109-118 august 119-128 lrd 129-144 fddid 145-154 fdcid 155-168 cdf yymmdd10.;
	format fcd yymmdd10. cdf yymmdd10.;
run;

data swineflu2;
	infile 'E:\Users\cxk190003\Downloads\SwineFlu2009.dat';
	input fcid 1-13 fccid 14-27 county $28-60 fcd yymmdd10. april 79-88 may 89-98 june 99-108 july 109-118 august 119-128 lrd 129-144 fddid 145-154 fdcid 155-168 cdf yymmdd10.;
	format fcd yymmdd10. cdf yymmdd10.;
	label fcid = 'ID for sorting by first case date'
		  fccid = 'ID  for sorting by first case date within a continent'
		  country = 'Country'
		  fcd = 'Date of first case reported'
		  april = 'April'
		  may = 'May'
		  june = 'June'
		  july = 'July'
		  august = 'August'
		  lrd = 'Last reported cumulative number of cases reported'
		  fddid = 'ID for sorting by first death date'
		  fdcid = 'ID for sorting by first death date within a continent'
		  cdf = 'Date of first death';
run;
PROC PRINT data=swineflu2;
proc contents data=swineflu2;
title 'Contents of Swine Flu Dataset';
run;
data swineflu3;
	infile 'E:\Users\cxk190003\Downloads\SwineFlu2009.dat';
	input fcid 1-13 fccid 14-27 county $28-60 fcd yymmdd10. april 79-88 may 89-98 june 99-108 july 109-118 august 119-128 lrd 129-144 fddid 145-154 fdcid 155-168 cdf yymmdd10.;
	format fcd yymmdd10. cdf yymmdd10.;
run;PROC PRINT data=swineflu3;
title 'Contents of Swine Flu Dataset without Label';
run;
