FROM debian:buster as build

ARG build_threads="4"
ARG tdlib_tag="v1.5.0"

RUN apt-get update \
    && apt-get install -y \
        clang \
        cmake \
        git \
        gperf \
        libc++-dev \
        libc++abi-dev \
        libssl-dev \
        make \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/cache/*

RUN git clone --branch=${tdlib_tag} --depth=1 https://github.com/tdlib/td.git \
    && cd td \
    && mkdir build \
    && cd build \
    && CXXFLAGS="-stdlib=libc++" \
    && CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/var/build/tdlib .. \
    && cmake -j${build_threads} --build . \
    && make -j${build_threads} install

FROM scratch
COPY --from=build /var/build/tdlib /tdlib
