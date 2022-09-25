#!/usr/bin/bash
####################################################################################################

# The Conda-compatible package manager you want to use (currently: conda | mamba)
WHICH_SNAKE="mamba"
#WHICH_SNAKE="conda"

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDLean"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

# A directory with CUDA / CUDNN / NCCL installed inside, and ./lib64/ folder removed
# after having it merged with ./lib/
export DO_INJECT_PORTABLECUDA="0"
export PORTABLECUDA_ROOT="$RDDL_PORTABLECUDA_ROOT/portablecuda/11.6.2/"

# Package path (to manually install packages in, if needed)
export PYPKG_DIR="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/python3.9/site-packages/"

####################################################################################################

# Become location-aware
export SELF_STORED_CALLDIR="$(pwd)"

####################################################################################################

# Remove already-existing environment with the same name
conda env remove -n $ANACONDA_ENV_NAME      # Conda required here!
rm -R -f "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/"

# Create new environment
export PRE_PYTHONUSERBASE="$PYTHONUSERBASE"
export PYTHONUSERBASE="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"
mkdir -p "$PYTHONUSERBASE/etc"
cp -R -f ./etc "$PYTHONUSERBASE"
sed -i 's@__SUB__THIS__@'"$PORTABLECUDA_ROOT"'@' "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/etc/conda/activate.d/zz_cuda.sh"
cp -f ./dot_condarc "$PYTHONUSERBASE/.condarc"
cp -f ./start.py "$PYTHONUSERBASE/start.py"
export _PRE_ALLOW_BOTORCH_LATEST="$ALLOW_BOTORCH_LATEST"
export ALLOW_BOTORCH_LATEST="1"
"$WHICH_SNAKE" env create -f environment.yml
export PYTHONUSERBASE="$PRE_PYTHONUSERBASE"
unset PRE_PYTHONUSERBASE

####################################################################################################

# Remove Anaconda-installed CUDA & other nasty stuff (that must be system-installed, though);
# Install and overwrite (if any) libjpeg-turbo
# MUST BE SYSTEM-INSTALLED: CMake, cURL, Kerberos 5 (if needed), MPI libraries & compilers.
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

conda remove -y cmake curl krb5 mpi llvmlite --force --force-remove    # Conda required here!
if [[ "$DO_INJECT_PORTABLECUDA" == "1" ]]; then
    conda remove -y cudatoolkit cudnn nccl nccl2 --force --force-remove    # Conda required here!
fi

"$WHICH_SNAKE" install -y libjpeg-turbo --force --force-reinstall --no-deps --clobber

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

mkdir -p "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
ln -s -f /usr/bin/ld "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
ln -s -f /usr/bin/addr2line "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/addr2line"
ln -s -f /usr/bin/ar "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ar"
ln -s -f /usr/bin/as "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/as"
ln -s -f /usr/bin/c++ "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/c++"
ln -s -f /usr/bin/c++filt "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/c++filt"
ln -s -f /usr/bin/cc "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/cc"
ln -s -f /usr/bin/cpp "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/cpp"
ln -s -f /usr/bin/dwp "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/dwp"
ln -s -f /usr/bin/elfedit "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/elfedit"
ln -s -f /usr/bin/f95 "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/f95"
ln -s -f /usr/bin/g++ "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/g++"
ln -s -f /usr/bin/gcc "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcc"
ln -s -f /usr/bin/gcc-ar "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcc-ar"
ln -s -f /usr/bin/gcc-nm "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcc-nm"
ln -s -f /usr/bin/gcc-ranlib "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcc-ranlib"
ln -s -f /usr/bin/gcov "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcov"
ln -s -f /usr/bin/gcov-dump "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcov-dump"
ln -s -f /usr/bin/gcov-tool "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gcov-tool"
ln -s -f /usr/bin/gfortran "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gfortran"
ln -s -f /usr/bin/gold "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gold"
ln -s -f /usr/bin/gprof "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/gprof"
ln -s -f /usr/bin/ld "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ld"
ln -s -f /usr/bin/ld.bfd "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ld.bfd"
ln -s -f /usr/bin/ld.gold "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ld.gold"
ln -s -f /usr/bin/nm "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/nm"
ln -s -f /usr/bin/objcopy "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/objcopy"
ln -s -f /usr/bin/objdump "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/objdump"
ln -s -f /usr/bin/ranlib "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ranlib"
ln -s -f /usr/bin/readelf "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/readelf"
ln -s -f /usr/bin/size "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/size"
ln -s -f /usr/bin/strings "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/strings"
ln -s -f /usr/bin/strip "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/strip"

####################################################################################################

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
if [[ "$DO_INJECT_PORTABLECUDA" == "1" ]]; then
    ./portablecuda.sh
fi

ln -s "$HOME/$ANACONDA_BASEDIR_NAME/lib/libcom_err.so.3.0" "$HOME/$ANACONDA_BASEDIR_NAME/lib/libcom_err.so.3" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/"

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################
############################# PIP REQUIREMENTS #####################################################
####################################################################################################

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

pip install --upgrade --no-deps --force --force-reinstall pip setuptools wheel

pip install llvmlite==0.36 --ignore-installed
pip install -r "$SELF_STORED_CALLDIR/requirements.txt"

pip install --upgrade jupyter_http_over_ws
pip uninstall -y typing

pip uninstall -y pillow

CC="gcc -mavx2" pip install --no-cache-dir --upgrade --no-deps --force-reinstall --no-binary :all: --compile pillow-simd
pip install --upgrade --no-deps --force --force-reinstall --pre cupy-cuda116
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/emaballarin/ffcv.git

pip install --upgrade "nbclassic>=0.4.3"

jupyter nbextension enable --py jupytext
jupyter nbextension enable varInspector/main
jupyter nbextension enable --py neptune-notebooks
jupyter nbextension enable --py ipygany

#jupyter labextension install @jupyterlab/toc --no-build
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter labextension install jupyterlab-plotly --no-build
jupyter labextension install plotlywidget --no-build
jupyter labextension install neptune-notebooks --no-build
jupyter labextension install @jupyter-widgets/jupyterlab-manager ipygany --no-build
jupyter labextension install jupyterlab-jupytext --no-build

jupyter serverextension enable --py jupyter_http_over_ws

# Jupyter Notebook/Lab upgrade and rebuild
jupyter labextension update --all
jupyter lab build

pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.12.1+cu116.html --no-deps
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.12.1+cu116.html --no-deps
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.12.1+cu116.html --no-deps
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.12.1+cu116.html --no-deps
pip install git+https://github.com/rusty1s/pytorch_geometric.git --no-deps
pip install git+https://github.com/benedekrozemberczki/pytorch_geometric_temporal.git --no-deps

ln -s "$PYPKG_DIR/numpy/core/include/numpy" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/include/python3.9/"
#pip install git+https://github.com/sissa-data-science/DADApy.git

# FIXUP for: https://github.com/getkeops/keops/pull/222#issuecomment-1061589904
pip install "git+https://github.com/getkeops/keops.git#subdirectory=keopscore" --force-reinstall --no-deps
pip install "git+https://github.com/getkeops/keops.git#subdirectory=pykeops" --force-reinstall --no-deps

#pip install git+https://github.com/facebookresearch/torchdim
#pip install git+https://github.com/IntelLabs/bayesian-torch.git --no-deps

pip uninstall -y pillow

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################
####################################################################################################


# Install Nvidia APEX (with cpp & cuda extensions) with a trick
################################################################################
#source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
#export PRE_APEX_CC="$CC"
#export PRE_APEX_CXX="$CXX"
#export PRE_APEX_FC="$FC"
#export CC=gcc-9
#export CXX=g++-9
#export FC=gfortran-9
##
#pip install --upgrade --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" git+https://github.com/NVIDIA/apex.git
##
#export CC="$PRE_APEX_CC"
#export CXX="$PRE_APEX_CXX"
#export FC="$PRE_APEX_FC"
#unset PRE_APEX_CC
#unset PRE_APEX_CXX
#unset PRE_APEX_FC
#source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"
################################################################################
# Phew! Done! :)

# Rich stack-traces
cd "$PYPKG_DIR/"
mkdir sitecustomize
cd sitecustomize
echo "from rich.traceback import install" >> __init__.py
echo "install()" >> __init__.py
echo ""

# End
cd "$SELF_STORED_CALLDIR"
export ALLOW_BOTORCH_LATEST="$_PRE_ALLOW_BOTORCH_LATEST"
echo ' '
echo 'DONE!'
echo ' '
