FROM traumfewo/docker-wkhtmltopdf:v0.12.2.1
MAINTAINER Fabian Beuke <beuke@traum-ferienwohnungen.de>

# Install dependencies for running web service
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-pip && \
    pip install werkzeug executor gunicorn && \
    apt-get autoremove -y && \
    apt-get clean && \
    pip install prometheus_client && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

ADD app.py /app.py
EXPOSE 5555

ENTRYPOINT ["usr/local/bin/gunicorn"]

CMD ["-b", "0.0.0.0:5555", "--log-file", "-", "app:application"]
