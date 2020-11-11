# Usando *docker machines*

Docker es una aplicación cliente-servidor que se ejecuta
localmente. Gestionar contenedores remotos implicaría, generalmente,
trabajar con ejecutores remotos tipo Ansible lo que, en caso de que
haya que trabajar con muchos contenedores, generaría todo tipo de
inconvenientes. Para eso
está
[`docker-machine`](https://docs.docker.com/machine/overview/),
que en general sirve
para trabajar con gestores de contenedores en la nube o con
hipervisores locales, aunque solo funciona con unos pocos, y
generalmente privativos. El caso de uso principal de docker machines
es en sistemas operativos, como Windows y OSX, que no tienen una
implementación nativa (en el segundo caso) o siempre que quieras
generar contenedores nativos Linux (que son los más comunes) en ese
tipo de arquitectura.

[Docker machine se descarga desde Docker](https://docs.docker.com/machine/) y
su funcionamiento es similar a otras herramientas como Vagrant. En
general, tras crear y gestionar un sistema en la nube, o bien instalar
un *daemon* que se pueda controlar localmente, crea un entorno en la
línea de órdenes que permite usar el cliente `docker` con estos
entornos remotos.

Vamos a trabajar con VirtualBox localmente. Ejecutando

```shell
docker-machine create --driver=virtualbox maquinilla
```

se le indica a `docker-machine` que vamos a crear una máquina llamada
`maquinilla` y que vamos a usar el driver de VirtualBox. Esta orden,
en realidad, trabaja sobre VirtualBox instalando una imagen llamada
`boot2docker`, una versión de sistema operativo un poco destripada que
arranca directamente en Docker. Como también suele suceder en gestores
de este estilo, se crea un par clave pública-privada que nos va a
servir más adelante para trabajar con esa máquina.

Con `ls` listamos las máquinas virtuales que hemos gestionado, así
como alguna información adicional:

```shell
$ docker-machine ls
NAME     ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
maquinilla   -    virtualbox   Running   tcp://192.168.99.104:2376        v1.12.5
vbox-test    -    virtualbox   Running   tcp://192.168.99.100:2376        v1.12.5
```

Aquí hay dos máquinas, cada una con una dirección IP virtual que vamos
a usar para conectarnos a ellas directamente o desde nuestro cliente
docker. Por ejemplo, hacer `ssh`

```shell
$ docker-machine ssh maquinilla
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/
 _                 _   ____     _            _
| |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
| '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
| |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
|_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
Boot2Docker version 1.12.5, build HEAD : fc49b1e - Fri Dec 16 12:44:49 UTC 2016
Docker version 1.12.5, build 7392c3b
```

Como vemos, estamos
en [Boot2Docker](https://github.com/boot2docker/boot2docker), un Linux
ligero, con el servicio de Docker incluido, que vamos a poder usar
para desplegar y demás.

Si queremos usarlo más en serio, desde nuestra línea de órdenes,
tenemos que ejecutar

```shell
docker-machine env maquinilla
```

Que devolverá algo así:

```shell
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.104:2376"
export DOCKER_CERT_PATH="/home/jmerelo/.docker/machine/machines/maquinilla"
export DOCKER_MACHINE_NAME="maquinilla"
# Run this command to configure your shell:
# eval $(docker-machine env maquinilla)
```

Si estamos ejecutando desde superusuario, habrá que ejecutar

```shell
eval $(docker-machine env maquinilla)
```

Esa orden exporta las variables anteriores, que le indicarán a docker
qué tiene que usar en ese *shell* explícitamente. Cada nuevo shell
tendrá también que exportar esas variables para poder usar la máquina
virtual. Las órdenes docker que se ejecuten a continuación se
ejecutarán en esa máquina; por ejemplo,

```shell
sudo -E docker pull jjmerelo/alpine-perl6
```

descargará dentro de la máquina virtual esa imagen y se ejecutará
dentro de ella cualquier orden. En este caso, -E sirve para que las
variables de entorno del shell local, que hemos establecido
anteriormente, se transporten al nuevo shell. Efectivamente, desde el
nuevo shell podemos comprobar que existen

```text
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
jjmerelo/alpine-perl6   latest              837fc8bf9307        10
hours ago        491.5 MB
```

De la misma forma podemos operar con servidores en la nube, con solo
usar los drivers correspondientes.

<div class='ejercicios' markdown='1'>

Crear con docker-machine una máquina virtual local que permita
desplegar contenedores y ejecutar en él contenedores creados con
antelación.

</div>

## A dónde ir desde aquí

Si te interesa, puedes consultar cómo
se [virtualiza el almacenamiento](Almacenamiento) que, en general, es
independiente de la generación de una máquina virtual. También puedes
ir directamente al [tema de uso de sistemas](Uso_de_sistemas) en el
que se trabajará con sistemas de virtualización completa.
