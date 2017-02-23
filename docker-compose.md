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
docker-compose -f docker-compose-temp.yml -p borrarme up
```
  [c1ae1065]: https://docs.docker.com/compose/install/ "Docker-compose"
