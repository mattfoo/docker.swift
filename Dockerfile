FROM ubuntu:15.10

MAINTAINER Matt Foo <foo.matt@googlemail.com>

# https://swift.org/builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz
# https://swift.org/builds/swift-2.2-branch/ubuntu1510/swift-2.2-SNAPSHOT-2016-03-01-a/swift-2.2-SNAPSHOT-2016-03-01-a-ubuntu15.10.tar.gz

ARG SWIFT_BRANCH
ENV SWIFT_BRANCH   ${SWIFT_BRANCH:-swift-2.2-branch}

ARG SWIFT_VERSION
ENV SWIFT_VERSION  ${SWIFT_VERSION:-swift-2.2}

ARG SWIFT_SNAPSHOT
ENV SWIFT_SNAPSHOT ${SWIFT_SNAPSHOT:-SNAPSHOT-2016-03-01-a}

ARG SWIFT_PLATFORM
ENV SWIFT_PLATFORM ${SWIFT_PLATFORM:-ubuntu15.10}

ARG PROXY
ENV PROXY ${PROXY:-""}

RUN echo "Acquire::http::proxy  \"$PROXY\";" >  /etc/apt/apt.conf.d/80proxy && \
    echo "Acquire::https::proxy \"$PROXY\";" >> /etc/apt/apt.conf.d/80proxy

# Install related packages
RUN apt-get update									            && \
	apt-get install -y curl clang libicu55 libpython2.7 libxml2 && \
	apt-get clean 										        && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Swift keys
RUN curl -o - https://swift.org/keys/all-keys.asc | gpg --import - && \
    gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift

# Install Swift Ubuntu 15.10 Release
RUN SWIFT_ARCHIVE_NAME=$SWIFT_VERSION-$SWIFT_SNAPSHOT-$SWIFT_PLATFORM.tar.gz  && \
    SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION-$SWIFT_SNAPSHOT/$SWIFT_ARCHIVE_NAME && \
    curl -x "$PROXY" -# $SWIFT_URL     -o $SWIFT_ARCHIVE_NAME               && \
    curl -x "$PROXY" -# $SWIFT_URL.sig -o $SWIFT_ARCHIVE_NAME.sig           && \
    gpg --verify $SWIFT_ARCHIVE_NAME.sig                                    && \
    tar -xvzf $SWIFT_ARCHIVE_NAME --directory / --strip-components=1        && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/*

# Set Swift Path
ENV PATH /usr/bin:$PATH

# Print Installed Swift Version
RUN /usr/bin/swift --version
