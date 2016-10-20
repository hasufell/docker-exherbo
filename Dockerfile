FROM       busybox
MAINTAINER Julian Ospald <hasufell@posteo.de>

# copy hooks
COPY ./config/paludis /etc/paludis-new

# This one should be present by running the build.sh script
COPY bootstrap.sh build.sh /

# one step, to make the layer as thin as possible
# bootstrap.sh calls build.sh
RUN /bootstrap.sh amd64 x86_64

# update etc files... hope this doesn't screw up
RUN eclectic config accept-all

