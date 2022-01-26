* Encoding: UTF-8.

* If an analysis or a series of analysis needs to be conducted several times,
* as in forming the BCa confidence interval, it is convenient to 
* define a macro to do this analysis or series of analysis.
* This file provides sample macros for researchers to adapt them to their own
* situations or as templates for other scenarios.

******************** Sample Analysis Macros **************************.
* Requirements for the macro.
* - Must have no arguments (unless users are comfortable to do this).
*    - Exception: Can add a debug argument which by default will suppress output.
*       When debugging, we can disable suppressing output by this argument, as shown
*       below.
* - Work directly on the active dataset.
* - Does not do any filtering, selection, or split file.
* - After the macro finishes, the active dataset stores the computed statistics.
* - It does not have to save the active dataset. This is optional though recommended.
* - No need to specify the statistics. Only need to make sure that the statistics is
*     in the dataset.
* - For consistency, name the final dataset as macro_output and activate it, as shown
*     below.

******************** Regression Coefficients ***************************.

define !stat_reg_coeff(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.
oms /select tables
   /if commands = ["Regression"] subtypes = ["Coefficients"]
   /destination format = sav outfile = "H:/temp/regression_coefficients.sav"
   /columns dimnames = ["Variables" "Statistics"].
regression
 /dependent dv
 /method = enter iv1 iv2.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
omsend.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
get file = "H:/temp/regression_coefficients.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/2iv_regression.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!stat_reg_coeff debug = 1.


******************** Adjusted R-square ***************************.

define !stat_reg_adjrsq(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.
oms /select tables
 /if commands = ["Regression"] subtypes = ["Model Summary"]
 /destination format = sav outfile = "H:/temp/model_summary.sav"
 /columns dimnames = ["Model" "Statistics"].
regression
 /dependent dv
 /method = enter iv1 iv2.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
omsend.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
get file = "H:/temp/model_summary.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/2iv_regression.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!stat_reg_adjrsq debug = 1.


******************** Parallel Mediation ***************************.

define !stat_med_parallel(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.

/* ***** Regressing mediator1 on iv *****.
oms /select tables
   /if commands = ["Regression"] subtypes = ["Coefficients"]
   /destination format = sav outfile = "H:/temp/mediator1_on_iv.sav"
   /columns dimnames = ["Variables" "Statistics"]
   /tag = "med1_reg".
regression
 /dependent mediator1
 /method = enter iv.
omsend tag = ["med1_reg"]. /* End the OMS instruction above.
/* It is recommended to end the corresponding OMS immediately after each analysis.

/* ***** Regressing mediator2 on iv *****.
oms /select tables
   /if commands = ["Regression"] subtypes = ["Coefficients"]
   /destination format = sav outfile = "H:/temp/mediator2_on_iv.sav"
   /columns dimnames = ["Variables" "Statistics"]
   /tag = "med2_reg".
regression
 /dependent mediator2
 /method = enter iv.
omsend tag = ["med2_reg"]. /* End the OMS instruction above.

/* ***** Regressing dv on mediation1, mediator2, and iv *****.
oms /select tables
   /if commands = ["Regression"] subtypes = ["Coefficients"]
   /destination format = sav outfile = "H:/temp/dv_on_all.sav"
   /columns dimnames = ["Variables" "Statistics"]
   /tag = "dv_reg".
regression
 /dependent dv
 /method = enter mediator1 mediator2 iv.
omsend tag = ["dv_reg"]. /* End the OMS instruction above.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
/* This OMSEND also turns off suppressing results in the output file, if turned on.
omsend.

/* ***** Merge all the results *****.
/* Additional processing can be done here.
/* The files created by OMS above are not available until OMSEND is run.
match files
 /file = "H:/temp/mediator1_on_iv.sav"
 /rename = (iv_B = a1_B) (iv_Beta = a1_Beta)
 /file = "H:/temp/mediator2_on_iv.sav"
 /rename = (iv_B = a2_B) (iv_Beta = a2_Beta)
 /file = "H:/temp/dv_on_all.sav"
 /rename = (iv_B = c_B) (iv_Beta = c_Beta)
                  (mediator1_B = b1_B) (mediator1_Beta = b1_Beta)
                  (mediator2_B = b2_B) (mediator2_Beta = b2_Beta)
 /keep a1_B a1_Beta a2_B a2_Beta b1_B b1_Beta b2_B b2_Beta c_B c_Beta.
execute.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
save outfile = "H:/temp/parallel_mediation_combined_results.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/parallel_mediation.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!stat_med_parallel debug = 1.


******************** Mean Difference (Hedges's g) ***************************.

define !hedgessg(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.

/* Do the t test.
oms /select tables
   /if commands = ["T-Test"] subtypes = ["Independent Samples Test"]
   /destination format = sav outfile = "H:/temp/independent_samples_test.sav"
   /columns dimnames = ["Dependent Variables" "Assumptions" "Statistics"].
t-test groups = gp(1 2)
 /variables = dv_gp.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
/* This OMSEND also turns off suppressing results in the output file, if turned on.
omsend.

/* ***** Process the results *****.
/* Additional processing can be done here.
/* The files created by OMS above are not available until OMSEND is run.
get file = "H:/temp/independent_samples_test.sav".
compute cohensd = dv_gp_Equalvariancesassumed_t * sqrt(1 / 50 + 1 / 50).
compute hedgessg = cohensd * (1 - 3 / (4 * (50 + 50) - 9)).
execute.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
save outfile = "H:/temp/independent_samples_test.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/mean_difference.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!hedgessg debug = 1.


******************** ANOVA (omega-square) ***************************.

define !anova_omegasq(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.

/* Do the ANOVA.
oms /select tables
   /if commands = ["ONEWAY"] subtypes = ["ANOVA"]
   /destination format = sav outfile = "H:/temp/anova_results.sav"
   /columns dimnames = ["Dependent Variable" "Source" "Statistics"].
oneway dv_gp by gp.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
/* This OMSEND also turns off suppressing results in the output file, if turned on.
omsend.

/* ***** Process the results *****.
/* Additional processing can be done here.
/* The files created by OMS above are not available until OMSEND is run.
get file = "H:/temp/anova_results.sav".
compute omegasq = dv_gp_BetweenGroups_df * (dv_gp_BetweenGroups_MeanSquare - dv_gp_WithinGroups_MeanSquare)/
                                   (dv_gp_Total_SumofSquares - dv_gp_WithinGroups_MeanSquare).
execute.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
save outfile = "H:/temp/anova_results.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/anova.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!anova_omegasq debug = 1.


******************** Cronbach's Alpha ***************************.

define !alpha(debug = !default(0) !tokens(1))
!if (!debug !eq 0) !then
/* Suppressing printing the results in the output file is optional but is recommended.
oms /destination viewer = no.
!ifend.

/* The analysis to be conducted along with the corresponding OMS commands.

oms /select tables
   /if commands = ["Reliability"] subtypes = ["Reliability Statistics"]
   /destination format = sav outfile = "H:/temp/reliability_statistics.sav"
   /columns dimnames = ["Statistics"].
reliability
  /variables item1 to item10
  /scale('All items') all
  /model = alpha.

/* Must use OMSEND to tell SPSS to write the results above to the destination file.
/* This OMSEND also turns off suppressing results in the output file, if turned on.
omsend.

/* The following lines ensure that the output file is the active dataset 
/* when the macro finishes.
get file = "H:/temp/reliability_statistics.sav".
dataset name macro_output window = front.
dataset activate macro_output.
!enddefine.

* Test the macro to see whether it works on one dataset.
get file "H:/gbootdatext/examples/scale_items.sav".
dataset name source_data window = front.
* Check whether the active file is the one storing the statistics.
* Set debug to a non-zero number to show the results.
!alpha debug = 1.


