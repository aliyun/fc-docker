ARG TAG="build"
FROM aliyunfc/runtime-nodejs10:${TAG}

# 删掉了libmaxminddb-dev \
# 修改了libxml-dev -> libxml2-dev
# libxslt-dev -> libxslt1-dev
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apt-utils \
	    ca-certificates \
        curl \
        netbase \
        wget \
        bzr \
        git \
        mercurial \
        openssh-client \
        subversion \
        procps \
		autoconf \
		automake \
		bzip2 \
		dpkg-dev \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libgmp-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libpng12-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt1-dev \
		libyaml-dev \
		make \
		patch \
		unzip \
		xz-utils \
		zlib1g-dev \
		\
# https://lists.debian.org/debian-devel-announce/2016/09/msg00000.html
		$( \
# if we use just "apt-cache show" here, it returns zero because "Can't select versions from package 'libmysqlclient-dev' as it is purely virtual", hence the pipe to grep
			if apt-cache show 'default-libmysqlclient-dev' 2>/dev/null | grep -q '^Version:'; then \
				echo 'default-libmysqlclient-dev'; \
			else \
				echo 'libmysqlclient-dev'; \
			fi \
		) \
	; \
    if ! command -v gpg > /dev/null; then \
        apt-get install -y --no-install-recommends \
            gnupg \
            dirmngr \
        ; \
    fi \
    && apt-get install -yq \
        asciidoctor \
        bash-completion \
        build-essential \
        htop \
        jq \
        iputils-ping \
        net-tools \
        lsof \
        less \
        locales \
        man-db \
        nano \
        software-properties-common \
        sudo \
        vim \
        tree \
        multitail \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
ENV LANG=en_US.UTF-8

#RUN echo "export PS1='\n\e[1;37m[\e[m\e[1;32m\u\e[m\e[1;33m@\e[m\e[1;35m\h\e[m \e[4m`pwd`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\$'" >> /root/.bashrc && \
RUN curl --connect-timeout 5 -s -o /usr/bin/ossutil "http://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/ossutil/ossutil" && \
    chmod 755 /usr/bin/ossutil && \
    rm -rf /bin/sh && \
    ln -s /bin/bash /bin/sh


#COPY etc_profile /etc/profile
#COPY skel_bashrc /etc/skel/.bashrc


## User account
RUN adduser --disabled-password --gecos '' admin && \
    adduser admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## time zone set
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

COPY cxinit.sh /usr/sbin/cxinit

# 修复 vim 导致的 terminal 出现 2R 问题
RUN echo "set t_u7=" > /home/admin/.vimrc

# 以下为standardone-ide的集成代码
RUN curl -s http://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/nvm/nvm.tgz | tar -x && \
    mv nvm /home/admin/.nvm && \
    mv tnvm /home/admin/.tnvm

ENV CXAPP=standardaone-ide

RUN ln -s /usr/sbin/cxinit /usr/sbin/standardaone-ide

#ENTRYPOINT ["/usr/sbin/standardaone-ide"]

USER admin

VOLUME /home/admin/.cide /home/admin/workspace

WORKDIR /home/admin/workspace

ENV CXAPP_HOME=/home/admin/${CXAPP} IDE_NODE_VERSION=v12.14.1

RUN sudo chown admin:admin /home/admin -R && \
    echo "export LANG=en_US.UTF-8" >> /home/admin/.bashrc && \
    echo "export MAN_DISABLE_SECCOMP=1" >> /home/admin/.bashrc && \
    echo 'source /home/admin/.nvm/nvm.sh' >> /home/admin/.bashrc && \
    echo 'source /home/admin/.tnvm/tnvm.sh' >> /home/admin/.bashrc && \
    source /home/admin/.bashrc && \
    cat /home/admin/.bashrc && \
    source /home/admin/.tnvm/tnvm.sh && \
    source /home/admin/.nvm/nvm.sh && \
    tnvm install node-${IDE_NODE_VERSION} && tnvm use node-${IDE_NODE_VERSION} && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install -g yarn

RUN echo '# OS #' > /home/admin/.gitignore_global && \
    echo '.DS_Store' >> /home/admin/.gitignore_global && \
    echo '# Java #' >> /home/admin/.gitignore_global && \
    echo '*.class' >> /home/admin/.gitignore_global && \
    echo '# Output Folders #' >> /home/admin/.gitignore_global && \
    echo 'target/' >> /home/admin/.gitignore_global && \
    echo '# IntelliJ #' >> /home/admin/.gitignore_global && \
    echo '.idea/' >> /home/admin/.gitignore_global && \
    echo '*.iml' >> /home/admin/.gitignore_global && \
    echo '*.ipr' >> /home/admin/.gitignore_global && \
    echo '*.iws' >> /home/admin/.gitignore_global && \
    echo '# Eclipese #' >> /home/admin/.gitignore_global && \
    echo '.classpath' >> /home/admin/.gitignore_global && \
    echo '.factorypath' >> /home/admin/.gitignore_global && \
    echo '.settings/' >> /home/admin/.gitignore_global && \
    echo '.project' >> /home/admin/.gitignore_global && \
    git config --global core.quotepath false && \
    git config --global credential.helper 'store --file ${GIT_REPO_BI_DIR}.git/git-credentials' && \
    git config --global core.excludesfile ~/.gitignore_global

ENV IDE_VERSION=124
ENV IDE_BUILTIN_PLUGIN_VERSION=41

RUN echo "HELLO" && sudo mkdir -p ${CXAPP_HOME} && \
    sudo chown admin:admin ${CXAPP_HOME} -R && \
    cd ${CXAPP_HOME} && \
    curl -s https://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/${CXAPP}/${CXAPP}_${IDE_VERSION}.info > /home/admin/version.info && \
    curl -s "https://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/${CXAPP}/${CXAPP}_${IDE_VERSION}.tgz" | tar -xz && \
    cd ${CXAPP} && \
    rm -rf plugins && \
    curl -s https://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/builtin-plugins/aone-ide-builtin-plugins_${IDE_BUILTIN_PLUGIN_VERSION}.info > /home/admin/builtin_plugin_version.info && \
    curl -s "https://x-ide-resource-beijing.oss-cn-beijing.aliyuncs.com/cxide-release/builtin-plugins/aone-ide-builtin-plugins_${IDE_BUILTIN_PLUGIN_VERSION}.tgz" | tar -xz 

COPY libstdc++.so.6.0.22 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.22
COPY start.sh ${CXAPP_HOME}/bin/start.sh

RUN sudo rm -f /usr/lib/x86_64-linux-gnu/libstdc++.so.6 && \
    sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.22 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

CMD ["/usr/sbin/standardaone-ide"]
