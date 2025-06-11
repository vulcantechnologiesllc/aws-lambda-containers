ARG FUNCTION_DIR="/function"

# Base image: IronBank (for DOD compliance)
# Feel free to swap or change out the base image as needed.
FROM registry1.dso.mil/ironbank/opensource/python:v3.11 as build-image

ARG FUNCTION_DIR

# Set proxies if applicable
ENV http_proxy="http://proxy.example.com:8080"
ENV https_proxy="http://proxy.example.com:8080"
ENV HTTP_PROXY="http://proxy.example.com:8080"
ENV HTTPS_PROXY="http://proxy.example.com:8080"

# Set user to root for installation (some base images have a non-root user)
USER root

# Create the function directory
RUN mkdir -p ${FUNCTION_DIR}

# Base image user for ironbank/python:v3.11 is "python" -- replace with image user as needed
RUN chown python:python ${FUNCTION_DIR}
USER python

COPY . ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

# Install the AWS Lambda Runtime Interface Client (RIC) for Python
RUN pip install --target ${FUNCTION_DIR} awslambdaric

# Install the function's dependencies
RUN pip install --no-cache-dir --target ${FUNCTION_DIR} -r ${FUNCTION_DIR}/requirements.txt

# If available, use a slimmer image to reduce size (optional)
FROM registry1.dso.mil/ironbank/opensource/python:v3.11

ARG FUNCTION_DIR

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

# Set the entrypoint to the AWS Lambda Runtime Interface Client
ENTRYPOINT ["/usr/bin/python3.11", "-m", "awslambdaric"]

CMD ["lambda_function.lambda_handler"]