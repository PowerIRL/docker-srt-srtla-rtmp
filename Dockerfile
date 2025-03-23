FROM ubuntu:latest
# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake pkg-config git \
    libssl-dev libprotobuf-dev protobuf-compiler \
    libgoogle-perftools-dev libcurl4-openssl-dev \
    libjson-c-dev libmicrohttpd-dev && \
    rm -rf /var/lib/apt/lists/*
# Set working directory
WORKDIR /opt
# Install SRT
RUN git clone --depth 1 https://github.com/Haivision/srt.git && \
    cd srt && \
    mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install && \
    ldconfig
# Install SRT-live-server (SLS)
RUN git clone --depth 1 https://github.com/PowerIRL/srt-live-server.git && \
    cd srt-live-server && \
    mkdir -p logs && \
    make -j$(nproc)
# Install SRTLA
RUN git clone --depth 1 https://github.com/BELABOX/srtla.git && \
    cd srtla && \
    make
# Expose necessary ports
# EXPOSE 8282 8181 5000
# Set working directory to where sls binary is located
# WORKDIR /opt/srt-live-server/bin
# # Run SLS with config file
# # CMD ["./sls", "-c", "/opt/srt-live-server/sls.conf"]
