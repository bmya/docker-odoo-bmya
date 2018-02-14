FROM bmya/odoo:11.0
MAINTAINER Blanco Martín & Asociados <daniel@blancomartin.cl>
USER root

# Generate locale (es_AR for right odoo es_AR language config, and C.UTF-8 for postgres and general locale data)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y locales -qq
RUN echo 'es_AR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'es_CL.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'es_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'C.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN dpkg-reconfigure locales && /usr/sbin/update-locale LANG=C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

#RUN groupadd -r odoo
#RUN useradd -g odoo odoo

RUN set -x; \
apt-get update \
&& apt-get install -y --no-install-recommends \
apt-utils \
ca-certificates \
curl \
sudo \
gcc mc bzr \ 
lptools make  \
poppler-utils \  
antiword \
git

RUN pip3 install --upgrade pip
RUN pip3 install wheel
RUN pip3 install phonenumbers

### RUN pip3 install pyOpenSSL

#WORKDIR /opt/odoo
#RUN git clone https://www.github.com/odoo/odoo.git --depth 1 --branch 11.0 --single-branch
#RUN chown -R odoo:odoo .
#WORKDIR /opt/odoo/odoo
#RUN pip3 install -r requirements.txt
