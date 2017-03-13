# Como instalar docker-compose como un contenedor
Basado en la [doc de Docker-compose][c1ae1065]
``` bash
curl -L https://github.com/docker/compose/releases/download/1.10.0/run.sh > /tmp/docker-compose
chmod +x /tmp/docker-compose
sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
```

# Pasos para utilizar este repositorio
1. El primer paso es descargarlo
``` bash
git clone https://github.com/jobcespedes/moodlerize.git
```

2. Modificar el entorno de trabajo

3. Correr proyecto
``` bash
docker-compose up -d
# Nombrar el proyecto diferente a la carpeta:
# docker-compose -p mi-proy up -d
```
Eliminar proyecto
``` bash
docker-compose down
# Eliminar con un nombre de proyecto especifico:
# docker-compose -p mi-proy down
# Eliminar los volumenes también:
# docker-compose -p mi-proy down --volumes
```
  [c1ae1065]: https://docs.docker.com/compose/install/ "Docker-compose"
