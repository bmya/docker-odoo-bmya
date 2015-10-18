FROM bmya/odoo:latest
MAINTAINER Blanco Martín & Asociados <daniel@blancomartin.cl>
# based on https://github.com/ingadhoc/docker-odoo-adhoc
# with custom refferences


# install some dependencies
USER root

# Generate locale (es_AR for right odoo es_AR language config, and C.UTF-8 for postgres and general locale data)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y locales -qq
RUN echo 'es_AR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'es_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'C.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN dpkg-reconfigure locales && /usr/sbin/update-locale LANG=C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Install some deps
RUN apt-get update \
        && apt-get install -y \
        python-pip git sudo vim

# Workers and longpolling dependencies
RUN apt-get install -y python-gevent
RUN pip install psycogreen

## Install pip dependencies for adhoc used odoo repositories

# used by many pip packages
RUN apt-get install -y python-dev

# odoo-extra
RUN apt-get install -y python-matplotlib font-manager

# odoo argentina (nuevo modulo de FE)
RUN apt-get install -y swig libffi-dev libssl-dev python-m2crypto python-httplib2 mercurial
RUN pip install geopy==0.95.1 BeautifulSoup pyOpenSSL suds

# odoo bmya cambiado de orden (antes o despues de odoo argentina)
# to be removed when we remove crypto
RUN apt-get install -y swig libssl-dev
# to be removed when we remove crypto
RUN pip install suds


#### daniel # para facturacion electrónica
# sudo apt-get -y install swig
# apt-get -y install python-m2crypto
# vpip install suds


# Agregado por Daniel Blanco para ver si soluciona el problema de la falta de la biblioteca pysimplesoap
# RUN git clone https://github.com/pysimplesoap/pysimplesoap.git
# WORKDIR /pysimplesoap/
# RUN python setup.py install

# instala pyafip desde google code usando mercurial
# M2Crypto suponemos que no haria falta ahora
RUN hg clone https://code.google.com/p/pyafipws
WORKDIR /pyafipws/
# ADD ./requirements.txt /pyafipws/
RUN pip install -r requirements.txt
RUN python setup.py install
RUN chmod 777 -R /usr/local/lib/python2.7/dist-packages/pyafipws/

# RUN git clone https://github.com/reingart/pyafipws.git
# WORKDIR /pyafipws/
# RUN python setup.py install
# RUN chmod 777 -R /usr/local/lib/python2.7/dist-packages/pyafipws/

# odoo etl, infra and others
RUN pip install openerp-client-lib fabric erppeek fabtools


# oca reports
RUN pip install xlwt

# odoo kineses
RUN pip install xlrd

# create directories for repos
RUN mkdir -p /opt/odoo/stable-addons/bmya
RUN mkdir -p /opt/odoo/stable-addons/oca
RUN mkdir -p /opt/odoo/stable-addons/bmya/odoo-chile
RUN mkdir -p /opt/odoo/.filelocal/odoo

# update openerp-server.conf file (todo: edit with "sed")
COPY ./openerp-server.conf /etc/odoo/
RUN chown odoo /etc/odoo/openerp-server.conf
RUN chown -R odoo /opt/odoo
RUN chown -R odoo /mnt/extra-addons
RUN chown -R odoo /mnt/test-addons

# oca partner contacts
RUN pip install unicodecsv

# aeroo direct print
RUN apt-get install -y libcups2-dev
RUN pip install git+https://github.com/aeroo/aeroolib.git@master
RUN pip install pycups==1.9.68

# akretion/odoo-usability
RUN pip install BeautifulSoup4

# OCA knowledge
RUN pip install python-magic

# odoo support
RUN pip install erppeek

# Instalación de repositorios varios BMyA
WORKDIR /opt/odoo/stable-addons/bmya/
RUN git clone -b bmya_custom https://github.com/bmya/odoo-addons.git
# RUN git clone https://github.com/bmya/odoo-crypto.git
RUN git clone https://github.com/bmya/server-tools.git
RUN git clone https://github.com/bmya/pos-addons.git
RUN git clone https://github.com/bmya/ws-zilinkas.git
# Eliminado para evitar la gran instalación de dependencias que tiene
# (Por ahora para tenerlo estable)
# RUN git clone https://github.com/bmya/addons-vauxoo.git
RUN git clone https://github.com/bmya/addons-yelizariev.git
# RUN git clone -b custom_cl3 https://github.com/bmya/odoo-argentina.git

RUN git clone https://github.com/bmya/odoo-argentina.git

RUN git clone https://github.com/bmya/odoo-web.git
RUN git clone https://github.com/bmya/website-addons.git
RUN git clone https://github.com/bmya/tkobr-addons.git tko

WORKDIR /opt/odoo/stable-addons/bmya/odoo-chile/
RUN git clone https://github.com/odoo-chile/l10n_cl_base.git
RUN git clone https://github.com/odoo-chile/l10n_cl_vat.git
RUN git clone https://github.com/odoo-chile/l10n_cl_base_rut.git
RUN git clone https://github.com/odoo-chile/l10n_cl_toponyms.git
RUN git clone https://github.com/odoo-chile/l10n_cl_financial_indicators.git
RUN git clone https://github.com/odoo-chile/l10n_cl_partner_activities.git
RUN git clone https://github.com/odoo-chile/l10n_cl_banks_sbif.git
RUN git clone https://github.com/odoo-chile/l10n_cl_invoice.git
RUN git clone https://github.com/odoo-chile/base_state_ubication.git
RUN git clone https://github.com/odoo-chile/decimal_precision_currency.git
RUN git clone https://github.com/odoo-chile/invoice_printed.git
RUN git clone https://github.com/odoo-chile/l10n_cl_hr_payroll.git

WORKDIR /opt/odoo/stable-addons/oca/
RUN git clone -b 8.0 https://github.com/OCA/web.git
RUN git clone -b 8.0 https://github.com/OCA/knowledge.git

RUN chown -R odoo:odoo /opt/odoo/stable-addons
WORKDIR /opt/odoo/stable-addons/
RUN git clone https://github.com/aeroo/aeroo_reports.git

## Clean apt-get (copied from odoo)
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make auto_install = False for various modules
RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/im_chat/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/im_odoo_support/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/bus/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/base_import/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/portal/__openerp__.py

RUN sed  -i  "s/'auto_install': False/'auto_install': True/" /opt/odoo/stable-addons/bmya/addons-yelizariev/web_logo/__openerp__.py

USER odoo
