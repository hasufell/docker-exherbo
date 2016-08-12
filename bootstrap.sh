#!/bin/sh

set -e

# First param is package tarball, 2nd is the *.DIGEST file
VerifyShaOfStage3()
{
	test_sum=$(awk -v myvar="$1" '$2==myvar {for(i=1; i<=1; i++) { print $1; exit}}' $2)
	calculated_sum=$(sha1sum $1 | awk '{print $1}' -)
	if [[ "$test_sum" == "$calculated_sum" ]]; then
		return 0
	else
		return 1
	fi
}

suffix=$3 # e.g. -hardened
arch=$1
dist="http://dev.exherbo.org/stages/"
stage3="exherbo-amd64-current.tar.xz"

# Create working directory, keep a copy of busybox handy
mkdir newWorldOrder; cd newWorldOrder
cp /bin/busybox .

echo "Downloading and extracting ${stage3}..."
wget -c "${dist}/${stage3}" "${dist}/sha1sum"
if VerifyShaOfStage3 $stage3 "sha1sum"; then
	echo "DIGEST sum is okey";
else
	echo "DIGEST sum is NOT okey";
	return 1;
fi
xz -d ${stage3}
tar --exclude "./etc/hosts" --exclude "./etc/hostname" --exclude "./sys/*" -xf ${stage3%.*}
/newWorldOrder/busybox rm -f ${stage3%.*}

echo "Installing stage 3"
/newWorldOrder/busybox rm -rf /lib* /usr /var /bin /sbin /opt /mnt /media /root /home /run /tmp
/newWorldOrder/busybox cp -fRap lib* /
/newWorldOrder/busybox cp -fRap bin boot home media mnt opt root run sbin tmp usr var /
/newWorldOrder/busybox cp -fRap etc/* /etc/
/newWorldOrder/busybox cp -fRap /etc/paludis-new/* /etc/paludis/
/newWorldOrder/busybox rm -rf /etc/paludis-new

# Cleaning
cd /
/newWorldOrder/busybox rm -rf /newWorldOrder /bootstrap.sh /linuxrc

# Say hello
echo "Bootstrapped ${stage3} into /:"
ls --color -lah

# exec /bin/bash -c /build.sh

