FROM       exherbo/exherbo-x86_64-pc-linux-gnu-base
MAINTAINER Julian Ospald <hasufell@posteo.de>

ENV PALUDIS_DO_NOTHING_SANDBOXY=1
RUN echo "export PALUDIS_DO_NOTHING_SANDBOXY=1" >> /etc/profile

# copy hooks
COPY ./config/paludis /etc/paludis

# This one should be present by running the build.sh script
COPY build.sh /
RUN chmod +x /build.sh && /build.sh
RUN rm /build.sh

# update etc files... hope this doesn't screw up
RUN eclectic config accept-all

