FROM busybox
MAINTAINER Julian Ospald <hasufell@posteo.de>

# copy hooks
COPY ./config/paludis /etc/paludis-new

# This one should be present by running the build.sh script
COPY bootstrap.sh /

# one step, to make the layer as thin as possible
# bootstrap.h calls build.sh
RUN /bootstrap.sh amd64 x86_64

COPY build.sh /

RUN /build.sh

# update etc files... hope this doesn't screw up
RUN eclectic config accept-all

# don't allow regular sync, because we want to make sure
# all images deriving from this one have the same state
RUN sed -i -e 's|^sync|#sync|' /etc/paludis/repositories/*.conf


