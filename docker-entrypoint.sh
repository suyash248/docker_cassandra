#!/bin/bash

CASSANDRA_CONF="/usr/lib/cassandra/conf"
sed -r -i 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' $CASSANDRA_CONF/cassandra.yaml

for yaml in \
	broadcast_address \
	broadcast_rpc_address \
	cluster_name \
	endpoint_snitch \
	listen_address \
	num_tokens \
	rpc_address \
	start_rpc \
; do
	var="CASSANDRA_${yaml^^}"
	val="${!var}"
	if [ "$val" ]; then
		sed -r -i 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' $CASSANDRA_CONF/cassandra.yaml
	fi
done

for rackdc in dc rack; do
	var="CASSANDRA_${rackdc^^}"
	val="${!var}"
	if [ "$val" ]; then
		sed -r -i 's/^('"$rackdc"'=).*/\1'"$val"'/' $CASSANDRA_CONF/cassandra-rackdc.properties
	fi
done

exec "$@"
