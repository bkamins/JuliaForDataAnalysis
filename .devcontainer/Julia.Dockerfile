ARG BUILD_ON_IMAGE=glcr.b-data.ch/julia/base
ARG JULIA_VERSION=latest

FROM ${BUILD_ON_IMAGE}:${JULIA_VERSION} as files

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir /files

COPY julia-base/conf/user /files
COPY julia-base/scripts /files

## Ensure file modes are correct when using CI
## Otherwise set to 777 in the target image
RUN find /files -type d -exec chmod 755 {} \; \
  && find /files -type f -exec chmod 644 {} \; \
  && find /files/usr/local/bin -type f -exec chmod 755 {} \;

FROM ${BUILD_ON_IMAGE}:${JULIA_VERSION}

ARG DEBIAN_FRONTEND=noninteractive

## Update environment
ARG USE_ZSH_FOR_ROOT
ARG SET_LANG
ARG SET_TZ

ENV LANG=${SET_LANG:-$LANG} \
    TZ=${SET_TZ:-$TZ} \
    PARENT_IMAGE_BUILD_DATE=${BUILD_DATE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

  ## Change root's shell to ZSH
RUN if [ ! -z "$USE_ZSH_FOR_ROOT" ]; then \
    chsh -s /bin/zsh; \
  fi \
  ## Update timezone if needed
  && if [ "$TZ" != "Etc/UTC" ]; then \
    echo "Setting TZ to $TZ"; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
      && echo $TZ > /etc/timezone; \
  fi \
  ## Add/Update locale if needed
  && if [ "$LANG" != "en_US.UTF-8" ]; then \
    sed -i "s/# $LANG/$LANG/g" /etc/locale.gen; \
    locale-gen; \
    echo "Setting LANG to $LANG"; \
    update-locale --reset LANG=$LANG; \
  fi \
  ## Allow updating pre-installed Julia packages
  ## Make sure $JULIA_PATH/local/share/julia/registries/* is deleted
  && rm -rf ${JULIA_PATH}/local/share/julia/registries/*

## Pip: Install to the Python user install directory (1) or not (0)
ARG PIP_USER=1

ENV PIP_USER=${PIP_USER}

## Copy files as late as possible to avoid cache busting
COPY --from=files /files /

## Reset environment variable BUILD_DATE
ARG BUILD_START

ENV BUILD_DATE=${BUILD_START}
