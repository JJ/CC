FROM frolvlad/alpine-scala
LABEL maintainer="JJ Merelo <jjmerelo@GMail.com>"
WORKDIR /root
CMD ["/usr/local/bin/sbt"]
ARG SBT_VERSION=1.4.2

RUN apk update && apk upgrade && apk add curl \
    && curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" -o /usr/local/sbt.tgz \
    && cd /usr/local && tar xvfz sbt.tgz \
    &&  mv /usr/local/sbt/bin/* /usr/local/bin \
    && apk del curl \
    && rm /usr/local/sbt.tgz

