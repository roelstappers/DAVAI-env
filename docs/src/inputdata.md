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

