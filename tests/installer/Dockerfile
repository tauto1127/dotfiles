FROM ubuntu:22.04

WORKDIR /workspace
COPY . /workspace

RUN chmod +x tests/installer/test-installer.sh \
    && chmod +x tests/installer/mock-bin/*

CMD ["bash", "tests/installer/test-installer.sh"]
