# `RDDL`: *`R`apid `D`eployment `D`eep `L`earning*

A *Conda*-based, templatable, extendable, R&D-focused infrastructure scaffold aiming at fast iterability and *cross-unix* robustness.

---

Some relevant specifications:

- The *entire thing* is **Python-based**.
- **PyTorch** and **JAX** (plus some respective extensions) are the supported *deep learning* frameworks. Some inter-operability is also guaranteed.
- The *hardware stack* of reference is **Intel CPU** and **Nvidia GPU**.
- A **UNIX** (or *UNIX-like* at least) system is a prerequisite.

---

#### Essential *how-to*:

1. Ensure that you have **not** an already-existing *Anaconda* environment
   called `RDDL` (or, for our purposes, whichever name you want to call the
   environment to-be-created). Otherwise, it will be overwritten without
   further notice!

2. Ensure that you are running `bash` or `zsh` as shell, since they are the
   only supported (no `fish`, sorry... although I use it as my default shell in
   most of the cases!), and verify that the `conda` (or `mamba`, if you want to
   use it instead) command is available and working correctly.

3. Clone the *GitHub* repository via `git clone
   https://github.com/emaballarin/RDDL.git`.

4. Open the `init.sh` and `portablecuda.sh` script files, and check if the
   **environmental variables**, **paths** and **versions** are OK for your
   system. Please, not that this set of scripts is nothing more than a (useful,
   though) tool for personal use, shared in the hope it might be useful to
   someone else too. It is not a full-fledged, stable product. Some rough edges
   may still be present.
   In this case, however, minimal modifications should be enough!

5. Let the script prepare and install everything, via `./init.sh` . Note that
   an active Internet connection is still required for everything to work as
   expected.
