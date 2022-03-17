# diybootstat

Extension commands and examples for DIY bootstrapping in SPSS presented in the
following manuscript: 

Cheung, S. F., Pesigan, I. J. A., & Vong, W. N. (2022). DIY bootstrapping: Getting the nonparametric bootstrap confidence interval in SPSS for any statistics or function of statistics (when this bootstrapping is appropriate). *Behavior Research Methods*. [https://doi.org/10.3758/s13428-022-01808-5](https://doi.org/10.3758/s13428-022-01808-5)

Currently, only one command is available, `GENERATE NONPAR BOOTSAMPLES`.

Our goal is not to develop a general tool for any particular statistics. Instead,
we want to demonstrate that, with the help of OMS commands, nonparametric bootstrapping
confidence intervals can be formed for any statistics we can see in the
output, or can be computed from those statistics. The extension command makes
the first step, drawing bootstrapping samples, easier to do. After this, bootstrapping
confidence intervals can be formed by using `SPLIT FILE`, `OMS` commands, and
`EXAMINE`. Please refer to the manuscript and online examples by others cited in
the manuscript.

## GENERATE NONPAR BOOTSAMPLES

The source can be found in the folder `GENERATE_NONPAR_BOOTSAMPLES` in
`extension_commands`.

The bundle ready for installation can be found in the folder `extension_bundles`.

An example on using this command can be found at the OSF page: https://osf.io/95rhx/

An example on using the custom dialog for this command can be found at the OSF page: https://osf.io/95rhx/

We can no longer access SPSS 26 and so cannot build and test the bundle for SPSS 26.
A version that we developed and tested in SPSS 26 can be found in the OSF page. Please
refer to https://osf.io/8wevk/.

The `examples` folder contains sample syntax files and data files presented in
the manuscript.

The `macros` folder contains sample macro commands used to illustrate how researchers
can write their own macros for statistics for which they want to form the nonparametric
bootstrap percentile confidence intervals.