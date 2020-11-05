#!/bin/bash
####################################################################################################

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDL"

# A directory with CUDA / CUDNN / NCCL installed inside, and ./lib64/ folder removed
# after having it merged with ./lib/
# A ./lib64/ folder may alternatively be present, but as a soft symlink to 'lib'
export PORTABLECUDA_ROOT="/opt/portablecuda/11.0.3/"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

####################################################################################################

# Copy CUDA / CUDNN / NCCL
cp -R -np $PORTABLECUDA_ROOT/* "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"
#ln -s "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib64"

# Link CUDNN to another common place (for Theano and the like)
mkdir -p "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/x86_64-conda_cos6-linux-gnu/sysroot/lib"
ln -s "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/libcudnn.so" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/x86_64-conda_cos6-linux-gnu/sysroot/lib/libcudnn.so"

# Copy Anaconda environment setup for CUDA / OpenMP
cp -R -f ./etc "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"
