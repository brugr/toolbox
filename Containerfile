FROM docker.io/archlinux/archlinux:base-devel

RUN pacman -Syu --needed --noconfirm git

ARG user=makepkg
RUN useradd --system --create-home $user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

RUN git clone https://aur.archlinux.org/yay-bin.git && \
    cd yay-bin && \
    makepkg -sri --needed --noconfirm && \ 
    cd && \
    yay -Syu --needed --noconfirm openssh zsh nano vim vi autojump fzf trash-cli rmtrash && \
    rm -rfv .cache yay-bin && \
    sudo rm -rfv /var/cache/* && \
    yay -Scc --noconfirm

USER root
WORKDIR /
RUN curl -L "https://github.com/1player/host-spawn/releases/latest/download/host-spawn-x86_64" -o /tmp/host-spawn && \
    mv -v /tmp/host-spawn /usr/bin && chmod -v +x /usr/bin/host-spawn && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/podman && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/flatpak && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/flatpak-builder