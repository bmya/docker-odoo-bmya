odoo11:l01 Esta imagen usa entrypoint /opt/odoo/odoo/odoo-bin y cmd /opt/odoo/odoo/odoo-bin
odoo11:l02 Esta imagen es con entrypoint y sin command


doeall:

docker rm db
docker rm odoo11

docker run -d --name="db" \
-p 127.0.0.1:5434:5432 \
-e POSTGRES_USER=odoo \
-e POSTGRES_PASSWORD=odoo \
-v /Users/danielb/odoo/pg/database:/var/lib/postgresql/data \
postgres:9.5

docker run -u root -ti \
-p 8069:8069 --name="odoo11" \
--link db:db \
-v /Users/danielb/odoo/odoo11/conf:/etc/odoo \
hub.bmya.cl:5000/odoo11:l01 bash

# Dentro del contenedor
/opt/odoo/odoo/odoo-bin -c /etc/odoo/odoo.conf
