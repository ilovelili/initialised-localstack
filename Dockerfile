ARG  LOCALSTACK_DOCKER_IMAGE_TAG=latest
FROM localstack/localstack:$LOCALSTACK_DOCKER_IMAGE_TAG

COPY bootstrap /opt/bootstrap/

RUN chmod +x /opt/bootstrap/scripts/init.sh
RUN chmod +x /opt/bootstrap/bootstrap.sh

# No module named 'yaml' error happens.. so I copy from local
# RUN pip3 install awscli-local
COPY awslocal /usr/local/bin/
RUN chmod +x /usr/local/bin/awslocal

# We run the init script as a health check
# That way the container won't be healthy until it's completed successfully
# Once the init completes we wipe it to prevent it continiously running
HEALTHCHECK --start-period=10s --interval=1s --timeout=3s --retries=30\
  CMD /opt/bootstrap/bootstrap.sh
