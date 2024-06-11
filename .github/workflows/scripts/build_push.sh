#!/bin/bash
# Copyright (C) 2024 Intel Corporation
# SPDX-License-Identifier: Apache-2.0

set -xe

echo "Using IMAGE_REPO=$IMAGE_REPO, IMAGE_TAG=$IMAGE_TAG"

IMAGE_REPO=${IMAGE_REPO:-}
IMAGE_TAG=${IMAGE_TAG:-latest}

function docker_build() {
    # docker_build <service_name> <dockerfile>
    if [ -z "$2" ]; then
        DOCKERFILE_PATH=Dockerfile
    else
        DOCKERFILE_PATH=$2
    fi
    echo "Building ${IMAGE_REPO}opea/$1:$IMAGE_TAG using Dockerfile $DOCKERFILE_PATH"
    # if https_proxy and http_proxy are set, pass them to docker build
    if [ -z "$https_proxy" ]; then
        docker build --no-cache -t ${IMAGE_REPO}opea/$1:$IMAGE_TAG -f $DOCKERFILE_PATH .
    else
        docker build --no-cache -t ${IMAGE_REPO}opea/$1:$IMAGE_TAG --build-arg https_proxy=$https_proxy --build-arg http_proxy=$http_proxy -f $DOCKERFILE_PATH .
    fi
    docker push ${IMAGE_REPO}opea/$1:$IMAGE_TAG
    docker rmi ${IMAGE_REPO}opea/$1:$IMAGE_TAG
}

case "$1" in
    AudioQnA)
        #TBD
        ;;
    ChatQnA)
        cd ChatQnA/docker
        docker_build chatqna
        cd ui
        docker_build chatqna-ui docker/Dockerfile
        ;;
    CodeGen)
        cd CodeGen/docker
        docker_build codegen
        cd ui
        docker_build codegen-ui docker/Dockerfile
        ;;
    CodeTrans)
        cd CodeGen/docker
        docker_build codetrans
        cd ui
        docker_build codetrans-ui docker/Dockerfile
        ;;
    DocSum)
        cd DocSum/docker
        docker_build docsum
        cd ui
        docker_build docsum-ui docker/Dockerfile
        ;;
    SearchQnA)
        #TBD
        ;;
    Translation)
        #TBD
        ;;
    VisualQnA)
        #TBD
        ;;
    *)
        echo "Unknown function: $1"
        ;;
esac
