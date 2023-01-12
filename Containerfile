FROM docker.io/archlinux/archlinux:base-devel

RUN pacman -Syu --needed --noconfirm git && \
    rm -rfv /var/cache/* && \
    pacman -Scc --noconfirm

ARG user=makepkg
RUN useradd --system --create-home $user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

RUN git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && \
    makepkg -sri --needed --noconfirm && \ 
    cd && \
    paru -Syu --needed --noconfirm openssh zsh nano vim vi autojump fzf trash-cli rmtrash kitty-terminfo && \
    rm -rfv .cache paru-bin && \
    sudo rm -rfv /var/cache/* && \
    paru -Scc --noconfirm

USER root
WORKDIR /
RUN curl -L "https://github.com/1player/host-spawn/releases/latest/download/host-spawn-x86_64" -o /tmp/host-spawn && \
    mv -v /tmp/host-spawn /usr/bin && chmod -v +x /usr/bin/host-spawn && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/podman && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/flatpak && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/flatpak-builder
