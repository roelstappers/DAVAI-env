Complementary information about DAVAI setup on `belenos` HPC machine @ MF
=========================================================================

Quick install
-------------

```
module use ~mary/public/modulefiles
module load davai
```
I advise to put the first line in your `.bash_profile`, and execute the second only when needed.

---

Pre-requirements (if not already set up)
----------------------------------------

1. Load modules (conveniently in your `.bash_profile`):
   ```
   module load python/3.7.6
   module load git
   ```
   
2. Configure your `~/.netrc` file for FTP communications with archive machine hendrix, if not already done:
   ```
   machine hendrix login <your_user> password <your_password>
   machine hendrix.meteo.fr login <your_user> password <your_password>
   ```
   (! don't forget to `chmod 600 ~/.netrc` if you are creating this file !)\
   _To be updated when you change your password_
   
3. Configure ftserv (information is stored encrypted in ~/.ftuas):\
   `ftmotpasse -h hendrix -u <your_user>`\
   (and give your actual password)\
   **AND**\
   `ftmotpasse -h hendrix.meteo.fr -u <your_user>`\
   (same)\
   _To be updated when you change your password_
   
4. Configure Git proxy certificate info :\
   `git config --global http.sslVerify false`
   
5. Ensure SSH connectivity between compute and transfer nodes, if not already done:\
   `cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`

---

And maybe
---------
with a version of tests prior to `DV48T1_op0.04-1`, you may also need `epygram`:

  - `~mary/public/EPyGrAM/stable/_install/setup_epygram.py -v`
  - then to avoid a matplotlib/display issue, set:\
    ```
    backend : Agg
    ```
    in `~/.config/matplotlib/matplotlibrc`
