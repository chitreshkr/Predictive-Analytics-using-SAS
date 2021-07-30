
data Hotel;
	infile 'E:\Users\cxk190003\Downloads\Hotel.dat';
	input roomno 1-4 guest checkin_month checkin_day  checkin_year  checkout_month checkout_day checkout_year internet_use $ days_use roomtype $53-68 rate ;
	label roomno = 'room number'
		  guest = 'number of guests'
		  checkin_month = 'check-in month'
		  checkin_day = 'day'
		  checkin_year = 'year'
		  checkout_month = 'check-out month'
		  checkout_day = 'day out'
		  checkout_year = 'year out'
		  internet_use = 'use of wireless Internet service'
		  days_use = 'number of days of Internet use'
		  roomtype = 'room type'
		  rate = 'room rate';
run;

PROC PRINT data=Hotel;
run;
data hotel2;
  set Hotel;
  check_in_date = catx("/",checkin_month,checkin_day,checkin_year);
  check_out_date = catx("/",checkout_month,checkout_day,checkout_year);
  drop checkin_month checkin_day checkin_year checkout_month checkout_day checkout_year;
run;

data hotel3;
   set hotel2;
   checkin_date = input(check_in_date,anydtdte32.);
   *Date= INPUT(DateString, anydtdte32.);
   checkout_date = input(check_out_date,anydtdte32.);
   drop check_out_date check_in_date;
   format checkout_date mmddyy8. checkin_date mmddyy8. ;
run;

data hotel4;
   set hotel3;
   if  days_use=1 & guest=1 then
      do;
         subtotal = (rate*(checkout_date - checkin_date)) + 9.95;
      end;
	if  days_use=1 & guest>1 then
      do;
         subtotal = (rate*(checkout_date - checkin_date)) + 9.95 +  (10*(guest-1));
      end;
   else if days_use>1 & guest=1  then
      do;
         subtotal = rate*(checkout_date - checkin_date) + 9.95 + ((days_use-1)*4.95);
      end;
   else if  days_use>1 & guest>1 then
      do;
         subtotal = rate*(checkout_date - checkin_date) + 9.95 + ((days_use-1)*4.95) + (10*(guest-1));
       end;
    else if  missing(days_use) & guest=1 then
      do;
         subtotal = rate*(checkout_date - checkin_date) ;
       end;
   else if  missing(days_use) & guest>1 then
      do;
         subtotal = rate*(checkout_date - checkin_date) +(10*(guest-1));
       end;
run;

proc print data=hotel4;
   title 'HOTEL  Dataset with subtotal';
run;

data hotel5;
   set hotel4;
   retain total_value 0;
   total_value =  (subtotal * 0.0775) + subtotal;
   total_value = round(total_value,0.01);
run;
proc print data=hotel5 ;
   title 'HOTEL Dataset with total';
run;
