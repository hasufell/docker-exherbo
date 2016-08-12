#!/bin/bash

set -e

source /etc/profile
eclectic env update

# set timezone
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# set locale
export LANG=en_US.utf8
export LANGUAGE=en_US:en
export LC_ALL=en_US.utf8
cat << EOF > /etc/locale.gen
en_US ISO-8859-1
en_US.UTF-8 UTF-8
EOF
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.utf8
echo LANG="en_US.UTF-8" > /etc/env.d/99locale

# update
chgrp paludisbuild /dev/tty
cave sync
cave resolve -z -1 dev-libs/libressl sys-apps/paludis -U dev-libs/openssl -D dev-libs/openssl -f -x
cave resolve -z \!dev-libs/openssl -u '*/*' -x
cave resolve -z -1 dev-libs/libressl -x
cave resolve -z -1 net-misc/wget net-misc/curl -x
cave fix-linkage -x -- --without sys-apps/paludis
cave resolve -z \!sys-apps/systemd -u '*/*' -x
cave resolve -c world -x
cave purge -x
cave fix-linkage -x

