FROM registry.fedoraproject.org/fedora-toolbox:37

RUN dnf install -y zsh autojump fzf git btop trash-cli && \
    dnf clean all -y