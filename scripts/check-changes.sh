#!/bin/bash

export CLUSTER_YAML=$(git diff --name-only HEAD^ HEAD)
echo "$CLUSTER_YAML has changes"


