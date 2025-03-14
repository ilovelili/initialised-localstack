ARG  LOCALSTACK_DOCKER_IMAGE_TAG=latest
FROM localstack/localstack:$LOCALSTACK_DOCKER_IMAGE_TAG

RUN apk add --no-cache jq
ENV SRC_DIR=/opt/bootstrap

COPY bootstrap $SRC_DIR
RUN chmod +x $SRC_DIR/scripts/init.sh
RUN chmod +x $SRC_DIR/bootstrap.sh

RUN pip install --upgrade pip
RUN pip install awscli-local

# Fix dependency bug (otherwise aws cli throws `No module named 'yaml'` error)
RUN cp -r /usr/lib/python3.6/site-packages/yaml /opt/code/localstack/.venv/lib/python3.6/site-packages/yaml

# We run the init script as a health check
# That way the container won't be healthy until it's completed successfully
# Once the init completes we wipe it to prevent it continiously running
HEALTHCHECK --start-period=10s --interval=10s --timeout=10s --retries=5\
  CMD /opt/bootstrap/bootstrap.sh
