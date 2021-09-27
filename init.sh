#!/bin/bash
####################################################################################################

# The Conda-compatible package manager you want to use (currently: conda | mamba)
WHICH_SNAKE="mamba"
#WHICH_SNAKE="conda"

# The name of the Conda environment you want the script to operate on.
export ANACONDA_ENV_NAME="RDDL"

# The name of the (in-home, i.e. ~/) directory in which [Ana|Mini]conda is installed.
export ANACONDA_BASEDIR_NAME="anaconda3"

# A directory with CUDA / CUDNN / NCCL installed inside, and ./lib64/ folder removed
# after having it merged with ./lib/
export PORTABLECUDA_ROOT="$RDDL_PORTABLECUDA_ROOT/portablecuda/11.1.105/"

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
mkdir -p "$PYTHONUSERBASE/etc"
cp -R -f ./etc "$PYTHONUSERBASE"
sed -i 's@__SUB__THIS__@'"$PORTABLECUDA_ROOT"'@' "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/etc/conda/activate.d/zz_cuda.sh"
cp -f ./dot_condarc "$PYTHONUSERBASE/.condarc"
cp -f ./start.py "$PYTHONUSERBASE/start.py"
"$WHICH_SNAKE" env create -f environment.yml
export PYTHONUSERBASE="$PRE_PYTHONUSERBASE"
unset PRE_PYTHONUSERBASE

# Dependency fixups (2)
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
pip install -U fastapi starlette bayesian-optimization
pip install --upgrade --no-deps watchdog PyJWT
pip install --upgrade --no-deps --force jedi==0.18.0
pip install --upgrade --no-deps --force git+https://github.com/maciejkula/spotlight.git
pip install --upgrade --no-deps --force pytorch_resample
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

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

# TensorFlow (as self-contained as possible!)
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
###
pip install --upgrade jupyter_http_over_ws
pip install keras-preprocessing
pip install tensorflow
pip install tensorflow-estimator
pip install keras-tuner
pip install autokeras
pip install tensorflow-metadata
pip install tensorflow_probability
pip install tensorflow-addons
#pip install waymo-open-dataset-tf-2-3-0
pip install model-pruning-google-research
pip install tensorflow-datasets
#pip install lingvo
pip install dm-reverb
pip install tf-agents
pip install dm-sonnet
pip install trfl
pip install dm-acme
pip install graph_nets
pip install contextlib2
pip install ml_collections
pip install neural-structured-learning
pip install tensorflow-io
pip install tensorflow-lattice
pip install tensorflow_hub
pip install tensorflow-gan
pip install tf_slim
pip install git+https://github.com/google/dopamine.git
pip install git+https://github.com/deepmind/jaxline
pip install git+https://github.com/onnx/onnx-tensorflow.git
pip install git+https://github.com/onnx/tensorflow-onnx.git
pip install neptune-tensorboard
###
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

# STUFF REQUIRING typing UNINSTALL (Python >=3.8)
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME
# Fix typing deprecation
pip uninstall -y typing
# (Nengo stuff)
pip install git+https://github.com/nengo/keras-spiking.git
pip install git+https://github.com/nengo/nengo-dl.git
pip install git+https://github.com/nengo/keras-lmu.git
pip install git+https://github.com/nengo/nengo-spa.git
#
# (Wesselb cyclical deps)
pip install \
git+https://github.com/wesselb/matrix.git \
git+https://github.com/wesselb/wbml.git \
git+https://github.com/wesselb/stheno.git \
git+https://github.com/wesselb/varz.git
# (Wesselb toposort deps)
pip install git+https://github.com/wesselb/psa.git
pip install git+https://github.com/wesselb/gpcm.git
pip install git+https://github.com/wesselb/gpar.git
#
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"

####################################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME


# Install TensorAnnotations
pip install git+https://github.com/deepmind/tensor_annotations
pip install 'git+https://github.com/deepmind/tensor_annotations#egg=jax-stubs&subdirectory=jax-stubs'
pip install 'git+https://github.com/deepmind/tensor_annotations#egg=tensorflow-stubs&subdirectory=tensorflow-stubs'


# Install deferred extra packages
pip install --upgrade --no-deps --pre hydra-core
pip install --upgrade --no-deps --pre fastai
CC="gcc -mavx2" pip install --no-cache-dir --upgrade --no-deps --force-reinstall --no-binary :all: --compile pillow-simd
pip install --upgrade --no-deps --pre cupy-cuda111
pip install --upgrade --no-deps git+https://github.com/ElementAI/baal.git
pip install --upgrade --no-deps --force --force-reinstall pynvml
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/tensorwerk/hangar-py.git
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/emaballarin/stockroom.git
pip install --upgrade --no-deps --force pyrser
pip install --upgrade --no-deps --force git+https://github.com/aimhubio/aimrecords.git
pip install --upgrade --no-deps --force git+https://github.com/aimhubio/aim.git
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/PyTorchLightning/lightning-flash.git
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/PyTorchLightning/lightning-transformers.git
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/FrancescoSaverioZuppichini/glasses.git
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/huggingface/datasets.git
pip install --upgrade --no-deps --force --force-reinstall sacremoses tokenizers transformers
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/huggingface/nn_pruning.git
pip install --upgrade --no-deps --force --force-reinstall https://ballarin.cc/mirrorsrv/tinydfa/tinydfa.zip
pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/thu-ml/tianshou.git
#pip install --upgrade --no-deps --force --force-reinstall git+https://github.com/CalculatedContent/WeightWatcher.git
MARCH_NATIVE=1 OPENMP_FLAG="-fopenmp" pip install git+https://github.com/cvxgrp/diffcp.git
pip install git+https://github.com/cvxgrp/cvxpylayers.git
pip install --upgrade --no-deps git+https://github.com/bethgelab/imagecorruptions.git
pip install --upgrade --no-deps git+https://github.com/bethgelab/foolbox.git
pip install --upgrade --no-deps git+https://github.com/pytorch/ort.git
pip install --upgrade --no-deps pytorchfi

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

pip install --upgrade --no-deps --force --force-reinstall lckr-jupyterlab-variableinspector

jupyter serverextension enable --py jupyter_http_over_ws


# Jupyter Notebook/Lab upgrade and rebuild
jupyter labextension update --all
jupyter lab build

source "$HOME/$ANACONDA_BASEDIR_NAME/bin/deactivate"


# Install Nvidia APEX (with cpp & cuda extensions) with a bold, unorthodox trick
################################################################################
source "$HOME/$ANACONDA_BASEDIR_NAME/bin/activate" $ANACONDA_ENV_NAME

#export PTG_PREPATH="$PATH"
#export PTG_FAKEPATHDIR="$(pwd)"
#
#mkdir -p ./faketop && cd ./faketop
#
#export PATH="$PTG_FAKEPATHDIR/faketop:$PATH"
#
#ln -s $(which gcc-7) ./gcc
#ln -s $(which g++-7) ./g++
#ln -s $(which gfortran-7) ./gfortran
#
#cd ..

# APEX (from above)
pip install --upgrade --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" git+https://github.com/NVIDIA/apex.git

#export PATH="$PTG_PREPATH"
#unset PTG_PREPATH
#rm -R -f "$PTG_FAKEPATHDIR/faketop"
#unset PTG_FAKEPATHDIR
#
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
#export PRE_CUDA="$CUDA"
#export CUDA="cu111"
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.9.0+cu111.html --no-deps
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.9.0+cu111.html --no-deps
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.9.0+cu111.html --no-deps
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.9.0+cu111.html --no-deps
pip install git+https://github.com/rusty1s/pytorch_geometric.git --no-deps
pip install git+https://github.com/benedekrozemberczki/pytorch_geometric_temporal.git --no-deps
#export CUDA="$PRE_CUDA"
#unset PRE_CUDA
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
cd "$HOME/$ANACONDA_BASEDIR_NAME/envs/$ANACONDA_ENV_NAME/lib/python3.8/site-packages/"
mkdir sitecustomize
cd sitecustomize
echo "from rich.traceback import install" >> __init__.py
echo "install()" >> __init__.py

echo ""
echo "If you want compatibility with Microsoft DeepSpeed, just run the following"
echo "in the newly-created Conda environment."
echo "------------------------------------------"
# echo "pip install mpi4py"
echo "pip install triton"
# echo "pip install ninja"
echo "pip install --upgrade deepspeed"
echo "pip install --upgrade tensorboardx==2.2"
# echo "pip install --upgrade ninja"
echo "------------------------------------------"
echo ""

# End
cd "$SELF_STORED_CALLDIR"
echo ' '
echo 'DONE!'
echo ' '
#echo ' '
#echo 'NOTE: You may need to rebuild JupyterLab upon first start!'
#echo ' '
