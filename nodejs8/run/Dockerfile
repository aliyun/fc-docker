FROM aliyunfc/runtime-nodejs8:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/tmp/nodejs8.tgz | tar -zx -C /

# nodejs8 directory structure is same with nodejs6
RUN cp -r /var/fc/runtime/nodejs6/* /var/fc/runtime/nodejs8/

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs8/mock.sh

ENTRYPOINT ["/var/fc/runtime/nodejs8/mock.sh"]
