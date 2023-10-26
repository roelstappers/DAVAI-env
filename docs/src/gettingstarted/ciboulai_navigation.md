## [Navigation in *Ciboulaï*](@id ciboulai)


- On the [main page](http://intra.cnrm.meteo.fr/gws/davai), the numbers in the columns to the right indicate the numbers of jobs which results are respectively:
  - bit-reproducible or within acceptable numerical error;
  - numerically different;
  - jobs that have crashed before end;
  - the experts were not able to state on the test results, to be checked manually;
  - these tests have no expected result to be checked: they are assumed OK since they did not crash.

- When you get to an experiment page, you can find a few key features of the experiment, in the header. The `[+]` close to the XPID (experiment ID) will provide more. The others `[+]` to the left of the *`uenv`*'s provide inner details from each one.  The summary of tests results is also visible on the top right.

- Each task is summarized: its Pending/Crashed/Ended status, and in case of Ended, the comparison status. As a first glance, a main metric is shown, assumed to be the most meaningful for this test.

- The `‘drHook rel diff’` and `‘rss rel diff’` columns show the relative difference in respectively: the elapse time of the execution, and the memory consumption (RSS) compared to the reference. 

  !!! warning 
      So far the drHook figures have proven to be too volatile from an execution to another, to be meaningful. Don't pay too much attention, for now. Similarly, the RSS figures remain to be investigated (relevance and availability).

-   A filter is available to show only a subset of tasks.

-   When you click on the `[+]` of the *`more`* column, the detailed
    expertise is displayed:

    -   the *`itself`* tab will show info from each Expert about the
        task independently from reference

    -   the *`continuity`* tab will show the compared results from each
        Expert against the same task from *reference* experiment

    -   the *`consistency`* tab will show the compared results from each
        Expert against a different *reference* task from the same
        experiment, when meaningful (very few cases, so far)

    Click on each Expert to unroll results.

-   At the experiment level as well as at the task level, a little pen
    symbol enables you to annotate it. That might be used for instance
    to justify numerical differences.

