* Encoding: UTF-8.

********* Open the Data File  ****************.

get file "H:/temp/2iv_regression.sav".
dataset name source_data window = front.

********* Analysis on the Data File  ****************.

regression
 /dependent dv
 /method = enter iv1 iv2.

********* Generate the Bootstrap Samples  ****************.

generate nonpar bootsamples b = 5000
 /options outfile = "H:/temp/2iv_regression_bootsamples.sav" seed = 53243.

* Optional.
dataset close source_data.

********* Do the Analysis for the Bootstrap Samples  ****************.
********* Statistic: Adjusted R-square ****************.

* Get the bootstrap samples.

get file "H:/temp/2iv_regression_bootsamples.sav".
dataset name boot_samples window = front.

* Start analyzing the bootstrap samples.

split file by boot_id.
oms
 /destination viewer = no.
oms /select tables
 /if commands = ["Regression"] subtypes = ["Model Summary"]
 /destination format = sav outfile = "H:/temp/model_summary.sav"
 /columns dimnames = ["Model" "Statistics"].
regression
 /dependent dv
 /method = enter iv1 iv2.
omsend.
split file off.

* Optional.
dataset close boot_samples.

********* Form the Bootstrap Confidence Intervals  ****************.

get file = "H:/temp/model_summary.sav".
dataset name regression_coefficients window = front.

examine
  variables = @1_AdjustedRSquare
 /plot histogram npplot
 /percentiles(2.5, 97.5)
 /statistics descriptives.


