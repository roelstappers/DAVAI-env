In your IAL repo:
 
* Make sure you have latest releases:
  `git fetch accord --tags`
* Create your branch on top of `CY49T0_bf.00`(contains a workaround/bugfix for ECMWF HPC):
  `git checkout -b <user>_CY49T0_<my_awesome_dev> CY49T0_bf.00`
* Implement your development therein ...
  If your dev is a rephasing of a branch developped on an earlier release, you can "cherry-pick" the commits from the original branch (`git cherry-pick -x <commit>`)
* Commit as necessary, with intermediate granularity: not 1 commit for one big development, but not 1 commit for each modified line either.
* Test your branch with Davai: [README](https://github.com/ACCORD-NWP/DAVAI-env) and User Guide referenced therein
* When happy with tests results, check for uncommited modifications, then push to your fork, and finally send the Pull Request.

