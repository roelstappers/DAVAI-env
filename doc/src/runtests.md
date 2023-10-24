### Run tests

1. Create your experiment, specifying which version of the tests you want to use:

   ```
   davai-new_xp <my_branch> -v <tests_version>
   ```

   !!! tip "Example" 
       ```
       davai-new_xp mary_CY48T1_cleaning -v DV48T1
       ```
   An experiment with a unique experiment ID is created and prompted as output of the command, together with its path.

   - To know what is the version to be used for a given development: See [here](https://github.com/ACCORD-NWP/DAVAI-tests/wiki)
   - See `davai-new_xp -h` for more options on this command
   - See Appendix for a more comprehensive approach to tests versioning.
   - If the version you are requesting is not known, you may need to specify the DAVAI-tests origin repository from which to clone/fetch it, using argument `–origin <URL of the remote DAVAI-tests.git>`

2. Go to the (prompted) experiment directory.
   
   If you want to set some options differently from the default, open file `conf/davai_nrv.ini` and tune the parameters in the `[DEFAULT]` section. The usual tunable parameters are detailed in Section options 

3. Launch the build and tests:

   ```
   davai-run_xp
   ```

   After initializing the Ciboulaï page for the experiment, the command will first run the build of the branch and wait for the executables (that step may take a while, depending on the scope of your modifications, especially with several compilation flavours). Once build completed, it will then launch the tests (through scheduler on HPC).

