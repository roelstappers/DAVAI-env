## Fork

The ACCORD-NWP central repository is accessible in reading mode to Accord members, but restricted in writing mode to administrators of the repo.
Hence you need a clone of this repo on your github account, to which to push your branches to make them accessible to the integrators. This personal distant clone is called a "_Fork_".

On https://github.com/ACCORD-NWP/IAL click "Fork", uncheck "_Copy the `master` branch only_" then "_Create fork_".
That can take a little while.

## Token
  SSH communications are blocked from certain platform (e.g. belenos), hence I recommend to use git through `https` to clone, fetch and pull from/to github.com.
  This implies using a "token" as password; here's how-to.

* Logged in on github.com, click on your avatar (on the right in the top banner), then _"Settings" > "Developer settings" (bottom of the left column/menu) > "Personal access tokens" (classic) > "Generate new token" (classic)_, then give it a name, select an expiry date, check the "repo" checkbox, and finally "Generate token"
* Set your token in your `~/.netrc` file:
 ```echo "machine github.com login <your github login> password <token>" >> ~/.netrc```

## Local clone

* _Pre-requirement on `belenos` to bypass MF certificate:_
  ```git config --global http.sslVerify false```
* Choose a directory where you want to clone the IAL repository and `cd` it (e.g. `~/repositories/`)
* Therein, clone the repo:
  ```git clone https://github.com/<your github login>/IAL.git```
* And connect the ACCORD central repo, to fetch tags and updates of official branches:
  ```
  git remote add accord https://github.com/ACCORD-NWP/IAL.git
  git fetch accord --tags
  ```

Your IAL repository is now set up.
The `accord` remote is the distant repo where you will fetch new releases, the `origin` remote is where you will push your branches (to your fork), for them to be integrated in a next release, issuing a Pull Request.
Cf. `git remote -v` or `git branch -r`

### Case of preexisting `arpifs` repo from GCO on belenos

If you already have, on belenos HPC, an `arpifs` repos cloned from the original GCO repo (with Git-GCO toolbox commands), you can connect it anyway to the IAL repo from ACCORD-NWP and to your fork, as they share the same history.
In this case:

  ```
  git remote add my_fork https://github.com/<your github login>/IAL.git
  git remote add accord https://github.com/ACCORD-NWP/IAL.git
  git fetch accord --tags
  ```

_**Now you can go to step 2: [prepare your branch](https://github.com/ACCORD-NWP/IAL/discussions/77)**_

_Originally posted by @AlexandreMary in https://github.com/ACCORD-NWP/IAL/discussions/72_
