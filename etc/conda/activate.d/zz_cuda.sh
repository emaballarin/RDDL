#!/bin/bash

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDL"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

# Backup variables
export PRE_PATH="$PATH"
export PRE_CPATH="$CPATH"
export PRE_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PRE_CUDA_HOME="$CUDA_HOME"
export PRE_CUDA_ROOT="$CUDA_ROOT"
export PRE_CUDA_PATH="$CUDA_PATH"
export PRE_HOROVOD_CUDA_HOME="$HOROVOD_CUDA_HOME"
export PRE_HOROVOD_CUDA_INCLUDE="$HOROVOD_CUDA_INCLUDE"
export PRE_HOROVOD_CUDA_LIB="$HOROVOD_CUDA_LIB"
export PRE_HOROVOD_GPU_ALLREDUCE="$HOROVOD_GPU_ALLREDUCE"
export PRE_HOROVOD_NCCL_HOME="$HOROVOD_NCCL_HOME"
export PRE_HOROVOD_NCCL_INCLUDE="$HOROVOD_NCCL_INCLUDE"
export PRE_HOROVOD_NCCL_LIB="$HOROVOD_NCCL_LIB"
export PRE_PYTHONUSERBASE="$PYTHONUSERBASE"
export PRE_MKL_THREADING_LAYER="$MKL_THREADING_LAYER"
export PRE_MKL_SERVICE_FORCE_INTEL="$MKL_SERVICE_FORCE_INTEL"
export PRE_PYTHONSTARTUP="$PYTHONSTARTUP"

# Inject variables
export CUDA_HOME="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/"
export CUDA_ROOT="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/"
export CUDA_PATH="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/"
export CPATH="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/include:$CPATH"
export PATH="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib:$LD_LIBRARY_PATH"
export HOROVOD_CUDA_HOME="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"
export HOROVOD_CUDA_INCLUDE="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/include"
export HOROVOD_CUDA_LIB="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib"
export HOROVOD_GPU_ALLREDUCE="NCCL"
export HOROVOD_NCCL_HOME="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"
export HOROVOD_NCCL_INCLUDE="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/include"
export HOROVOD_NCCL_LIB="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib"
export PYTHONUSERBASE="$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME"

export MKL_THREADING_LAYER="INTEL"
export MKL_SERVICE_FORCE_INTEL="1"

export PYTHONSTARTUP="$CONDA_PREFIX/start.py"
