FROM {{ cookiecutter.base_docker_image }}
ADD requirements.txt /build/requirements.txt
RUN pip install -r /build/requirements.txt
WORKDIR /mnt/
