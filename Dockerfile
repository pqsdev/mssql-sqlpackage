# SQL Server Command Line Tools
FROM ubuntu:16.04

LABEL maintainer="it_infra@pqs.com.ar"

# apt-get and system utilities
RUN apt-get update && apt-get install -y \
	curl apt-transport-https debconf-utils \
    && rm -rf /var/lib/apt/lists/*

# adding custom MS repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# install SQL Server drivers and tools
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql mssql-tools
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# INSTALL SQLPACKAGE
RUN apt-get install libunwind8 libicu55 unzip -y
RUN curl -Lq https://go.microsoft.com/fwlink/?linkid=873926 -o sqlpackage-linux-x64-latest.zip
RUN unzip sqlpackage-linux-x64-latest.zip -d /opt/sqlpackage
RUN chmod a+x /opt/sqlpackage/sqlpackage
RUN echo 'export PATH="$PATH:/opt/sqlpackage"' >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8



CMD /bin/bash 
