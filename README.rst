# como partir con Odoo en un servidor limpio en 7 pasos.
# primero: instalar docker
sudo apt-get -y install docker.io

# segundo: agregar el usuario actual al grupo docker
sudo gpasswd -a ${USER} docker

# tercero: reiniciar servicio docker
sudo service docker restart

# cuarto: cerrar y abrir sesión para tomar los cambios

# quinto: correr un contenedor docker con postgres a partir
# de la imágen oficial de postgres
docker run -d --name="postgres" \
  -v /opt/database:/var/lib/postgresql/data \
  -v /var/log/postgresql:/var/log/postgresql postgres:9.3

# sexto: conectarse al contenedor  postgres y crear un usuario "odoo" en la imagen de postgres
docker run -it --link postgres:postgres --rm postgres \
  sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" \
  -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

CREATE USER odoo WITH PASSWORD 'odoo';
ALTER USER odoo WITH SUPERUSER;

# séptimo: salir de psql
\q

# octavo: correr un contenedor de Odoo conectándo postgres
docker run -d \
-v /opt/odoo/test-addons:/mnt/test-addons \
-p 127.0.0.1:8069:8069 \
--name odoo \
--link postgres:db -t bmya/odoo-bmya:latest