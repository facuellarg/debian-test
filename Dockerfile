# Use the Debian base image
#FROM debian:bullseye-slim
#RUN zlib-flate -version
FROM debian:bookworm-20240513-slim

# Specify the zlib version you want to install
ARG ZLIB_VERSION=1.3.1
ARG PYTHON_VERSION=3.9.18

# Install necessary build tools, libraries, and Python
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    curl \
    libssl-dev \
    libffi-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libgdbm-dev \
    liblzma-dev \
    tk-dev \
    build-essential \
    checkinstall \
    zlib1g-dev \
    libatlas-base-dev \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    && apt-get clean


# Download and compile the specified version of zlib
RUN wget http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz && \
    tar -xzvf zlib-${ZLIB_VERSION}.tar.gz && \
    cd zlib-${ZLIB_VERSION} && \
    ./configure --prefix=/usr/local/zlib-${ZLIB_VERSION} && \
    make && \
    make install

# Clean up
RUN rm -rf zlib-${ZLIB_VERSION} zlib-${ZLIB_VERSION}.tar.gz

ENV LD_LIBRARY_PATH=/usr/local/zlib-${ZLIB_VERSION}/lib:$LD_LIBRARY_PATH
ENV CPATH=/usr/local/zlib-${ZLIB_VERSION}/include:$CPATH
ENV LIBRARY_PATH=/usr/local/zlib-${ZLIB_VERSION}/lib:$LIBRARY_PATH

# Verify installation
RUN ldconfig  

# Download and compile the specified version of Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make altinstall

# Clean up Python source
RUN rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz


# Verify installation of zlib
RUN python3.9 -c "import zlib; print('zlib version:', zlib.ZLIB_VERSION)"

# Default command
CMD ["sh"]

