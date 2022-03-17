# diybootstat

This repository stores extension commands and examples for DIY bootstrapping in SPSS presented in the
following manuscript: 

Cheung, S. F., Pesigan, I. J. A., & Vong, W. N. (2022). DIY bootstrapping: Getting the nonparametric bootstrap confidence interval in SPSS for any statistics or function of statistics (when this bootstrapping is appropriate). *Behavior Research Methods*. [https://doi.org/10.3758/s13428-022-01808-5](https://doi.org/10.3758/s13428-022-01808-5)

Currently, only one command is available, `GENERATE NONPAR BOOTSAMPLES`, described below, for generating bootstrapping samples.

Our goal is not to develop a general tool for any particular statistics. Instead,
we want to demonstrate that, with the help of `OMS` commands, nonparametric bootstrapping
confidence intervals can be formed for any statistics we can see in the
output, or can be computed from those statistics. The extension command makes
the first step, drawing bootstrapping samples, easier to do. After this, bootstrapping
confidence intervals can be formed by using `SPLIT FILE`, `OMS` commands, and
`EXAMINE`. Please refer to the manuscript and online examples by others cited in
the manuscript.

## GENERATE NONPAR BOOTSAMPLES

This command is for generating nonparametric bootstrapping samples, to be used in
forming nonparametric bootstrapping confidence intervals as outlined in the manuscript.
A custom dialog is also avaiable for generating the command using the pull down menu.

### Downlaod and Install

The bundle ready for installation can be found in the folder [`extension_bundles`](https://github.com/sfcheung/diybootstat/tree/main/extension_bundles). The latest version is v1.1.2. Just download and install in SPSS (see the first 15 seconds of [this video](https://osf.io/95rhx/) on how to install it):

[GENERATE_NONPAR_BOOTSAMPLES.spe](https://github.com/sfcheung/diybootstat/blob/ff6672dc10675680f8401fcae9092a84289f28b6/extension_bundles/GENERATE_NONPAR_BOOTSAMPLES.spe)

### Syntax Command Example

An example on using this command in a syntax file can be found at the OSF page: https://osf.io/8pnjs/. See the manuscript for a detailed description of this example.

A vidoe demonstrating on this example can be found at the OSF page: https://osf.io/95rhx/

### Video Demonstration on Using the Custom Dialog

A vidoe demonstrating how to use the custom dialog for this command and how to generate the `OMS` commands can be found at the OSF page: https://osf.io/3bdmj/.

This video demonstrates how to generate the commands using nearly only the pull down menu. Users new to these commands or have never used `OMS` commands can learn about them in this video.

### Sample Macro Commands

The [`macros`](https://github.com/sfcheung/diybootstat/tree/main/macros) folder contains sample macro commands used to illustrate how researchers
can write their own macros for statistics for which they want to form the nonparametric
bootstrap percentile confidence intervals.

### Other Examples Presented in the Manuscript

The [`examples`](https://github.com/sfcheung/diybootstat/tree/main/examples) folder contains sample syntax files and data files presented in
the manuscript.


### Source

The source can be found in the folder [`GENERATE_NONPAR_BOOTSAMPLES`](https://github.com/sfcheung/diybootstat/tree/main/extension_commands/GENERATE_NONPAR_BOOTSAMPLES) in
[`extension_commands`](https://github.com/sfcheung/diybootstat/tree/main/extension_commands).

### Note

We can no longer access SPSS 26 and so cannot build and test the bundle for SPSS 26.
A version that we developed and tested in SPSS 26 can be found in the OSF page. Please
refer to https://osf.io/8wevk/.
