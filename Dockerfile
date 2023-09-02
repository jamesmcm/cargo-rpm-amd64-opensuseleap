FROM opensuse/leap:latest

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH;
RUN zypper -n in -t pattern devel_basis
RUN set -eux; \
    zypper -n install curl; \
	curl -o /tmp/install_rust.sh https://sh.rustup.rs; \
	sh /tmp/install_rust.sh -y;

RUN cargo install cargo-rpm

ENV PATH=/usr/local/bin:/root/.cargo/bin:$PATH \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    LD_LIBRARY_PATH=$PREFIX

RUN zypper -n install rpm-build
RUN zypper -n install systemd-rpm-macros

RUN zypper --non-interactive addrepo -G https://download.opensuse.org/repositories/home:Ledest:misc/openSUSE_Leap_15.5/home:Ledest:misc.repo
RUN zypper -n refresh

ENV PATH=/usr/local/cargo/bin/cargo:$PATH
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

