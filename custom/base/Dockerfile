# aliyunfc/fc-runtime:custom-stretch-base see commons directory
FROM aliyunfc/fc-runtime:custom-stretch-base

ENV FC_SERVER_PORT=9000 \
    FC_FUNC_CODE_PATH=/code

ENV PYTHONPATH=/code

ENV BOOTSTRAP_FILE=bootstrap

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]