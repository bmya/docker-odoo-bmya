FROM bmya/odoo:latest
MAINTAINER Blanco Martín & Asociados <daniel@blancomartin.cl>
# based on https://github.com/ingadhoc/docker-odoo-adhoc
# with custom refferences
ENV REFRESHED_AT 2015-09-20

# install some dependencies
USER root

RUN apt-get update \
        && apt-get install -y \
        python-pip git sudo vim python-xlrd

# Workers and longpolling dependencies
RUN apt-get install -y python-gevent

RUN apt-get install -y python-dev

# odoo-extra
RUN apt-get install -y python-matplotlib font-manager 

# to be removed when we remove crypto
RUN apt-get install -y swig libssl-dev

# aeroo direct print
RUN apt-get install -y libcups2-dev

# odoo argentina (nuevo modulo de FE)
RUN apt-get install -y swig libffi-dev libssl-dev python-m2crypto python-httplib2 mercurial python-pandas


ADD ./requirements.txt .
RUN pip install -r requirements.txt

# Agregado por Daniel Blanco para ver si soluciona el problema de la falta de la biblioteca pysimplesoap
# RUN git clone https://github.com/pysimplesoap/pysimplesoap.git
# WORKDIR /pysimplesoap/
# RUN python setup.py install

RUN hg clone https://code.google.com/p/pyafipws
WORKDIR /pyafipws/
RUN python setup.py install
RUN chmod 777 -R /usr/local/lib/python2.7/dist-packages/pyafipws/

# RUN git clone https://github.com/reingart/pyafipws.git
# WORKDIR /pyafipws/
# RUN python setup.py install
# RUN chmod 777 -R /usr/local/lib/python2.7/dist-packages/pyafipws/

RUN mkdir -p /opt/odoo/stable-addons/bmya
RUN mkdir -p /opt/odoo/stable-addons/bmya/odoo-chile
RUN mkdir -p /opt/odoo/.filelocal/odoo

# update openerp-server.conf file (todo: edit with "sed")
COPY ./openerp-server.conf /etc/odoo/
RUN chown odoo /etc/odoo/openerp-server.conf
RUN chown -R odoo /opt/odoo
RUN chown -R odoo /mnt/extra-addons
RUN chown -R odoo /mnt/test-addons

WORKDIR /opt/odoo/stable-addons/
RUN git clone https://github.com/aeroo/aeroo_reports.git

WORKDIR /opt/odoo/stable-addons/bmya/
RUN git clone -b bmya_custom https://github.com/bmya/odoo-addons.git
RUN git clone https://github.com/bmya/server-tools.git
RUN git clone https://github.com/bmya/pos-addons.git
RUN git clone https://github.com/bmya/ws-zilinkas.git
RUN git clone https://github.com/bmya/addons-vauxoo.git
RUN git clone https://github.com/bmya/addons-yelizariev.git
RUN git clone -b custom_cl3 https://github.com/bmya/odoo-argentina.git
RUN git clone https://github.com/bmya/odoo-web.git
RUN git clone https://github.com/bmya/website-addons.git

WORKDIR /opt/odoo/stable-addons/bmya/odoo-chile/
RUN git clone https://github.com/odoo-chile/l10n_cl_base.git
RUN git clone https://github.com/odoo-chile/l10n_cl_vat.git
RUN git clone https://github.com/odoo-chile/l10n_cl_toponyms.git
RUN git clone https://github.com/odoo-chile/l10n_cl_financial_indicators.git
RUN git clone https://github.com/odoo-chile/l10n_cl_partner_activities.git
RUN git clone https://github.com/odoo-chile/l10n_cl_banks_sbif.git
RUN git clone https://github.com/odoo-chile/l10n_cl_invoice.git
RUN git clone https://github.com/odoo-chile/base_state_ubication.git
RUN git clone https://github.com/odoo-chile/decimal_precision_currency.git
RUN git clone https://github.com/odoo-chile/invoice_printed.git


RUN chown -R odoo:odoo /opt/odoo/stable-addons
WORKDIR /opt/odoo/stable-addons/

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
