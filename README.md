# docker-compose-moodle
![Moodle](https://img.shields.io/badge/Moodle-3.1-blue.svg?colorB=f98012)
![Apache2](https://img.shields.io/badge/Apache2-2.4-blue.svg?colorB=557697)
![PHP](https://img.shields.io/badge/PHP-5.6-blue.svg?colorB=8892BF)
![Postgres](https://img.shields.io/badge/Postgres-9.3-blue.svg?colorB=0085B0)
[![Software License](https://img.shields.io/badge/License-APACHE-black.svg?style=flat-square&colorB=585ac2)](LICENSE)

docker-compose-moodle es un repositorio para crear rápidamente un entorno de trabajo con Moodle (Apache2, PHP-FPM con XDEBUG y Postgres) usando contenedores para cada uno sus principales componentes. El entorno de trabajo se crea y gestiona con Docker Compose.

## Pasos rápidos para crear proyecto:
1. Tener Docker. Ver como instalar [_Docker_](#markdown-header-instalar-docker) en Ubuntu
2. Tener Docker Compose. Ver como instalar [_Docker Compose_](#markdown-header-instalar-docker-compose) en Ubuntu
3. Descargar este repo y acceder a él: ``` bash git clone https://jobcespedes@bitbucket.org/jobcespedes/docker-compose-moodle.git```
4. Copiar repositorio de código de Moodle: ``` bash git clone -b moodle_27_dev_bbb https://soporte-metics@bitbucket.org/metics/nube-moodle.git html```
5. Poner archivo de respaldo (**dump-init.sql.gz**) de base de datos a restaurar en **db_dumps**
6. Desplegar con: ``` bash docker-compose up -d```

A continuación se incluye una tabla con la estructura:

| Componente | Tipo | Responsabilidad | Contenido | Configuración |
| :--- |:--- | :---|:---|
| **apache2** | Contenedor | Servicio web | Debian8, Apache2 | El mínimo de módulos de apache y el [servidor web](http://dockerfile.readthedocs.io/en/latest/content/DockerImages/dockerfiles/php-apache.html#web-environment-variables) |
| **cron** | Contenedor|Tarea de cron de Moodle | Debian8, Cron | Frecuencia de ejecución de tarea cron de Moodle |
| **db_dumps** | Volumen | Restaurar una base de datos inicial | Archivos de respaldo de base de datos. | Para restaurar al iniciar, nombre el archivo sql de respaldo como dump-init.sql.gz |
| **moodledata** | Volumen | [Almacen de datos de moodle](https://docs.moodle.org/all/es/Directorio_Moodledata) | Archivos generados por Moodle |  |
| **php-fpm** | Contenedor | Interprete y manejador de procesos para PHP | Debian8, PHP-FPM, XDEBUG | Modulos de php  y paquetes adicionales para Moodle  |
| **postgres** | Contenedor | Gestor de base de datos  | Debian8, Postgres | [Usuario y base de datos](https://hub.docker.com/_/postgres/) |
| ***REPO_FOLDER*** | Volumen | Código de aplicación  | Código de Moodle  | Por defecto es './html' (ver archivo .env) |

La siguiente tabla contiene las variables utilizadas en el archivo [**.env**](.env) para docker compose:

| Variable | Valor por defecto | Utilidad |
| :--- |:--- |:--- |
| **REPO_FOLDER** | html | Ruta relativa para código de Moodle |
| **DOCUMENT_ROOT** | /var/www/html | Ruta de directorio público donde montar **REPO_FOLDER** |
| **MY_TZ** | America/Costa_Rica | Zona horaria para los contenedores |
| **PG_LOCALE** | es_CR | Configuración de lugar |
| **PG_PORT** | 5432 | Puerto de base de datos postgres a publicar  |
| **POSTGRES_DB** | moodle | Nombre de la base de datos postgres de Moodle |
| **POSTGRES_USER** | metics | Nombre de usuario de la base de datos postgres de Moodle |
| **POSTGRES_PASSWORD** | devpass | Contraseña de la base de datos postgres de Moodle |
| **PHP_SOCKET** | 9000 | Socket para conectar apache2 con php-fpm |
| **ALIAS_DOMAIN** | localhost | alias de dominio |
| **WWW_PORT** | 80 | Puerto web a publicar |
| **MOODLE_DATA** | /var/moodledata | Carpeta de datos de Moodle a montar en los contenedores |
| **WWWROOT** | localhost | Para de nombre de host en la url de config.php de Moodle |


## Gestión del entorno con Docker Compose
> **Dentro de la carpeta del proyecto**

1. Detener el proyecto
``` bash
docker-compose stop
```
2. Iniciar el proyecto
``` bash
docker-compose stop
```

2. Correr proyecto
``` bash
docker-compose up -d
# Nombrar el proyecto diferente a la carpeta:
# docker-compose -p mi-proy up -d
```
3. Eliminar proyecto
``` bash
docker-compose down
# Eliminar los volumenes también:
# docker-compose --volumes
# Eliminar con un nombre de proyecto especifico:
# docker-compose -p mi-proy down
```
4. Algunos comandos útiles de Docker
``` bash
# Ver contenedores
docker ps
# Ver imágenes
docker images
# Ingresar a un contenedores
 docker exec -it <nombre_contenedor> bash
# Ver logs de un contenedor
docker logs <nombre_contenedor> -f
# Eliminar imágenes huérfanas
docker rmi $(docker images -f "dangling=true" -q)
```

## Notas
> Restaurar una base de datos al inicio

Se puede restaurar una base de datos, agregando el script sql generador (comprimido como gzip) a la caperta db_dumps y nombrando el archivo como dump-init.sql.gz
> **IMPORTANTE**: Dependiendo del tamaño, la ejecución de este sql podría demorar la disponibilidad inicial de la base de datos.

## Instalar Docker
A partir de instrucciones en [la documentación de Docker](https://docs.docker.com/engine/installation/linux/ubuntu/)
``` bash
sudo apt-get update

# Paquetes extra
sudo apt-get install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

#Configurar el repositorio
sudo apt-get install apt-transport-https \
                       software-properties-common \
                       ca-certificates

# Agregar llave oficial GPG de docker
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

# Validar que llave sea 58118E89F3A912897C070ADBF76221572C52609D
$(apt-key fingerprint 58118E89F3A912897C070ADBF76221572C526091 | wc -l | grep -qv 0) && echo Verificado || echo "Error de verificacion"

# Instalar repositorio estable
sudo apt-get install software-properties-common
sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

# Instalar docker
sudo apt-get update
sudo apt-get -y install docker-engine

# Usuarios y grupos
sudo groupadd docker
sudo usermod -aG docker $USER

# Verificar la instalación
sudo docker run hello-world
```

## Instalar Docker Compose
Basado en la [doc de Docker-compose][c1ae1065]
``` bash
curl -L https://github.com/docker/compose/releases/download/1.10.0/run.sh > /tmp/docker-compose
chmod +x /tmp/docker-compose
sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
```

  [c1ae1065]: https://docs.docker.com/compose/install/ "Docker-compose"
