# Cómo partir con Odoo en un servidor limpio en 8 pasos.

## Prerequisitos:
Según nuestras últimas pruebas es conveniente la preexistencia de un usuario "odoo" en el sistema donde se realiza la instalación.

## 1) Instalar docker

sudo wget -qO- https://get.docker.com/ | sh 

(probado en Ubuntu 14.04.  Para otras versiones de sistema operativo, consultar el sitio de Docker).

## 2) Agregar el usuario actual al grupo docker

sudo gpasswd -a ${USER} docker

Esto permitirá que tu usuario, pertenezca al grupo 'docker', y de esta manera no será necesario utilizar "sudo" delante de los comandos para cargar docker.

## 3) Reiniciar servicio docker

Una vez realizado este cambio, deberás reiniciar el servicio docker para que tome el cambio.

sudo service docker restart

## 4) Cerrar y abrir sesión para tomar los cambios
.. esto permitirá que el sistema operativo te tome como usuario del grupo docker.

## 5) Correr un contenedor docker con postgres a partir
de la imágen oficial de postgres

docker run -d --restart="always" --name="postgres" \
-v /opt/database:/var/lib/postgresql/data \
-v /var/log/postgresql:/var/log/postgresql postgres:9.4

En caso que además desees que el contenedor se reinicie al reiniciar el equipo, deberás incluir --restart="always" como una de las opciones del comando. (válido para todos los contenedores).

## 6) Conectarse al contenedor postgres y crear un usuario "odoo" en la imagen de postgres
Esto debe ser hecho por única vez:

docker exec -ti postgres sh -c 'exec psql -U postgres'

CREATE USER odoo WITH PASSWORD 'odoo';
ALTER USER odoo WITH SUPERUSER;

## 7) Salir de psql
\q

## 8) Correr un contenedor de Odoo conectando postgres:
docker run --rm -ti --name odoo \
-v ~/odoo-docker-data/mnt/odoo/extra-addons:/mnt/extra-addons \
-v ~/odoo-docker-data/mnt/filelocal/odoo:/mnt/filelocal/odoo \
-v ~/odoo-docker-data/var/lib/odoo:/var/lib/odoo \
-p 8069:8069 \
--link db:db -t jalvcl/odoo_bmya_cl_dte:20.03.01

