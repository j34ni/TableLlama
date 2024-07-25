FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Authors Jean Iaquinta
# Contact jeani@uio.no
# Version v1.0.2
#
# This is a definition file to illustrate the use of a Cuda12.1 Ubuntu22.04 container to create a virtual python environment 
# and install the packages required for TableLlama

# Update system and install basic packages
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git openssh-client patch python3 python-is-python3 python3-venv vim wget && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.patch /opt/uio/requirements.patch
SHELL ["/bin/bash", "-c"]
# Python VENV & TableLlama packages install
RUN git clone https://github.com/OSU-NLP-Group/TableLlama.git /var/tmp/TableLlama && \
    patch -u /var/tmp/TableLlama/requirements.txt -i /opt/uio/requirements.patch && \
    python -m venv /opt/uio/my_tablellama_env && \
    source /opt/uio/my_tablellama_env/bin/activate && \
    python -m pip install wheel && \
    python -m pip install -r /var/tmp/TableLlama/requirements.txt && \
    python -m pip install flash-attn --no-build-isolation && \
    rm -rf /var/tmp/TableLlama /opt/uio/requirements.patch

# Git extension for versioning large files
RUN wget -q -nc --no-check-certificate -P /var/tmp https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz && \
    tar -x -f /var/tmp/git-lfs-linux-amd64-v3.5.1.tar.gz -C /var/tmp -z && \
    cd /var/tmp/git-lfs-3.5.1 && \
    ./install.sh && \
    git lfs install && \
    rm -rf /var/tmp/git-lfs-linux-amd64-v3.5.1.tar.gz /var/tmp/git-lfs-3.5.1
