FROM jupyter/scipy-notebook

LABEL maintainer="Dmitry Prokhorov <dipspb@gmail.com>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install octamap from sources because apt package version is outdated a lot
RUN cd /tmp && \
    git clone https://github.com/OctoMap/octomap.git && \
    cd octomap && \
    git checkout v1.8.1 && \
    mkdir build && cd build && \
    cmake .. && \
    make && make install && \
    cd .. && rm -rf octomap && \
    ldconfig

# Install python-octamap which does not have a pip or conda package at the moment
RUN cd /tmp && \
    export CPATH=/opt/conda/lib/python3.6/site-packages/numpy/core/include/ ; \
    pip install git+https://github.com/neka-nat/python-octomap.git \
    # pip install git+https://github.com/dipspb/python-octomap.git@octomap18-api-fix \
    && \
    fix-permissions $CONDA_DIR
