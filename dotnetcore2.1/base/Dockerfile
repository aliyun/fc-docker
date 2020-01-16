FROM mcr.microsoft.com/dotnet/core/runtime-deps:2.1-stretch-slim

MAINTAINER alibaba-serverless-fc

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Install ASP.NET Core
ENV ASPNETCORE_VERSION 2.1.7

RUN curl -SL --output aspnetcore.tar.gz https://dotnetcli.blob.core.windows.net/dotnet/aspnetcore/Runtime/$ASPNETCORE_VERSION/aspnetcore-runtime-$ASPNETCORE_VERSION-linux-x64.tar.gz \
    && aspnetcore_sha512='feef7cf9e296011b799b196f3f7cec93e685e5e1b981238064d934bc003eebc75a10567db3af02384c68000ce1d0a64f769928f6b91392934acdacb008c238ad' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf aspnetcore.tar.gz -C /usr/share/dotnet \
    && rm aspnetcore.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libc6-dev=2.24-11+deb9u4 \
       libgdiplus=4.2-1+b1  \
    && rm -rf /var/lib/apt/lists/

# Environment variables.
ARG FC_RUNTIME_PATH=/var/fc/runtime

ENV FC_SERVER_PATH=/var/fc/runtime/dotnetcore2.1 \
    FC_SERVER_PORT=9000
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=info

ENV FC_FUNC_CODE_PATH=/code/ \
    FC_RUNTIME_ROOT_PATH=${FC_SERVER_PATH}/bootstrap \
    FC_RUNTIME_SYSTEM_PATH=${FC_SERVER_PATH}

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}lib:${FC_FUNC_CODE_PATH}runtimes/linux-x64/native \
    PATH=${FC_FUNC_CODE_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create function directories.
RUN mkdir -p \
    ${FC_FUNC_CODE_PATH} \
    ${FC_RUNTIME_ROOT_PATH} \
    ${FC_RUNTIME_SYSTEM_PATH}

# Change work directory.
WORKDIR ${FC_SERVER_PATH}

RUN mkdir -p ${FC_SERVER_LOG_PATH}
RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

# Generate usernames
RUN for i in $(seq 10000 10999); do \
        echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

ENV SystemLogLevel=TRACE
ENV FcDotnetHttpUseLiteServer=true

# fix the dotnetcore2.1's bug on System.Net.HttpListener.dll. Once it's offically released, remove it.
COPY commons/System.Net.HttpListener.dll /usr/share/dotnet/shared/Microsoft.NETCore.App/2.1.7

# Start a shell by default
CMD ["bash"]