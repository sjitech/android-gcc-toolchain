#https://github.com/sjitech/ubuntu-non-root-with-utils/blob/master/Dockerfile
FROM osexp2000/ubuntu-non-root-with-utils

RUN sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get -y install \
        ccache

ENV PATH=$PATH:/home/devuser/ndk/prebuilt/linux-x86_64/bin:/home/devuser/ndk:/home/devuser/android-gcc-toolchain
ENV NDK=/home/devuser/ndk
ENV USE_CCACHE=1

RUN ccache -M 50G && \
    echo "Downloading NDK" >&2 && \
    wget https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip --no-verbose && \
    echo "Decompressing NDK" >&2 && \
    bash -c "7z x android-ndk-r12b-linux-x86_64.zip | grep -vE '^Extracting|^$'; exit \${PIPESTATUS[0]}" && \
    rm android-ndk-r12b-linux-x86_64.zip && \
    mv android-ndk-r12b ndk && \
    git clone https://github.com/sjitech/android-gcc-toolchain -b master --single-branch && \
    android-gcc-toolchain which gcc && \
    echo "Compressing platforms/android-*/arch-*/usr/* of \$NDK to \$NDK/platforms.7z" >&2 && \
    bash -c "cd $NDK && 7z a platforms.7z platforms/android-*/arch-*/usr/ | grep -vE '^Compressing|^$'; exit \${PIPESTATUS[0]}" && \
    echo "Removing platforms/android-*/arch-*/usr/* of \$NDK" >&2 && \
    (cd $NDK/platforms && rm -fr android-*/arch-*/usr/)

ENTRYPOINT ["android-gcc-toolchain"]
