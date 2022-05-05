# aliyunfc/fc-runtime:python27-stretch-base see commons directory
FROM aliyunfc/fc-runtime:python27-stretch-base

COPY commons/pip.conf /etc/pip.conf

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python2.7
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# Create directory.
RUN mkdir -p ${FC_SERVER_LOG_PATH}
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

# Start a shell by default
CMD ["bash"]

