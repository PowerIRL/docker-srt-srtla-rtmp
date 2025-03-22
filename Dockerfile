#install ubuntu as base image
FROM ubuntu:24.10
#updates packages/upgrades
RUN apt-get update -y
RUN apt-get upgrade -y
#install dependencies
RUN apt-get install tclsh -y
RUN apt-get install pkg-config -y
RUN apt-get install cmake -y
RUN apt-get install libssl-dev -y 
RUN apt-get install build-essential -y
RUN apt-get install zlib1g-dev -y
RUN apt-get install git -y
#clean up the apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
#set a working directory
WORKDIR /srt
#clone the srt repository from GitHub
RUN git clone https://github.com/Haivision/srt.git .
RUN ./configure
RUN make -j${nproc}
RUN make install
#SLS 
WORKDIR /srt-live-server
RUN git clone https://github.com/PowerIRL/srt-live-server.git .
RUN make -j${nproc}
RUN chmod +x /srt-live-server/bin/sls
# Update the linker cache to find shared libraries
RUN ldconfig
# Set the LD_LIBRARY_PATH environment variable
ENV LD_LIBRARY_PATH=/usr/local/lib
# Expose the necessary ports
EXPOSE 8282
EXPOSE 8181
# Set the default command to run the SRT Live Server
CMD ["/srt-live-server/bin/sls", "-c", "/srt-live-server/sls.conf"]