FROM quay.io/pypa/manylinux2014_x86_64

RUN yum install -y git zlib-devel
WORKDIR /root
ARG CONDA_PREFIX=/opt/conda
# Install the latest CMake
RUN curl -L https://github.com/Kitware/CMake/releases/download/v3.16.3/cmake-3.16.3.tar.gz -o cmake-3.16.3.tar.gz \
    && tar xfz cmake-3.16.3.tar.gz \
    && rm cmake-3.16.3.tar.gz \
    && cd cmake-3.16.3 \
    && ./bootstrap -- -DCMAKE_USE_OPENSSL=OFF \
    && make \
    && make install
# Install the latest boost library
RUN curl -L https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz -o boost-1.72.0.tar.gz \
    && tar xfz boost-1.72.0.tar.gz \
    && rm boost-1.72.0.tar.gz \
    && cd boost_1_72_0 \
    && ./bootstrap.sh --help \
    && ./bootstrap.sh --without-icu --with-libraries=headers --prefix=/usr/local \
    && ./b2 install
#
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
#
ENTRYPOINT ["/entrypoint.sh"]
