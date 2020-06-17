FROM node:lts-alpine

# https://github.com/gliderlabs/docker-alpine/issues/24
RUN apk update \
 && apk upgrade \
 && apk add alpine-sdk bash yarn python3 python3-dev python-dev postgresql-dev \
 && rm -rf /var/cache/*/* \
 && echo "" > /root/.ash_history

# change default shell from ash to bash
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

ENV GLIBC_VER=2.31-r0

# install glibc compatibility for alpine
RUN curl -sL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk \
  && curl -sLO https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk \
  && apk add --no-cache \
      glibc-${GLIBC_VER}.apk \
      glibc-bin-${GLIBC_VER}.apk \
  && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
  && unzip awscliv2.zip \
  && aws/install \
  && rm -rf \
      awscliv2.zip \
      aws \
      /usr/local/aws-cli/v2/*/dist/aws_completer \
      /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
      /usr/local/aws-cli/v2/*/dist/awscli/examples \
  && rm glibc-${GLIBC_VER}.apk \
  && rm glibc-bin-${GLIBC_VER}.apk \
  && rm -rf /var/cache/apk/* \
  && aws --version


ENV LC_ALL=en_US.UTF-8

RUN yarn global add lerna

RUN npm install -g @commitlint/cli @commitlint/config-conventional

RUN ([ -f /usr/bin/sops ] || (wget -q -O /usr/bin/sops https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux && chmod +x /usr/bin/sops))

RUN git clone https://github.com/sharkdp/shell-functools /tmp/shell-functools

