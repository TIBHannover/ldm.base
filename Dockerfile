# See CKAN docs on installation from Docker Compose on usage
FROM debian:jessie
MAINTAINER Open Knowledge

# Install required system packages
RUN apt-get -q -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y upgrade \
    && apt-get -q -y install \
        python-dev \
        python-pip \
        python-virtualenv \
        python-wheel \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libgeos-dev \
        libssl-dev \
        libffi-dev \
        postgresql-client \
        build-essential \
        git-core \
        vim \
        wget \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

# Define environment variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_VENV $CKAN_HOME/venv
ENV CKAN_CONFIG /etc/ckan
ENV CKAN_STORAGE_PATH=/var/lib/ckan

# Build-time variables specified by docker-compose.yml / .env
ARG CKAN_SITE_URL

# Create ckan user
RUN useradd -r -u 900 -m -c "ckan account" -d $CKAN_HOME -s /bin/false ckan

# Setup virtual environment for CKAN
RUN mkdir -p $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH && \
    virtualenv $CKAN_VENV && \
    ln -s $CKAN_VENV/bin/pip /usr/local/bin/ckan-pip &&\
    ln -s $CKAN_VENV/bin/paster /usr/local/bin/ckan-paster

# Setup CKAN
ADD . $CKAN_VENV/src/ckan/
RUN ckan-pip install -U pip && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirement-setuptools.txt && \
    ckan-pip install --upgrade --no-cache-dir -r $CKAN_VENV/src/ckan/requirements.txt && \
    ckan-pip install -e $CKAN_VENV/src/ckan/ && \
    ln -s $CKAN_VENV/src/ckan/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    cp -v $CKAN_VENV/src/ckan/contrib/docker/ckan-entrypoint.sh /ckan-entrypoint.sh && \
    chmod +x /ckan-entrypoint.sh && \
    chown -R ckan:ckan $CKAN_HOME $CKAN_VENV $CKAN_CONFIG $CKAN_STORAGE_PATH

# Install LDM.BASE specific extensions

RUN ckan-pip install -e git+https://github.com/ckan/ckanext-dcat.git#egg=ckanext-dcat && \		
ckan-pip install -r $CKAN_VENV/src/ckanext-dcat/requirements.txt && \
sed -r -i "/ckan.plugins =/ s/$/\ dcat/" /etc/ckan/production.ini
### update production.ini and enable dcat

RUN ckan-pip install -e git+https://github.com/tibhannover/ckanext-tibtheme.git#egg=ckanext-tibtheme && \
ckan-pip install -r $CKAN_VENV/src/ckanext-tibtheme/requirements.txt && \
sed -r -i "/ckan.plugins =/ s/$/\ tibtheme/" /etc/ckan/production.ini
### update production.ini and enable TIBtheme

RUN ckan-pip install -e git+https://github.com/tibhannover/ckanext-videoviewer.git#egg=ckanext-videoviewer && \
ckan-pip install -r $CKAN_VENV/src/ckanext-videoviewer/requirements.txt && \
sed -r -i "/ckan.plugins =/ s/$/\ videoviewer/" /etc/ckan/production.ini
### update production.ini and enable VideoViewer

RUN ckan-pip install -e git+https://github.com/tibhannover/ckanext-dwgviewer.git#egg=ckanext-dwgviewer && \
ckan-pip install -r $CKAN_VENV/src/ckanext-dwgviewer/requirements.txt && \
sed -r -i "/ckan.plugins =/ s/$/\ dwgviewer/" /etc/ckan/production.ini
### update production.ini and enable DrawingViewer

# Install LDM.Custom distribusion specific extensions

ENTRYPOINT ["/ckan-entrypoint.sh"]

USER ckan
EXPOSE 5000

CMD ["ckan-paster","serve","/etc/ckan/production.ini"]
