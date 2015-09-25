FROM bmya/odoo:latest
MAINTAINER Blanco Martín & Asociados <daniel@blancomartin.cl>
# based on https://github.com/ingadhoc/docker-odoo-adhoc
# with custom refferences

ENV REFRESHED_AT 2015-09-20

# install some dependencies
USER root

RUN apt-get update \
        && apt-get install -y \
        python-pip git sudo

# Workers and longpolling dependencies
RUN apt-get install -y python-gevent
## RUN pip install psycogreen


# used by many pip packages
RUN apt-get install -y python-dev

# odoo-extra
RUN apt-get install -y python-matplotlib font-manager

# odoo fact electronica (pip dependencies for adhoc)

# to be removed when we remove crypto
RUN apt-get install -y swig libssl-dev
# to be removed when we remove crypto
## RUN pip install M2Crypto suds

# odoo argentina (nuevo modulo de FE)
RUN apt-get install -y swig libffi-dev libssl-dev python-m2crypto python-httplib2 mercurial
## RUN pip install geopy==0.95.1 BeautifulSoup pyOpenSSL suds

# M2Crypto suponemos que no haria falta ahora
RUN hg clone https://code.google.com/p/pyafipws
WORKDIR /pyafipws/
RUN pip install -r requirements.txt
RUN python setup.py install
RUN chmod 777 -R /usr/local/lib/python2.7/dist-packages/pyafipws/

# odoo etl, infra and others
## RUN pip install openerp-client-lib fabric fabtools

# oca reports
## RUN pip install xlwt

# odoo kineses
## RUN pip install xlrd

# oca partner contacts
## RUN pip install unicodecsv

# aeroo direct print
RUN apt-get install -y libcups2-dev
## RUN pip install git+https://github.com/aeroo/aeroolib.git@master
## RUN pip install pycups==1.9.68

# akretion/odoo-usability
## RUN pip install BeautifulSoup4

# OCA knowledge
## RUN pip install python-magic

# odoo support
## RUN pip install erppeek

## Clean apt-get (copied from odoo)
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /mnt/extra-addons
RUN git clone https://github.com/bmya/odoo-addons.git /mnt/extra-addons


# Make auto_install = False for various modules
RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/im_chat/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/im_odoo_support/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/bus/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/base_import/__openerp__.py

RUN sed  -i  "s/'auto_install': True/'auto_install': False/" /usr/lib/python2.7/dist-packages/openerp/addons/portal/__openerp__.py


USER odoo
