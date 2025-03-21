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
RUN git clone https://github.com/Haivision/srt.git srt
RUN cd srt && ./configure
RUN cd srt && make
RUN cd srt && make install
#expose the port for srt
EXPOSE 8282

#SLS 
WORKDIR /srt-live-server
RUN git clone https://github.com/PowerIRL/srt-live-server.git srt-live-server
RUN cd srt-live-server && make
RUN cd srt-live-server && mv sls.sh ../sls.sh
# run the server
CMD ["sls.sh"]
EXPOSE 8181
