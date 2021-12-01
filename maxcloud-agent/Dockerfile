FROM --platform=linux/amd64 alpine:latest
MAINTAINER "SpotMax"
RUN apk add -U --no-cache ca-certificates curl bash bash-completion shadow git ncurses openssl && \
    rm -rf /var/cache/apk/*
RUN usermod -d /nonexistent/ nobody && \
    curl -sLf "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl && \
    git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/bin/kubens && \
    curl -sLf "https://storage.googleapis.com/knative-nightly/client/latest/kn-linux-amd64" > /usr/bin/kn && \
    chmod +x /usr/bin/kn && \
    wget -q https://github.com/istio/istio/releases/download/1.9.5/istioctl-1.9.5-linux-amd64.tar.gz -P /usr/bin/ && \
    tar -xzf /usr/bin/istioctl-1.9.5-linux-amd64.tar.gz -C /usr/bin/ && rm -f /usr/bin/istioctl-1.9.5-linux-amd64.tar.gz && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
COPY setupConfig /spotmax/
ENV PATH="/spotmax:${PATH}"
WORKDIR /spotmax/
CMD ["./maxcloud-agent"]
