FROM ubuntu:22.04

# Authors Jean Iaquinta
# Contact jeani@uio.no
# Version v1.0.0
#
# This is a definition file to illustrate the use of an Ubuntu22.04 container to create a virtual python environment 
# and install the packages required for TableLlama

# Update system and install basic packages
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git python3 python-is-python3 python3-venv vim && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
# Python VENV & TableLlama packages install
RUN git clone https://github.com/OSU-NLP-Group/TableLlama.git /var/tmp/TableLlama && \
    mkdir /opt/uio && \
    python -m venv /opt/uio/my_tablellama_env && \
    source /opt/uio/my_tablellama_env/bin/activate && \
    python -m pip install wheel && \
    python -m pip install -r /var/tmp/TableLlama/requirements.txt
