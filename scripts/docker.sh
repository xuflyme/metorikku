#!/bin/bash
set -e

# Hack that helps with the cache
docker pull $(grep -ioP '(?<=^from)\s+\S+' docker/spark/Dockerfile)
docker pull metorikku/spark:latest
docker pull metorikku/metorikku:latest
docker pull $(grep -ioP '(?<=^from)\s+\S+' docker/hive/Dockerfile)
docker pull metorikku/hive:latest

(cd docker/spark/hive-shim-loader && mvn install)

docker build -t metorikku/spark --cache-from metorikku/spark:latest --build-arg SPARK_VERSION=$SPARK_VERSION --build-arg HADOOP_VERSION=$HADOOP_VERSION -f docker/spark/Dockerfile docker/spark
docker build -t metorikku/hive --cache-from metorikku/hive --build-arg HIVE_VERSION=$HIVE_VERSION --build-arg HUDI_VERSION=$HUDI_VERSION -f docker/hive/Dockerfile docker/hive
docker build -t metorikku/metorikku -f docker/metorikku/Dockerfile .