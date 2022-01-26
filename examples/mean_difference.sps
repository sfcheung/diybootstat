* Encoding: UTF-8.

********* Open the Data File  ****************.

get file "H:/temp/mean_difference.sav".
dataset name source_data window = front.

********* Analysis on the Data File  ****************.

t-test groups = gp(1 2)
 /variables = dv_gp.

********* Generate the Bootstrap Samples  ****************.

temporary.
select if gp = 1.
generate nonpar bootsamples b = 5000
 /options outfile = "H:/temp/mean_difference_gp1_bootsamples.sav" seed = 15324.

temporary.
select if gp = 2.
generate nonpar bootsamples b = 5000
 /options outfile = "H:/temp/mean_difference_gp2_bootsamples.sav" seed = 43143.

* Optional.
dataset close source_data.

add files
 /file = "H:/temp/mean_difference_gp1_bootsamples.sav"
 /file = "H:/temp/mean_difference_gp2_bootsamples.sav".
dataset name boot_samples window = front.
sort cases by boot_id.
save outfile "H:/temp/mean_difference_bootsamples.sav".
exe.

********* Do the Analysis for the Bootstrap Samples  ****************.
********* Statistic: Hedges's g  ****************.

* Get the bootstrap samples.
* Already openend by previous commands.

* Start analyzing the bootstrap samples.

split file by boot_id.
oms
 /destination viewer = no.
oms /select tables
   /if commands = ["T-Test"] subtypes = ["Independent Samples Test"]
   /destination format = sav outfile = "H:/temp/independent_samples_test.sav"
   /columns dimnames = ["Dependent Variables" "Assumptions" "Statistics"].
t-test groups = gp(1 2)
 /variables = dv_gp.
omsend.
split file off.

* Optional.
dataset close boot_samples.

********* Form the Bootstrap Confidfence Intervals  ****************.

get file = "H:/temp/independent_samples_test.sav".
compute cohend = dv_gp_Equalvariancesassumed_t * sqrt(1 / 50 + 1 / 50).
compute hedgesg = cohend * (1 - 3 / (4 * (50 + 50) - 9)).
execute.

examine
  variables = hedgesg
 /plot histogram npplot
 /percentiles(2.5, 97.5)
 /statistics descriptives.

