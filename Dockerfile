FROM opensuse/leap:16.0

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH;
RUN zypper -n in -t pattern devel_basis
RUN set -eux; \
    zypper -n install curl; \
	curl -o /tmp/install_rust.sh https://sh.rustup.rs; \
	sh /tmp/install_rust.sh -y --default-toolchain stable --profile minimal;

RUN cargo install cargo-generate-rpm

ENV PATH=/usr/local/bin:/root/.cargo/bin:$PATH \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    LD_LIBRARY_PATH=$PREFIX

RUN zypper -n install rpm-build
RUN zypper -n install systemd-rpm-macros

ENV PATH=/usr/local/cargo/bin/cargo:$PATH
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
