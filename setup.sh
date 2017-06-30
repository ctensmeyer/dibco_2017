#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export CAFFE_ROOT=/opt/caffe_waldol1

apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-opencv \
        python-pip \
        python-scipy \
        libpng12-dev \
        libblas-dev \
        libfreetype6-dev \
        liblapack-dev \
        unzip

pip install -U cython
pip install git+https://github.com/lucasb-eyer/pydensecrf.git

mkdir $CAFFE_ROOT
pushd $CAFFE_ROOT

git clone --depth 1 https://github.com/waldol1/caffe.git .
for req in $(cat python/requirements.txt) pydot; do
    pip install $req
done

mkdir build && cd build && \
cmake -DCPU_ONLY=1 .. && \
make -j"$(nproc)"

export PYCAFFE_ROOT=$CAFFE_ROOT/python
export PYTHONPATH=$PYCAFFE_ROOT:$PYTHONPATH
export PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

popd

./get_howe_code.sh

