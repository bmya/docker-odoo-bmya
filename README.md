# Odoo 11.0 Community Dockerizado

## Para que se usa
Esta imágen se usa para montar Odoo Versión 11 Community mediante
*Docker Compose*.

## Prerrequisitos:
**Instalar docker y docker-compose.**

Ver instrucciones para instalar estos compoenentes en la siguiente url:


![Instalar Docker](https://docs.docker.com/install/)



![Instalar Docker Compose](https://docs.docker.com/compose/install/)


## Modalidades de montaje
Se proveen dos opciones de docker-compose.yml

#### Standalone:
Sirve para que con este único archivo, se pueda levantar la base de datos Postgres y Odoo.

##### Bridge:
Sirve para combinar con un docker-compose separado para levantar Postgres, de manera que el mismo
contenedor de postgres pueda servir a varias versiones de Odoo, o a varios sistemas diferentes.

Esto permite también que se pueda mantener postgres levantado, mientras se reinicia docker compose 
solamente para Odoo.

Se denomina **bridge**, porque la configuración que se usa en el sistema permite
conectar las redes de ambos docker-compose mediante un puente de redes.

### Cómo se usa
Previo a correr, se debe decidir con qué imágen se desea utilizar. Las imágenes posibles son:
 
- **Imágen privada de BMyA:** Esta imágen debe contar con soporte brindado por parte de BMyA
y es exclusivamente para clientes de nuestra empresa. La versión es la misma, pero se brinda soporte
en base a contrato.

    ```
    docker pull hub.bmya.cl:5000/bmya-odoo11c:l02
    ```

- **Imágen pública de BMyA:** esta imágen se puede descargar de `https://hub.docker.com` con el 
siguiente comando:

    ```
    docker pull bmya/odoo-bmya:11.0_latest
    ```

También puede descargarse reemplazando dentro del `docker-compose.yml`el nombre de la imágen 
privada por la pública.


si se usa en standalone o bridge. Una
vez tomada la decisión, se puede realizar un link simbolíco a docker-compose
desde uno de los dos directorios, bridge o standalone al directorio corriente.
Por defecto el link simbólico apunta al directorio bridge. En caso de
querer cambiarlo se puede hacer mediante el siguiente comando:

    
    rm docker-compose.yml
    ln -s standalone/docker-compose.yml
    

#### Caso standalone:

Basta con pararse en el directorio donde se ha descargado este repositorio, 
y se corre `docker-compose up`, con cualquiera de las opciones.

#### Caso bridge:

Se debe levantar postgres por separado (con `docker-compose up` en otro directorio 
para pg), y a posterior, correr `docker-compose up` en cualquiera de sus opciones, 
parado en el directorio corriente.

### Archivo `doeall`

`doeall` es un script que tiene la capacidad de bajar, destruir y levantar
nuevamente el contenedor de odoo.

