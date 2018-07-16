FROM aliyunfc/runtime-nodejs8:base

WORKDIR /code

RUN apt-get install -y vim \ 
    cmake \
    zip \
    clang \
    build-essential \
    libgmp3-dev \
    python2.7-dev 

CMD ["npm", "rebuild"]
