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

# Test an IAL development

## Create your branch, containing your modifications

To use DAVAÏ to test your contribution to the next development release,
you need to have your code in a Git branch starting from the latest
official release (e.g. `CY48T1` tag for contributions to 48T2, or `CY49`
tag for contributions to 49T1).

In the following the example is taken on a contribution to 48T2:

1.  In your repository (e.g. `~/repositories/arpifs` -- make sure it is clean with `git status` beforehand), create your branch:

    ```bash 
    git checkout -b <my_branch> [<starting_reference>]
    ```

    (e.g. `git checkout -b mary_CY48T1_cleaning CY48T1`)
    !!! note it is strongly recommended to have explicit branch names with regards to their origin and their owner, hence the legacy branch naming syntax `<user>_<CYCLE>_<purpose_of_the_branch>`

2.  Implement your developments in the branch.  *It is recommended to find a compromise between a whole development in only one commit, and a large number of very small commits (e.g.  one by changed file).* In case you then face compilation or runtime issues then, but only if you haven't pushed it yet, you can *amend*[^2] the latest commit to avoid a whole series of commits
    just for debugging purpose.
    !!! note 
        DAVAÏ is currently able to include non-committed changes in the compilation and testing. However, in the next version based on *bundle*, this might not be possible anymore.  

## Run tests

### Setup your experiment

1.  Create your experiment, specifying which version of the tests you
    want to use:

    ```
    davai-new_xp <my_branch> -v <tests_version>
    ```

    (e.g. `davai-new_xp mary_CY48T1_cleaning -v DV48T1`)
    $\hookrightarrow$ An experiment with a unique experiment ID is
    created and prompted as output of the command, together with its
    path.

    -   to know what is the version to be used for a given development: See [here](https://github.com/ACCORD-NWP/DAVAI-tests/wiki)`

    -   see `davai-new_xp -h` for more options on this command

    -   see
        Appendix [\[sect:tests\_versioning\]](#sect:tests_versioning){reference-type="ref"
        reference="sect:tests_versioning"} for a more comprehensive
        approach to tests versioning.

    -   if the version you are requesting is not known, you may need to
        specify the DAVAI-tests origin repository from which to
        clone/fetch it, using argument
        `–origin <URL of the remote DAVAI-tests.git>`

2.  $\hookrightarrow$ Go to the (prompted) experiment directory.\
    \
    If you want to set some options differently from the default, open
    file `conf/davai_nrv.ini` and tune the parameters in the `[DEFAULT]`
    section. The usual tunable parameters are detailed in
    Section [\[sect:options\]](#sect:options){reference-type="ref"
    reference="sect:options"}.

3.  Launch the build and tests:

    `davai-run_xp`

    After initializing the Ciboulaï page for the experiment, the command
    will first run the build of the branch and wait for the executables
    (that step may take a while, depending on the scope of your
    modifications, especially with several compilation flavours). Once
    build completed, it will then launch the tests (through scheduler on
    HPC).

### Monitor and inspect results

1.  Monitor the execution of the jobs with the scheduler (with SLURM:
    `squeue -u <user>`)

2.  Check the tests results summary on the *Ciboulaï* dashboard, which
    URL is prompted at the end of tests launch, or visible in the config
    file:

    -   open *Ciboulaï* dashboard in a web browser:
        (<https://www.umr-cnrm.fr/davai/>)

        -   To guide you in the navigation in *Ciboulaï*, cf.
            Section [\[sect:ciboulai\_navigation\]](#sect:ciboulai_navigation){reference-type="ref"
            reference="sect:ciboulai_navigation"}.

        -   To get the paths to a job output or abort directory: button
            `[+]` then ***Context***.

    -   if the dashboard is not accessible, a command-line version of
        the status is possible; in the XP directory, run:

        `davai-xp_status`

        to see the status summary of each job. The detailed status and
        expertise of tests are also available as json files on the
        Vortex cache:\
        `belenos:/scratch/mtool/<user>/cache/vortex/davai/<vconf>/<xpid>/summaries_stack/`\
        or

        `davai-xp_status -t <task>`

        $\Rightarrow$ To get the paths to a job output or abort
        directory: `davai-xp_status -t <task>` then open the `itself`
        file and look in the ***Context*** section.

### And then ? {#and-then .unnumbered}

-   If everything is OK (green) at the end of executions, your branch is
    validated !

-   If not, cf.
    Section [\[sect:options\]](#sect:options){reference-type="ref"
    reference="sect:options"} to re-compile a code modification and
    re-run tests.

### First tips

-   All Davai commands are prefixed `davai-*` and can be listed with
    `davai-help`. All commands are auto-documented with option `-h`.

-   If the **pack preparation or compilation fails**, for whatever
    reason, the build step prints an error message and the
    `davai-run_xp` command stops before running the tests. You can find
    the output of the pack preparation or compilation in `logs/`
    directory, as any other test log file.\
    A very common error is when the pack already exists; if you actually
    want to overwrite the contents of the pack (e.g. because you just
    fixed a code issue in the branch), you may need option
    `-e/–preexisting_pack`:

    `davai-run_xp -e`\
    or\
    `davai-build -e`

    Otherwise, if the pack preexists independantly for valid reasons,
    you will need to move/delete the existing pack, or rename your
    branch.

-   The tests are organised as ***tasks*** and ***jobs***:

    -   a ***task*** consists in fetching input resources, running an
        executable, analyzing its outputs to the Ciboulai dashboard and
        dispatching (archiving) them: *1 test = 1 task*

    -   a ***job*** consists in a sequential driver of one or several
        *task(s)*: either a flow sequence (i.e. outputs of task N is an
        input of task N+1) or family sequence (e.g. run independantly an
        IFS and an Arpege forecast)

-   To **fix a piece of code**, the best is to modify the code in your
    Git repo, then re-run

    `davai-run_xp -e` (or `davai-build -e` and then `davai-run_tests`).

    You don't necessarily need to commit the change rightaway, the
    non-committed changes are exported from Git to the pack. Don't
    forget to commit eventually though, before issuing pull request.

-   To **re-run one job only after re-compilation**, type\
    `davai-run_tests -l`\
    to list the jobs and then\
    `davai-run_tests <category.job>`\
    e.g.\
    `davai-run_tests forecasts.standalone_forecasts`

-   The syntax `category.job` indicates that the job to be run is the
    ***Driver*** in `./tasks/category/job.py`

-   To **re-run a single test** within a job, e.g. the IFS forecast in
    `forecasts/standalone_forecasts.py`: edit this file, comment the
    other `Family`(s) or `Task`(s) (*nodes*) therein, and re-run the job
    as indicated above.

-   **Eventually**, after code modifications and fixing particular
    tests, you should re-run **the whole set of tests**, to make sure
    your fix does not break any other test.

## Navigation in *Ciboulaï*

<http://intra.cnrm.meteo.fr/gws/davai>

-   On the main page, the numbers in the columns to the right indicate
    the numbers of jobs which results are respectively:

    -   : bit-reproducible or within acceptable numerical error;

    -   : numerically different;

    -   : jobs that have crashed before end;

    -   : the experts were not able to state on the test results, to be
        checked manually;

    -   : these tests have no expected result to be checked: they are
        assumed OK since they did not crash.

-   When you get to an experiment page, you can find a few key features
    of the experiment, in the header. The `[+]` close to the XPID
    (experiment ID) will provide more. The others `[+]` to the left of
    the *`uenv`*'s provide inner details from each one.\
    The summary of tests results is also visible on the top right.

-   Each task is summarized: its Pending/Crashed/Ended status, and in
    case of Ended, the comparison status. As a first glance, a main
    metric is shown, assumed to be the most meaningful for this test.

-   The `‘drHook rel diff’` and `‘rss rel diff’` columns show the
    relative difference in respectively: the elapse time of the
    execution, and the memory consumption (RSS) compared to the
    reference. ***However, so far the drHook figures have proven to be
    too volatile from an execution to another, to be meaningful. Don't
    pay too much attention, for now. Similarly, the RSS figures remain
    to be investigated (relevance and availability).***

-   A filter is available to show only a subset of tasks.

-   When you click on the `[+]` of the *`more`* column, the detailed
    expertise is displayed:

    -   the *`itself`* tab will show info from each Expert about the
        task independantly from reference

    -   the *`continuity`* tab will show the compared results from each
        Expert against the same task from *reference* experiment

    -   the *`consistency`* tab will show the compared results from each
        Expert against a different *reference* task from the same
        experiment, when meaningful (very few cases, so far)

    Click on each Expert to unroll results.

-   At the experiment level as well as at the task level, a little pen
    symbol enables you to annotate it. That might be used for instance
    to justify numerical differences.

## How it works, briefly

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

### Running jobs on HPC : `MTOOL`

On HPCs, the compute nodes are "expensive" and so we try as much as
possible to save the elapse time spent on compute nodes for actual
computations, i.e. execution of the executable. Therefore in DAVAÏ, the
generation of the scripts uses the `MTOOL` filter to replicate and cut a
job script into several ***steps***:

1.  on transfer nodes, fetch the resources, either locally on the file
    system(s) or using FTP connections to outer machines

2.  on compute nodes, execute the AlgoComponent(s)

3.  on transfer nodes, dispatch the produced output

4.  final step to clean the temporary environment created for the jobs

In addition to this separation and chaining these 4 steps, `MTOOL`
initially sets up a clean environment with a temporary unique execution
directory. It also collects log files of the script's execution, and in
the case of a failure (missing input resources, execution aborted), it
takes a screenshot of the execution directory. Therefore for each job,
one will find :

-   a ***depot*** directory in which to find the actual 4 scripts and
    their log files

-   an ***abort*** directory, in which to find the exact copy of the
    execution directory when the execution failed

These directories are registered by the DAVAÏ expertise and are
displayed in the ***Context*** item of the expertise for each task in
*Ciboulaï*.

### Jobs & tasks

A *Task* is generally understood as the triplet: (1) fetch input
resources, (2) run an executable, (3) dispatch the produced output. In a
Vortex script, the tasks are written in Python, using classes and
functionalities of the Vortex Python packages. In particular, running an
executable is wrapped in what is called an *AlgoComponent*. In DAVAÏ, we
add a second *AlgoComponent* right after the nominal one in (2) to
*"expertise"* the outputs and compare to a reference.

The tasks templates are stored in the `tasks/` directory, and all
inherit from the abstract class:\
`vortex.layout.nodes.Task`. A *Test* is a Task that includes an
expertise to a reference.\
A *Job* is understood as a series of one or several tasks, executed
sequentially within one "job submission" to a job scheduler.

The jobs templates are stored in the `tasks/` directory, and are defined
as a function `setup` that return a `Driver` object, which itself
contains a series of `Task`(s) and `Family`(ies).

In DAVAÏ, the idea is to have the tasks in independant jobs as far as
possible, except: for flow-dependant tasks, or for loops on clones of a
task with a varying parameter.

## More details

## (Re-)Build of executables

### Build with `gmkpack`

The tasks in the `build` job are respectively in charge of:

-   `gitref2pack` : fetch/pull the sources from the requested Git
    reference and set one or several incremental `gmkpack`'s pack(s) --
    depending on `compilation_flavours` as set in config. The packs are
    then populated with the set of modifications, from the latest
    official tag to the contents of your branch (including non-commited
    modifications).

-   `pack2bin` : compile sources and link necessary executables (i.e.
    those used in the tests), for each pack flavour.

In case the compilation fails, or if you need to (re-)modify the sources
for any reason (e.g. fix an issue):

1.  implement corrections in the branch (commited or not)

2.  re-run the build:\
    `davai-build -e`\
    (option `-e` or `–preexisting_pack` assumes the pack already
    preexists; this is a protection against accidental overwrite of an
    existing pack. The option can also be passed to `davai-run_xp`)

3.  and then if build successful `davai-run_tests`

### Build with \[cmake/makeup/ecbuild\...\]

Not implemented yet.

### Re-run a test

The Davai command `davai-run_tests` launches all the jobs listed in
`conf/<USECASE>.yaml`, sequentially and independantly (i.e. without
waiting for the jobs to finish). The command can also be used
complementary:

-   to list the jobs that would be launched by the command, according to
    the `conf/<USECASE>.yaml` config file:
    ```
    davai-run_tests -l
    ```

-   to run a single job:

    ```
    davai-run_tests <job identifier as given by -l option>
    ```

Some tests are gathered together within a single job. There are 2
reasons for that: if they are an instance of a loop (e.g. same test on
different obstypes, or different geometries), or if they have a
flow-dependancy with an upstream/downstream test (e.g. bator $>$
screening $>$ minimization).

When a test fails within a job and the user wants to re-run it without
re-runnning the other tests from the same job, it is possible to do so
by deactivating them[^3] :

-   **loops:** to deactivate members of a loop:\
    open config file `conf/davai_.ini`, and in the section corresponding
    to the job or family, the loops can be found as `list(...)`, e.g.
    `obstypes`, `rundates` or `geometrys`. Items in the list can be
    reduced to the only required ones (note that if only one item
    remains, one needs to keep a final `","` within the parenthesis).

-   **dependancy:** open driver file corresponding to the job name in
    `tasks/` directory, and comment out (`#`) the unrequired tasks or
    families of *`nodes`*, leaving only the required task.

### Investigating a problem

The **usecase** parameter of an experiment (to be set in the
`davai-new_xp` command) determines the span of tests to be generated and
run. Several usecases have been *(or will be)* implemented with various
purposes:

-   `NRV` (default): Non-Regression Validation, minimal set of tests
    that any contribution must pass.

-   `ELP`: Exploration and Localization of Problems, extended set of
    isolated components, to help localizing an issue

-   *`PC`: \[not implemented yet\] set of toy tests ported on
    workstation; the compilation with GNU (usually less permissive than
    vendor compilers) enables to raise issues that might not have been
    seen with NRV/ELP tests.*

### Smaller tests for smaller problems 

To investigate a non-reproducibility or crash issue, the `ELP` usecase
of Davaï can help localizing its context, with a set of more elementary
tests, that run smaller parts of code.

To switch to this mode:

-   create a new experiment with the same arguments but `-u ELP` and go
    in it

-   for a faster build (no re-compilation), edit config file
    `conf/davai_elp.ini` and in section `[gitref2pack]`, set
    `cleanpack = False`

-   `davai-run_xp`

Instead of 50$^+$ tests, the ELP mode will provide hundreds of more
elementary and focused tests. For instance, if you had a problem in the
4DVar minimization, you can run the 3 observation operators tests,
observation by observation, and/or a screening, and/or a 3DVar or 4DVar
single-obs minimization, in order to understand if the problem is in a
specific observation operator (which obs type ?), in its direct, TL or
AD version, or in the Variational algorithm, or in the preceding
screening, and so on\...

The user may want, at some point, to run only a subset of this very
large set of tests. In this case, simply open the `conf/ELP.yaml` and
comment (`#`) the launch of the various jobs. To reduce the number of
tests that are innerly looped, e.g. the loop on observation types within
the `*__obstype` jobs: open config file `conf/davai_elp.ini`, look for
the section named after job name and select the obstype(s) to be kept
only in list.

## Build options

The choice of a build system is corollary to the versioning of the
tests. However, at time of writing, only `gmkpack` is available within
DAVAÏ.

### Build with `gmkpack`

In the `[gmkpack]` section of config file `conf/davai_.ini`:

-   to make a main pack, instead of an incremental pack\
    $\hookrightarrow$ set `packtype = main`

-   to set the list of compilation flavours to build (a.k.a. compiler
    label/flag)\
    $\hookrightarrow$ use `compilation_flavours`\
    ! if you modify this, you potentially need to modify the
    `compilation_flavour` accordingly in the "families" sections that
    define it, as well as the `programs_by_flavour` that define the
    executables to be built for specific flavours

In the `[gitref2pack]` section:

-   to use a different `$ROOTPACK` (i.e. a different source of ancestor
    packs, for incremental packs)\
    $\hookrightarrow$ use `rootpack`\
    (preferably to modifying the environment variable, so that will be
    specific to that experiment only)

-   to avoid cleaning all `.o` and `.a` when (re-)populating the pack:\
    $\hookrightarrow$ set `cleanpack = False`\

In the `[pack2bin]` section:

-   to make the `pack2bin` task crash more quickly after a
    compilation/link error, or do not crash at all\
    $\hookrightarrow$ set `fatal_build_failure =`

    -   `__finally__` $\Rightarrow$ crash after trying to compile and
        build all executables

    -   `__any__` $\Rightarrow$ crash if compilation fails or right
        after the first executable linking to fail

    -   `__none__` $\Rightarrow$ never == ignore failed builds

-   to re-generate `ics_` files before building\
    $\hookrightarrow$ set `regenerate_ics = True`

-   to (re-)compile local sources with `gmkpack’s` option `Ofrt=2` (i.e.
    `-O0 -check bounds`):\
    $\hookrightarrow$ set `Ofrt = 2`

-   to use more/less threads for compilating (independant) sources files
    in parallel:\
    $\hookrightarrow$ use `threads`

-   to change the list of executables to be built, by default or
    depending on the compilation flavour:\
    $\hookrightarrow$ use `default_programs` and `programs_by_flavour`

Also, any `gmkpack` native variables can be set in the `.bash_profile`,
e.g. `ROOTPACK, HOMEPACK`, etc\... Some might be overwritten by the
config, e.g. if you set `rootpack` in config file.

### Build with \[cmake/makeup/ecbuild\...\]

Not implemented yet.

## Input data

DAVAÏ gets its input data through 2 providers:

-   *"shelves"* (pseudo Vortex experiments) for the data supposed to
    flow in real case (e.g. initial conditions file, observations files,
    etc\...), where this data is statically stored, usually in a cache
    to fetch it faster

-   *"uget"* for the static data (namelists, climatologic files,
    parameter files\...), catalogued in ***uenv*** files.

These *shelves* and *uenv* catalogs (cf. *uget/uenv* help documentation
for the use of this tool.) can be modified in the `[DEFAULT]` section of
config file.

In case your contribution needs a modification in these, ***don't forget
to describe these changes in the integration request***.

### Other options

In the `[DEFAULT]` section, a few other general options can be set to
tune the behaviour of the experiment:

-   `expertise_fatal_exceptions` to raise/ignore errors that could occur
    in the expertise subsequent to the tests

-   `drhook_profiling` to activate DrHook profiling or not

-   `ignore_reference` to force to ignore reference outputs (and so
    deactivate comparison)

-   `archive_as_ref` to archive the outputs (saving of a reference only)

## User configuration

Some more general parameters are configurable, such as the default
directory in which the experiments are stored, or the directory in which
the logs of jobs are put. This can be set in
`\sim/.davairc/user_config.ini`. If the user, for whatever reason, needs
to modify the packages linked in the experiments on a regular basis, it
is possible to specify that in the same user config file. An example of
these variables is available in the `DAVAI-env` repository, under
`templates/user_config.ini`.

## Parallel profiling

Each job has a section in the config file, in which one can tune the
requested profile parameters to the jobs scheduler:

-   `time` : elapse time

-   `ntasks` : number of MPI tasks per node

-   `nnodes` : number of nodes

-   `openmp` : number of OpenMP threads

-   `partition` : category of nodes

-   `mem` : memory (helps to prevent OOM)

The total number of MPI tasks is therefore `nnodes \times ntasks`, and
is automatically replaced in namelist

## Experts thresholds

*Experts* are the tools developed to parse outputs of the tasks and
compare them to a reference. Each expert has its expertise field: norms,
Jo-tables, etc\...

See *Information on experts* in the left tab of Ciboulaï to get
information about the tunable thresholds of the various experts (e.g.
the allowed error on Jo). Then, set according attributes in the experts
definitions in the concerned tasks.

Again, if you need to modify these, please ***explain and describe in
the integration request***.

## Versioning of tests

The following reasons may require to update the tests:

1.  Update the input resources or a task template script, to **change
    the purpose or context of a test** (e.g. new observations or
    modified namelists, to pull the tests more closely to operational
    configurations, \...). This usually comes with a change in the
    targeted tests outputs.

2.  Add **new tests**.

3.  Update the resources to **adapt to a code change** (e.g. new
    radiative coefficients files format, or a mandatory namelist
    change), with or without change in the results.

Therefore it is necessary to track the evolutions of the tests properly,
and version them clearly, so that it is clear what fixed or evolving
version is to be used in any context. Hence the existence of the
`DAVAI-tests` repository.\
The first two kinds of evolutions (a. and b.) are not necessarily linked
to a contribution of code to the IAL repository, and therefore can be
implemented at any moment in a dedicated branch of the tests repository
(`DAVAI-tests`). This is described in more details in
section [\[sect:add-modify-tests\]](#sect:add-modify-tests){reference-type="ref"
reference="sect:add-modify-tests"}.

The latter is on the other hand attached to a contribution, and will
require to be given together with the contribution for an integration,
and be integrated itself in an evolving tests branch dedicated to test
successive steps of the IAL integration branch. This case is detailed in
more details in
section [\[sect:parallel-branches\]](#sect:parallel-branches){reference-type="ref"
reference="sect:parallel-branches"}.

To follow more easily what version of the tests should be used in
particular for contributions to the IAL codes, it is proposed to adopt a
nomenclature that maps the IAL releases and integration/merge branches,
but replacing `"CY"` by `"DV"` (for DAVAÏ), as illustrated on
Figure [\[fig:tests\_versioning\]](#fig:tests_versioning){reference-type="ref"
reference="fig:tests_versioning"}. With this principle, the version of
the tests to be used *by default* would be, for example:

-   for a development based on `CY49` $\rightarrow$ `DV49`

-   for an integration branch towards `CY49T1`, named `dev_CY49_to_T1`
    $\rightarrow$ `dev_DV49_to_T1`

### Adding or updating tests independently from the code

The tests modifications which are not intrinsically linked with a
contribution (adding tests or modifying a test to modify its behaviour)
can be done at any moment, in a development branch of the tests
repository. However, in order not to disturb the users and integrators,
they should be merged into the next official version of tests (i.e. the
version used for contributions and integrations to IAL) [only between a
declaration of an IAL release and a call for contribution]{.underline}.

### Evolution of the tests w.r.t. Integration of an IAL release

In the context of integration of an IAL release, it is suitable that the
tests change as little as possible during the successive integration of
contributions. Therefore we will set a version of the tests at the
beginning of integration, and only adapt it for the contributions that
require an update of the tests.\
Let's consider the process of integration of contribution branches on
top of `CY49` to build a `CY49T1`. For that purpose we would have set a
reference experiment on `CY49`, hereafter named `x0`, generated with an
identified version of the tests. That version of the tests would then be
updated with `x0` as *reference experiment* (`ref_xpid`), and tagged
`DV49`. All contributions to `CY49T1` would then be required to be
tested with this version `DV49` (hence against reference experiment
`x0`). Cf.
section [\[sect:set\_a\_ref\_tests\_version\]](#sect:set_a_ref_tests_version){reference-type="ref"
reference="sect:set_a_ref_tests_version"} for more details about setting
up a reference tests version and experiment.

Suppose then that we have 5 of these contribution branches based on
`CY49`, and an integration branch named `dev_CY49_toT1`. These 4
contributions may have different levels of reproducibility: they may
conserve the results or not; they may require resources/tests
adaptations (e.g. namelist updates, \...) or not, in which case they
come with tests adaptations in an associated tests branch. Cf. the table


branch |   results |   test XPID  |   resources |  tested with  |  integration XPID
:--    | :--       | :--          | :--         | :--          | :--
`b1`  |    $=$     |  `x1`     |    $=$   |  `DV49`                   |       `xi1`
`b2` |   $\neq$    |  `x2`     |    $=$   |  `DV49`                    |      `xi2`
`b3` |     $=$     |  `x3`     |  $\neq$  |  $\rightarrow$ `DV49_b3`   |      `xi3`
`b4` |    $\neq$   |   `x4`    |   $\neq$ |   $\rightarrow$ `DV49_b4`  |       `xi4`

In parallel to the integration branch `dev_CY49_toT1`, we start a tests
branch from `DV49` to collect the necessary adaptations of the tests,
similarly named `dev_DV49_toT1`, which will be used to validate the
integration branch, and updated as required along the integration.

In case some intermediate versions of the integration branch are tagged
and some branches are based/rebased on these tagged versions, we could
also tag accordingly the tests branch if necessary.\
The reference experiment for the integration branch is at any moment,
*by default*, the experiment which tested the formerly integrated
branch, e.g. the reference for `xi2` is `xi1`. However, that may not be
true in some cases, some of these being potentially more tricky to
validate, as will be shown in the following example.

### Steps and updates in the Continuous Integration process

1.  Integration of `b1` :

    -   Reference: `x0` is the default reference xp in `dev_DV49_toT1`
        config file

    -   Tests: `b1` did not require to adapt the tests $\rightarrow$ we
        can test with branch `dev_DV49_toT1` unchanged (and still equal
        to `DV49`)

    `davai-new_xp dev_CY49_toT1 -v dev_DV49_toT1`\
    $~~~\hookrightarrow~~~$ `xi1 == x1 == x0`

2.  Integration of `b2` :

    -   Reference: `xi1` should normally be the reference xp, but since
        its results are bit-identical to `x0` as opposed to `x2`, it is
        more relevant to compare to `x2`, to check that the merge of
        `b1` and `b2` still give the same results as `b2`

    -   Tests: `b2` did not require to adapt the tests $\rightarrow$
        tests branch `DV49_toT1` unchanged

    `davai-new_xp dev_CY49_toT1 -v DV49_toT1`\
    $~~~$and set `ref_xpid = x2`\
    $~~~\hookrightarrow~~~$ `xi2 == x2`

    -   then `ref_xpid` should be set to `xi2` in branch `DV49_toT1`

3.  Integration of `b3` :

    -   Reference: `b3` does not change the results, so reference
        experiment is as expected by default `xi2`

    -   Tests: `b3` requires tests adaptations (`DV49_b3`) $\rightarrow$
        update `dev_DV49_toT1` by merging `DV49_b3` in

    `davai-new_xp dev_CY49_toT1 -v DV49_toT1`\
    $~~~\hookrightarrow~~~$ `xi3 == xi2`

4.  Integration of `b4` : *(where it becomes more or less tricky)*

    -   Reference: `b4` changes the results, but the results of `xi3`
        (current default reference for integration branch) are also
        changed from `x0` (since `b2`) $\rightarrow$ the reference
        experiment becomes less obvious !\
        The choice of the reference should be made depending on the
        width of impact on both sides:

        1.  if there is more differences in the results between
            `dev_CY49_toT1` and `CY49` than between `b4` and `CY49`:\
            $\rightarrow$ `xi3` should be taken as reference, and the
            differences finely compared to those shown in `x4`

        2.  if there is more differences in the results between `b4` and
            `CY49` than between `dev_CY49_toT1` and `CY49`:\
            $\rightarrow$ `x4` should be taken as reference, and the
            differences finely compared to those shown in `xi3’`, where
            `xi3’` is a *"witness"* experiment comparing the integration
            branch after integration of `b3` (commit `<c3>`) to `CY49`
            (experiment `x0`):\
            `davai-new_xp <c3> -v dev_DV49_toT1`\
            $~~~$and set `ref_xpid = x0`\
            $~~~\hookrightarrow~~~$ `xi3’`

        This is still OK if the tests affected by `dev_CY49_toT1` (via
        `b2`) and the tests affected by `b4` are not the same subset, or
        if at least if the affected fields are not the same. If they are
        (e.g. numerical differences that propagate prognostically
        through the model), the conclusion becomes much more difficult
        !!!\
        In this case, we do not really have explicit recommendation; the
        integrators should double-check the result of the merge with the
        author of the contribution `b4`. Any idea welcome to sort it
        out.

    -   Tests: `b4` requires tests adaptations (`DV49_b4`) $\rightarrow$
        update `dev_DV49_toT1` by merging in `DV49_b4` in

    `davai-new_xp dev_CY49_toT1 -v dev_DV49_toT1`\
    $~~~$and set `ref_xpid = xi3|xi4`\
    $~~~\hookrightarrow~~~$ `xi4`

### Setting up a reference version of the tests and an associated reference experiment

! WORK IN PROGRESS\...

We describe here how to set up a reference version of the tests and an
associated reference experiment, typically for developments based on a
given IAL release to be validated against this release.

For the example, let's consider `CY49` and setting up a `DV49` version
for it, including its reference experiment, to validate the
contributions to `CY49T1`.

1.  Choose an initial version of the tests you want to be used. It may
    probably not be the previous reference one (e.g. `DV48T2` or
    `dev_CY48T1_toT2`), as we may often want to modify or add tests in
    between cycles.

2.  In your development DAVAI-tests repository, make a branch starting
    from this version and check it out, e.g.:\
    `git checkout -b on_49 [<chosen_initial_ref]`

3.  Set the reference experiment:\
    `davai-new_xp CY49 -v on_49 -u ELP –origin <URL of my DAVAI-tests repo>`\
    $\hookrightarrow$ `dv-xxxx-machine@user`\
    Note:

    -   As ELP usecase encompasses NRV, reference experiments should use
        this usecase so it could be used as a reference for both
        usecases.

    -   `–origin <URL...>` to clone that repo in which you created the
        branch

    -   in config of the experiment, set `archive_as_ref = True` : the
        experiment will serve as a reference, so we want to archive its
        results

    -   in config of the experiment, set `ignore_reference = True` : if
        you are confident enough with the test version, it may not be
        useful/relevant to compare the experiment to any reference one.

4.  Run the experiment

5.  Update the `DAVAI-tests` repository:

    -   default config file for this machine (`conf/<machine>.ini`: with
        the name of this experiment as `ref_xpid` (and potentially the
        usecase chosen in minor case as `ref_vconf`)

    -   `README.md`: the table of correspondance of branches and tests

    Then commit, tag (`DV49`) and push:

          git commit -am "Set reference experiment for <machine> as <dv-xxxx-machine@user>"
          git tag DV49
          git push <remote>
          git push <remote> DV49

This way the tests experiment generated using `davai-new_xp -v DV49`
will use this version and be compared to this reference experiment.

## Internal organization of DAVAÏ

[^1]: IAL = **I**FS-**A**rpege-**L**AM

[^2]: `git commit –amend`

[^3]: including upstream tasks that produce flow-resources for the
    targeted test, as long as the resources stay in cache
