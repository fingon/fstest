#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/open/02.t,v 1.1 2007/01/17 01:42:10 pjd Exp $

desc="open returns ENAMETOOLONG if a component of a pathname exceeded 255 characters"

dir=`dirname $0`
. ${dir}/../misc.sh

case ${os}:${fs} in
Darwin:HFS+|Darwin:ZFS|Darwin:apfs)
	echo "1..3"
	;;
*)
	echo "1..4"
	;;
esac

expect 0 open ${name255} O_CREAT 0620
expect 0620 stat ${name255} mode
expect 0 unlink ${name255}
case ${os}:${fs} in
Darwin:HFS+|Darwin:ZFS|Darwin:apfs)
# HFS+ on Darwin unfortunately creates the file, which then can be
# removed only with rename + rm.
	;;
*)
	expect ENAMETOOLONG open ${name256} O_CREAT 0620
	;;
esac
