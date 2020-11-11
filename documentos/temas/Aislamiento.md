---
layout: index

apuntes: T

prev: Orquestacion
---

# Aislamiento de recursos: el camino a Docker

<!--@
prev: Orquestacion
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
* Realizar tareas de administración en infraestructura virtual.

### Objetivos específicos

1. Entender cómo las diferentes tecnologías de virtualización se
   integran en la creación de contenedores.

2. Crear infraestructuras virtuales completas.

3. Comprender los pasos necesarios para la configuración automática de
   las mismas.

</div>

## Introducción a la virtualización ligera: *contenedores*

> Llamar a los contenedores sistemas de *virtualización ligera* no
> deja de ser inexacto. Solo desde el punto de vista de un usuario del
> mismo contenedor aparecería que estás dentro de una máquina
> virtual.

El aislamiento de grupos de procesos formando una *jaula* o
*contenedor* ha sido una característica de ciertos sistemas operativos
descendientes de Unix desde los años 80, en forma del
programa [chroot](https://es.wikipedia.org/wiki/Chroot) (creado por
Bill Joy, el que más adelante sería uno de los padres de Java). La
restricción de uso de recursos de las *jaulas `chroot`*, que ya hemos
visto, se limitaba a la protección del acceso a ciertos recursos del
sistema de archivos, aunque eran relativamente fáciles de superar;
incluso así, fue durante mucho tiempo la forma principal de configurar
servidores de alojamiento compartidos y sigue siendo una forma simple
de crear virtualizaciones
*ligeras*. Las
[jaulas BSD](https://en.wikipedia.org/wiki/FreeBSD_jail) constituían
un sistema más avanzado, implementando
una
[virtualización a nivel de sistema operativo](https://en.wikipedia.org/wiki/Operating_system-level_virtualization)
que
creaba un entorno virtual prácticamente indistinguible de una máquina
real (o máquina virtual real). Estas *jaulas* no solo impiden el
acceso a ciertas partes del sistema de ficheros, sino que también
restringían lo que los procesos podían hacer en relación con el resto
del sistema. Tiene como limitación, sin embargo, la obligación de
ejecutar la misma versión del núcleo del sistema.

<div class='nota' markdown='1'>
En
[esta presentación](https://www.slideshare.net/dotCloud/scale11x-lxc-talk-16766275)
explica como los espacios de nombres son la clave para la creación de
contenedores y cuáles son sus ventajas frente a otros métodos de
virtualización
</div>

El mundo Linux no tendría capacidades similares hasta bien entrados
los años 90,
con
[vServers, OpenVZ y finalmente LXC](https://en.wikipedia.org/wiki/Operating_system-level_virtualization#Implementations).
Este último, [LXC](https://linuxcontainers.org/), se basa en el
concepto
de
[grupos de control o CGROUPS](https://en.wikipedia.org/wiki/Cgroups),
una capacidad del núcleo de Linux desde la versión 2.6.24 que crea
*contenedores* de procesos unificando diferentes capacidades del
sistema operativo que incluyen acceso a recursos, prioridades y
control de los procesos. Los procesos dentro de un contenedor están
*aislados* de forma que solo pueden *ver* los procesos dentro del
mismo, creando un entorno mucho más seguro que las anteriores
*jaulas*. Estos
[CGROUPS han sido ya vistos en otro tema](Intro_concepto_y_soporte_fisico).

Dentro de la familia de sistemas operativos Solaris (cuya última
versión libre se
denomina [Illumos](https://en.wikipedia.org/wiki/Illumos), y tiene
también otras versiones
como [SmartOS](https://www.joyent.com/smartos), centradas precisamente
en el uso de contenedores) la tecnología correspondiente se
denomina [zonas](https://en.wikipedia.org/wiki/Solaris_Zones). La
principal diferencia es el bajo *overhead* que le añaden al sistema
operativo y el hecho de que se les puedan asignar recursos
específicos; estas diferencias son muy leves al tratarse simplemente
de otra implementación de virtualización a nivel de sistema operativo.

Un contenedor es, igual que una jaula, una forma *ligera* de
virtualización, en el sentido que no requiere un hipervisor para
funcionar ni, en principio, ninguno de los mecanismos hardware
necesarios para llevar a cabo virtualización. Tiene la limitación de
que la *máquina invitada* debe tener el mismo kernel y misma CPU que
la máquina anfitriona, pero si esto no es un problema, puede resultar
una alternativa útil y ligera a la misma. A diferencia de las jaulas,
combina restricciones en el acceso al sistema de ficheros con otras
restricciones aprovechando espacios de nombres y grupos de
control. `lxc` una de las soluciones de creación de contenedores más
fácil de usar hoy en día en Linux, sobre todo si se quiere usar desde
un programa a nivel de librería. Evidentemente, desde que ha salido
Docker no es la más popular, aunque es una solución madura y estable.

Esta virtualización *ligera* tiene, entre otras ventajas, una *huella*
escasa: un ordenador normal puede admitir 10 veces más contenedores (o
*tápers*) que máquinas virtuales; su tiempo de arranque es de unos
segundos y, además, tienes mayor control desde fuera (desde el
anfitrión) del que se pueda tener usando máquinas virtuales.

## Usando `lxc`

No todas las versiones de los núcleos del sistema operativo pueden
usar este tipo de container; para empezar, dependerá de cómo esté
compilado, pero también del soporte que tenga el
hardware. `lxc-checkconfig` permite comprobar si está preparado para
usar este tipo de tecnología y también si se ha configurado
correctamente. Parte de la configuración se refiere a la instalación
de `cgroups`, que hemos visto antes; el resto a los espacios de
nombres y a capacidades *misceláneas* relacionadas con la red y el
sistema de ficheros.

![Usando lxc-chkconfig](../img/lxcchkconfig.png)

Hay que tener en cuenta que si no aparece alguno de esas capacidades
como activada, LXC no va a funcionar.

La instalación en Linux se hace usando el paquete en los
repositorios. Por las diferencias entre la versión uno y la 2, en
algunos aparecerán paquetes `lxc1` y `lxc2`. Es mejor instalar este
último, con el nombre que sea. Al menos en Ubuntu y distribuciones
derivadas de esta, como Mint, no debería de tener un gran problema.

### Instalando LXC en Arch

Para instalar LXC en una distribución ArchLinux lo que haremos será
ejecutar el comando siguiente:

```bash
pacaur -S lxc arch-install-scripts
```

Así instalaremos LXC junto con otro módulo que se recomienda en la
[documentación de Arch para este paquete](https://wiki.archlinux.org/index.php/Linux_Containers).
Además
hemos de señalar que, por cuestiones de seguridad que también se
comentan en esta documentación, los *namespaces* de usuario estarán
deshabilitados (como veremos al usar `lxc-checkconfig`) ya que no se
puede arrancar servidores sin permisos de superusuario.

Cuando queramos crear nuestro primer contenedor LXC usando las
instrucciones que se detallan en este tema es posible que nos dé un
error diciéndonos que no está disponible el comando `debootstrap`,
solamente tendremos que instalarlo con la orden `sudo pacman -S
debootstrap`, y ya podremos crear contenedores LXC sin problemas.

Tras instalar LXC en Arch junto con el paquete *arch-install-scripts*
(que sugiere en la documentación de Arch que se instale) con los
comandos:

```bash
pacaur -S lxc
pacaur -S arch-install-scripts
```

Lo primero que observamos es que, como dice en la documentación
anteriormente enlazada, los namespaces de usuario no aparecen como
disponibles cuando comprobamos con `lxc-checkconfig`, esto es
aparentemente por un motivo de seguridad de Arch lo que nos obliga a
ejecutar los comandos con sudo al parecer.

Una vez hecho esto al intentar crear una máquina con Ubuntu con el
comando `sudo lxc-create -t ubuntu -n una-caja` nos daba un error
indicando que no podía ejecutar el comando debootstrap, con lo que lo
hemos instalado por medio del comando `sudo pacman -S debootstrap`.

Una vez hecho esto, y tras un tiempo de espera, se ha configurado un
contenedor con Ubuntu que arrancamos son `sudo lxc-start -n una-caja`
y a la que nos ponemos conectar con `sudo lxc-console -n una caja`. Al
hacer esto antes de pulsar ENTER que nos iniciará la consola de dicho
contenedor, hemos de fijarnos que cuando queramos salir de dicha
consola hemos de emplear `Ctrl+a q`, si empleamos el comando `exit` lo
único que haremos será "salir" de la máquina y aparecerá de nuevo la
petición de usuario y contraseña para volver a entrar en ella.

### Instalando LXC en Debian

Para instalar LXC en Debian es necesario contar con una versión 8
(Jessie) o superior. Instalar LXC 2.0 en Debian 8 requiere añadir
los [Jessie backports](https://backports.debian.org/Instructions/) un
repositorio de paquetes inestables y/o de test, por ello contiene
versiones de los paquetes bastante más nuevas que los repositorios
oficiales.

Una vez hecho esto podemos instalar LXC usando
las
[instrucciones oficiales de instalación en Debian](https://wiki.debian.org/LXC)
con
los comandos:

```bash
sudo apt-get install -t jessie-backports  lxc libvirt0 linux-image-amd64

sudo apt-get install libpam-cgroup libpam-cgfs bridge-utils
```

Podemos comprobar que se ha instalado correctamente ejecutando

```bash
lxc-checkconfig
```
Lo que nos debería de dar todo enabled; también podemos comprobar la
versión de LXC instalada con

```bash
lxc-info --version
```

<div class='ejercicios' markdown="1">

Instala LXC en tu versión de Linux favorita. Normalmente la versión en
desarrollo, disponible tanto en [GitHub](https://github.com/lxc/lxc)
como en el [sitio web](https://linuxcontainers.org) está bastante más
avanzada; para evitar problemas sobre todo con las herramientas que
vamos a ver más adelante, conviene que te instales la última versión y
si es posible una igual o mayor a la 2.0.

</div>

### Creando contenedores con `lxc`

Si no hay ningún problema y
todas están *enabled* se puede
[usar lxc con relativa facilidad](https://www.stgraber.org/2012/05/04/lxc-in-ubuntu-12-04-lts/)
siempre que tengamos una distro como Ubuntu relativamente moderna:

```bash
sudo lxc-create -t ubuntu -n una-caja
```

crea un contenedor denominado `una-caja` e instala Ubuntu en él. La
versión que instala dependerá de la que venga con la instalación de
`lxc`, generalmente una de larga duración y en mi caso la 14.04.4; además,
aparte de la instalación mínima, incluirá en el contenedor una serie
de utilidades como `vim` o `ssh`. Todo esto lo indicará en la consola
según se vaya instalando, lo que tardará un rato.

Alternativamente, se
puede usar una imagen similar a la que se usa en
[EC2 de Amazon](https://aws.amazon.com/es/ec2/), donde se denomina AMI:

```bash
sudo lxc-create -t ubuntu-cloud -n nubecilla
```

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

```bash
sudo lxc-start -n nubecilla
```

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

```bash
sudo lxc-console -n nubecilla
```

La salida te dejará "pegado" al terminal.

<div class='ejercicios' markdown='1'>

Instalar una distro tal como Alpine y conectarse a ella usando el
nombre de usuario y clave que indicará en su creación

</div>

Una vez arrancados los
contenedores, si se lista desde fuera aparecerá de esta forma:

```bash
$ sudo lxc-ls -f
NAME       STATE    IPV4        IPV6  AUTOSTART
-----------------------------------------------
nubecilla  RUNNING  10.0.3.171  -     NO
una-caja   STOPPED  -           -     NO
```

Y, dentro de la misma, tendremos una máquina virtual con esta
pinta:

![Dentro del contenedor LXC](../img/lxc.png)

Para el usuario del contenedor aparecerá exactamente igual que
cualquier otro ordenador: será una máquina virtual que, salvo error o
brecha de seguridad, no tendrá acceso al anfitrión, que sí podrá tener
acceso a los mismos y pararlos cuando le resulte conveniente.

```bash
sudo lxc-stop -n nubecilla
```

Las
[órdenes que incluye el paquete](https://help.ubuntu.com/lts/serverguide/lxc.html)
permiten administrar las máquinas virtuales, actualizarlas y explican
cómo usar otras plantillas de las suministradas para crear
contenedores con otro tipo de sistemas, sean o no debianitas. Se
pueden crear sistemas basados en Fedora; también clonar contenedores
existentes para que vaya todo rápidamente.

> La
> [guía del usuario](https://help.ubuntu.com/lts/serverguide/lxc.html#lxc-startup)
> indica también cómo usarlo como usuario sin privilegios, lo que
> mayormente te ahorra la molestia de introducir sudo y en su caso la
> clave cada vez. Si lo vas a usar con cierta frecuencia, sobre todo
> en desarrollo, puede ser una mejor opción.

Los contenedores son la implementación de una serie de
tecnologías
[que tienen soporte en el sistema operativo: espacios de nombres,
CGroups y puentes de red](Tecnicas_de_virtualizacion):
y como tales pueden ser configurados para usar solo una cuota
determinada de recursos, por
ejemplo
[la CPU](https://www.slideshare.net/dotCloud/scale11x-lxc-talk-16766275). Para
ello se usan los ficheros de configuración de cada una de las máquinas
virtuales. Sin embargo, tanto para controlar como para visualizar los
tápers (que así vamos a llamar a los contenedores a partir de ahora)
es más fácil usar [lxc-webpanel](https://lxc-webpanel.github.io/), un
centro de control por web que permite iniciar y parar las máquinas
virtuales, aparte de controlar los recursos asignados a cada una de
ellas y visualizarlos; la página principal te da una visión general de
los contenedores instalados y desde ella se pueden arrancar o parar.

![Página inicial de LXC-Webpanel](../img/Overview-lxc.png)

Cada solución de virtualización tiene sus ventajas e
inconvenientes. La principal ventaja de este tipo de contenedores son el
aislamiento de recursos y la posibilidad de manejarlos, lo que hace
que se use de forma habitual en proveedores de infraestructuras
virtuales. El hecho de que se virtualicen los recursos también implica
que haya una diferencia en las prestaciones, que puede ser apreciable
en ciertas circunstancias.

## Configurando las aplicaciones en un táper

Una vez creados los tápers, son en casi todos los aspectos como una
instalación normal de un sistema operativo: se puede instalar lo que
uno quiera. Sin embargo, una de las ventajas de la infraestructura
virtual es precisamente la (aparente) configuración del *hardware*
mediante *software*: de la misma forma que se crea, inicia y para
desde el anfitrión una MV, se puede configurar para que ejecute unos
servicios y programas determinados.

A este tipo de aplicaciones y sistemas se les denomina
[SCM por *software configuration management*](https://en.wikipedia.org/wiki/Software_configuration_management);
a pesar de ese nombre, se dedican principalmente a configurar
hardware, no software. Un sistema de este estilo permite, por ejemplo,
crear un táper (o, para el caso, una máquina virtual, o muchas de
ellas) y automáticamente *provisionarla* con el software necesario
para comportarse como un
[PaaS](https://jj.github.io/IV/documentos/temas/Intro_concepto_y_soporte_fisico#usando_un_servicio_paas)
o simplemente como una máquina de servicio al cliente.

En general, un SCM permite crear métodos para instalar una aplicación
o servicio determinado, expresando sus dependencias, los servicios que
provee y cómo se puede trabajar con ellos. Por ejemplo, una base de
datos ofrece precisamente ese servicio; un sistema de gestión de
contenidos dependerá del lenguaje en el que esté escrito; además, se
pueden establecer *relaciones* entre ellos para que el CMS use la BD
para almacenar sus tablas.

Hay
[decenas de sistemas CMS](https://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software),
aunque hoy en día los hay que tienen cierta popularidad, como Salt, Rex,
Ansible, Chef, Juju y Puppet. Todos ellos tienen sus ventajas e
inconvenientes, pero para la configuración de tápers se puede usar
directamente [Juju](https://juju.ubuntu.com), creado por Canonical
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

```bash
vagrant init fgrehm/wheezy64-lxc
```

e iniciarlas con

```bash
sudo vagrant up --provider=lxc
```

Con esto se puede provisionar o conectarse usando las herramientas habituales,
siempre que la imagen tenga soporte para ello. Por ejemplo, se puede
conectar uno a esta imagen de Debian con `vagrant ssh`

<div class='ejercicios' markdown="1">

Provisionar un contenedor LXC usando Ansible o alguna otra herramienta
de configuración que ya se haya usado

</div>

## A dónde ir desde aquí

Lo más conveniente es ir al capítulo sobre [Docker](Contenedores).

Si te interesa, puedes consultar cómo
se [virtualiza el almacenamiento](Almacenamiento) que, en general, es
independiente de la generación de una máquina virtual. También puedes
ir directamente al [tema de uso de sistemas](Uso_de_sistemas) en el
que se trabajará con sistemas de virtualización completa.
