* Encoding: UTF-8.

* These macros serve as examples to illustrate how simple macros for repetitive parts can 
* be used to simplify the syntax file for main analysis.

* End all OMS directives.
define !bomsend()
omsend.
split file off.
!enddefine.

* Get model summary (e.g., R-squares, R-square increases) in regression.
define !bregrsq(out = !tokens(1))
split file by boot_id.
oms
 /destination viewer = no.
oms
 /select tables
 /if commands = ["Regression"] subtypes = ["Model Summary"]
 /destination format = sav outfile = !out
 /columns dimnames = ["Model" "Statistics"].
!enddefine.

* Get regression coefficients in regression.
define !bregcoef(out = !tokens(1))
split file by boot_id.
oms
 /destination viewer = no.
oms
 /select tables
 /if commands = ["Regression"] subtypes = ["Coefficients"]
 /destination format = sav outfile =!out
 /columns dimnames = ["Variables" "Statistics"].
!enddefine.



