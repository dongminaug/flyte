#!/bin/bash

# Note that this file is meant to be run on OSX by a user with the necessary GitHub privileges

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BASEDIR="${DIR}/.."

# Set up a temp directory
mkdir ${BASEDIR}/_repos || true
REPOS_DIR=`mktemp -d "${BASEDIR}/_repos/XXXXXXXXX"`

function clone_repos()
{
    git clone https://github.com/lyft/flytekit.git ${REPOS_DIR}/flytekit
    git clone https://github.com/lyft/flyteidl.git ${REPOS_DIR}/flyteidl
}

# Clone all repos
$(clone_repos)

# Generate documentation by running script inside the generation container
docker run -t -v ${BASEDIR}:/base -v ${REPOS_DIR}:/repos -v ${BASEDIR}/_rsts:/_rsts lyft/docbuilder:v2.2.0 /base/docs_infra/in_container_rst_generation.sh

# Cleanup
rm -rf ${REPOS_DIR}/* || true
