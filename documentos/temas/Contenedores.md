Virtualización *ligera* usando contenedores
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

Introducción a la virtualización ligera: *contenedores*
-------

El aislamiento de grupos de procesos formando una *jaula* o
*contenedor* ha sido una característica de ciertos sistemas operativos
de la rama Unix desde los años 80, en forma del programa
[chroot](https://es.wikipedia.org/wiki/Chroot) (creado por Bill Joy, el
que más adelante sería uno de los padres de Java). La restricción de
uso de recursos de las *jaulas `chroot`*, que ya hemos visto, se limitaba a la protección
del acceso a ciertos recursos del sistema de archivos, aunque son
relativamente fáciles de superar; incluso así, fue durante mucho
tiempo la forma principal de configurar servidores de alojamiento
compartidos y sigue siendo una forma simple de crear virtualizaciones *ligeras*. Las
[jaulas BSD](https://en.wikipedia.org/wiki/FreeBSD_jail) constituían un
sistema más avanzado, implementando una
[virtualización a nivel de sistema operativo](https://en.wikipedia.org/wiki/Operating_system-level_virtualization)
que creaba un entorno virtual prácticamente indistinguible de una
máquina real (o máquina virtual real). Estas *jaulas* no sólo impiden
el acceso a ciertas partes del sistema de ficheros, sino que también
restringían lo que los procesos podían hacer en relación con el resto
del sistema. Tiene como limitación, sin embargo, la obligación de
ejecutar la misma versión del núcleo del sistema.

<div class='nota' markdown='1'>

En
[esta presentación](http://www.slideshare.net/dotCloud/scale11x-lxc-talk-16766275)
explica como los espacios de nombres son la clave para la creación de
contenedores y cuáles son sus ventajas frente a otros métodos de
virtualización

</div>


El mundo Linux no tendría capacidades similares hasta bien entrados los años 90, con
[vServers, OpenVZ y finalmente LXC](https://en.wikipedia.org/wiki/Operating_system-level_virtualization#Implementations). Este
último, [LXC](https://linuxcontainers.org/), se basa en el concepto de
[grupos de control o CGROUPS](https://en.wikipedia.org/wiki/Cgroups),
una capacidad del núcleo de Linux desde la versión 2.6.24 que crea
*contenedores* de procesos unificando diferentes capacidades del
sistema operativo que incluyen acceso a recursos, prioridades y
control de los procesos. Los procesos dentro de un contenedor están
*aislados* de forma que sólo pueden *ver* los procesos dentro del
mismo, creando un entorno mucho más seguro que las anteriores
*jaulas*. Estos [CGROUPS han sido ya vistos en otro tema](Intro_concepto_y_soporte_fisico.md).

Dentro de la familia de sistemas operativos Solaris (cuya última
versión libre se denomina
[Illumos](https://en.wikipedia.org/wiki/Illumos), y tiene también otras
versiones como SmartOS) la tecnología
correspondiente se denomina
[zonas](https://en.wikipedia.org/wiki/Solaris_Zones). La principal
diferencia es el bajo *overhead* que le añaden al sistema operativo y
el hecho de que se les puedan asignar recursos específicos; estas
diferencias son muy leves al tratarse simplemente de otra
implementación de virtualización a nivel de sistema operativo.

Un contenedor es, igual que una jaula, una forma *ligera* de virtualización, en el sentido
que no requiere un hipervisor para funcionar ni, en principio, ninguno
de los mecanismos hardware necesarios para llevar a cabo
virtualización. Tiene la limitación de que la *máquina invitada* debe
tener el mismo kernel y misma CPU que la máquina anfitriona, pero si
esto no es un problema, puede resultar una alternativa útil y ligera a
la misma. A diferencia de las jaulas, combina restricciones en el
acceso al sistema de ficheros con otras restricciones aprovechando
espacios de nombres y grupos de control. `lxc` una de las soluciones de
creación de contenedores más fácil de usar hoy en día en Linux, sobre todo si se quiere usar desde un programa a nivel de librería. Evidentemente, desde que ha salido Docker no es la más popular, aunque es una solución madura y estable. 


Esta virtualización *ligera* tiene, entre otras ventajas, una
*huella* escasa: un ordenador normal puede admitir 10 veces más contenedores
(o *tápers*) que máquinas virtuales; su tiempo de arranque es de unos
segundos y, además, tienes mayor control desde fuera (desde el anfitrión) del que se pueda
tener usando máquinas virtuales.

Usando `lxc`
--

No todas las versiones de los núcleos del sistema operativo pueden usar este tipo de container; para empezar,
dependerá de cómo esté compilado, pero también del soporte que tenga
el hardware. `lxc-checkconfig` permite comprobar si está preparado
para usar este tipo de tecnología y también si se ha configurado correctamente. Parte de la configuración se
refiere a la instalación de `cgroups`, que hemos visto antes; el resto
a los espacios de nombres y a capacidades *misceláneas* relacionadas
con la red y el sistema de ficheros.

![Usando lxc-chkconfig](../img/lxcchkconfig.png)

Hay que tener en cuenta que si no aparece alguno de esas capacidades
como activada, LXC no va a funcionar.

La instalación en Linux se hace usando el paquete en los
repositorios. Por las diferencias entre la versión uno y la 2, en
algunos aparecerán paquetes `lxc1` y `lxc2`. Es mejor instalar este
último, con el nombre que sea. Al menos en Ubuntu y distribuciones
derivadas de esta, como Mint, no debería de tener un gran problema.

### Instalando LXC en Arch

Para instalar LXC en una distribución ArchLinux lo que haremos será ejecutar el comando siguiente:

```bash
pacaur -S lxc arch-install-scripts
```

Así instalaremos LXC junto con otro módulo que se recomienda en la
[documentación de Arch para este paquete](https://wiki.archlinux.org/index.php/Linux_Containers). Además
hemos de señalar que, por cuestiones de seguridad que también se
comentan en esta documentación, los *namespaces* de usuario estarán
deshabilitados (como veremos al usar `lxc-checkconfig`) ya que no se
puede arrancar servidores sin permisos de superusuario.

Cuando queramos crear nuestro primer contenedor LXC usando las
instrucciones que se detallan en este tema es posible que nos dé un
error diciéndonos que no está disponible el comando `debootstrap`,
solamente tendremos que instalarlo con la orden `sudo pacman -S
debootstrap`, y ya podremos crear contenedores LXC sin problemas.

### Instalando LXC en Debian

Para instalar LXC en Debian es necesario contar con una versión 8 (Jessie) o superior. Instalar LXC 2.0 en Debian 8 requiere añadir los [Jessie backports](https://backports.debian.org/Instructions/) un repositorio de paquetes inestables y/o de test, por ello contiene versiones de los paquetes bastante más nuevas que los repositorios oficiales.

Una vez hecho esto podemos instalar LXC usando las [instrucciones oficiales de instalación en Debian](https://wiki.debian.org/LXC) con los comandos:
```
sudo apt-get install -t jessie-backports  lxc libvirt0 linux-image-amd64

sudo apt-get install libpam-cgroup libpam-cgfs bridge-utils
```

Podemos comprobar que se ha instalado correctamente ejecutando
```
lxc-checkconfig
```
Lo que nos debería de dar todo enabled; también podemos comprobar la versión de LXC instalada con
```
lxc-info --version
```

<div class='ejercicios' markdown="1">

Instala LXC en tu versión de Linux favorita. Normalmente la versión en
desarrollo, disponible tanto en [GitHub](http://github.com/lxc/lxc)
como en el [sitio web](http://linuxcontainers.org) está bastante más
avanzada; para evitar problemas sobre todo con las herramientas que
vamos a ver más adelante, conviene que te instales la última versión y
si es posible una igual o mayor a la 2.0.

</div>

### Creando contenedores con `lxc`

Si no hay ningún problema y
todas están *enabled* se puede
[usar lxc con relativa facilidad](http://www.stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/)
siempre que tengamos una distro como Ubuntu relativamente moderna:

	sudo lxc-create -t ubuntu -n una-caja

crea un contenedor denominado `una-caja` e instala Ubuntu en él. La
versión que instala dependerá de la que venga con la instalación de
`lxc`, generalmente una de larga duración y en mi caso la 14.04.4; además,
aparte de la instalación mínima, incluirá en el contenedor una serie
de utilidades como `vim` o `ssh`. Todo esto lo indicará en la consola
según se vaya instalando, lo que tardará un rato.

Alternativamente, se
puede usar una imagen similar a la que se usa en
[EC2 de Amazon](https://aws.amazon.com/es/ec2/), donde se denomina AMI:

	sudo lxc-create -t ubuntu-cloud -n nubecilla

que funciona de forma ligeramente diferente, porque se descarga un
fichero `.tar.gz` usando `wget` (y tarda también un rato). Las
imágenes disponibles las podemos consultar en
[esta web](https://us.images.linuxcontainers.org/), junto con los
nombres que tienen. La opción `-t` es para las plantillas existentes
instaladas en el sistema, que podemos consultar en el directorio
`/usr/share/lxc/templates`.

>Entre ellas, varias de [Alpine Linux](https://alpinelinux.org/), una
>distribución ligera precisamente dirigida a su uso dentro de
>contenedores. También hay una llamada `plamo`, escrita en algún tipo de
>letra oriental, posiblemente japonés. Se puede instalar, pero igual
>no se entiende nada.

Podemos
listar los contenedores que tenemos disponibles con `lxc-ls`, aunque
en este momento cualquier contenedor debería estar en estado
`STOPPED`.

Para arrancar el contenedor y conectarse a él,

	sudo lxc-start -n nubecilla

, donde `-n` es la opción para dar el nombre del contenedor que se va
a iniciar. Dependiendo del contenedor que se arranque, habrá una configuración
inicial; en este caso, se configuran una serie de cosas y
eventualmente sale el login, que será para todas las máquinas creadas
de esta forma `ubuntu` (también clave). Lo que hace esta orden es
automatizar una serie de tareas tales como asignar los CGROUPS, crear
los namespaces que sean necesarios, y crear un puente de red tal como
hemos visto anteriormente. En general, creará un puente llamado
`lxcbr0` y otro con el prefijo `veth`.

Te puedes conectar al contenedor desde otro terminal usando
`lxc-console`

	sudo lxc-console -n nubecilla

La salida te dejará "pegado" al terminal.

<div class='ejercicios' markdown='1'>

Instalar una distro tal como Alpine y conectarse a ella usando el
nombre de usuario y clave que indicará en su creación

</div>

Una vez arrancados los
contenedores, si se lista desde fuera aparecerá de esta forma:

~~~
$ sudo lxc-ls -f      
NAME       STATE    IPV4        IPV6  AUTOSTART  
-----------------------------------------------
nubecilla  RUNNING  10.0.3.171  -     NO         
una-caja   STOPPED  -           -     NO         
~~~

Y, dentro de la misma, tendremos una máquina virtual con esta
pinta:

![Dentro del contenedor LXC](../img/lxc.png)

Para el usuario del contenedor aparecerá exactamente igual que
cualquier otro ordenador: será una máquina virtual que, salvo error o
brecha de seguridad, no tendrá acceso al anfitrión, que sí podrá tener
acceso a los mismos y pararlos cuando le resulte conveniente.

	sudo lxc-stop -n nubecilla

Las
[órdenes que incluye el paquete](https://help.ubuntu.com/lts/serverguide/lxc.html)
permiten administrar las máquinas virtuales, actualizarlas y explican
cómo usar otras plantillas de las suministradas para crear
contenedores con otro tipo de sistemas, sean o no debianitas. Se
pueden crear sistemas basados en Fedora; también clonar contenedores
existentes para que vaya todo rápidamente.


>La
>[guía del usuario](https://help.ubuntu.com/lts/serverguide/lxc.html#lxc-startup)
>indica también cómo usarlo como usuario sin privilegios, lo que
>mayormente te ahorra la molestia de introducir sudo y en su caso la
>clave cada vez. Si lo vas a usar con cierta frecuencia, sobre todo en
>desarrollo, puede ser una mejor opción.

Los contenedores son la implementación de una serie de tecnologías
[que tienen soporte en el sistema operativo: espacios de nombres, CGroups y puentes de red](Tecnicas_de_virtualizacion.md): y como
tales pueden ser configurados para usar sólo una cuota determinada
de recursos, por ejemplo
[la CPU](http://www.slideshare.net/dotCloud/scale11x-lxc-talk-16766275). Para
ello se usan los ficheros de configuración de cada una de las máquinas
virtuales. Sin embargo, tanto para controlar como para visualizar los
tápers (que así vamos a llamar a los contenedores a partir de ahora)
es más fácil usar [lxc-webpanel](http://lxc-webpanel.github.io/), un
centro de control por web que permite iniciar y parar las máquinas
virtuales, aparte de controlar los recursos asignados a cada una de
ellas y visualizarlos; la página principal te da una visión general de los contenedores
instalados y desde ella se pueden arrancar o parar.

![Página inicial de LXC-Webpanel](../img/Overview-lxc.png)

Cada solución de virtualización tiene sus ventajas e
inconvenientes. La principal ventaja de este tipo de contenedores son el
aislamiento de recursos y la posibilidad de manejarlos, lo que hace
que se use de forma habitual en proveedores de infraestructuras
virtuales. El hecho de que se virtualicen los recursos también implica
que haya una diferencia en las prestaciones, que puede ser apreciable
en ciertas circunstancias.


Configurando las aplicaciones en un táper
----

Una vez creados los tápers, son en casi todos los aspectos como una
instalación normal de un sistema operativo: se puede instalar lo que
uno quiera. Sin embargo, una de las ventajas de la infraestructura
virtual es precisamente la (aparente) configuración del *hardware*
mediante *software*: de la misma forma que se crea, inicia y para
desde el anfitrión una MV, se puede configurar para que ejecute unos
servicios y programas determinados.

A este tipo de aplicaciones y sistemas se les denomina
[SCM por *software configuration management*](http://en.wikipedia.org/wiki/Software_configuration_management);
a pesar de ese nombre, se dedican principalmente a configurar
hardware, no software. Un sistema de este estilo permite, por ejemplo,
crear un táper (o, para el caso, una máquina virtual, o muchas de
ellas) y automáticamente *provisionarla* con el software necesario
para comportarse como un
[PaaS](http://jj.github.io/IV/documentos/temas/Intro_concepto_y_soporte_fisico#usando_un_servicio_paas)
o simplemente como una máquina de servicio al cliente.

En general, un SCM permite crear métodos para instalar una aplicación
o servicio determinado, expresando sus dependencias, los servicios que
provee y cómo se puede trabajar con ellos. Por ejemplo, una base de
datos ofrece precisamente ese servicio; un sistema de gestión de
contenidos dependerá del lenguaje en el que esté escrito; además, se
pueden establecer *relaciones* entre ellos para que el CMS use la BD
para almacenar sus tablas.

Hay
[decenas de sistemas CMS](http://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software),
aunque hoy en día los hay que tienen cierta popularidad, como Salt, Rex,
Ansible, Chef, Juju y Puppet. Todos ellos tienen sus ventajas e
inconvenientes, pero para la configuración de tápers se puede usar
directamente [Juju](http://juju.ubuntu.com), creado por Canonical
especialmente para máquinas virtuales de ubuntu que se ejecuten en la
nube de Amazon. En este punto nos interesa también porque se puede
usar directamente con contenedores LXC, mientras que no todos lo
hacen.

En el caso de `lxc`, una forma fácil de gestionar configuraciones es
hacerlo con Vagrant usando
[el driver para lxc](https://github.com/fgrehm/vagrant-lxc). Usando
alguna de las
[*cajas base* de  Atlas](https://github.com/obnoxxx/vagrant-lxc-base-boxes),
pero requiere cierta cantidad de trabajo para construir las plantillas
con Vagrant; eventualmente las cajas se tienen que introducir en el
directorio de plantillas de `lxc` para que se puedan usar, o bien usar
las de Atlas tales como esta

	vagrant init fgrehm/wheezy64-lxc

e iniciarlas con

	sudo vagrant up --provider=lxc

Con esto se puede provisionar o conectarse usando las herramientas habituales,
siempre que la imagen tenga soporte para ello. Por ejemplo, se puede
conectar uno a esta imagen de Debian con `vagrant ssh`  

<div class='ejercicios' markdown="1">

Provisionar un contenedor LXC usando Ansible o alguna otra herramienta
de configuración que ya se haya usado

</div>

Introducción a Docker
---

[Docker](http://docker.com) es una herramienta de gestión de
contenedores que permite no sólo instalarlos, sino trabajar con el
conjunto de ellos instalados (orquestación) y exportarlos de forma que
se puedan desplegar en diferentes servicios en la nube. La tecnología de
[Docker](https://en.wikipedia.org/wiki/Docker_%28software%29) es
relativamente reciente, habiendo sido publicado en marzo de 2013;
actualmente está sufriendo una gran expansión, lo que ha llevado al
desarrollo paralelo de sistemas operativos tales como
[CoreOS](http://coreos.com/), 
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

El enfoque de la virtualización ligera de
Docker [es fundamentalmente diferente](https://www.flockport.com/lxc-vs-docker/) al
de otras soluciones como `lxc/lxd`, que lo precedieron en el tiempo,
aunque las tecnologías subyacentes de virtualización por software son
las mismas y también el hecho de que se trata de soluciones de
virtualización *por software* o *ligera*. Sin embargo, Docker hace
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
*DevOps*. 

A continuación vamos a ver cómo podemos usar Docker como simples
usuarios, para ver a continuación como se puede diseñar una
arquitectura usándolo, empezando por el principio, como instalarlo. 

## Instalación de Docker

[Instalar `docker` es sencillo en las últimas versiones](https://www.docker.com/). 
Por
ejemplo, para
[Ubuntu hay que dar de alta una serie de repositorios](https://docs.docker.com/engine/installation/linux/ubuntulinux/)
y no funcionará con versiones más antiguas de la 12.04 (y en este caso
sólo si se instalan kernels posteriores). En las últimas versiones, de
hecho, ya está en los repositorios y para instalarlo no hay más que
hacer

	sudo apt-get install docker.io

aunque la versión en los repositorios oficiales suele ser más antigua que la que
se descargue de la web o los repositorios adicionales. 


La instalación coloca también un servicio que
se ejecutará como *daemon* y se arrancará con el inicio del
sistema. La instalación desde `docker.com` siguiendo las instrucciones
te instalará también una serie de imágenes genéricas con las que se
puede empezar a trabajar de forma más o menos inmediata. Una vez
instalado, el clásico

	sudo docker run hello-world

`docker` permite instalar contenedores y trabajar con
ellos. Normalmente el ciclo de vida de un contenedor pasa por su
creación y, más adelante, ejecución de algún tipo de programa, por
ejemplo de instalación de los servicios que queramos; luego se puede
salvar el estado del táper y clonarlo o realizar cualquier otro tipo
de tareas.

Así que comencemos desde el principio:
[vamos a ejecutar `docker`y trabajar con el contenedor creado](https://docs.docker.com/engine/installation/linux/ubuntulinux/).

>Hay
>también
>[diferentes opciones para instalar Docker en Windows](https://docs.docker.com/engine/installation/windows/) o
>en
>[un Mac](https://docs.docker.com/engine/installation/mac/). 


## Comenzando a ejecutar Docker

Si no se está ejecutando ya, se puede arrancar como un servicio

	sudo docker -d &

La línea de órdenes de docker conectará con este daemon, que mantendrá
el estado de docker y demás. Cada una de las órdenes se ejecutará
también como superusuario, al tener que contactar con este *daemon*
usando un socket protegido.

>Estamos trabajando con docker como superusuario, que es la forma
>adecuada de
>hacerlo. [Puedes seguir estas instrucciones para hacerlo desde un usuario sin privilegios.](https://docs.docker.com/engine/installation/linux/ubuntulinux/#manage-docker-as-a-non-root-user) sin
>privilegios de administración.

A partir de ahí, podemos crear un contenedor

	sudo docker pull alpine

Esta orden descarga un contenedor básico de [Alpine Linux](https://alpinelinux.org/) y lo instala. Hay
muchas imágenes creadas y se pueden crear y compartir en el sitio web
de Docker, al estilo de las librerías de Python o los paquetes
Debian. Se pueden
[buscar todas las imágenes de un tipo determinado, como Ubuntu](https://hub.docker.com/search/?isAutomated=0&isOfficial=0&page=1&pullCount=0&q=ubuntu&starCount=0)
o
[buscar las imágenes más populares](https://hub.docker.com/explore/). Estas
imágenes contienen no sólo sistemas operativos *bare bones*, sino
también otros con una funcionalidad determinada.

<div class='ejercicios' markdown='1'>

Instalar una imagen alternativa de Ubuntu y alguna
adicional, por ejemplo de CentOS.

</div>

El contenedor tarda un poco en instalarse, mientras se baja la
imagen. Una vez bajada, se pueden empezar a ejecutar comandos. Lo
bueno de `docker` es que permite ejecutarlos directamente sin
necesidad de conectarse a la máquina; la gestión de la conexión y
demás lo hace ello, al modo de Vagrant (lo que veremos más adelante).

Podemos ejecutar, por ejemplo, un listado de los directorios

	sudo docker run alpine ls

Tras el sudo, hace falta docker; `run` es el comando de docker que
estamos usando, `ubuntu` es el nombre de la máquina, el mismo que le
hayamos dado antes cuando hemos hecho pull y finalmente `ls`, el
comando que estamos ejecutando. Este comando arranca el contenedor, lo
ejecuta y a continuación sale de él. Esta es una de las ventajas de
este tipo de virtualización: es tan rápido arrancar que se puede usar
para un simple comando y dejar de usarse a continuación.

Esta imagen de Alpine no contiene bash, pero si el shell básico
llamado `ash` y que está instalado en `sh`,
por lo que podremos *meternos* en la misma ejecutando

	sudo docker run -it alpine sh

Dentro de ella podemos trabajar como un consola cualquiera, pero
teniendo acceso sólo a los recursos propios.

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

	apk update
	apk upgrade

Para que actualice la lista de paquetes disponibles. Después, se pueden instalar paquetes, por ejemplo  

	apk add git perl

Una vez añadido todo lo que queramos a la imagen, se puede almacenar o
subir al registro. En todo caso, `apk search` te permite buscar los
ficheros y paquetes que necesites para compilar o instalar algo. En
algunos casos puede ser un poco más complicado que para otras distros,
pero merece la pena.


### Tareas adicionales con contenedores Docker

La máquina instalada la podemos arrancar usando como ID el nombre de
la imagen de la que procede, pero cada
táper tiene un id único que se puede ver con

	sudo docker ps -a=false

siempre que se esté ejecutando, obteniendo algo así:

	CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
b76f70b6c5ce        ubuntu:12.04        /bin/bash           About an hour ago   Up About an hour                        sharp_brattain     

El primer número es el ID de la máquina que podemos usar también para
referirnos a ella en otros comandos. También se puede usar

	sudo docker images

Que devolverá algo así:

	REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ubuntu              latest              8dbd9e392a96        9 months ago        128 MB
ubuntu              precise             8dbd9e392a96        9 months ago        128 MB
ubuntu              12.10               b750fe79269d        9 months ago        175.3 MB
ubuntu              quantal             b750fe79269d        9 months ago        175.3 MB

El *IMAGE ID* es el ID interno del contenedor, que se puede usar para
trabajar en una u otra máquina igual que antes hemos usado el nombre
de la imagen:

		sudo docker run b750fe79269d du

En vez de ejecutar las cosas una a una podemos directamente [ejecutar un shell](https://docs.docker.com/engine/getstarted/step_two/):

	sudo docker run -i -t ubuntu /bin/bash

que [indica](https://docs.docker.com/engine/reference/commandline/cli/) que
se está creando un seudo-terminal (`-t`) y se está ejecutando el
comando interactivamente (`-i`). A partir de ahí sale la línea de
órdenes, con privilegios de superusuario, y podemos trabajar con la
máquina e instalar lo que se nos ocurra. Esto, claro está, si tenemos
ese contenedor instalado y ejecutándose.

Los contenedores se pueden arrancar de forma independiente con `start`

	sudo docker start	ed747e1b64506ac40e585ba9412592b00719778fd1dc55dc9bc388bb22a943a8

pero hay que usar el ID largo que se obtiene dando la orden de esta
forma

	sudo docker ps -a
	
en la primera columna, donde indica el ID del contenedor.
	
Con esta orden

	sudo docker images --no-trunc

se obtiene el ID largo. Para inspeccionar las imágenes  tienes que averiguar qué IP está usando
y los usuarios y claves y por supuesto tener ejecutándose un cliente
de `ssh` en la misma. Para averiguar la IP:

	sudo docker inspect	ed747e1b64506ac40e585ba9412592b00719778fd1dc55dc9bc388bb22a943a8

te dirá toda la información sobre la misma, incluyendo qué es lo que
está haciendo en un momento determinado. Para finalizar, se puede
parar usando `stop`.

Hasta ahora el uso de
docker [no es muy diferente del contenedor, pero lo interesante](http://stackoverflow.com/questions/17989306/what-does-docker-add-to-just-plain-lxc) es que se puede guardar el estado de un contenedor tal
como está usando [commit](https://docs.docker.com/engine/reference/commandline/cli/#commit)

	sudo docker commit 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c nuevo-nombre

que guardará el estado del contenedor tal como está en ese
momento. Este `commit` es equivalente al que se hace en un
repositorio; para enviarlo al repositorio habrá que usar `push` (pero
sólo si uno se ha dado de alta antes).

<div class='ejercicios' markdown='1'>

Crear a partir del contenedor anterior una imagen persistente con
*commit*.

</div>

Finalmente, `docker` tiene capacidades de provisionamiento similares a
otros [sistemas (tales como Vagrant](Gestion_de_configuraciones.md) usando
[*Dockerfiles*](https://docs.docker.com/engine/reference/builder/). Por
ejemplo,
[se puede crear fácilmente un Dockerfile para instalar node.js con el módulo express](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/).

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
[esta otra](http://containerjournal.com/2016/03/21/5-docker-best-practices-follow/).

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
en [el Docker hub](http://hub.docker.com) hay multitud de contenedores
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

RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/0.13.13/sbt-0.13.13.tgz" -o /usr/local/sbt.tgz
RUN cd /usr/local && tar xvfz sbt.tgz
RUN mv /usr/local/sbt-launcher-packaging-0.13.13/bin/sbt-launch.jar /usr/local/bin
COPY sbt /usr/local/bin
RUN chmod 0755 /usr/local/bin/sbt
RUN /usr/local/bin/sbt
~~~

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

	sudo docker build -t jjmerelo/bobot .

(o el nick que tengas en GitHub). El `-t` es, como es habitual, para
asignar un *tag*, en este caso uno que se puede usar más adelante en
el Docker Hub. Tardará un rato, sobre todo por la descarga de unas
cuantas bibliotecas por parte de sbt, lo que se hace en la última
línea. Una vez hecho esto, si funciona la construcción, se
podrá ejecutar con

	sudo docker run --rm -t --env BOBOT_TOKEN=un:token:tocho jjmerelo/bobot 

donde --env se usa para pasar la variable de entorno de Telegram que
necesita el bot para funcionar.

Si queremos simplemente examinar el contenedor, podemos entrar en él
de la forma habitual 

	sudo docker run -it jjmerelo/bot sh

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

~~~
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
RUN rakudobrew build panda
RUN panda install Linenoise

#Mount point
RUN mkdir /app
VOLUME /app
~~~

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

	ENV PATH="/root/.rakudobrew/bin:${PATH}"

que añade al `PATH` el directorio donde se encuentra. Con estas dos
características se puede ejecutar el contenedor con:

    sudo docker run -t jjmerelo/alpine-perl6 -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "

Si tuviéramos perl6 instalado en local, se podría escribir
directamente 

	perl6 -e "say π  - 4 * ([+]  <1 -1> <</<<  (1,3,5,7,9...10000))  "
	
o algún
otro
[*one-liner* de Perl6](https://gist.github.com/JJ/9953ba0a98800fed205eaae5b5a6410a). 

En caso de que se trate de un servicio o algún otro tipo de programa
de ejecución continua, se puede usar directamente `CMD`. En este caso,
`ENTRYPOINT` da más flexibilidad e incluso de puede evitar usando 

	sudo docker run -it --entrypoint "sh -l -c" jjmerelo/alpine-perl6
	
que accederá directamente a la línea de órdenes, en este caso
`busybox`, que es el *shell* que provee Alpine. 

Por otro lado, otra característica que tiene este contenedor es que, a
través de `VOLUME`, hemos creado un directorio sobre el que podemos
*montar* un directorio externo, tal como hacemos aquí:

	sudo docker run --rm -t -v `pwd`:/app  \
	    jjmerelo/alpine-perl6 /app/horadam.p6 100 3 7 0.25 0.33

En realidad, usando `-v` se puede montar cualquier directorio externo
en cualquier directorio interno. `VOLUME` únicamente *marca* un
directorio específico para ese tipo de labor, de forma que se pueda
usar de forma genérica para interaccionar con el contenedor a través
de ficheros externos o para *copiar* (en realidad, simplemente hacer
accesibles) estos ficheros al contenedor. En el caso anterior,
podíamos haber sustituido `/app` en los dos lugares donde aparece por
cualquier otro valor y habría funcionado igualmente. 

En este caso, además, usamos `--rm` para borrar el contenedor una vez
se haya usado y `-t` en vez de `-it` para indicar que sólo estamos
interesados en que se asigne un terminal y la salida del mismo, no
vamos a interaccionar con él. 

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
hipervisores locales, aunque sólo funciona con unos pocos, y
generalmente privativos. 

[Docker machine se descarga desde Docker](https://docs.docker.com/machine/) y
su funcionamiento es similar a otras herramientas como Vagrant. En
general, tras crear y gestionar un sistema en la nube, o bien instalar
un *daemon* que se pueda controlar localmente, crea un entorno en la
línea de órdenes que permite usar el cliente `docker` con estos
entornos remotos. 

Vamos a trabajar con VirtualBox localmente. Ejecutando 

	sudo docker-machine create --driver=virtualbox maquinilla
	
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
$ sudo docker-machine ls                                                                                
NAME     ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
maquinilla   -    virtualbox   Running   tcp://192.168.99.104:2376        v1.12.5   
vbox-test    -    virtualbox   Running   tcp://192.168.99.100:2376        v1.12.5   
~~~

Aquí hay dos máquinas, cada una con una dirección IP virtual que vamos
a usar para conectarnos a ellas directamente o desde nuestro cliente
docker. Por ejemplo, hacer `ssh`

~~~
$ sudo docker-machine ssh maquinilla
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

	sudo docker-machine env maquinilla
	
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

	eval $(sudo docker-machine env maquinilla)
	
Esa orden exporta las variables anteriores, que le indicarán a docker
qué tiene que usar en ese *shell* explícitamente. Cada nuevo shell
tendrá también que exportar esas variables para poder usar la máquina
virtual. Las órdenes docker que se ejecuten a continuación se
ejecutarán en esa máquina; por ejemplo, 

	sudo -E docker pull jjmerelo/alpine-perl6
	
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

De la misma forma podemos operar con servidores en la nube, con sólo
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
sudo docker run --rm -t -v
  /home/jmerelo/Code/forks/perl6/perl6-Math-Sequences:/test jjmerelo/test-perl6 /test/t
~~~



## Otros gestores de contenedores

La infraestructura basada en contenedores ha tenido tanto éxito que
han surgido diferentes tipos y también iniciativas de
estandarización. El principal competidor este área es
[`rkt`](https://github.com/coreos/rkt), que además es nativo en el
sistema operativo basado en contenedores CoreOS y que puede usar de
forma nativa el formato de contenedores de Docker, aparte de tener el
suyo propio llamado APPC y
[su propio lenguaje para provisionar contenedores](https://github.com/coreos/rkt/blob/master/Documentation/getting-started-guide.md).
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

Primero, hay que [llevar a cabo el hito del proyecto correspondiente a este tema](../proyecto/4.Docker.md).

Si te interesa, puedes consultar cómo se [virtualiza el almacenamiento](Almacenamiento) que, en general, es independiente de la
generación de una máquina virtual. También puedes ir directamente al
[tema de uso de sistemas](Uso_de_sistemas.md) en el que se trabajará
con sistemas de virtualización completa.
