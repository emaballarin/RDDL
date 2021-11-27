#!/bin/bash
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
export PORTABLECUDA_ROOT="$RDDL_PORTABLECUDA_ROOT/portablecuda/11.3.1/"

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
"$WHICH_SNAKE" env create -f environment.yml
export PYTHONUSERBASE="$PRE_PYTHONUSERBASE"
unset PRE_PYTHONUSERBASE

####################################################################################################

# Remove Anaconda-installed CUDA & other nasty stuff (that must be system-installed, though);
# Install and overwrite (if any) libjpeg-turbo
# MUST BE SYSTEM-INSTALLED: CMake, cURL, Kerberos 5 (if needed), MPI libraries & compilers.
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
conda remove -y cmake curl krb5 mpi cudatoolkit cudnn nccl nccl2 --force --force-remove    # Conda required here!

"$WHICH_SNAKE" install -y libjpeg-turbo --force --force-reinstall --no-deps --clobber

mkdir -p "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
rm -f "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/ld"
rm -f "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/ld"
ln -s "$(which ld)" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
ln -s "$(which ld)" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/"

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
./portablecuda.sh
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

# FIXUPS
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
# Upgrade to latest pip version
pip install --upgrade jupyter_http_over_ws
# Fix typing deprecation
pip uninstall -y typing
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

# Install deferred extra packages
pip install --upgrade --no-deps --force --force-reinstall --pre cupy-cuda113

# Install / enable Jupyter(Lab) extensions
jupyter nbextension enable varInspector/main
jupyter nbextension enable --py neptune-notebooks
jupyter nbextension enable --py ipygany

jupyter labextension install @jupyterlab/toc --no-build
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter labextension install jupyterlab-plotly --no-build
jupyter labextension install plotlywidget --no-build
jupyter labextension install neptune-notebooks
jupyter labextension install @jupyter-widgets/jupyterlab-manager ipygany --no-build

jupyter serverextension enable --py jupyter_http_over_ws


# Jupyter Notebook/Lab upgrade and rebuild
jupyter labextension update --all
jupyter lab build

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"


# Install Nvidia APEX (with cpp & cuda extensions) with a bold, unorthodox trick
################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

# APEX (from above)
pip install --upgrade --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" git+https://github.com/NVIDIA/apex.git

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"
################################################################################
# Phew! Done! :)


# Install the entire 'PyTorch Geometric' stack with a bold, unorthodox trick (again!)
######################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

#export PTG_PREPATH="$PATH"
#export PTG_FAKEPATHDIR="$(pwd)"
#
#mkdir -p ./faketop && cd ./faketop
#
#export PATH="$PTG_FAKEPATHDIR/faketop:$PATH"
#
#ln -s $(which gcc-5) ./gcc
#ln -s $(which g++-5) ./g++
#ln -s $(which gfortran-5) ./gfortran
#
#cd ..
#
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.10.0+cu113.html --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.10.0+cu113.html --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.10.0+cu113.html --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.10.0+cu113.html --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
pip install git+https://github.com/rusty1s/pytorch_geometric.git --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
pip install git+https://github.com/benedekrozemberczki/pytorch_geometric_temporal.git --no-deps # (not yet available for PyTorch 1.10; CUDA 11.3.1)
#
#export PATH="$PTG_PREPATH"
#unset PTG_PREPATH
#rm -R -f "$PTG_FAKEPATHDIR/faketop"
#unset PTG_FAKEPATHDIR

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"
######################################################################################
# Phew! Done! :)

# Post-fix Kerberos installation
ln -s "$HOME/$ANACONDA_BASEDIR_NAME/lib/libcom_err.so.3.0" "$HOME/$ANACONDA_BASEDIR_NAME/lib/libcom_err.so.3" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/"

# Rich stack-traces
cd "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/python3.9/site-packages/"
mkdir sitecustomize
cd sitecustomize
echo "from rich.traceback import install" >> __init__.py
echo "install()" >> __init__.py

echo ""

# End
cd "$SELF_STORED_CALLDIR"
echo ' '
echo 'DONE!'
echo ' '
