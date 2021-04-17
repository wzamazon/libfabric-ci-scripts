#!/bin/bash

os_name="$(. /etc/os-release; echo $NAME)"
if [  "$os_name" == "Ubuntu" ]; then
    sudo apt-get install -y "g++"
elif [ "$os_name" == "openSUSE Leap" ] || [ "$os_name" == "SLES" ]; then
    sudo zypper install -y "gcc-c++"
else
    sudo yum install -y "gcc-c++"
fi

NCCL_VERSION="v2.8.3-1"
cd $HOME
git clone -b ${NCCL_VERSION} https://github.com/NVIDIA/nccl.git
pushd nccl
make -j src.build CUDA_HOME=/usr/local/cuda NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80"
if [ $? -ne 0 ]; then
    echo "NCCL build failed!"
    exit -1
fi
popd

echo "export LD_LIBRARY_PATH=$HOME/nccl/build/lib/:\$LD_LIBRARY_PATH" >> ~/.bash_profile
echo "export LD_LIBRARY_PATH=$HOME/nccl/build/lib/:\$LD_LIBRARY_PATH" >> ~/.bashrc
