# (Re-)Build of executables

### Build with `gmkpack`

The tasks in the `build` job are respectively in charge of:

- `gitref2pack` : fetch/pull the sources from the requested Git reference and set one or several incremental `gmkpack`'s pack(s) -- depending on `compilation_flavours` as set in config. The packs are then populated with the set of modifications, from the latest official tag to the contents of your branch (including non-commited modifications).

- `pack2bin` : compile sources and link necessary executables (i.e. those used in the tests), for each pack flavour.

In case the compilation fails, or if you need to (re-)modify the sources for any reason (e.g. fix an issue):

1. implement corrections in the branch (commited or not)

2. re-run the build: 

   ```
   davai-build -e
   ```
   (option `-e` or `–preexisting_pack` assumes the pack already preexists; this is a protection against accidental overwrite of an existing pack. The option can also be passed to `davai-run_xp`)

3. and then if build successful `davai-run_tests`

### Build with \[cmake/ecbuild\...\]

Not implemented yet.

