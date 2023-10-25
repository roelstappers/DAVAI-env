### Create your branch, containing your modifications

To use DAVAÏ to test your contribution to the next development release,
you need to have your code in a Git branch starting from the latest
official release (e.g. `CY48T1` tag for contributions to 48T2, or `CY49`
tag for contributions to 49T1).

In the following the example is taken on a contribution to 48T2:

1. In your repository (e.g. `~/repositories/arpifs` -- make sure it is clean with `git status` beforehand), create your branch:

   ```bash 
   git checkout -b <my_branch> [<starting_reference>]
   ```

   !!! tip "Example" 
       `git checkout -b mary_CY48T1_cleaning CY48T1`
   
   !!! note 
       It is strongly recommended to have explicit branch names with regards to their origin and their owner, hence the legacy branch naming syntax `<user>_<CYCLE>_<purpose_of_the_branch>`

2. Implement your developments in the branch.  *It is recommended to find a compromise between a whole development in only one commit, and a large number of very small commits (e.g.  one by changed file).* In case you then face compilation or runtime issues then, but only if you haven't pushed it yet, you can *amend*[^1] the latest commit to avoid a whole series of commits just for debugging purpose.
   !!! note 
       DAVAÏ is currently able to include non-committed changes in the compilation and testing. However, in the next version based on *bundle*, this might not be possible anymore.  
[^1]: `git commit –amend`
