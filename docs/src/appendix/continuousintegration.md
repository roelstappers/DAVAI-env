### Steps and updates in the Continuous Integration process

1.  Integration of `b1` :

    -   Reference: `x0` is the default reference xp in `dev_DV49_toT1`
        config file

    -   Tests: `b1` did not require to adapt the tests $\rightarrow$ we
        can test with branch `dev_DV49_toT1` unchanged (and still equal
        to `DV49`)

    `davai-new_xp dev_CY49_toT1 -v dev_DV49_toT1`\
    $~~~\hookrightarrow~~~$ `xi1 == x1 == x0`

2.  Integration of `b2` :

    -   Reference: `xi1` should normally be the reference xp, but since
        its results are bit-identical to `x0` as opposed to `x2`, it is
        more relevant to compare to `x2`, to check that the merge of
        `b1` and `b2` still give the same results as `b2`

    -   Tests: `b2` did not require to adapt the tests $\rightarrow$
        tests branch `DV49_toT1` unchanged

    `davai-new_xp dev_CY49_toT1 -v DV49_toT1`\
    $~~~$and set `ref_xpid = x2`\
    $~~~\hookrightarrow~~~$ `xi2 == x2`

    -   then `ref_xpid` should be set to `xi2` in branch `DV49_toT1`

3.  Integration of `b3` :

    -   Reference: `b3` does not change the results, so reference
        experiment is as expected by default `xi2`

    -   Tests: `b3` requires tests adaptations (`DV49_b3`) $\rightarrow$
        update `dev_DV49_toT1` by merging `DV49_b3` in

    `davai-new_xp dev_CY49_toT1 -v DV49_toT1`\
    $~~~\hookrightarrow~~~$ `xi3 == xi2`

4.  Integration of `b4` : *(where it becomes more or less tricky)*

    -   Reference: `b4` changes the results, but the results of `xi3`
        (current default reference for integration branch) are also
        changed from `x0` (since `b2`) $\rightarrow$ the reference
        experiment becomes less obvious !\
        The choice of the reference should be made depending on the
        width of impact on both sides:

        1.  if there is more differences in the results between
            `dev_CY49_toT1` and `CY49` than between `b4` and `CY49`:\
            $\rightarrow$ `xi3` should be taken as reference, and the
            differences finely compared to those shown in `x4`

        2.  if there is more differences in the results between `b4` and
            `CY49` than between `dev_CY49_toT1` and `CY49`:\
            $\rightarrow$ `x4` should be taken as reference, and the
            differences finely compared to those shown in `xi3’`, where
            `xi3’` is a *"witness"* experiment comparing the integration
            branch after integration of `b3` (commit `<c3>`) to `CY49`
            (experiment `x0`):\
            `davai-new_xp <c3> -v dev_DV49_toT1`\
            $~~~$and set `ref_xpid = x0`\
            $~~~\hookrightarrow~~~$ `xi3’`

        This is still OK if the tests affected by `dev_CY49_toT1` (via
        `b2`) and the tests affected by `b4` are not the same subset, or
        if at least if the affected fields are not the same. If they are
        (e.g. numerical differences that propagate prognostically
        through the model), the conclusion becomes much more difficult
        !!!\
        In this case, we do not really have explicit recommendation; the
        integrators should double-check the result of the merge with the
        author of the contribution `b4`. Any idea welcome to sort it
        out.

    -   Tests: `b4` requires tests adaptations (`DV49_b4`) $\rightarrow$
        update `dev_DV49_toT1` by merging in `DV49_b4` in

    `davai-new_xp dev_CY49_toT1 -v dev_DV49_toT1`\
    $~~~$and set `ref_xpid = xi3|xi4`\
    $~~~\hookrightarrow~~~$ `xi4`

