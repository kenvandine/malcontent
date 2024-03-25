FROM debian:unstable

RUN apt-get update -qq && apt-get install --no-install-recommends -qq -y \
    appstream \
    desktop-file-utils \
    gettext \
    git \
    gtk-doc-tools \
    itstool \
    lcov \
    libadwaita-1-dev \
    libaccountsservice-dev \
    libappstream-dev \
    libdbus-1-dev \
    libflatpak-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libglib-testing-0-dev \
    libgtk-4-dev \
    libpam0g-dev \
    libpolkit-gobject-1-dev \
    libtimedate-perl \
    libxml2-utils \
    locales \
    meson \
    pkg-config \
    policykit-1 \
    python3-pip \
 && rm -rf /usr/share/doc/* /usr/share/man/*

# Locale for our build
RUN locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

ARG HOST_USER_ID=5555
ENV HOST_USER_ID ${HOST_USER_ID}
RUN useradd -u $HOST_USER_ID -ms /bin/bash user

USER user
WORKDIR /home/user

COPY cache-subprojects.sh .
RUN ./cache-subprojects.sh

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
