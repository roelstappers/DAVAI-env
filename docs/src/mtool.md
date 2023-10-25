# Running jobs on HPC : `MTOOL`

On HPCs, the compute nodes are "expensive" and so we try as much as possible to save the elapse time spent on compute nodes for actual
computations, i.e. execution of the executable. 
Therefore in DAVAÏ, the generation of the scripts uses the `MTOOL` filter to replicate and cut a job script into several **steps**:

1. on transfer nodes, fetch the resources, either locally on the file system(s) or using FTP connections to outer machines
2. on compute nodes, execute the AlgoComponent(s)
3. on transfer nodes, dispatch the produced output
4. final step to clean the temporary environment created for the jobs

In addition to this separation and chaining these 4 steps, `MTOOL` initially sets up a clean environment with a temporary unique execution
directory. It also collects log files of the script's execution, and in the case of a failure (missing input resources, execution aborted), it
takes a screenshot of the execution directory. Therefore for each job, one will find :

- a **depot** directory in which to find the actual 4 scripts and their log files

- an **abort** directory, in which to find the exact copy of the execution directory when the execution failed

These directories are registered by the DAVAÏ expertise and are displayed in the **Context** item of the expertise for each task in *Ciboulaï*.
