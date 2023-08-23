Complementary information about DAVAI setup on `aa|ab|ac|ad` HPC machine @ ECMWF/Bologna
========================================================================================

Quick install
-------------

```
module use ~rm9/public/modulefiles
module load davai
```
I advise to put the first line in your `.bash_profile`, and execute the second only when needed.

---

Pre-requirements (if not already set up)
----------------------------------------

1. Load the required environment for GMKPACK compilation and DAVAI execution. It is **REQUIRED** that add the following to your `.bash_profile`):
   ```
    module purge
    module use /home/rm9/public/modulefiles
    module load intel/2021.4.0 prgenv/intel python3/3.10.10-01 ecmwf-toolbox/2021.08.3.0 davai/master
    . use_gmkpack.sh
   ```

2. Ensure permissions to `accord` group (e.g. with `chgrp`) for support
   ```
   for d in $HOME/davai $HOME/pack $SCRATCH/mtool/depot
   do
   mkdir -p $d
   chgrp -R accord $d
   done
   ```
