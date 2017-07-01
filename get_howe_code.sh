
#### Howe Code ####
# remove existing zip file if present
rm -f IJDAR-Binarization.zip

# download the code
wget http://www.cs.smith.edu/~nhowe/research/code/IJDAR-Binarization.zip

# unzip it into the current dir
unzip -o IJDAR-Binarization.zip

#### Max Flow Code ####
rm -f maxflow-v3.04.src.zip
wget http://pub.ist.ac.at/~vnk/software/maxflow-v3.04.src.zip
unzip -o maxflow-v3.04.src.zip
mv maxflow-v3.04.src/*.cpp maxflow-v3.04.src/*.h  maxflow-v3.04.src/*.inc  .
rm -r maxflow-v3.04.src

sed -i 's/int \*dim/mwSize \*dim/g' *.cpp

mex imgcut3.cpp graph.cpp maxflow.cpp
mex imgcutmulti.cpp graph.cpp maxflow.cpp

# remove files not needed to run dibco eval
rm demo.m binarizeImageAlg3.m license.txt *.cpp *.h *.inc sample.jpg README.txt *.zip

