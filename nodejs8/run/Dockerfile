FROM aliyunfc/runtime-nodejs8:build

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/tmp/nodejs8.tgz | tar -zx -C /

RUN cp -r /var/fc/runtime/nodejs6/* /var/fc/runtime/nodejs8/

# nodejs8 directory structure is same with nodejs6
COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs8/mock.sh

ENTRYPOINT ["/var/fc/runtime/nodejs8/mock.sh"]
