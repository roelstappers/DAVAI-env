### Organisation of an experiment

The `davai-new_xp` command-line prepares a "testing experiment"
directory, named uniquely after an incremental number, the platform and
the user.

This testing experiment will consist in:

-   `conf/davai_nrv.ini` : config file, containing parameters such as
    the git reference to test, davai options, historisations of input
    resources to use, tunings of tests (e.g. the input obs files to take
    into account) and profiles of jobs

-   `conf/<USECASE>.yaml` : contains an ordered and categorised list of
    jobs to be ran in the requested usecase.

-   `conf/sources.yaml` : information about the sources to be tested, in
    terms of Git or bundle

-   `tasks/` : templates of single tasks and jobs

-   links to the python packages that are used by the scripts (`vortex`,
    `epygram`, `ial_build`, `ial_expertise`)

-   a `logs` directory/link will appear after the first execution,
    containing log files of each job.

-   `DAVAI-tests` : a clone of the DAVAI-tests repository, checkedout on
    the requested version of the tests, on which point the `tasks/` and
    `conf/`

