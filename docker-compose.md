# Como instalar docker-compose como un contenedor
Basado en la [doc de Docker-compose][c1ae1065]
``` bash
curl -L https://github.com/docker/compose/releases/download/1.10.0/run.sh > /tmp/docker-compose
chmod +x /tmp/docker-compose
sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
```

# Notas
Correr proyecto
``` bash
# Modificar y cargar variables de entorno
. variables.env
# Levantar stack
docker-compose up -d
# Nombrar el proyecto diferente a la carpeta:
# docker-compose -p dev-metics up -d
```
Eliminar proyecto
``` bash
docker-compose down
# Eliminar con un nombre de proyecto especifico:
# docker-compose -p dev-metics down
# Eliminar los volumenes también:
# docker-compose -p postgres down --volumes
```
  [c1ae1065]: https://docs.docker.com/compose/install/ "Docker-compose"
