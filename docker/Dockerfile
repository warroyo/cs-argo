FROM ubuntu:bionic


RUN apt-get update && apt-get install -y git jq curl wget && \
    curl -LO https://tmc-cli.s3-us-west-2.amazonaws.com/tmc/latest/linux/x64/tmc && \
    chmod +x ./tmc && \
    mv ./tmc /usr/local/bin/tmc && \
    wget https://github.com/mikefarah/yq/releases/download/v4.7.0/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq &&\
    curl -LO https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.35.1/ytt-linux-amd64 &&\
    chmod +x ytt-linux-amd64 &&\
    mv ytt-linux-amd64 /usr/local/bin/ytt &&\
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
    install -m 0755 kubectl /usr/local/bin/kubectl
