FROM ubuntu:jammy

WORKDIR /app

COPY requirements.txt .
COPY app.py .
COPY export.sql .
COPY routines_viste_userAdmin.sql .
COPY start.sh .

RUN apt-get update && \
    apt-get install -y \
    mariadb-server\
    python3 \
    python3-pip

RUN pip3 install --upgrade pip

RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["/bin/bash", "start.sh"]
