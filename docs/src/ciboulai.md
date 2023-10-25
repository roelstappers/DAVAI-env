### Monitor and inspect results

1. Monitor the execution of the jobs with the scheduler (with SLURM: `squeue -u <user>`)

2. Check the tests results summary on the *Ciboulaï* dashboard, which URL is prompted at the end of tests launch, or visible in the config file:

   - open [Ciboulaï dashboard](https://www.umr-cnrm.fr/davai/) in a web browser:

     - To guide you in the navigation in *Ciboulaï*, cf. [Ciboulai](@ref ciboulai) 
     - To get the paths to a job output or abort directory: button `[+]` then **Context**.

   - if the dashboard is not accessible, a command-line version of the status is possible; in the XP directory, run:

     ```
     davai-xp_status
     ```

     to see the status summary of each job. The detailed status and expertise of tests are also available as json files on the Vortex cache: `belenos:/scratch/mtool/<user>/cache/vortex/davai/<vconf>/<xpid>/summaries_stack/` or
        
     ```
     davai-xp_status -t <task>
     ```

     To get the paths to a job output or abort directory: `davai-xp_status -t <task>` then open the `itself` file and look in the **Context** section.

3. If everything is OK (green) at the end of executions, your branch is
    validated !

4. If not, cf. Section advanced topics to re-compile a code modification and re-run tests.

