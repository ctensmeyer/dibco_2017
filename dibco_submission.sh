#!/bin/bash

export CAFFE_ROOT=/opt/caffe_waldol1
export PYCAFFE_ROOT=$CAFFE_ROOT/python
export PYTHONPATH=$PYCAFFE_ROOT:$PYTHONPATH
export PATH=$CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH

./dibco_submission.py "$@"

