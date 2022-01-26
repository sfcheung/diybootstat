* Encoding: UTF-8.

********* Open the Data File  ****************.

get file "H:/temp/3iv_regression.sav".
dataset name source_data window = front.

********* Analysis on the Data File  ****************.

regression
 /statistics default change
 /dependent dv
 /method = enter iv1
 /method = enter iv2 iv3.

********* Generate the Bootstrap Samples  ****************.

generate nonpar bootsamples b = 5000
 /options outfile = "H:/temp/3iv_regression_bootsamples.sav" seed = 53243.

* Optional.
dataset close source_data.

********* Do the Analysis for the Bootstrap Samples  ****************.
********* Statistic: R-square Change ****************.

* Get the bootstrap samples.

get file "H:/temp/3iv_regression_bootsamples.sav".
dataset name boot_samples window = front.

* Start analyzing the bootstrap samples.

split file by boot_id.
oms
 /destination viewer = no.
oms /select tables
 /if commands = ["Regression"] subtypes = ["Model Summary"]
 /destination format = sav outfile = "H:/temp/model_summary_with_change.sav"
 /columns dimnames = ["Model" "Statistics"].
regression
 /statistics default change
 /dependent dv
 /method = enter iv1
 /method = enter iv2 iv3.
omsend.
split file off.

* Optional.
dataset close boot_samples.

********* Form the Bootstrap Confidence Intervals  ****************.

get file = "H:/temp/model_summary_with_change.sav".
dataset name model_summary window = front.

examine
  variables = @2_RSquareChange
 /plot histogram npplot
 /percentiles(2.5, 97.5)
 /statistics descriptives.


