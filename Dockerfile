FROM sequenceiq/hadoop-docker:2.7.0

MAINTAINER Maik Hummel <m@ikhummel.com>

ENV JAR_NAME=/root/.m2/repository/mawazo/sifarish/1.0/sifarish-1.0.jar \
    CLASS_NAME=org.sifarish.common.TextAnalyzer

WORKDIR /opt

RUN yum install -y wget git && \
    wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo && \
    yum install -y apache-maven && \

    # Chombo dependency
    git clone https://github.com/pranab/chombo && cd chombo && \
    git checkout nuovo && \
    mvn clean install -P yarn && \
    cd .. && \
    rm -rf chombo && \

    # Hoidla dependency
    git clone https://github.com/pranab/hoidla && cd hoidla && \
    git checkout 782689b0760c533d2f4bc71b1625e74eea1b8f35 && \
    mvn clean install && \
    cd .. && \
    rm -rf hoidla && \

    # Sifarish itself
    git clone https://github.com/pranab/sifarish && cd sifarish && \
    git checkout nuovo && \
    mvn clean install -P yarn && \
    cd .. && \
    rm -rf sifarish
    
ENTRYPOINT ["/usr/local/hadoop/bin/hadoop"]
