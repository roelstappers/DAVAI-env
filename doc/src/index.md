# DAVAÏ User Guide
A. Mary 

DAVAÏ embeds the whole workflow from the source code to the green/red
light validation status: fetching sources from Git, building
executables, running test cases, analysing the results and displaying
them on a dashboard.

For now, the only build system embedded is `gmkpack`, but we expect
other systems to be plugged when required. The second limitation of this
version is that the starting point is still an IAL[^1] Git reference
only. The next version of the DAVAÏ system will include
multi-projects/repositories fetching, using the *`bundle`* concept as
starting point.

The dimensioning of tests (grid sizes, number of observations,
parallelization\...) is done in order to conceal representativity and
execution speed. Therefore, in the general usecases, the tests are
supposed to run on HPC. A dedicated usecase will target smaller
configurations to run on workstation (not available yet).
An accessible source code forge is set within the ACCORD consortium to
host the IAL central repository on which updates and releases are
published, and where integration requests will be posted, reviewed and
monitored.

By the way: DAVAI stands for *"**D**evice **A**iming at the
**VA**lidation of **I**AL"*

[^1]: IAL = **I**FS-**A**rpege-**L**AM
