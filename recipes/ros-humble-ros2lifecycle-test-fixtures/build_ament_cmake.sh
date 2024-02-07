# Generated by vinca http://github.com/RoboStack/vinca.
# DO NOT EDIT!

rm -rf build
mkdir build
cd build

# necessary for correctly linking SIP files (from python_qt_bindings)
export LINK=$CXX

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  PYTHON_EXECUTABLE=$PREFIX/bin/python
  PKG_CONFIG_EXECUTABLE=$PREFIX/bin/pkg-config
  OSX_DEPLOYMENT_TARGET="10.15"
else
  PYTHON_EXECUTABLE=$BUILD_PREFIX/bin/python
  PKG_CONFIG_EXECUTABLE=$BUILD_PREFIX/bin/pkg-config
  OSX_DEPLOYMENT_TARGET="11.0"
fi

echo "USING PYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}"
echo "USING PKG_CONFIG_EXECUTABLE=${PKG_CONFIG_EXECUTABLE}"

export ROS_PYTHON_VERSION=`$PYTHON_EXECUTABLE -c "import sys; print('%i.%i' % (sys.version_info[0:2]))"`
echo "Using Python ${ROS_PYTHON_VERSION}"
echo "Using site-package dir ${SP_DIR}"

# see https://github.com/conda-forge/cross-python-feedstock/issues/24
if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  find $PREFIX/lib/cmake -type f -exec sed -i "s~\${_IMPORT_PREFIX}/lib/python${ROS_PYTHON_VERSION}/site-packages~${BUILD_PREFIX}/lib/python${ROS_PYTHON_VERSION}/site-packages~g" {} + || true
  find $PREFIX/share/rosidl* -type f -exec sed -i "s~$PREFIX/lib/python${ROS_PYTHON_VERSION}/site-packages~${BUILD_PREFIX}/lib/python${ROS_PYTHON_VERSION}/site-packages~g" {} + || true
  find $PREFIX/share/rosidl* -type f -exec sed -i "s~\${_IMPORT_PREFIX}/lib/python${ROS_PYTHON_VERSION}/site-packages~${BUILD_PREFIX}/lib/python${ROS_PYTHON_VERSION}/site-packages~g" {} + || true
  find $PREFIX/lib/cmake -type f -exec sed -i "s~message(FATAL_ERROR \"The imported target~message(WARNING \"The imported target~g" {} + || true
fi

if [[ $target_platform =~ linux.* ]]; then
    export CFLAGS="${CFLAGS} -D__STDC_FORMAT_MACROS=1"
    export CXXFLAGS="${CXXFLAGS} -D__STDC_FORMAT_MACROS=1"
fi;

# Needed for qt-gui-cpp ..
if [[ $target_platform =~ linux.* ]]; then
  ln -s $GCC ${BUILD_PREFIX}/bin/gcc
  ln -s $GXX ${BUILD_PREFIX}/bin/g++
fi;

cmake \
    -G "Ninja" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DCMAKE_PREFIX_PATH=$PREFIX \
    -DAMENT_PREFIX_PATH=$PREFIX \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_BUILD_TYPE=Release \
    -DPYTHON_EXECUTABLE=$PYTHON_EXECUTABLE \
    -DPython_EXECUTABLE=$PYTHON_EXECUTABLE \
    -DPython3_EXECUTABLE=$PYTHON_EXECUTABLE \
    -DPython3_FIND_STRATEGY=LOCATION \
    -DPKG_CONFIG_EXECUTABLE=$PKG_CONFIG_EXECUTABLE \
    -DPYTHON_INSTALL_DIR=$SP_DIR \
    -DSETUPTOOLS_DEB_LAYOUT=OFF \
    -DCATKIN_SKIP_TESTING=$SKIP_TESTING \
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
    -DBUILD_SHARED_LIBS=ON  \
    -DBUILD_TESTING=OFF \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=$OSX_DEPLOYMENT_TARGET \
    $SRC_DIR/$PKG_NAME/src/work

cmake --build . --config Release --target install
