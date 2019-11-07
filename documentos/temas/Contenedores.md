Contenedores y cómo usarlos
===

<!--@
prev: Orquestacion
-->

<div class="objetivos" markdown="1">

Objetivos
--

### Cubre los siguientes objetivos de la asignatura

* Conocer las diferentes tecnologías y herramientas de virtualización tanto para procesamiento, comunicación y almacenamiento.
* Instalar, configurar, evaluar y optimizar las prestaciones de un servidor virtual.
* Configurar los diferentes dispositivos físicos para acceso a los
  servidores virtuales: acceso de usuarios, redes de comunicaciones o entrada/salida.
* Diseñar, implementar y construir un centro de procesamiento de datos virtual.
* Documentar y mantener una plataforma virtual.
* Optimizar aplicaciones sobre plataformas virtuales.
* Conocer diferentes tecnologías relacionadas con la virtualización
  (Computación Nube, Utility Computing, Software as a Service) e
  implementaciones tales como Google AppSpot, OpenShift o Heroku.
* Realizar tareas de administración en infraestructura virtual.

### Objetivos específicos

1. Entender cómo las diferentes tecnologías de virtualización se integran en la creación de contenedores.

2. Crear infraestructuras virtuales completas.

3. Comprender los pasos necesarios para la configuración automática de las mismas.

</div>



Introducción a Docker
---

> Previamente a este tema conviene consultar la historia del
> aislamiento de aplicaciones en [este capítulo](Aislamiento.md), que
> se ha eliminado del temario eventualmente.

Docker es una herramienta que permite *aislar* aplicaciones, creando
*contenedores* que pueden almacenarse de forma permanente para
permitir el despliegue de esas mismas aplicaciones en la nube. Por lo
tanto, en una primera aproximación, Docker serían similares a otras
aplicaciones tales como LXC/LXD o incluso las *jaulas `chroot`*, es
decir, una forma de empaquetar una aplicación con todo lo necesario
para que opere de forma independiente del resto de las aplicaciones y
se pueda, por tanto, replicar, escalar, desplegar, arrancar y destruir
de forma también independiente. 

>Una traducción más precisa de *container*
>sería
>[táper](https://www.fundeu.es/recomendacion/taper-adaptacion-espanola-del-anglicismo-tupper-1475/),
>es decir, un recipiente, generalmente de plástico, usado en
>cocina. Si me refiero a un táper a continuación, es simplemente por
>esta razón.

[Docker](https://docker.com) es una herramienta de gestión de
contenedores que permite no solo instalarlos, sino trabajar con el
conjunto de ellos instalados (orquestación) y exportarlos de forma que
se puedan desplegar en diferentes servicios en la nube. La tecnología de
[Docker](https://en.wikipedia.org/wiki/Docker_%28software%29) es
relativamente reciente, habiendo sido publicada en marzo de 2013;
actualmente está sufriendo una gran expansión, lo que ha llevado al
desarrollo paralelo de sistemas operativos tales como
[CoreOS](https://coreos.com/), 
basado en Linux y que permite despliegue masivo de servidores. Pero no
adelantemos acontecimientos. 

>Docker funciona mejor en Linux, fue creado para Linux y es donde
>tiene mejor soporte a nivel de núcleo del sistema operativo. Desde la
>última versión de Windows, la 10, funciona relativamente bien también
>en este sistema operativo. Si no tienes esa versión no te molestes;
>en todo caso, también en Windows 10 puedes usar el subsistema Linux
>(Ubuntu y últimamente OpenSuSE) para interactuar con
>Docker. Finalmente, aunque es usable desde Mac, en realidad el
>sistema operativo no tiene soporte para el mismo. Es mejor que en
>este caso se use una máquina virtual local o en la nube. 

Aunque en una primera aproximación Docker es, como hemos dicho arriba,
similar a otras aplicaciones de virtualización *ligera*  como
`lxc/lxd`, que lo precedieron en el tiempo, sin embargo el enfoque de
Docker
[es fundamentalmente diferente](https://www.flockport.com/lxc-vs-docker/) es
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

>Conviene que, en este momento o un poco más adelante, tengas preparad
>una instalación de un hipervisor o gestor de máquinas virtuales tipo
>VirtualBox o similar. Sea porque quieras tener una máquina virtual
>Linux específica para esto, o para tener varias máquinas virtuales
>funcionando a la vez. 

## Instalación de Docker

[Instalar `docker`](https://www.docker.com/) es sencillo desde que se
publicó la versión 1.0, especialmente en distribuciones de Linux. Por
ejemplo, para [Ubuntu hay que dar de alta una serie de repositorios](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
y no funcionará con versiones más antiguas de la 12.04 (y en este caso
solo si se instalan kernels posteriores). En las últimas versiones, de
hecho, ya está en los repositorios oficiales de Ubuntu y para instalarlo no hay más que
hacer

	sudo apt-get install docker-engine

aunque la versión en los repositorios oficiales suele ser más antigua que la que
se descargue de la web o los repositorios adicionales. Este paquete incluye varias aplicaciones: un *daemon*, `dockerd`, y un cliente de línea de órdenes, `docker`. La instalación dejará este *daemon* ejecutándose y lo configurará para que se   arranque con el inicio del
sistema. También una serie de *imágenes* genéricas con las que se
puede empezar a trabajar de forma más o menos inmediata. 

>Hay
>también
>[diferentes opciones para instalar Docker en Windows](https://docs.docker.com/engine/installation/windows/) o
>en
>[un Mac](https://docs.docker.com/engine/installation/mac/). 

Otra posibilidad para trabajar con Docker es usar
[el anteriormente denominado CoreOS, ahora Container Linux](https://coreos.com/). *Container
Linux* es una distribución diseñada
para usar aplicaciones distribuidas, casi de forma exclusiva, en contenedores, y aparte de
una serie de características interesantes, como el uso de `etcd` para
configuración distribuida, tiene un gestor de Docker instalado en la
configuración base. Si es para experimentar Docker sin afectar la
instalación de nuestro propio ordenador, se aconseja que se instale
[Container Linux en una máquina virtual](https://coreos.com/os/docs/latest/booting-with-iso.html).


Con cualquiera de las formas que hayamos elegido para instalar Docker,
vamos a comenzar desde el principio. Veremos a continuación cómo empezar a ejecutar Docker.

## Comenzando a ejecutar Docker

Docker consiste, entre otras cosas, en un servicio que se encarga de
gestionar los contenedores y una herramienta de línea de ordenes que
es la que vamos a usar, en general, para trabajar con él. 

Los paquetes de instalación estándar generalmente instalan Docker como
servicio para que comience a ejecutarse en el momento que arranque el
sistema. Si no se está ejecutando ya, se puede arrancar como un servicio

	sudo dockerd &

La línea de órdenes de docker conectará con este daemon, que mantendrá
el estado de docker y demás. Cada una de las órdenes se ejecutará
también como superusuario, al tener que contactar con este *daemon*
usando un socket protegido.


Con una instalación estándar, 

```
sudo status docker
```

debería responder si se está ejecutando o no. Si está parado,

```
sudo start docker
```

comenzará a ejecutarlo. 


>Una vez instalado, [debes seguir estas instrucciones para poder usar el cliente desde un usuario sin privilegios.](https://docs.docker.com/engine/installation/linux/ubuntulinux/#manage-docker-as-a-non-root-user). 

Una vez
instalado, se puede ejecutar el clásico

```
docker run hello-world
```

Generalmente, vamos a usar Docker usando su herramienta de la línea de
órdenes, `docker`, que permite instalar contenedores y trabajar con
ellos. El resultado de esta orden será un mensaje que te muestra que
Docker está funcionando. Sin embargo, veamos por partes qué es lo que
hace esta orden.

1. Usa `sudo` para ejecutar el cliente de línea de órdenes de
   Docker. Es más seguro, porque te fuerza a dar la clave de
   administrador en cada terminal que se ejecute. Puede configurarse
   docker para que lo pueda usar cualquier usuario, aunque es menos
   seguro y no lo aconsejamos. 
1. Busca una *imagen* de Docker llamada `hello-world`. Una imagen es
equivalente a un *disco de instalación* que contiene los elementos que
se van a aislar dentro del contenedor. 
Al no encontrar esa imagen localmente, la descarga del [Hub de Docker](https://hub.docker.com/_/hello-world/), el lugar donde
se suben las imágenes de Docker y donde puedes encontrar muchas más;
más adelante se verán.

```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
78445dd45222: Pull complete 
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest
```

2. Crea un *contenedor* usando como base esa imagen, es decir, el
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
imagen cuyo nombre es `hello world` y se ha creado un contenedor, en
principio sin nombre. Puedes listar las imágenes que tienes con 

```
docker images
```

que, en principio, solo listará una llamada `hello-world` en la
segunda columna, etiquetada IMAGES. Pero esto incluye solo las
imágenes en sí. Para listas los contenedores que tienes, 

```
docker ps -a
```

listará los contenedores que efectivamente se han creado, por ejemplo:

~~~
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                         PORTS               NAMES
1e9e7dfe46e3        hello-world         "/hello"            3 seconds ago       Exited (0) 2 seconds ago                           focused_poincare
ec9ba7a27e93        hello-world         "/hello"            About an hour ago   Exited (0) About an hour ago                       dreamy_goldstine
~~~

Vemos dos contenedores, con dos IDs de contenedor diferentes, ambas
correspondientes a la misma imagen, `hello-world`. Cada vez que
ejecutemos la imagen crearemos un contenedor nuevo, por lo que
conviene que recordemos ejecutarlo, siempre que no vayamos a necesitarlo, con

```
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
[el contenedor `daleksay`](https://hub.docker.com/r/jjmerelo/docker-daleksay/) para
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

## Trabajando *dentro* de contenedores. 

Pero no solo podemos descargar y ejecutar contenedores de forma
efímera. También se puede crear un contenedor y trabajar en
él. Realmente, no es la forma adecuada de trabajar, que debería ser
reproducible y automática, pero se puede usar para crear prototipos o
para probar cosas sobre contenedores cuya creación se automatizará a
continuación. Comencemos por descargar la imagen.

```
docker pull alpine
```

Esta orden descarga una imagen de
[Alpine Linux](https://alpinelinux.org/) y la instala, haciéndola
disponible para que se creen, a partir de ella, contenedores. Como se
ha visto antes, las imágenes que hay disponibles en el sistema se
listan con 

```
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
[buscar las imágenes más populares](https://hub.docker.com/explore/). Estas
imágenes contienen no solo sistemas operativos *bare bones*, sino
también otros con una funcionalidad determinada. Por ejemplo, una de
las imágenes más populares es la de
[`nginx`](https://hub.docker.com/_/nginx/), la de Redis o la de
Busybox, un sustituto del *shell* que incluye también una serie de
utilidades externas y que se pueden usar como imagen base. 

<div class='ejercicios' markdown='1'>

Comparar el tamaño de las imágenes de diferentes sistemas operativos
base, Fedora, CentOS y Alpine, por ejemplo. 

</div>

Si usas otra imagen, se tendrá que descargar lo que tardará más o
menos dependiendo de la conexión; hay también otro factor que veremos
más adelante. Una vez bajada, se pueden empezar a ejecutar comandos. Lo
bueno de `docker` es que permite ejecutarlos directamente, y en esto
tenemos que tener en cuenta que se va a tratar de comandos *aislados*
y que, en realidad, no tenemos una máquina virtual *diferente*. 

Podemos ejecutar, por ejemplo, un listado de los directorios

```
docker run --rm alpine ls
```

Tras el sudo, hace falta el comando docker; `run` es el comando de docker que
estamos usando, `--rm` hace que la máquina se borre una vez ejecutado
el comando. `alpine` es el nombre de la máquina, el mismo que le
hayamos dado antes cuando hemos hecho pull y finalmente `ls`, el
comando que estamos ejecutando. Este comando arranca el contenedor, lo
ejecuta y a continuación sale de él. Esta es una de las ventajas de
este tipo de virtualización: es tan rápido arrancar que se puede usar
para un simple comando y dejar de usarse a continuación, y de hecho
hasta se puede borrar el contenedor correspondiente.

Esta imagen de Alpine no contiene bash, pero si el shell básico
llamado `ash` y que está instalado en `sh`,
por lo que podremos *meternos* en la misma ejecutando

```
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

```
apk update
apk upgrade
```

Para que actualice la lista de paquetes disponibles. Después, se pueden instalar paquetes, por ejemplo  
```
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

	docker ps -a=false

siempre que se esté ejecutando, obteniendo algo así:

```
	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
b76f70b6c5ce        ubuntu:12.04        /bin/bash           About an hour ago   Up About an hour                        sharp_brattain     
```

El primer número es el ID de la máquina que podemos usar también para
referirnos a ella en otros comandos. También se puede usar

```
docker images
```

Que, una vez más, devolverá algo así:

```
	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ubuntu              latest              8dbd9e392a96        9 months ago        128 MB
ubuntu              precise             8dbd9e392a96        9 months ago        128 MB
ubuntu              12.10               b750fe79269d        9 months ago        175.3 MB
ubuntu              quantal             b750fe79269d        9 months ago        175.3 MB
```

El *IMAGE ID* es el ID interno del contenedor, que se puede usar para
trabajar en una u otra máquina igual que antes hemos usado el nombre
de la imagen:

```
docker run b750fe79269d du
```

## Cómo crear imágenes docker interactivamente.

En vez de ejecutar las cosas una a una podemos directamente [ejecutar un shell](https://docs.docker.com/engine/getstarted/step_two/):

```
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

	docker run -it ubuntu /bin/bash

(donde hemos abreviado las opciones `-i` y `-t` juntándolas) crearía, a partir de
la imagen de Ubuntu, un nuevo contenedor. 

En cualquiera de los casos, cuando se ejecuta `exit` o `Control-D`
para salir del contenedor, este deja de ejecutarse. Ejecutar

	docker ps -l
	
mostrará  que ese contenedor está `exited`, es decir, que ha salido,
pero también mostrará en la primera columna el ID del
mismo. *Arrancarlo* de nuevo no nos traerá la línea de órdenes, pero
sí se arrancará el entorno de ejecución; si queremos volver a ejecutar
algo como la línea de órdenes, tendremos que arrancarlo y a
continuación efectivamente ejecutar algo como el *shell*

	docker start 6dc8ddb51cd6 && docker exec -it 6dc8ddb51cd6 sh
	
Sin embargo, en este caso simplemente salir del shell no dejará de
ejecutar el contenedor, por lo que habrá que pararlo

	docker stop 6dc8ddb51cd6

y, a continuación, si no se va a usar más el contenedor, borrarlo

	docker rm 6dc8ddb51cd6

Las imágenes que se han creado se pueden examinar con `inspect`, lo
que nos da información sobre qué metadatos se le han asignado por
omisión, incluyendo una IP. 

```
docker inspect	ed747e1b64506ac40e585ba9412592b00719778fd1dc55dc9bc388bb22a943a8
```

te dirá toda la información sobre la misma, incluyendo qué es lo que
está haciendo en un momento determinado. 

Para finalizar, se puede parar usando `stop`.

Hasta ahora el uso de
docker [no es muy diferente de `lxc`, pero lo interesante](https://stackoverflow.com/questions/17989306/what-does-docker-add-to-just-plain-lxc) es que se puede guardar el estado de un contenedor tal
como está usando [commit](https://docs.docker.com/engine/reference/commandline/cli/#commit)

```
docker commit 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c nuevo-nombre
```

que guardará el estado del contenedor tal como está en ese
momento, convirtiéndolo en una nueva imagen, a la que podemos acceder
si usamos

```
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

	docker commit 3465c7cef2ba jjmerelo/bbtest
	
creamos una nueva imagen, que vamos a llamar `jjmerelo/bbtest`. Esta
imagen contendrá, sobre la capa original, la capa adicional que hemos
creado. Este comando devolverá un determinado SHA, de la forma:

	sha256:d092d86c2bcde671ccb7bb66aca28a09d710e49c56ad8c1f6a4c674007d912f3

Para examinar las capas, 

	 sudo jq '.' /var/lib/docker/image/aufs/imagedb/content/sha256/d092d86c2bcde671ccb7bb66aca28a09d710e49c56ad8c1f6a4c674007d912f3

nos mostrará un JSON bien formateado (por eso usamos `jq`, una
herramienta imprescindible) que, en el elemento `diff_ids`, nos
mostrará las capas. Si repetimos esta operación cada vez que hagamos
un commit sobre una nueva imagen, nos mostrará las capas adicionales
que se van formando. 

<div class='ejercicios' markdown='1'>

Examinar la estructura de capas que se forma al crear imágenes nuevas
a partir de contenedores que se hayan estado ejecutando.

</div>

## Almacenamiento de datos y creación de volúmenes Docker.

Ya hemos visto cómo se convierte un contenedor en imagen, al menos de
forma local, con `commit`. Pero veamos exactamente qué es lo que
sucede y cómo se lleva a cabo.

Docker crea
un
[sistema de ficheros superpuesto u *overlay*](https://rominirani.com/docker-tutorial-series-part-7-data-volumes-93073a1b5b72). Este
[sistema de ficheros superpuesto](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/) puede
tener varias formas posibles, igual que en Linux hay varios tipos de
sistemas de ficheros posibles; Docker usa diferentes drivers
(denominados `overlay` u `overlay2`) para
estructurar la información dentro del contenedor pero generalmente usa
un sistema *copy on write* que escribe en sistema de ficheros
anfitrión cada vez que se produce una modificación en el sistema de
ficheros superpuesto. 

En general, salvo que haya algún problema crítico de prestaciones, es
mejor usar el driver que se use por defecto; dependerá de la
implementación de Docker (CE o EE) y de la versión del
kernel. En
[esta página](https://docs.docker.com/engine/userguide/storagedriver/overlayfs-driver/#configure-docker-with-the-overlay-or-overlay2-storage-driver) se
indica como configurar el driver que se va a usar. 

Hay una forma de usar contenedores solo para almacenar datos, sin que
haya ningún proceso que se ejecute en ellos usando los
llamados
[volúmenes](https://docs.docker.com/engine/reference/commandline/volume_create/#related-commands). Se
crea usando `volume create`

```
docker volume create log
```

Igual que un contenedor Docker es algo así como un proceso con
esteroides, un volumen de Docker es una especie de disco
transportable, que almacena información y que puedes llevar de un lado
a otro. De la misma forma, la arquitectura de las aplicaciones
varía. No vamos a tener una aplicación monolítica que escriba en el
log, lo analice y lo lea, sino diferentes contenedores que
interaccionarán no directamente, sino a través de este contenedor de
almacenamiento.

Por ejemplo, podemos usar un volumen para montar el `/app` de
diferentes sistemas operativos, de forma que podamos probar una
aplicación determinada en los mismos. Hagamos

```
docker volume create benchmark
docker pull fedora
docker run -it --rm -v benchmark:/app fedora /bin/bash
```

Una vez dentro, se puede crear un minibenchmark, que diga por ejemplo
el número de ficheros `ls -R / | wc` y se guarda en `/app`. Una vez
hecho eso, puedes ejecutar ese programa en cualquier distro, de esta
forma:

```
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

```
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

```
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

```
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

```
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

```
docker run -it --rm --volumes-from 8d1e385 jjmerelo/p5hitos
```

`--volumes-from` usa el ID que se haya asignado al contenedor
ejecutándose, o bien el nombre del mismo, que no es el tag con el que
le hemos llamado, sino un nombre generado aleatoriamente
`deeste_estilo`. En este caso no hemos añadido una definición de
volúmenes, por lo que el contenedor se ejecutará y tendrá en `/data`
el mismo contenido. Se puede montar también el contenedor en modo de
solo lectura:

```
docker run -it --rm --volumes-from 8d1e385:ro jjmerelo/p5hitos
```

con la etiqueta `ro` añadida al final del ID del contenedor que se
está usando.

Como se ve, se ejecutan varios pasos uno de los cuales implica "tomar"
un ID e usarlo más adelante en el montaje. No es difícil de resolver
con un script del shell, pero como es una necesidad habitual se han
habilitado otras herramientas para poder hacer esto de forma ágil:
`compose`

## Composición de servicios con `docker compose`


[Docker compose](https://docs.docker.com/compose/install/#install-compose)
tiene que instalarse, no forma parte del conjunto de herramientas que
se instalan por omisión. Su principal tarea es crear aplicaciones que
usen diferentes contenedores, entre los que se citan
[entornos de desarrollo, entornos de prueba o en general despliegues que usen un solo nodo](https://docs.docker.com/compose/overview/#common-use-cases). Para
entornos que escalen automáticamente, o entornos que se vayan a
desplegar en la nube las herramientas necesarias son muy diferentes.

`docker-compose` es una herramienta que parte de una descripción de
las relaciones entre diferentes contenedores y que construye y arranca
los mismos, relacionando los puertos y los volúmenes; por ejemplo,
puede usarse para conectar un contenedor con otro contenedor de datos,
de la forma siguiente:

```
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
trata. Hay hasta una versión 3,
con
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


```
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
> [este artículo](https://medium.freecodecamp.org/docker-development-workflow-a-guide-with-flask-and-postgres-db1a1843044a) se
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

```
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
[esta otra](https://containerjournal.com/2016/03/21/5-docker-best-practices-follow/).

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
[Atomic Host](https://www.projectatomic.io/) hará que se creen
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

[Docker da una serie de recomendaciones a la hora de construir contenedores](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/). Para
hacerlo reproducible, se deben usar Dockerfile o el equivalente en
otro tipo de contenedores, y las órdenes que se
deben usar y cómo usarlas constituye un acervo que conviene conocer y
usar. 

## Usando Dockerfiles

La infraestructura se debe crear usando código, y en Docker pasa
exactamente igual. Tiene un mecanismo llamado Dockerfiles que permite
construir contenedores o tápers de forma que lo que quede en control
de versiones sea el código en sí, no el contenedor, con el
consiguiente ahorro de espacio. La ventaja además es que
en [el Docker hub](https://hub.docker.com) hay multitud de contenedores
ya hechos, que se pueden usar directamente. Veamos un ejemplo, como es
habitual para el bot en Scala que hemos venido usando.

~~~
FROM frolvlad/alpine-scala
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
CMD ["/usr/local/bin/sbt"]

RUN apk update && apk upgrade
RUN apk add git
RUN apk add curl

RUN curl -sL "https://dl.bintray.com/sbt/native-packages/sbt/0.13.13/sbt-0.13.13.tgz" -o /usr/local/sbt.tgz
RUN cd /usr/local && tar xvfz sbt.tgz
RUN mv /usr/local/sbt-launcher-packaging-0.13.13/bin/sbt-launch.jar /usr/local/bin
COPY sbt /usr/local/bin
RUN chmod 0755 /usr/local/bin/sbt
RUN /usr/local/bin/sbt
~~~

Para empezar, puede ser que dentro de la UGR y de alguna otra
instalación similar tengáis problemas de acceso a Internet desde
dentro de un contenedor. En ese caso, meted esto en el `daemon.json`
en el directorio `/etc/docker`

```
{"dns": ["150.214.204.10", "8.8.8.8"] }
```

> La primera IP es solamente para la UGR. Fuera de la UGR tendréis que
> averiguar uno de los servidores DNS que os sirva.

En la primera línea se establece cuál es el contenedor de origen que
estamos usando. Siempre es conveniente usar distros ligeras, y en este
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
hacer una cosa adicional: copiar mediante `COPY` un par de ficheros
locales, el `.jar` que contiene el programa y el fichero de hitos que
se va a usar para responder al usuario.

Para crear una imagen a partir de esto se usa

```
docker build -t jjmerelo/bobot .
```

(o el nick que tengas en GitHub). El `-t` es, como es habitual, para
asignar un *tag*, en este caso uno que se puede usar más adelante en
el Docker Hub. Tardará un rato, sobre todo por la descarga de unas
cuantas bibliotecas por parte de sbt, lo que se hace en la última
línea. Una vez hecho esto, si funciona la construcción, se
podrá ejecutar con

```
docker run --rm -t --env BOBOT_TOKEN=un:token:tocho jjmerelo/bobot 
```

donde --env se usa para pasar la variable de entorno de Telegram que
necesita el bot para funcionar.

Si queremos simplemente examinar el contenedor, podemos entrar en él
de la forma habitual 

```
docker run -it jjmerelo/bot sh
```

para entrar directamente en la línea de órdenes. El repositorio está
en [bobot](https://github.com/JJ/BoBot), como es habitual. En este
caso usamos `CMD` para ejecutar la orden, ya que el contenedor no
recibe ningún parámetro adicional.

<div class='ejercicios' markdown='1'>

Reproducir los contenedores creados anteriormente usando un `Dockerfile`.

</div>

Se pueden construir contenedores más complejos. Una funcionalidad interesante
de los contenedores es la posibilidad de usarlos como *sustitutos* de
una orden, de forma que sea mucho más fácil trabajar con alguna
configuración específica de una aplicación o de un lenguaje de
programación determinado. 

Por
ejemplo,
[esta, llamada `alpine-perl6`](https://hub.docker.com/r/jjmerelo/alpine-perl6/) que
se puede usar en lugar del intérprete de Perl6 y usa como base la
distro ligera Alpine:

```
FROM alpine:latest
MAINTAINER JJ Merelo <jjmerelo@GMail.com>
WORKDIR /root
ENTRYPOINT ["perl6"]

#Basic setup
RUN apk update
RUN apk upgrade

#Add basic programs
RUN apk add gcc git linux-headers make musl-dev perl

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
es la orden `ENTRYPOINT ["perl6"]`. `ENTRYPOINT` se usa para señalar
a qué orden se va a concatenar el resto de los argumentos en la línea
de órdenes, en este caso, tratándose del intérprete de Perl 6, se
comportará exactamente como él. Para que esto funcione también se ha
definido una variable de entorno en:

```
ENV PATH="/root/.rakudobrew/bin:${PATH}"
```

que añade al `PATH` el directorio donde se encuentra. Con estas dos
características se puede ejecutar el contenedor con:

```
docker run -t jjmerelo/alpine-perl6 -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "
```

Si tuviéramos perl6 instalado en local, se podría escribir
directamente 

```
perl6 -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "
```

o algún
otro
[*one-liner* de Perl6](https://gist.github.com/JJ/9953ba0a98800fed205eaae5b5a6410a). 

En caso de que se trate de un servicio o algún otro tipo de programa
de ejecución continua, se puede usar directamente `CMD`. En este caso,
`ENTRYPOINT` da más flexibilidad e incluso de puede evitar usando 

```
docker run -it --entrypoint "sh -l -c" jjmerelo/alpine-perl6
```

que accederá directamente a la línea de órdenes, en este caso
`busybox`, que es el *shell* que provee Alpine. 

Por otro lado, otra característica que tiene este contenedor es que, a
través de `VOLUME`, hemos creado un directorio sobre el que podemos
*montar* un directorio externo, tal como hacemos aquí:

```
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


## Provisión de contenedores docker con herramientas estándar

`docker` tiene capacidades de provisionamiento similares a
otros [sistemas (tales como Vagrant](Gestion_de_configuraciones) usando
[*Dockerfiles*](https://docs.docker.com/engine/reference/builder/). Por
ejemplo,
[se puede crear fácilmente un Dockerfile para instalar node.js con el módulo express](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/). 


## Gestionando contenedores remotos

Docker es una aplicación cliente-servidor que se ejecuta
localmente. Gestionar contenedores remotos implicaría, generalmente,
trabajar con ejecutores remotos tipo Ansible lo que, en caso de que
haya que trabajar con muchos contenedores, generaría todo tipo de
inconvenientes. Para eso
está
[`docker-machine`](https://blog.docker.com/2015/02/announcing-docker-machine-beta/),
que en general sirve 
para trabajar con gestores de contenedores en la nube o con
hipervisores locales, aunque solo funciona con unos pocos, y
generalmente privativos. 

[Docker machine se descarga desde Docker](https://docs.docker.com/machine/) y
su funcionamiento es similar a otras herramientas como Vagrant. En
general, tras crear y gestionar un sistema en la nube, o bien instalar
un *daemon* que se pueda controlar localmente, crea un entorno en la
línea de órdenes que permite usar el cliente `docker` con estos
entornos remotos. 

Vamos a trabajar con VirtualBox localmente. Ejecutando 

	docker-machine create --driver=virtualbox maquinilla
	
se le indica a `docker-machine` que vamos a crear una máquina llamada
`maquinilla` y que vamos a usar el driver de VirtualBox. Esta orden,
en realidad, trabaja sobre VirtualBox instalando una imagen llamada
`boot2docker`, una versión de sistema operativo un poco destripada que
arranca directamente en Docker. Como también suele suceder en gestores
de este estilo, se crea un par clave pública-privada que nos va a
servir más adelante para trabajar con esa máquina.  

Con `ls` listamos las máquinas virtuales que hemos gestionado, así
como alguna información adicional: 

~~~
$ docker-machine ls                                                                                
NAME     ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
maquinilla   -    virtualbox   Running   tcp://192.168.99.104:2376        v1.12.5   
vbox-test    -    virtualbox   Running   tcp://192.168.99.100:2376        v1.12.5   
~~~

Aquí hay dos máquinas, cada una con una dirección IP virtual que vamos
a usar para conectarnos a ellas directamente o desde nuestro cliente
docker. Por ejemplo, hacer `ssh`

~~~
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
~~~

Como vemos, estamos
en [Boot2Docker](https://github.com/boot2docker/boot2docker), un Linux
ligero, con el servicio de Docker incluido, que vamos a poder usar
para desplegar y demás. 

Si queremos usarlo más en serio, desde nuestra línea de órdenes,
tenemos que ejecutar 

	docker-machine env maquinilla
	
Que devolverá algo así:

~~~
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.104:2376"
export DOCKER_CERT_PATH="/home/jmerelo/.docker/machine/machines/maquinilla"
export DOCKER_MACHINE_NAME="maquinilla"
# Run this command to configure your shell: 
# eval $(docker-machine env maquinilla)
~~~

Si estamos ejecutando desde superusuario, habrá que ejecutar

```
eval $(docker-machine env maquinilla)
```

Esa orden exporta las variables anteriores, que le indicarán a docker
qué tiene que usar en ese *shell* explícitamente. Cada nuevo shell
tendrá también que exportar esas variables para poder usar la máquina
virtual. Las órdenes docker que se ejecuten a continuación se
ejecutarán en esa máquina; por ejemplo, 

```
sudo -E docker pull jjmerelo/alpine-perl6
```

descargará dentro de la máquina virtual esa imagen y se ejecutará
dentro de ella cualquier orden. En este caso, -E sirve para que las
variables de entorno del shell local, que hemos establecido
anteriormente, se transporten al nuevo shell. Efectivamente, desde el
nuevo shell podemos comprobar que existen

~~~
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
jjmerelo/alpine-perl6   latest              837fc8bf9307        10
hours ago        491.5 MB
~~~

De la misma forma podemos operar con servidores en la nube, con solo
usar los drivers correspondientes.

<div class='ejercicios' markdown='1'>

Crear con docker-machine una máquina virtual local que permita desplegar contenedores y ejecutar en él
contenedores creados con antelación. 

</div>

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

~~~
docker run --rm -t -v
    /home/jmerelo/Code/forks/perl6/perl6-Math-Sequences:/test
      jjmerelo/test-perl6 /test/t
~~~


## Otros gestores de contenedores

La infraestructura basada en contenedores ha tenido tanto éxito que
han surgido diferentes tipos y también iniciativas de
estandarización. El principal competidor este área es
[`rkt`](https://github.com/coreos/rkt), que además es nativo en el
sistema operativo basado en contenedores CoreOS y que puede usar de
forma nativa el formato de contenedores de Docker, aparte de tener el
suyo propio llamado APPC y
[su propio lenguaje para provisionar contenedores](https://github.com/coreos/rkt/blob/master/Documentation/getting-started-guide).
A diferencia de Docker, se pueden firmar y verificar imágenes, para
evitar su manipulación externa, y, al estar basado en estándares,
puede usar herramientas de orquestación como Kubernetes u otras.

Por otro lado,
la [*Open Container Initiative*](https://www.opencontainers.org/) está
todavía en una fase muy preliminar. Aunque contiene especificaciones
tanto apara ejecutarlos como para especificar imágenes, por lo pronto
no hay muchas implementaciones de referencia que se puedan usar. Si
acaba cuajando puede hacer que el campo de los contenedores evite
monopolios, así que habrá que estar atentos al
mismo. Hay
[trabajo en curso](https://github.com/opencontainers/image-tools) para
comprobar imágenes, por ejemplo. 

A dónde ir desde aquí
-----

Primero, hay que [llevar a cabo el hito del proyecto correspondiente a este tema](../proyecto/6.Docker).

Si te interesa, puedes consultar cómo se [virtualiza el almacenamiento](Almacenamiento) que, en general, es independiente de la
generación de una máquina virtual. También puedes ir directamente al
[tema de uso de sistemas](Uso_de_sistemas) en el que se trabajará
con sistemas de virtualización completa.
