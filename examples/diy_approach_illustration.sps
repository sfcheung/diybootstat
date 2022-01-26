* Encoding: UTF-8.

********* Open the Data File  ****************.

get file "H:/gbootdat/examples/2iv_regression.sav".
dataset name source_data window = front.

********* Analysis on the Data File  ****************.

regression
 /dependent dv
 /method = enter iv1 iv2.

********* Generate the Bootstrap Samples  ****************.

generate nonpar bootsamples b = 5000
 /options outfile = "D:/temp/2iv_regression_bootsamples.sav" seed = 53243.

* Optional.
dataset close source_data.

********* Do the Analysis for the Bootstrap Samples  ****************.
********* Statistic: Standardized Regression Coefficients  ****************.

* Get the bootstrap samples.

get file "D:/temp/2iv_regression_bootsamples.sav".
dataset name boot_samples window = front.

* Start analyzing the bootstrap samples.

split file by boot_id.
oms
 /destination viewer = no.
oms /select tables
   /if commands = ["Regression"] subtypes = ["Coefficients"]
   /destination format = sav outfile = "D:/temp/regression_coefficients.sav"
   /columns dimnames = ["Variables" "Statistics"].
regression
 /dependent dv
 /method = enter iv1 iv2.
omsend.
split file off.

* Optional.
dataset close boot_samples.

********* Form the Bootstrap Confidence Intervals  ****************.

get file = "D:/temp/regression_coefficients.sav".
dataset name regression_coefficients window = front.

frequencies
  variables = iv1_Beta iv2_Beta
 /format notable
 /percentiles = 2.5 97.5.

examine
  variables = iv1_Beta iv2_Beta
 /plot histogram npplot
 /percentiles(2.5, 97.5)
 /statistics descriptives.


