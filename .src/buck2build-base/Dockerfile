FROM rust:latest

ENV BUCK2_GIT https://github.com/facebook/buck2.git

ENV NIGHTLY_BUILD nightly-2023-07-10

WORKDIR /workspace

RUN rustup install $NIGHTLY_BUILD \
    && rustup default $NIGHTLY_BUILD \
    && cargo +$NIGHTLY_BUILD install --git $BUCK2_GIT buck2 \
    && ln -s  /root/.cargo/bin/buck2 /bin/buck2

RUN git clone $BUCK2_GIT \
    && cp -R buck2/prelude . \
    && cp -R buck2/shim . \
    && ln -s  ~/prelude /bin/prelude \
    && ln -s  ~/shim /bin/shim

CMD ""