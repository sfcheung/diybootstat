* Encoding: UTF-8.

********* Open the Data File  ****************.

get file "H:/gbootdat/examples/scale_items.sav".
dataset name source_data window = front.

********* Analysis on the Data File  ****************.

reliability
  /variables item1 to item10
  /scale('All items') all
  /model = alpha.

********* Generate the Bootstrap Samples  ****************.

generate nonpar bootsamples b = 5000
 /options outfile = "H:/temp/scale_items_bootsamples.sav" seed = 53243.

* Optional.
dataset close source_data.

********* Do the Analysis for the Bootstrap Samples  ****************.
********* Statistic: Cronbach's alpha  ****************.

* Get the bootstrap samples.

get file "H:/temp/scale_items_bootsamples.sav".
dataset name boot_samples window = front.

* Start analyzing the bootstrap samples.

split file by boot_id.
oms
 /destination viewer = no.
oms /select tables
   /if commands = ["Reliability"] subtypes = ["Reliability Statistics"]
   /destination format = sav outfile = "H:/temp/reliability_statistics.sav"
   /columns dimnames = ["Statistics"].
reliability
  /variables item1 to item10
  /scale('All items') all
  /model = alpha.
omsend.
split file off.

* Optional.
dataset close boot_samples.

********* Form the Bootstrap Confidfence Intervals  ****************.

get file = "H:/temp/reliability_statistics.sav".
dataset name reliability_statistics window = front.

examine
  variables = CronbachsAlpha
 /plot histogram npplot
 /percentiles(2.5, 97.5)
 /statistics descriptives.
