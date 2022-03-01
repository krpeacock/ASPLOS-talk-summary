FROM ubuntu:20.04

# Install a basic environment needed for our build tools
# Make tzdata not ask about the timezone
ENV DEBIAN_FRONTEND=noninteractive

RUN \
    apt -yq update && \
    apt -yqq install --no-install-recommends curl ca-certificates \
        build-essential pkg-config libssl-dev llvm-dev liblmdb-dev clang cmake rsync

# Install Node.js using nvm
# Specify the Node version
ENV NODE_VERSION=14.17.1
RUN curl --fail -sSf https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# Install dfx; the version is picked up from the DFX_VERSION environment variable
ENV DFX_VERSION=0.9.2
RUN sh -ci "$(curl -fsSL https://sdk.dfinity.org/install.sh)"

RUN apt -yqq install --no-install-recommends reprotest disorderfs faketime sudo wabt

COPY . /canister
WORKDIR /canister

