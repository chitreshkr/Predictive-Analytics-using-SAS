LIBNAME HW5 'E:\Users\hxs190042\Desktop\Predictive\HomeWork 5';
ODS GRAPHICS ON;
/*
Question -1 :
) Use PROC SURVEYSELECT to sample the original data into training and testing data sets. Use 75% for
training and 25% for testing. Use the seed= option to set random seed to a value of 23.
*/

data crackers;
set HW5.crackers;
run;

proc surveyselect data=HW5.crackers out=crackers_sampled outall samprate=0.75 seed=23;
run;
* Split data into training vs. test set;
data crackers_training crackers_test;
 set crackers_sampled;
 if selected then output crackers_training; 
 else output crackers_test;
run;

proc print data = crackers_test;
title 'Testing Dataset';
run;



/* Question 2

General utility model is explained in report */


/* Question 3 

Is the data formatted as needed to estimate the above multinomial logit model using PROC LOGISTIC?
If not, how should the data be formatted? Reformat the data as necessary.*/


data Cracker_train_format (keep = selected obs brand_feature brand_display brand_name brand_price brand_choice);
set crackers_training;
array name[4] $ ('Private' 'Sunshine' 'Keebler' 'Nabisco');
array price[4] priceprivate pricesunshine pricekeebler pricenabisco;
array feature[4] featprivate featsunshine featkeebler featnabisco;
array display[4] displprivate displsunshine displkeebler displnabisco;
array choice[4] private sunshine keebler nabisco;
do i = 1 to 4;
brand_name = name[i];
brand_price = price[i];
brand_feature = feature[i];
brand_display = display[i];
brand_choice = choice[i];
output;
end;
run;

PROC print data=Cracker_train_format;
title 'Formatted training data';
run;


/* Question 4
Estimate the logit model on the training sample using PROC LOGISTIC and report the estimation results (model parameters, significance).*/

proc logistic data = Cracker_train_format;
strata obs ;
class brand_name (ref = 'Private') / param=glm;
model brand_choice (event='1') = brand_name brand_price brand_name*brand_feature brand_name*brand_display / clodds=wald orpvalue;
run;


/* Question 5 
Reproduce your results using multinomial discrete choice command PROC MDC */

proc mdc data = Cracker_train_format;
title 'Multinomial Discrete choice command MDC';
id OBS;
class brand_name;
model brand_choice = brand_name brand_price brand_name*brand_feature brand_name*brand_display / type = clogit nchoice = 4;
restrict brand_nameprivate =0;
run;


/* Question 6
Use PROC MDC to predict the choice probabilities for the test sample using the estimated model.
*/

/* Formatting test data*/
data crackers_format(keep = selected obs brand_feature brand_display brand_name brand_price brand_choice);
set crackers_sampled;
array name[4] $ ('Private' 'Sunshine' 'Keebler' 'Nabisco');
array price[4] priceprivate pricesunshine pricekeebler pricenabisco;
array feature[4] featprivate featsunshine featkeebler featnabisco;
array display[4] displprivate displsunshine displkeebler displnabisco;
array choice[4] private sunshine keebler nabisco;
do i = 1 to 4;
brand_name = name[i];
brand_price = price[i];
brand_feature = feature[i];
brand_display = display[i];
brand_choice = choice[i];
output;
end;
run;
data crackers_prob;
set crackers_format;
if selected=0 then brand_choice=.;
run;
proc mdc data = crackers_prob;
id obs;
class brand_name;
model brand_choice = brand_name brand_price brand_name*brand_feature brand_name*brand_display / type = mprobit nchoice = 4;
restrict brand_nameprivate=0;
output out = probdata pred = prob;
run;
 


proc sql;
create table temp_a as select obs, selected, brand_name as predicted_choice, prob from probdata group by obs having prob = max(prob);
create table temp_b as select obs, brand_name as actual_choice from crackers_format group by obs having brand_choice=1;
create table crackers_pred as select temp_a.*, temp_b.obs,temp_b.actual_choice from temp_a inner join temp_b on temp_a.obs = temp_b.obs;
quit;

proc print data = crackers_pred;
title'predicted';
run;

proc freq data = crackers_pred;
tables actual_choice * predicted_choice;
run;

