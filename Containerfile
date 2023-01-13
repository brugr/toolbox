FROM quay.io/toolbx-images/archlinux-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox command" \
      summary="Custom image for toolbox/distrobox" \
      maintainer="brugr <me@brugr.com>"

# Download host-spawn and do some useful symlinks
RUN curl -L "https://github.com/1player/host-spawn/releases/latest/download/host-spawn-x86_64" -o /tmp/host-spawn && \
    mv -v /tmp/host-spawn /usr/bin && chmod -v +x /usr/bin/host-spawn && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/podman && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/docker && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/flatpak && \
    ln -vs /usr/bin/host-spawn /usr/local/bin/rpm-ostree

# Create and change to makepkg user
ARG user=makepkg
RUN useradd --system --create-home $user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install paru (aur helper)
RUN sudo pacman -Syu --needed --noconfirm git && \
    git clone https://aur.archlinux.org/paru-bin.git && \
    cd paru-bin && makepkg -sri --needed --noconfirm && \ 
    sudo rm -rfv $HOME/.cache $HOME/paru-bin /var/cache/* && \
    paru -Scc --noconfirm

# Install extra packages
COPY extra-packages /
RUN paru -Syu --needed --noconfirm $(cat /extra-packages | xargs) && \
    sudo rm -rfv $HOME/.cache /var/cache/* /extra-packages && \
    paru -Scc --noconfirm

# Change back to root
USER root
WORKDIR /