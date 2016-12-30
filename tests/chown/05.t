#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/chown/05.t,v 1.1 2007/01/17 01:42:08 pjd Exp $

desc="chown returns EACCES when search permission is denied for a component of the path prefix"

dir=`dirname $0`
. ${dir}/../misc.sh

cases=15
if ! supported supgroups; then
    cases=$(expr $cases - 2)
fi
echo "1..$cases"

n0=`namegen`
n1=`namegen`
n2=`namegen`

id1=65534
gid1=65533
gid2=65532

expect 0 mkdir ${n0} 0755
cdir=`pwd`
cd ${n0}
expect 0 mkdir ${n1} 0755
expect 0 chown ${n1} $id1 $gid2
expect 0 -u $id1 -g $gid2 create ${n1}/${n2} 0644
expect 0 -u $id1 -g $gid1,$gid2 -- chown ${n1}/${n2} -1 $gid1
expect $id1,$gid1 -u $id1 -g $gid2 stat ${n1}/${n2} uid,gid
expect 0 chmod ${n1} 0644
expect EACCES -u $id1 -g $gid1,$gid2 -- chown ${n1}/${n2} -1 $gid2
expect 0 chmod ${n1} 0755
expect $id1,$gid1 -u $id1 -g $id1 stat ${n1}/${n2} uid,gid
if supported supgroups ; then
    expect 0 -u $id1 -g $gid1,$gid2 -- chown ${n1}/${n2} -1 $gid2
    expect $id1,$gid2 -u $id1 -g $id1 stat ${n1}/${n2} uid,gid
fi
expect 0 -u $id1 -g $id1 unlink ${n1}/${n2}
expect 0 rmdir ${n1}
cd "${cdir}"
expect 0 rmdir ${n0}
