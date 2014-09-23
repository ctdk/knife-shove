#!/bin/sh

# adapted from https://github.com/marpaia/chef-golang/blob/master/test/support/start_server.sh

RUNDIR="/tmp/schob-goiardi"

if [ -d $RUNDIR ]; then
	rm -f $RUNDIR/*
else
	mkdir -p $RUNDIR
fi

pushd $(dirname "${0}") > /dev/null
basedir=$(pwd -L)
# Use "pwd -P" for the path without links. man bash for more info.
popd > /dev/null

go get github.com/ctdk/goiardi
go get github.com/ctdk/schob

cp $basedir/keys/* $RUNDIR

serf agent -bind=0.0.0.0:17946 -rpc-addr=127.0.0.1:17373 &

serf agent -bind=0.0.0.0:27946 -rpc-addr=127.0.0.1:27373 -join=127.0.0.1:17946 -node=foobar.local &

goiardi -V -i $RUNDIR/idx-test.bin -D $RUNDIR/ds-test-bin -A --conf-root=$RUNDIR -H localhost -P 4646 -m $basedir/shovey-test-export.json

goiardi -VVVV -i $RUNDIR/idx-test.bin -D $RUNDIR/ds-test-bin -A --conf-root=$RUNDIR -H localhost -P 4646 --use-serf --serf-addr=127.0.0.1:17373 --use-shovey --sign-priv-key=$RUNDIR/shovey-test.pem -F 30 &

schob -VVVV -e http://localhost:4646 -n foobar.local -k $RUNDIR/foobar.local.key -w $basedir/whitelist.json -p $RUNDIR/shovey-test.key --serf-addr=127.0.0.1:27373 &
