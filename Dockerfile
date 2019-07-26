ARG  LOCALSTACK_DOCKER_IMAGE_TAG=latest
FROM localstack/localstack:$LOCALSTACK_DOCKER_IMAGE_TAG

RUN apk add --no-cache jq
COPY bootstrap /opt/bootstrap/

RUN chmod +x /opt/bootstrap/scripts/init.sh
RUN chmod +x /opt/bootstrap/bootstrap.sh

RUN pip install awscli-local

# Fix dependency bug (otherwise aws cli throws `No module named 'yaml'` error)
RUN cp -r /usr/lib/python3.6/site-packages/yaml /opt/code/localstack/.venv/lib/python3.6/site-packages/yaml

# We run the init script as a health check
# That way the container won't be healthy until it's completed successfully
# Once the init completes we wipe it to prevent it continiously running
HEALTHCHECK --start-period=10s --interval=1s --timeout=3s --retries=30\
  CMD /opt/bootstrap/bootstrap.sh
