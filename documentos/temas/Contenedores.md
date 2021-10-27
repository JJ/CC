# Contenedores y cómo usarlos

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
* Configurar los diferentes dispositivos físicos para acceso a los
  servidores virtuales: acceso de usuarios, redes de comunicaciones o
  entrada/salida.
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

## Introducción a Docker

> Previamente a este tema conviene consultar la historia del
> aislamiento de aplicaciones en [este capítulo](Aislamiento.md), que
> se ha eliminado del temario en esta edición..

Docker es una herramienta que permite *aislar* aplicaciones, creando
*contenedores* que pueden almacenarse de forma permanente para
permitir el despliegue de esas mismas aplicaciones en la nube. Por lo
tanto, en una primera aproximación, Docker serían similares a otras
aplicaciones tales como LXC/LXD o incluso las *jaulas `chroot`*, es
decir, una forma de empaquetar una aplicación con todo lo necesario
para que opere de forma independiente del resto de las aplicaciones y
se pueda, por tanto, replicar, escalar, desplegar, arrancar y destruir
de forma también independiente.

> Una traducción más precisa de *container* sería
> [táper](https://www.fundeu.es/recomendacion/taper-adaptacion-espanola-del-anglicismo-tupper-1475/),
> es decir, un recipiente, generalmente de plástico, usado en
> cocina. Si me refiero a un táper a continuación, es simplemente por
> esta razón.

[Docker](https://www.docker.com) es una herramienta de gestión de
contenedores que permite no solo instalarlos, sino trabajar con el
conjunto de ellos instalados (orquestación) y exportarlos de forma que
se puedan desplegar en diferentes servicios en la nube. La tecnología de
[Docker](https://en.wikipedia.org/wiki/Docker_%28software%29) es
relativamente reciente, habiendo sido publicada en marzo de 2013;
actualmente está sufriendo una gran expansión, lo que ha llevado al
desarrollo paralelo de sistemas operativos tales como
[CoreOS](https://www.redhat.com/en/technologies/cloud-computing/openshift),
basado en Linux y que permite despliegue masivo de servidores. Pero no
adelantemos acontecimientos.

> Docker funciona mejor en Linux, fue creado para Linux y es donde
> tiene mejor soporte a nivel de núcleo del sistema operativo. Desde la
> última versión de Windows, la 10, funciona relativamente bien también
> en este sistema operativo. Si no tienes esa versión no te molestes;
> en todo caso, también en Windows 10 puedes usar el subsistema Linux
> (Ubuntu y últimamente OpenSuSE) para interactuar con
> Docker. Finalmente, aunque es usable desde Mac, en realidad el
> sistema operativo no tiene soporte para el mismo. Es mejor que en
> este caso se use una máquina virtual local o en la nube.

Aunque en una primera aproximación Docker es, como hemos dicho arriba,
similar a otras aplicaciones de virtualización *ligera*  como
`lxc/lxd`, que lo precedieron en el tiempo, sin embargo el enfoque de
Docker
[es fundamentalmente diferente](https://archives.flockport.com/lxc-vs-docker/) es
fundamentalmente diferente,
aunque las tecnologías subyacentes de virtualización por software son
las mismas. La principal diferencia es que Docker hace
énfasis en la gestión centralizada de recursos y, en una línea que va
desde la virtualización por hardware hasta la generación de un
ejecutable para su uso en cualquier otra máquina, estaría mucho más
cerca de ésta que de la primera, mientras que `lxc/lxd` estarían más
enfocados a empaquetar máquinas virtuales completas o casi. En la
práctica, muchas aplicaciones, como la creación de máquinas virtuales
efímeras para ejecución de aplicaciones, van a ser las mismas, pero
los casos de uso son también diferentes, con Docker tendiendo más
hacia uso de contenedores de *usar y tirar* y 'lxc/lxd' a una
alternativa ligera al uso de máquinas virtuales completas.

En todo caso, Docker se ha convertido últimamente en una herramienta
fundamental para el diseño de arquitecturas de software escalables,
sobre todo por su combinación con otra serie de herramientas como
Swarm o Kubernetes para orquestar conjuntos de contenedores, dando
también lugar a todo un ecosistema de aplicaciones y servicios que
permiten usarlo fácilmente e integrarlo dentro de los entornos de
desarrollo de software habituales, especialmente los denominados
*DevOps*. Y sí conviene tener en cuenta que un contenedor Docker sería
más parecido al ejecutable de una aplicación (con todo lo necesario
para que esta funcione), que a una máquina virtual, por lo que es más
preciso decir que *ejecutamos* un táper (que utilizaremos a partir de
ahora como sinónimo de "contenedor Docker") que *estamos ejecutando
algo en un táper*, de la misma forma que ejecutaríamos algo en una
máquina virtual.

A continuación vamos a ver cómo podemos usar Docker como simples
usuarios, para ver a continuación como se puede diseñar una
arquitectura usándolo, empezando por el principio, como instalarlo.

> Conviene que, en este momento o un poco más adelante, tengas
> preparada una instalación de un hipervisor o gestor de máquinas
> virtuales tipo VirtualBox o similar. Sea porque quieras tener una
> máquina virtual Linux específica para esto, o para tener varias
> máquinas virtuales funcionando a la vez.

## Instalación de Docker

[Instalar `docker`](https://www.docker.com/) es sencillo desde que se
publicó la versión 1.0, especialmente en distribuciones de Linux. Por
ejemplo, para
[Ubuntu hay que dar de alta una serie de repositorios](https://docs.docker.com/engine/installation/linux/ubuntulinux/)

aunque no funcionará con versiones más antiguas de la 12.04 (y en este
caso solo si se instalan kernels posteriores). En las últimas
versiones, de hecho, ya está en los repositorios oficiales de Ubuntu y
para instalarlo no hay más que hacer

```bash
sudo apt-get install docker-engine
```

aunque la versión en los repositorios oficiales suele ser más antigua
que la que se descargue de la web o los repositorios adicionales. Este
paquete incluye varias aplicaciones: un *daemon*, `dockerd`, y un
cliente de línea de órdenes, `docker`. La instalación dejará este
*daemon* ejecutándose y lo configurará para que se arranque con el
inicio del sistema. También una serie de *imágenes* genéricas con las
que se puede empezar a trabajar de forma más o menos inmediata.

> Hay también
> [diferentes opciones para instalar Docker en Windows](https://docs.docker.com/engine/installation/windows/)
> o en
> [un Mac](https://docs.docker.com/engine/installation/mac/).

Otra posibilidad para trabajar con Docker es
usar
[el anteriormente denominado CoreOS, ahora Container Linux](https://coreos.com/).
*Container
Linux* es una distribución diseñada para usar aplicaciones
distribuidas, casi de forma exclusiva, en contenedores, y aparte de
una serie de características interesantes, como el uso de `etcd` para
configuración distribuida, tiene un gestor de Docker instalado en la
configuración base.

Con cualquiera de las formas que hayamos elegido para instalar Docker,
vamos a comenzar desde el principio. Veremos a continuación cómo
empezar a ejecutar Docker.

## Comenzando a ejecutar Docker

> Red Hat ha liberado un gestor "serverless" (sin un servicio
> ejecutándose con privilegios) de contenedores
> llamado [Podman](https://podman.io/). Podman usa exactamente las
> mismas órdenes que Docker, pero no necesita un daemon con
> privilegios para funcionar.

Docker consiste, entre otras cosas, en un servicio que se encarga de
gestionar los contenedores y una herramienta de línea de ordenes que
es la que vamos a usar, en general, para trabajar con él.

Los paquetes de instalación estándar generalmente instalan Docker como
servicio para que comience a ejecutarse en el momento que arranque el
sistema. Si no se está ejecutando ya, se puede arrancar como un servicio

```bash
sudo dockerd &
```

La línea de órdenes de docker conectará con este daemon, que mantendrá
el estado de docker y demás. Cada una de las órdenes se ejecutará
también como superusuario, al tener que contactar con este *daemon*
usando un socket protegido.

Con una instalación estándar,

```bash
sudo status docker
```

debería responder si se está ejecutando o no. Si está parado,

```shell
sudo start docker
```

comenzará a ejecutarlo. Tras instalarlo
[debes seguir estas instrucciones](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
para poder usar el cliente desde un usuario sin privilegios.

Una vez instalado, se puede ejecutar el clásico

```shell
docker run hello-world
```

Generalmente, vamos a usar Docker usando su herramienta de la línea de
órdenes, `docker`, que permite instalar contenedores y trabajar con
ellos. El resultado de esta orden será un mensaje que te muestra que
Docker está funcionando. Sin embargo, veamos por partes qué es lo que
hace esta orden.

1. Busca una *imagen* de Docker llamada `hello-world`. Una imagen es
   equivalente a un *disco de instalación* que contiene los elementos que
   se van a aislar dentro del contenedor.
2. Al no encontrar esa imagen localmente, la descarga del
   [Hub de Docker](https://hub.docker.com/_/hello-world/), el lugar donde
   se suben las imágenes de Docker y donde puedes encontrar muchas más;
   más adelante se verán.

```text
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
78445dd45222: Pull complete
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest
```

1. Crea un *contenedor* usando como base esa imagen, es decir, el
   equivalente a *arrancar* un sistema usando como disco duro esa
   imagen.
2. Ejecuta un programa llamado `hello` situado *dentro* de esa
   imagen. Ese programa simplemente muestra el mensaje que nos
   aparece. Este es un programa que el autor ha configurado para que
   sea ejecutado cuando se ejecute el comando `run` sobre esa
   imagen. Este programa se está ejecutando *dentro* del contenedor y,
   por tanto, aislado del resto del sistema.
3. Sale del contenedor y te deposita en la línea de órdenes. El
   contenedor deja de ejecutarse. La imagen se queda almacenada
   localmente, para la próxima vez que se vaya a ejecutar.

De los pasos anteriores habrás deducido que se ha descargado una
imagen cuyo nombre es `hello-world` y se ha creado un contenedor, en
principio sin nombre. Puedes listar las imágenes que tienes con

```shell
docker images
```

que, en principio, solo listará una llamada `hello-world` en la
segunda columna, etiquetada IMAGES. Pero esto incluye solo las
imágenes en sí. Para listas los contenedores que tienes,

```shell
docker ps -a
```

listará los contenedores que efectivamente se han creado, por ejemplo:

```text
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
1e9e7dfe46e3        hello-world         "/hello"            3 seconds ago       Exited (0) 2 seconds ago                           focused_poincare
ec9ba7a27e93        hello-world         "/hello"            About an hour ago   Exited (0) About an hour ago                       dreamy_goldstine
```

Vemos dos contenedores, con dos IDs de contenedor diferentes, ambas
correspondientes a la misma imagen, `hello-world`. Cada vez que
ejecutemos la imagen crearemos un contenedor nuevo, por lo que
conviene que recordemos ejecutarlo, siempre que no vayamos a necesitarlo, con

```shell
docker run --rm hello-world
```

que borrará el contenedor creado una vez ejecutada la orden. Así se
mantiene el número de contenedores bajo y sobre todo se guardan solo y
exclusivamente los que se piensen mantener o trabajar más
adelante. Esta orden pone también de manifiesto la idea de
*contenedores de usar y tirar*. Una vez ejecutado el contenedor, se
dispone de la memoria y el disco que usa.

Como vemos, los contenedores pueden actuar como un *ejecutable*, una
forma de distribuir aplicaciones de forma independiente de la versión
de Linux y de forma efímera. De hecho, como tal ejecutable, se le
pueden pasar argumentos por línea de órdenes

```bash
docker run --rm jjmerelo/docker-daleksay -f smiling-octopus Uso argumentos, ea
```

que usa
[el contenedor `daleksay`](https://hub.docker.com/r/jjmerelo/docker-daleksay/)
para
imprimir a un pulpo sonriente diciendo cosas. Como vemos, se le pasa
como argumentos `-f smiling-octopus Uso argumentos, ea` de forma que
el contenedor actúa, para casi todos los efectos, como el propio
programa al que aísla.

<div class='ejercicios' markdown='1'>

Buscar alguna demo interesante de Docker y ejecutarla localmente, o en
su defecto, ejecutar la imagen anterior y ver cómo funciona y los
procesos que se llevan a cabo la primera vez que se ejecuta y las
siguientes ocasiones.

</div>

## Trabajando *dentro* de contenedores

Pero no solo podemos descargar y ejecutar contenedores de forma
efímera. También se puede crear un contenedor y trabajar en
él. Realmente, no es la forma adecuada de trabajar, que debería ser
reproducible y automática, pero se puede usar para crear prototipos o
para probar cosas sobre contenedores cuya creación se automatizará a
continuación. Comencemos por descargar la imagen.

```shell
docker pull alpine
```

Esta orden descarga una imagen de
[Alpine Linux](https://alpinelinux.org/) y la instala, haciéndola
disponible para que se creen, a partir de ella, contenedores. Como se
ha visto antes, las imágenes que hay disponibles en el sistema se
listan con

```shell
docker images
```

Si acabas de hacer el pull anterior, aparecerá esa y otras que hayas
creado anteriormente. También aparecerá el tamaño de la imagen, que es
solamente de unos 4 megabytes. Otras imágenes, como las de Ubuntu,
tendrán alrededor de 200 MBs, por lo que siempre se aconseja que se
use este tipo de imágenes, mucho más ligeras, que hace que la descarga
sea mucho más rápida.

Se pueden usar, sin embargo, las imágenes que sean más adecuadas para
la tarea, el prototipo o la prueba que se quiera realizar. Hay
muchas imágenes creadas y se pueden crear y compartir en el sitio web
de Docker, al estilo de las librerías de Python o los paquetes
Debian. Se pueden
[buscar todas las imágenes de un tipo determinado, como Ubuntu](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=ubuntu&starCount=0)
o
[buscar las imágenes más populares](https://hub.docker.com/search/?q=&type=image).
Estas imágenes contienen no solo sistemas operativos *bare bones*, sino
también otros con una funcionalidad determinada. Por ejemplo, una de
las imágenes más populares es la de
[`nginx`](https://hub.docker.com/_/nginx/), la de Redis o la de
Busybox, un sustituto del *shell* que incluye también una serie de
utilidades externas y que se pueden usar como imagen base.

<div class='ejercicios' markdown='1'>

Tomar algún programa simple, "Hola mundo" impreso desde el intérprete
de línea de órdenes, y comparar el tamaño de las imágenes de
diferentes sistemas operativos base, Fedora, CentOS y Alpine, por
ejemplo.

</div>

Si usas otra imagen, se tendrá que descargar lo que tardará más o
menos dependiendo de la conexión; hay también otro factor que veremos
más adelante. Una vez bajada, se pueden empezar a ejecutar comandos. Lo
bueno de `docker` es que permite ejecutarlos directamente, y en esto
tenemos que tener en cuenta que se va a tratar de comandos *aislados*
y que, en realidad, no tenemos una máquina virtual *diferente*.

Podemos ejecutar, por ejemplo, un listado de los directorios

```shell
docker run --rm alpine ls
```

Tras el sudo, hace falta el comando docker; `run` es el comando de
docker que estamos usando, `--rm` hace que la máquina se borre una vez
ejecutado el comando. `alpine` es el nombre de la máquina, el mismo
que le hayamos dado antes cuando hemos hecho pull y finalmente `ls`,
el comando que estamos ejecutando. Este comando arranca el contenedor,
lo ejecuta y a continuación sale de él. Esta es una de las ventajas de
este tipo de virtualización: es tan rápido arrancar que se puede usar
para un simple comando y dejar de usarse a continuación, y de hecho
hasta se puede borrar el contenedor correspondiente.

Esta imagen de Alpine no contiene bash, pero si el shell básico
llamado `ash` y que está instalado en `sh`,
por lo que podremos *meternos* en la misma ejecutando

```shell
docker run -it alpine sh
```

Dentro de ella podemos trabajar como un consola cualquiera, pero
teniendo acceso solo a los recursos propios.

### Trabajando con Alpine Linux

Alpine es una instalación peculiar y más bien mínima, pero es muy
interesante para usarla como base para nuestros propios contenedores,
por su minimalismo. Conviene
[consultar el wiki](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
para ver las tareas que se pueden realizar en ella.

Una de las primeras cosas que habrá que hacer es actualizar la
distribución. Alpine usa `apk` como gestor de paquetes, y la
instalación base no permite hacer gran cosa, así que para empezar
conviene hacer

```bash
apk update
apk upgrade
```

Para que actualice la lista de paquetes disponibles. Después, se
pueden instalar paquetes, por ejemplo

```bash
apk add git perl
```

Una vez añadido todo lo que queramos a la imagen, se puede almacenar o
subir al registro. En todo caso, `apk search` te permite buscar los
ficheros y paquetes que necesites para compilar o instalar algo. En
algunos casos puede ser un poco más complicado que para otras distros,
pero merece la pena.

### Tareas adicionales con contenedores Docker

La máquina instalada la podemos arrancar usando como ID el nombre de
la imagen de la que procede, pero cada
táper tiene un id único que se puede ver con

```bash
docker ps -a=false
```

siempre que se esté ejecutando, obteniendo algo así:

```text
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
b76f70b6c5ce        ubuntu:12.04        /bin/bash           About an hour ago   Up About an hour                        sharp_brattain
```

El primer número es el ID de la máquina que podemos usar también para
referirnos a ella en otros comandos. También se puede usar

```bash
docker images
```

Que, una vez más, devolverá algo así:

```text
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ubuntu              latest              8dbd9e392a96        9 months ago        128 MB
ubuntu              precise             8dbd9e392a96        9 months ago        128 MB
ubuntu              12.10               b750fe79269d        9 months ago        175.3 MB
ubuntu              quantal             b750fe79269d        9 months ago        175.3 MB
```

El *IMAGE ID* es el ID interno del contenedor, que se puede usar para
trabajar en una u otra máquina igual que antes hemos usado el nombre
de la imagen:

```shell
docker run b750fe79269d du
```

## Cómo crear imágenes de Docker interactivamente

En vez de ejecutar las cosas una a una podemos
directamente
[ejecutar un shell](https://docs.docker.com/engine/getstarted/step_two/):

```shell
docker run -i -t ubuntu /bin/bash
```

que [indica](https://docs.docker.com/engine/reference/commandline/cli/) que
se está creando un seudo-terminal (`-t`) y se está ejecutando el
comando interactivamente (`-i`). A partir de ahí sale la línea de
órdenes, con privilegios de superusuario, y podemos trabajar con el
contenedor e instalar lo que se nos ocurra. Esto, claro está, si tenemos
ese contenedor instalado y ejecutándose.

Cuando se ejecuta `bash` se está haciendo precisamente eso, ejecutando
un intérprete de línea de órdenes o *shell* de forma aislada del resto
de los recursos. Hablar de *conectarte* a un contenedor, en este caso,
no tendría mucho sentido, o al menos tanto sentido como *conectarse* a
un proceso que está ejecutándose. De hecho, una segunda ejecución del
mismo comando

```bash
docker run -it ubuntu /bin/bash
```

(donde hemos abreviado las opciones `-i` y `-t` juntándolas) crearía, a partir de
la imagen de Ubuntu, un nuevo contenedor.

En cualquiera de los casos, cuando se ejecuta `exit` o `Control-D`
para salir del contenedor, este deja de ejecutarse. Ejecutar

```bash
docker ps -l
```

mostrará  que ese contenedor está `exited`, es decir, que ha salido,
pero también mostrará en la primera columna el ID del
mismo. *Arrancarlo* de nuevo no nos traerá la línea de órdenes, pero
sí se arrancará el entorno de ejecución; si queremos volver a ejecutar
algo como la línea de órdenes, tendremos que arrancarlo y a
continuación efectivamente ejecutar algo como el *shell*

```shell
docker start 6dc8ddb51cd6 && docker exec -it 6dc8ddb51cd6 sh
```

Sin embargo, en este caso simplemente salir del shell no dejará de
ejecutar el contenedor, por lo que habrá que pararlo

```shell
docker stop 6dc8ddb51cd6
```

y, a continuación, si no se va a usar más el contenedor, borrarlo

```shell
docker rm 6dc8ddb51cd6
```

Las imágenes que se han creado se pueden examinar con `inspect`, lo
que nos da información sobre qué metadatos se le han asignado por
omisión, incluyendo una IP.

```shell
docker inspect ed747e1b64506ac40e585ba9412592b00719778fd1dc55dc9bc388bb22a943a8
```

te dirá toda la información sobre la misma, incluyendo qué es lo que
está haciendo en un momento determinado. La información la escribe en
JSON, por eso puede ser conveniente instalar `jq`, una herramienta
para imprimir de forma más visible JSON, pero también para poder
extraer información de los mismos:

```shell
docker inspect jjmerelo/scala-testing:latest | jq
```

> En vez de este nombre, usar el nombre o id del contenedor que se
> quiere examinar.

Hasta ahora el uso de
Docker
[no es muy diferente de `lxc`](Aislamiento.md); es decir, se aisla un
proceso y se van creando interactivamente los diferentes componentes
del mismo, pero
[lo interesante](https://stackoverflow.com/questions/17989306/what-does-docker-add-to-lxc-tools-the-userspace-lxc-tools)
es que se puede guardar el estado de un contenedor tal
como está usando [commit](https://docs.docker.com/engine/reference/commandline/commit)

```shell
docker commit 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c nuevo-nombre
```

que guardará el estado del contenedor tal como está en ese
momento, convirtiéndolo en una nueva imagen, a la que podemos acceder
si usamos

```shell
docker images
```

Este `commit` es equivalente al que se hace en un
repositorio; para enviarlo al repositorio habrá que usar `push` (pero
solo si uno se ha dado de alta antes).

<div class='ejercicios' markdown='1'>

Crear a partir del contenedor anterior una imagen persistente con
*commit*.

</div>

El hacer `commit` de una imagen crea una capa adicional, identificada
por un SHA específico, en el sistema de ficheros de Docker. Por
ejemplo, si trabajamos con una imagen cualquiera y hacemos commit de
esta forma

```shell
docker commit 3465c7cef2ba jjmerelo/bbtest
```

creamos una nueva imagen, que vamos a llamar `jjmerelo/bbtest`. Esta
imagen contendrá, sobre la capa original, la capa adicional que hemos
creado. Este comando devolverá un determinado SHA, de la forma:

```text
sha256:d092d86c2bcde671ccb7bb66aca28a09d710e49c56ad8c1f6a4c674007d912f3
```

Para examinar las capas,

```shell
sudo jq '.' /var/lib/docker/image/aufs/imagedb/content/sha256/d092d86c2bcde671ccb7bb66aca28a09d710e49c56ad8c1f6a4c674007d912f3
```

nos mostrará un JSON bien formateado (por eso usamos `jq`, una
herramienta imprescindible) que, en el elemento `diff_ids`, nos
mostrará las capas. Si repetimos esta operación cada vez que hagamos
un commit sobre una nueva imagen, nos mostrará las capas adicionales
que se van formando.

<div class='ejercicios' markdown='1'>

Examinar la estructura de capas que se forma al crear imágenes nuevas
a partir de contenedores que se hayan estado ejecutando.

</div>

## Almacenamiento de datos y creación de volúmenes Docker

Ya hemos visto cómo se convierte un contenedor en imagen, al menos de
forma local, con `commit`. Pero veamos exactamente qué es lo que
sucede y cómo se lleva a cabo.

Docker crea un
[sistema de ficheros superpuesto u *overlay*](https://rominirani.com/docker-tutorial-series-part-7-data-volumes-93073a1b5b72).
Este
[sistema de ficheros superpuesto](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/)
puede tener varias formas posibles, igual que en Linux hay varios
tipos de sistemas de ficheros posibles; Docker usa diferentes drivers
(denominados `overlay` u `overlay2`) para estructurar la información
dentro del contenedor pero generalmente usa un sistema *copy on write*
que escribe en sistema de ficheros anfitrión cada vez que se produce
una modificación en el sistema de ficheros superpuesto.

En general, salvo que haya algún problema crítico de prestaciones, es
mejor usar el driver que se use por defecto; dependerá de la
implementación de Docker (CE o EE) y de la versión del
kernel. En
[esta
página](https://docs.docker.com/storage/storagedriver/overlayfs-driver/#configure-docker-with-the-overlay-or-overlay2-storage-driver)
se indica como configurar el driver que se va a usar.

Hay una forma de usar contenedores solo para almacenar datos, sin que
haya ningún proceso que se ejecute en ellos usando los
llamados
[volúmenes](https://docs.docker.com/engine/reference/commandline/volume_create/#related-commands).
Se crea usando `volume create`

```shell
docker volume create log
```

Igual que un contenedor Docker es algo así como un proceso con
esteroides, un volumen de Docker es una especie de disco
transportable, que almacena información y que puedes llevar de un lado
a otro. De la misma forma, la arquitectura de las aplicaciones
varía. No vamos a tener una aplicación monolítica que escriba en el
log, lo analice y lo lea, sino diferentes contenedores que
interaccionarán no directamente, sino a través de este contenedor de
almacenamiento, o simplemente lo usarán para almacenar datos.

Por ejemplo, podemos usar un volumen para montar el `/app` de
diferentes sistemas operativos, de forma que podamos probar una
aplicación determinada en los mismos. Hagamos

```shell
docker volume create benchmark
docker pull fedora
docker run -it --rm -v benchmark:/app fedora /bin/bash
```

Una vez dentro, se puede crear un minibenchmark, que diga por ejemplo
el número de ficheros `ls -R / | wc` y se guarda en `/app`. Una vez
hecho eso, puedes ejecutar ese programa en cualquier distro, de esta
forma:

```shell
docker run -it --rm -v benchmark:/app fedora sh /app/bm.sh
  87631   81506 1240789
docker run -it --rm -v benchmark:/app alpine sh /app/bm.sh
    72284     67414    974042
docker run -it --rm -v benchmark:/app busybox sh /app/bm.sh
    72141     67339    972158
```

> Incidentalmente, se observa que de las tres imágenes de
> contenedores, la que tiene una mínima cantidad de ficheros es
> `busybox`. Alpine, como se ha comentado antes, es una distribución
> también bastante ligera con casi 14000 ficheros/directorios menos
> que fedora.

La utilidad para este tipo de aplicaciones es relativamente limitada;
estos volúmenes, en general, se crean para ser usados por otros
contenedores con algún tipo de aplicación, por tanto. Por ejemplo con
[este microservicio en Perl Dancer2](https://github.com/JJ/p5-hitos)
de la forma siguiente

```shell
docker run -it --rm -v log:/log -p5000:5000 jjmerelo/p5hitos
```

> Se tendrá que haber construido antes el contenedor Docker, claro.

En este caso, con `-p` le indicamos los puertos que tiene que usar;
antes de : será el puerto "externo" y tras él el puerto que usa
internamente. El volumen se usa con `-v log:/log`; el primer parámetro
es el nombre del volumen externo que estamos usando, en el segundo el
nombre del directorio o sistema de ficheros interno en el que se ha
montado.

La aplicación, efectivamente, tendrá que estar de alguna forma
configurada para que ese sea el directorio donde se vayan a escribir
los logs; no hace falta crear el directorio, pero sí que la
configuración sea la correcta.

Lo que se hace en este caso es que `log` actúa como un volumen de
datos, efectivamente. Y ese volumen de datos es persistente, por lo
que los datos que se escriben ahí se pueden guardar o enviar; también
se puede usar simultáneamente por parte de otro contenedor,
*montándolo* de esta forma:

```shell
docker run -it --rm -v log:/log jjmerelo/checklog
```

Una vez más, el volumen de docker `log` se monta en el directorio
`/log`, un nombre arbitrario, porque igual que los puntos de montaje
del filesystem de Linux, puede ser en uno cualquiera; el OverlayFS
crea ese directorio y lo hace accesible a un programa, en este caso
[un programa también dockerizado](https://github.com/JJ/p5-hitos/blob/master/check-log/log-to-json.pl)
que pasa del formato en texto plano de los logs de
[Dancer2](https://perldancer.org/) a un formato JSON que puede ser
almacenado incluso en otro volumen si se desea.

<div class='ejercicios' markdown='1'>

Crear un volumen y usarlo, por ejemplo, para escribir la salida de un
programa determinado.

</div>

## Contenedores "de datos"

El problema con los volúmenes es que son una construcción local y es
difícil desplegarlos. Para solucionar esto se pueden usar simples
contenedores de datos, contenedores cuya principal misión es llevar un
conjunto de datos de un lugar a otro de forma que puedan ser
compartidos. Crear un contenedor de datos se puede hacer de la forma
siguiente:

```Dockerfile
FROM busybox

WORKDIR /data
VOLUME /data
COPY hitos.json .
```

Es decir, simplemente se copia un fichero que estará *empaquetado*
dentro del contenedor. Habrá que construirlo. A diferencia de los
volúmenes de datos, estos contenedores de datos sí hay que
ejecutarlos. En realidad es igual lo que se esté ejecutando, por lo
que generalmente se ejecutan de esta forma:

```shell
docker run -d -it --rm jjmerelo/datos sh
```

Esta orden escribe un número hexa en la consola, que habrá que tener
en cuenta por que es el `CONTAINER ID`, lo que vamos a usar más
adelante. Como se ve, se ejecuta como *daemon* `-d` y se ejecuta
simplemente `sh`. En este contenedor se estará ejecutando de forma
continua ese proceso, lo que puede ser interesante a la hora de
monitorizarlo, pero lo interesante de él es que se va a usar para
cargar ese fichero de configuración desde diferentes contenedores, de
esta forma:

```shell
docker run -it --rm --volumes-from 8d1e385 jjmerelo/p5hitos
```

`--volumes-from` usa el ID que se haya asignado al contenedor
ejecutándose, o bien el nombre del mismo, que no es el tag con el que
le hemos llamado, sino un nombre generado aleatoriamente
`deeste_estilo`. En este caso no hemos añadido una definición de
volúmenes, por lo que el contenedor se ejecutará y tendrá en `/data`
el mismo contenido. Se puede montar también el contenedor en modo de
solo lectura:

```shell
docker run -it --rm --volumes-from 8d1e385:ro jjmerelo/p5hitos
```

con la etiqueta `ro` añadida al final del ID del contenedor que se
está usando.

Como se ve, se ejecutan varios pasos uno de los cuales implica "tomar"
un ID e usarlo más adelante en el montaje. No es difícil de resolver
con un script del shell, pero como es una necesidad habitual se han
habilitado otras herramientas para poder hacer esto de forma ágil:
`compose`.

## Algunas buenas prácticas en el uso de virtualización ligera

Una de las principales ventajas que tiene este tipo de virtualización,
sea cual sea como se implemente, es precisamente el hecho de que sea
*ligera*, y que por lo tanto los contenedores se puedan crear, activar
y desactivar rápidamente. Por eso, aunque pueda parecer a priori que
es otra forma de crear máquinas virtuales, su ámbito de aplicación es
totalmente diferente al de estas. Conviene seguir este tipo de reglas,
sacadas entre otros sitios de
[esta lista de buenas prácticas con Docker](https://github.com/FuriKuri/docker-best-practices)
y
[esta otra](https://containerjournal.com/features/5-docker-best-practices-follow/).

### Simplicidad

Los contenedores deben de ser lo más simples posible, y llevar esta
regla desde el principio al final. Idealmente, los contenedores
ejecutarán un solo proceso. Esto facilita el escalado mediante
replicación, y permite también separar las tareas en diferentes
contenedores, que pueden ser desplegados o actualizados de forma
totalmente independiente. Esto también facilita el uso de contenedores
estándar, bien depurados y cuya configuración sea lo más segura
posible.

Esto también implica una serie de cosas: usar la distribución más
ligera que soporte la configuración, por ejemplo. El usar una
distribución ligera y adaptada a contenedores como
[Alpine Linux](https://alpinelinux.org/) o
[Atomic Host](https://projectatomic.io/) hará que se creen
contenedores mucho más ligeros y rápidos de cargar y que tengan toda
la funcionalidad que se necesita. También conviene eliminar toda
aquella funcionalidad que no se necesite y que se haya usado solamente
para construir el contenedor, tales como compiladores o ficheros
intermedios.

### Seguridad

Los contenedores docker se ejecutan de forma aislada del resto del
sistema operativo, pero eso no significa que no se pueda penetrar en
ellos y llevar a cabo diferentes actividades no deseadas. Es
importante, por ejemplo, que siempre que sea posible se ejecute la
aplicación como un usuario no privilegiado.

### Recomendaciones a la hora de construir un contenedor

[Docker da una serie de recomendaciones a la hora de construir
contenedores](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).
Para
hacerlo reproducible, se deben usar Dockerfile o el equivalente en
otro tipo de contenedores, y las órdenes que se
deben usar y cómo usarlas constituye un acervo que conviene conocer y
usar.

## Elección de contenedor base

Una de las decisiones más complejas a la hora de construir nuestro
contenedor es una buena elección de la imagen que utilizaremos como base.
El principal problema consiste en conocer los requisitos para nuestro
proyecto, y saber si la imagen base cumple con dichos requisitos o
si nos facilita alcanzarlos en un futuro.

Una herramienta que permite realizar un análisis previo sin necesidad
de probar todas las imágenes es [container-diff](https://github.com/GoogleContainerTools/container-diff).
Esta herramienta nos permite ver características como *tamaño*,
*historial*, *sistema de archivos*, *paquetes instalados* (tanto en
*apt*, *rpm*, *pip* o *Node*). Permite además analizar y comparar dos
contenedores distintos.

Si queremos analizar la imagen oficial de **ubuntu:bionic**:

```shell
container-diff analyze ubuntu:bionic --type=size --type=apt --type=history
```

Al ejecutar esta orden, se mostrará como un listado de diferentes
secciones, donde muestra los paquetes instalados mediante *apt*,
el historial de la imagen y el tamaño de la imagen. Esta herramienta
nos ahorra la necesidad de crear una imagen y comprobarla paso a paso.

Por otro lado, si queremos comparar dos imágenes diferentes, como
**ubuntu:focal** y **ubuntu:bionic**, se haría:

```shell
container-diff diff ubuntu:focal ubuntu:bionic --type=size --type=apt
```

A continuación se muestra un listado donde se ven los paquetes *apt*
que poseen cada imagen y que no posee la otra, seguido de aquellos paquetes
en común pero que poseen diferentes versiones. Por último se muestran los
tamaños de ambas imágenes.

La principal ventaja de esta herramienta es el poder realizar un análisis
de forma simple y clara, ahorrando tiempo de configuración y creación de
imágenes y ahorrando espacio. Además, es completamente configurable, por
lo que se pueden comparar únicamente aquellas características que se
indiquen mediante el parámetro ```--type=``` (si se omite por defecto
toma ```--type=size```).

Un ejemplo de como se muestra un análisis del tamaño de una imagen sería:

```text
-----Size-----

Analysis for ubuntu:bionic:
IMAGE                DIGEST                                                                     SIZE
ubuntu:bionic        sha256:45c6f8f1b2fe15adaa72305616d69a6cd641169bc8b16886756919e7c01fa48b    62.4M
```

Por otro lado, si se realiza una comparativa, un ejemplo sería:

```text
-----Size-----

Image size difference between ubuntu:focal and ubuntu:bionic:
SIZE1    SIZE2
72.9M    62.4M

```

## Usando Dockerfiles

La infraestructura se debe crear usando código, y en Docker pasa
exactamente igual. Tiene un mecanismo llamado Dockerfiles que permite
construir contenedores o tápers de forma que lo que quede en control
de versiones sea el código en sí, no el contenedor, con el
consiguiente ahorro de espacio. La ventaja además es que
en [el Docker hub](https://hub.docker.com) hay multitud de contenedores
ya hechos, que se pueden usar directamente.

El
[ejemplo](https://github.com/JJ/CC/blob/53382c0258edda645bd0027b7b094ac9c7d1b36a/ejemplos/Scala/Dockerfile)
a continuación conteneriza `sbt`, la Scala Build Tool, de
forma que haga falta instalarla o podamos construir sobre ella algún
otro contenedor que la use.

> De hecho, es más fácil buscar en Docker Hub a ver si hay algún
> contenedor similar; de
> hecho,
> [lo hay](https://hub.docker.com/r/digitalgenius/alpine-scala-sbt)
> aunque que no muestre los Dockerfiles puede dar lugar a alguna que
> otra sospecha.

```Dockerfile
FROM frolvlad/alpine-scala
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
CMD ["/usr/local/bin/sbt"]
ARG SBT_VERSION=1.4.2

RUN apk update && apk upgrade
RUN apk add git
RUN apk add curl

RUN curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" -o /usr/local/sbt.tgz
RUN cd /usr/local && tar xvfz sbt.tgz
RUN mv /usr/local/sbt/bin/* /usr/local/bin
RUN chmod 0755 /usr/local/bin/sbt
```

A la hora de hacer `docker build` puede ser que dentro de la UGR y de
alguna otra
instalación similar tengáis problemas de acceso a Internet desde
dentro de un contenedor. En ese caso, meted esto en el `daemon.json`
en el directorio `/etc/docker`

```json
{"dns": ["150.214.204.10", "8.8.8.8"] }
```

> La primera IP es solamente para la UGR. Fuera de la UGR tendréis que
> averiguar uno de los servidores DNS que os sirva.

En la primera línea se establece cuál es
el
[contenedor de origen](https://hub.docker.com/r/frolvlad/alpine-scala)
que vamos a usar. Siempre es conveniente usar distros ligeras, y en este
caso usamos la ya conocida Alpine, que tiene ya una versión que
incluye Scala. A continuación se pone la dirección del mantenedor,
servidor, y el directorio de trabajo `WORKDIR` en el que se va a
entrar cuando se ejecute algo en el contenedor. El siguiente comando
`CMD` indica qué se va a ejecutar en caso de que se ejecute el
contenedor directamente; se trata de `sbt`, el Scala Build Tool. Como
se ve, la estructura siempre es la misma: órdenes en mayúsculas, al
principio de la
línea. La
[referencia de las mismas se encuentra en la web de Docker](https://docs.docker.com/engine/reference/builder/#copy).

Las siguientes órdenes son todas `apk`, el gestor de paquetes de
Alpine. No tiene tantos empaquetados como las distros más conocidas,
pero sí los básicos; siempre al principio habrá que actualizar los
repos para que no haya problemas.

El resto son otras órdenes `RUN`, que ejecutan directamente órdenes
dentro del contenedor, y que en este caso descargan un paquete, que es
la forma como se distribuye `sbt`, y lo ponen como ejecutable. Hay que
hacer una cosa adicional: mover los ejecutables a un sitio que esté
localizable en el path.

Para crear una imagen a partir de esto se usa

```shell
docker build -t jjmerelo/scala-test .
```

(o el nick que tengas en Docker Hub). El `-t` es, como es habitual, para
asignar un *tag*, en este caso uno que se puede usar más adelante en
el Docker Hub. Tardará un rato, sobre todo por la descarga de unas
cuantas bibliotecas por parte de sbt, lo que se hace en la última
línea. Una vez hecho esto, si funciona la construcción, se
podrá ejecutar con `docker run`, con lo que saldrá la línea de órdenes
de `sbt` (y un error si no hay ningún fichero `sbt` presente).

Con esto ya tenemos un contenedor funcionar para ejecutar `sbt`, pero
el problema es cuanto ocupa. Los contenedores deben ser lo más simples
posibles para que tarden poco en descargarse, arrancarse y
cargarse. Con `docker images` podemos ver lo que ocupa:

```text
jjmerelo/scala-testing         latest                 dd34369171bb        13 hours ago        331MB
```

¿A qué se debe esto? Principalmente, a la cantidad de capas que
tiene. Podemos descargarnos dos
utilidades, [`skopeo`](https://github.com/containers/skopeo), que es
un programa para examinar imágenes con más posibilidades que `docker
images`, y también [`jq`](https://stedolan.github.io/jq/), un
programar para examinar estructuras JSON complejas, ya que el
resultado lo da en este formato (también otros como `docker
inspect`). Ejecutamos:

```shell
skopeo inspect docker-daemon:jjmerelo/scala-testing:latest | jq ".Layers | length"
```

En caso de usar `docker inspect`, la orden sería:

```shell
docker inspect docker-daemon:jjmerelo/scala-testing:latest | jq ".[].RootFS.Layers | length"
```

Que usa la suborden `inspect` para examinar la imagen, que se tiene
que especificar como una imagen local (con `docker-daemon`). `jq`
extrae una de las claves del JSON resultante, `Layers`, y simplemente
la cuenta (con `length`). Resultado: 11 capas. Vamos entonces a
reducirlas en lo posible, haciendo lo siguiente:

* Borrando ficheros innecesarios.
* Agrupando órdenes para reducir el número de capas.

Así está en el ejemplo siguiente

```Dockerfile
FROM frolvlad/alpine-scala
LABEL maintainer="JJ Merelo <jjmerelo@GMail.com>"
WORKDIR /root
CMD ["/usr/local/bin/sbt"]
ARG SBT_VERSION=1.4.2

RUN apk update && apk upgrade && apk add curl \
    && curl -sL "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" -o /usr/local/sbt.tgz \
    && cd /usr/local && tar xvfz sbt.tgz \
    &&  mv /usr/local/sbt/bin/* /usr/local/bin \
    && apk del curl \
    && rm /usr/local/sbt.tgz

```

Donde, además, se ha usado `LABEL` para `maintainer`, en vez del
anterior, que estaba deprecado. En este caso, el tamaño es:

```shell
jjmerelo/scala-testing         latest                 24c3ab20c2cd        8 seconds ago        248MB
```

Se han ahorrado más de 50 MBs. Aparte de lo que hemos borrado, esta
orden

```bash
skopeo inspect docker-daemon:jjmerelo/scala-testing:latest | jq ".Layers "

[
  "sha256:503e53e365f34399c4d58d8f4e23c161106cfbce4400e3d0a0357967bad69390",
  "sha256:e32a020a29e2566c96697b7ed1538e0b72e65616bfb56037c9727bc102a8a3c5",
  "sha256:161733eb0605b3af381a4bcb6325708b0e2f659e04fb0a253b88f7eb8c8ed580",
  "sha256:1f1f384806d20a378fbd8085956704b71f6dde33d1e077dd48c8eab268965d51",
  "sha256:1a03f5e9c8a404ff58ec812e3dab012808580e84f2de54e74a2b07883a6631dc"
]
```

Muestra que de las 11 capas originales lo hemos reducido sólo a 5
capas, y el contenido es exactamente el mismo.

Otra herramienta interesante para examinar las capas y poder disminuir
el tamaño es [dive](https://github.com/wagoodman/dive). Para poder
examinar una imagen que ya tenemos creada, basta con ejecutar la orden

```bash
dive <nombre-imagen>
```

Una vez ha sido cargada, se nos presentan dos paneles (podemos cambiar
de uno a otro usando el tabulador). En el de la izquierda podemos ver
las capas existentes junto con el comando que las generó. Por su
parte, en la derecha podemos navegar por el árbol de directorios en el
que se indican los archivos nuevos, modificados y eliminados respecto
a la capa anterior así como el tamaño de cada uno de los mismos. Un
aspecto a destacar lo encontramos en el panel de la izquierda donde da
una visión global de la imagen. Utiliza una métrica para determinar la
"eficiencia" de la misma indicando potenciales archivos que podrían no
ser del todo útiles.

<div class='ejercicios' markdown='1'>

Reproducir los contenedores creados anteriormente usando un `Dockerfile`.

</div>

Se pueden construir contenedores más complejos. Una funcionalidad interesante
de los contenedores es la posibilidad de usarlos como *sustitutos* de
una orden, de forma que sea mucho más fácil trabajar con alguna
configuración específica de una aplicación o de un lenguaje de
programación determinado.

Por ejemplo,
[esta, llamada `alpine-perl6`](https://hub.docker.com/r/jjmerelo/alpine-perl6/)
que se puede usar en lugar del intérprete de Perl6 y usa como base la
distro ligera Alpine. Una vez más, usamos órdenes separadas y sin
optimizar simplemente por cuestiones de claridad;

```Dockerfile
FROM alpine:latest
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
ENTRYPOINT ["raku"]

#Basic setup
RUN apk update && apk upgrade \
     apk add gcc git linux-headers make musl-dev perl

#Download and install rakudo
RUN git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
RUN echo 'export PATH=~/.rakudobrew/bin:$PATH' >> /etc/profile
RUN echo 'eval "$(/root/.rakudobrew/bin/rakudobrew init -)"' >> /etc/profile
ENV PATH="/root/.rakudobrew/bin:${PATH}"
RUN rakudobrew init

#Build moar
RUN rakudobrew build moar

#Build other utilities
RUN rakudobrew build zef
RUN panda install Linenoise

#Mount point
RUN mkdir /app
VOLUME /app
```

Como ya hemos visto anteriormente, usa `apk`, la orden de Alpine para
instalar paquetes e instala lo necesario para que eche a andar el
gestor de intérpretes de Perl6 llamado `rakudobrew`. Este gestor tarda
un buen rato, hasta minutos, en construir el intérprete a través de
diferentes fases de compilación, por eso este contenedor sustituye eso
por la simple descarga del mismo. Instala además alguna utilidad
relativamente común, pero lo que lo hace trabajar "como" el intérprete
es la orden `ENTRYPOINT ["raku"]`. `ENTRYPOINT` se usa para señalar
a qué orden se va a concatenar el resto de los argumentos en la línea
de órdenes, en este caso, tratándose del intérprete de Perl 6, se
comportará exactamente como él. Para que esto funcione también se ha
definido una variable de entorno en:

```shell
ENV PATH="/root/.rakudobrew/bin:${PATH}"
```

que añade al `PATH` el directorio donde se encuentra. Con estas dos
características se puede ejecutar el contenedor con:

```shell
docker run -t jjmerelo/alpine-perl6 -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "
```

Si tuviéramos perl6 instalado en local, se podría escribir
directamente

```shell
raku -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "
```

o algún
otro
[*one-liner* de Raku](https://gist.github.com/JJ/9953ba0a98800fed205eaae5b5a6410a).

En caso de que se trate de un servicio o algún otro tipo de programa
de ejecución continua, se puede usar directamente `CMD`. En este caso,
`ENTRYPOINT` da más flexibilidad e incluso de puede evitar usando

```shell
docker run -it --entrypoint "sh -l -c" jjmerelo/alpine-perl6
```

que accederá directamente a la línea de órdenes, en este caso
`busybox`, que es el *shell* que provee Alpine.

Por otro lado, otra característica que tiene este contenedor es que, a
través de `VOLUME`, hemos creado un directorio sobre el que podemos
*montar* un directorio externo, tal como hacemos aquí:

```shell
docker run --rm -t -v `pwd`:/app  \
 jjmerelo/alpine-perl6 /app/horadam.p6 100 3 7 0.25 0.33
```

En realidad, usando `-v` se puede montar cualquier directorio externo
en cualquier directorio interno. `VOLUME` únicamente *marca* un
directorio específico para ese tipo de labor, de forma que se pueda
usar de forma genérica para interaccionar con el contenedor a través
de ficheros externos o para *copiar* (en realidad, simplemente hacer
accesibles) estos ficheros al contenedor. En el caso anterior,
podíamos haber sustituido `/app` en los dos lugares donde aparece por
cualquier otro valor y habría funcionado igualmente.

En este caso, además, usamos `--rm` para borrar el contenedor una vez
se haya usado y `-t` en vez de `-it` para indicar que solo estamos
interesados en que se asigne un terminal y la salida del mismo, no
vamos a interaccionar con él.

Con esto, `docker` tiene capacidades de provisionamiento similares a
otros [sistemas (tales como Vagrant](Gestion_de_configuraciones) usando
[*Dockerfiles*](https://docs.docker.com/engine/reference/builder/). Por
ejemplo,
[se puede crear fácilmente un Dockerfile para instalar node.js
con el módulo express](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/).

## Limpieza de contenedores

Una vez que se lleva trabajando con Docker un rato, puede que nos
encontremos con diferentes contenedores en diferente estado de
construcción, así como las imágenes a partir de las cuales se han
creado esos contenedores. Todo eso ocupa una cierta cantidad de
espacio, y conviene de vez en cuando liberarlo para que no acaben
llenando el disco duro de la máquina que se use para desarrollo. Antes
de llegar a eso, conviene recordar la opción `--rm` para ejecutar
órdenes dentro del contenedor, que limpia automáticamente el
contenedor y lo elimina cuando se sale del mismo:

```shell
docker run --rm -t -v
    /home/jmerelo/Code/forks/perl6/perl6-Math-Sequences:/test
      jjmerelo/test-perl6 /test/t
```

## Otros gestores de contenedores

La infraestructura basada en contenedores ha tenido tanto éxito que
han surgido diferentes tipos y también iniciativas de
estandarización. El principal competidor este área es
[Podman/buildah](https://developers.redhat.com/blog/2019/02/21/podman-and-buildah-for-docker-users).

Por otro lado,
la [*Open Container Initiative*](https://opencontainers.org/) está
todavía en una fase muy preliminar. Aunque contiene especificaciones
tanto apara ejecutarlos como para especificar imágenes, por lo pronto
no hay muchas implementaciones de referencia que se puedan usar. Si
acaba cuajando puede hacer que el campo de los contenedores evite
monopolios, así que habrá que estar atentos al
mismo. Hay
[trabajo en curso](https://github.com/opencontainers/image-tools) para
comprobar imágenes, por ejemplo.

## Ver también

En caso de que tu máquina principal de desarrollo sea Windows o Mac,
puede que te
interese [trabajar con *docker machines*](Docker-machines.md), una
herramienta para gestionar localmente contenedores alojados en otro
ordenador o máquina virtual.

## A dónde ir desde aquí

Primero, hay que [llevar a cabo el hito del proyecto correspondiente a este tema](../proyecto/3.Docker).

Si te interesa, puedes consultar cómo
se [virtualiza el almacenamiento](Almacenamiento) que, en general, es
independiente de la generación de una máquina virtual. También puedes
ir directamente al [tema de uso de sistemas](Uso_de_sistemas) en el
que se trabajará con sistemas de virtualización completa.
