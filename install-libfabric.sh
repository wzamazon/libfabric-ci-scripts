echo "==> Building libfabric"
# Pulls the libfabric repository and checks out the pull request commit
cd ${HOME}
git clone https://github.com/ofiwg/libfabric
cd ${HOME}/libfabric
git fetch origin +refs/pull/$PULL_REQUEST_ID/*:refs/remotes/origin/pr/$PULL_REQUEST_ID/*
git checkout $PULL_REQUEST_REF -b PRBranch
./autogen.sh
./configure --prefix=${HOME}/libfabric/install/ \
    --enable-debug  \
    --enable-mrail  \
    --enable-tcp    \
    --enable-rxm    \
    --disable-rxd   \
    --disable-verbs
make -j 4
make install
LIBFABRIC_INSTALL_PATH=${HOME}/libfabric/install