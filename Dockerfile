FROM mcr.microsoft.com/dotnet/core/runtime-deps:3.1-buster-slim

ENV RUNNER_CONFIG_URL=""
ENV GITHUB_PAT=""
ENV RUNNER_NAME=""
ENV RUNNER_GROUP=""
ENV RUNNER_LABELS=""

RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
    curl \
    jq \
    apt-utils \
    apt-transport-https \
    unzip \
    net-tools\
    gnupg2\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get -y install --no-install-recommends kubectl

# Install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

# copy runner
COPY ./runner /actions-runner

# Directory for runner to operate in
WORKDIR /actions-runner
COPY ./entrypoint.sh /actions-runner/entrypoint.sh
COPY ./runner_lifecycle.sh /actions-runner/runner_lifecycle.sh

ENV _INTERNAL_RUNNER_LIFECYCLE_NOTIFICATION=/actions-runner/runner_lifecycle.sh


# Allow runner to run as root
ENV RUNNER_ALLOW_RUNASROOT=1

ENTRYPOINT ["./entrypoint.sh"] 
