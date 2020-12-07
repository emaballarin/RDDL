#!/bin/bash
####################################################################################################

# The Conda-compatible package manager you want to use (currently: conda | mamba)
WHICH_SNAKE="mamba"

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDL"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

# Package path (to manually install packages in, if needed)
export PYPKG_DIR="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/python3.8/site-packages/"

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
"$WHICH_SNAKE" env create -f environment.yml
export PYTHONUSERBASE="$PRE_PYTHONUSERBASE"
unset PRE_PYTHONUSERBASE
cp -f ./dot_condarc "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/.condarc"
cp -f ./start.py "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/start.py"

####################################################################################################

# Remove Anaconda-installed CUDA & other nasty stuff (that must be system-installed, though);
# Install and overwrite (if any) libjpeg-turbo
# MUST BE SYSTEM-INSTALLED: CMake, cURL, Kerberos 5 (if needed), MPI libraries & compilers.
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
conda remove -y cmake curl krb5 mpi cudatoolkit cudnn nccl nccl2 --force --force-remove    # Conda required here!

"$WHICH_SNAKE" install -y libjpeg-turbo --force --force-reinstall --no-deps --clobber

mkdir -p "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
rm -f "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/ld"
ln -s "$(which ld)" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/compiler_compat/"
ln -s "$(which ld)" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin/"

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
./portablecuda.sh
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME


# Install deferred extra packages
pip install --upgrade --no-deps --pre hydra-core
pip install --upgrade --no-deps --pre fastai
CC="gcc -mavx2" pip install --no-cache-dir --upgrade --no-deps --force-reinstall --no-binary :all: --compile pillow-simd
pip install --upgrade --no-deps --pre cupy-cuda110
# pip install --pre lightning-grid
pip install --upgrade jupyter_http_over_ws
pip install --upgrade --no-deps --force --force-reinstall pynvml


# Install / enable Jupyter(Lab) extensions

jupyter nbextension enable varInspector/main

jupyter labextension install @jupyterlab/toc --no-build
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
jupyter labextension install jupyterlab-plotly --no-build
jupyter labextension install plotlywidget --no-build

jupyter labextension install @lckr/jupyterlab_variableinspector

jupyter serverextension enable --py jupyter_http_over_ws

jupyter lab build

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"


# Install Nvidia APEX (with cpp & cuda extensions) with a bold, unorthodox trick
################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

export PTG_PREPATH="$PATH"
export PTG_FAKEPATHDIR="$(pwd)"

mkdir -p ./faketop && cd ./faketop

export PATH="$PTG_FAKEPATHDIR/faketop:$PATH"

ln -s $(which gcc-7) ./gcc
ln -s $(which g++-7) ./g++
ln -s $(which gfortran-7) ./gfortran

cd ..

# APEX (from above)
pip install --upgrade --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" git+https://github.com/NVIDIA/apex.git

export PATH="$PTG_PREPATH"
unset PTG_PREPATH
rm -R -f "$PTG_FAKEPATHDIR/faketop"
unset PTG_FAKEPATHDIR

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"
################################################################################
# Phew! Done! :)


# Install the entire 'PyTorch Geometric' stack with a bold, unorthodox trick (again!)
######################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

export PTG_PREPATH="$PATH"
export PTG_FAKEPATHDIR="$(pwd)"

mkdir -p ./faketop && cd ./faketop

export PATH="$PTG_FAKEPATHDIR/faketop:$PATH"

ln -s $(which gcc-5) ./gcc
ln -s $(which g++-5) ./g++
ln -s $(which gfortran-5) ./gfortran

cd ..

export PRE_CUDA="$CUDA"
export CUDA="cu110"
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.7.0+cu110.html
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.7.0+cu110.html
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.7.0+cu110.html
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.7.0+cu110.html
pip install git+https://github.com/rusty1s/pytorch_geometric.git --no-deps
pip install git+https://github.com/benedekrozemberczki/pytorch_geometric_temporal.git
export CUDA="$PRE_CUDA"
unset PRE_CUDA

export PATH="$PTG_PREPATH"
unset PTG_PREPATH
rm -R -f "$PTG_FAKEPATHDIR/faketop"
unset PTG_FAKEPATHDIR

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"
######################################################################################
# Phew! Done! :)

# End
cd "$SELF_STORED_CALLDIR"
echo ' '
echo 'DONE!'
