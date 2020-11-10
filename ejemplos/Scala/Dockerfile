FROM frolvlad/alpine-scala
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
CMD ["/usr/local/bin/sbt"]
ARG SBT_VERSION=1.4.2

RUN apk update && apk upgrade
RUN apk add git
RUN apk add curl

RUN curl -sL "https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" -o /usr/local/sbt.tgz
RUN cd /usr/local && tar xvfz sbt.tgz
RUN mv /usr/local/sbt-launcher-packaging-${SBT_VERSION}/bin/* /usr/local/bin
RUN chmod 0755 /usr/local/bin/sbt
RUN /usr/local/bin/sbt
