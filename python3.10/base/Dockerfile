FROM aliyunfc/fc-runtime:python310-buster-base-v0.1

COPY commons/pip.conf /etc/pip.conf

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Create directory.
RUN mkdir -p ${FC_SERVER_LOG_PATH}

# Start a shell by default
CMD ["bash"]