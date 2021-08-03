FROM vmwarecmbu/k8s-ci-container


RUN apt-get update && apt-get install -y git jq && \
    curl -LO https://tmc-cli.s3-us-west-2.amazonaws.com/tmc/latest/linux/x64/tmc && \
    chmod +x ./tmc && \
    mv ./tmc /usr/local/bin/tmc && \
    wget https://github.com/mikefarah/yq/releases/download/v4.7.0/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq