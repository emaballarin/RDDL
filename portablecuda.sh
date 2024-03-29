#!/usr/bin/bash
####################################################################################################

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDLean"

# A directory with CUDA / CUDNN / NCCL installed inside, and ./lib64/ folder removed
# after having it merged with ./lib/
export PORTABLECUDA_ROOT="$RDDL_PORTABLECUDA_ROOT/portablecuda/11.6.2/"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

####################################################################################################

# Copy CUDA / CUDNN / NCCL
cp -R -np $PORTABLECUDA_ROOT/* "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"

# Link CUDNN to another common place (for Theano and the like)
mkdir -p "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/x86_64-conda_cos6-linux-gnu/sysroot/lib"
ln -s "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/libcudnn.so" "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/x86_64-conda_cos6-linux-gnu/sysroot/lib/libcudnn.so"

# Copy Anaconda environment setup for CUDA / OpenMP
cp -R -f ./etc "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"

# Fix a new Anaconda-CUDA quirk
sed -i 's@__SUB__THIS__@'"$PORTABLECUDA_ROOT"'@' "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/etc/conda/activate.d/zz_cuda.sh"
