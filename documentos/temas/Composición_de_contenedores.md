# Composición de contenedores

<!--@
prev: Desarrollo_basado_en_pruebas
next: Integracion_continua
-->

<div class="objetivos" markdown="1">

## Objetivos

### Cubre los siguientes objetivos de la asignatura

* Conocer las diferentes tecnologías y herramientas de virtualización
  tanto para procesamiento, comunicación y almacenamiento.
* Instalar, configurar, evaluar y optimizar las prestaciones de un
  servidor virtual.
* Diseñar, implementar y construir un centro de procesamiento de datos
  virtual.
* Documentar y mantener una plataforma virtual.
* Optimizar aplicaciones sobre plataformas virtuales.
* Conocer diferentes tecnologías relacionadas con la virtualización
  (Computación Nube, Utility Computing, Software as a Service) e
  implementaciones tales como Google AppSpot, OpenShift o Heroku.
* Realizar tareas de administración en infraestructura virtual.

### Objetivos específicos

1. Entender cómo las diferentes tecnologías de virtualización se
   integran en la creación de contenedores.

2. Crear infraestructuras virtuales completas.

3. Comprender los pasos necesarios para la configuración automática de las mismas.

</div>

## Composición de servicios con `docker compose`

[Docker compose](https://docs.docker.com/compose/install/#install-compose)
tiene que instalarse de forma individual porque no forma parte del
conjunto de herramientas que se instalan por omisión (el daemon y el
cliente de línea de órdenes, principalmente). Su principal misión es
crear aplicaciones que usen diferentes contenedores, entre los que se citan
[entornos de desarrollo, entornos de prueba o en general despliegues
que usen un solo nodo](https://docs.docker.com/compose/#common-use-cases).
Para
entornos que escalen automáticamente, o entornos que se vayan a
desplegar en la nube las herramientas necesarias son muy diferentes.

`docker-compose` es una herramienta que parte de una descripción de
las relaciones entre diferentes contenedores y que construye y arranca
los mismos, relacionando los puertos y los volúmenes; por ejemplo,
puede usarse para conectar un contenedor con otro contenedor de datos,
de la forma siguiente:

```yaml
version: '2'

services:
  config:
    build: config
  web:
    build: .
    ports:
      - "80:5000"
    volumes_from:
      - config:ro
```

La especificación de la versión indica de qué versión del interfaz se
trata. Hay hasta una versión 3, con
[cambios sustanciales](https://docs.docker.com/compose/compose-file/). En
este caso, esta versión permite crear dos servicios, uno que
denominamos `config`, que será el contenedor que tenga la
configuración en un fichero, y otro que se llama `web`. YAML se
organiza como un *hash* o diccionario, de forma que `services` tiene
dos claves `config` y `web`. Dentro de cada una de las claves se
especifica como se levantan esos servicios. En el primer caso se trata
de `build` o construir el servicio a partir del Dockerfile, y se
especifica el directorio donde se encuentra; solo puede haber un
Dockerfile por directorio, así que para construir varios servicios
tendrán que tendrán que ponerse en directorios diferentes, como
en [este caso](https://github.com/JJ/p5-hitos). El segundo servicio
está en el mismo directorio que el fichero, que tiene que llamarse
`docker-compose.yml`, pero en este estamos indicando un mapeo de
puertos, con el 5000 interno cambiando al 80 externo (que, recordemos,
es un puerto privilegiado) y usando `volumes_from` para usar los
volúmenes, es decir, los datos, contenidos en el fichero
correspondiente.

Para ejecutarlo,

```shell
docker-compose up
```

Esto construirá las imágenes de los servicios, si no existen, y les
asignará un nombre que tiene que ver con el nombre del servicio;
también ejecutará el programa, en este caso de `web`. Evidentemente,
`docker-compose down` parará la máquina virtual.

<div class='ejercicios' markdown='1'>

Usar un miniframework REST para crear un servicio web y introducirlo
en un contenedor, y componerlo con un cliente REST que sea el que
finalmente se ejecuta y sirve como "frontend".

</div>

> En
> [este artículo](https://www.freecodecamp.org/news/docker-development-workflow-a-guide-with-flask-and-postgres-db1a1843044a/)
> se
> explica cómo se puede montar un entorno de desarrollo con Python y
> Postgres usando Docker Compose. Montar entornos de desarrollo
> independientemente del sistema operativo en el que se encuentre el
> usuario es, precisamente, uno de los casos de uso de esta
> herramienta.

La ventaja de describir la infraestructura como código es que, entre
 otras cosas, se puede introducir en un entorno de test tal como
 [Travis](https://travis-ci.org). Travis permite instalar cualquier
 tipo de servicio y lanzar tests; estos tests se interpretan de forma
 que se da un aprobado global a los tests o se indica cuales no han
 pasado.

Y en estos tests podemos usar `docker-compose` y lanzarlo:

```shell
services:
  - docker
env:
  - DOCKER_COMPOSE_VERSION=1.17.0

before_install:
  - sudo rm /usr/local/bin/docker-compose
  - curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  - chmod +x docker-compose
  - sudo mv docker-compose /usr/local/bin
  - docker-compose up

script:
  - docker ps -a | grep -q web
```

Como se ve más o menos, este fichero de configuración en YAML
reproduce diferentes fases del test. Después de seleccionar la versión
con la que vamos a trabajar, en la fase `before_install` borramos (por
si hubiera una versión anterior) e instalamos desde cero
`docker-compose`, y finalmente hacemos un `build` usando el fichero
`docker-compose.yml` que debe estar en el directorio principal; con
`up` además levantamos el servicio. Si hay
algún problema a la hora de construir el test parará; si no lo hay,
además, en la fase `script` que es la que efectivamente lleva a cabo
los tests se comprueba que haya un contenedor que incluya el nombre
`web` (el nombre real será algo así como `web-algo-1`, pero siempre
incluirá el nombre del servicio en compose). Si es así, el test
pasará, si no, el test fallará, con lo que podremos comprobar offline
si el código es correcto o no.

> Estos tests se pueden hacer también con simples Dockerfile, y de
> hecho sería conveniente combinar los tests de los servicios
> conjuntos con los tests de Dockerfile. Cualquier infraestructura es
> código, y como tal si no está testeado está roto.

## A dónde ir desde aquí

