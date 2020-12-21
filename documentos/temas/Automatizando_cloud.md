---
layout: index

apuntes: T

prev: Provision
next: Orquestacion
---

# Automatizando el despliegue en la nube


<!--@
prev: Provision
next: Orquestacion
-->

<div class="objetivos" markdown="1">

## Objetivos

1. Conocer las diferentes tecnologías y herramientas de
virtualización tanto para procesamiento, comunicación y
almacenamiento.
2. Diseñar, construir y analizar las prestaciones de un centro de
proceso de datos virtual.
3. Documentar y mantener una plataforma virtual.
4. Realizar tareas de administración de infraestructuras virtuales.

</div>

## Introducción

El objetivo de las plataformas de virtualización es, eventualmente,
crear y gestionar una máquina virtual completa que funcione de forma
aislada del resto del sistema y que permita trabajar con sistemas
virtualizados de forma flexible, escalable y adaptada a cualquier
objetivo. Eventualmente, el objetivo de este este tema es aprender a
crear
[infraestructura como servicio tal como vimos en el primer tema](Intro_concepto_y_soporte_fisico).
Para
ello necesitamos configurar una serie de infraestructuras virtuales,
especialmente
[almacenamiento como se explica en el tema dedicado a almacenamiento](Almacenamiento).

Los programas que permiten crear infraestructuras virtuales completas
se denominan
[hipervisores](https://en.wikipedia.org/wiki/Hypervisor). Un hipervisor
permite manejar las diferentes infraestructuras desde línea de órdenes
o mediante un programa, y a su vez se habla de dos tipos de
hipervisores: los de *tipo I* o *bare metal* que se ejecutan
directamente sobre el hardware (es decir, el sistema arranca con
ellos) y los de *tipo II* o *alojados*, que se ejecutan dentro de un
sistema operativo tradicional como un módulo del núcleo o simplemente
un programa. En muchos casos la diferencia no está clara, porque hay
hipervisores que son distribuciones de un sistema operativo con
módulos determinados y por lo tanto de Tipo II (si consideramos el
módulo) o de Tipo I (si consideramos el sistema operativo completo),
y en todo caso la distinción es más académica que funcional; en la
práctica, en la mayoría de los casos nos vamos a encontrar con
hipervisores alojados que se ejecutan desde un sistema operativo.

![Ilustración de los dos tipos de hipervisores (alojada en la Wikipedia)](https://upload.wikimedia.org/wikipedia/commons/e/e1/Hyperviseur.png)

Para apoyar la virtualización, casi todos los procesadores actuales y
especialmente
[los de las líneas más populares basadas en la arquitectura x86
tienen una serie de instrucciones que permiten usarla de manera segura
y eficiente](https://en.wikipedia.org/wiki/X86_virtualization).
Esta arquitectura tiene dos ramas: la Intel y la AMD, cada uno de los
cuales tiene un conjunto de instrucciones diferentes para llevarla a
cabo. Aunque la mayoría de los procesadores lo incluyen, los
portátiles de gama baja y algunos ordenadores de sobremesa antiguos no
la incluyen, por lo que habrá que comprobar si nuestro procesador lo
hace. Si no lo hiciera, se habla
de
[paravirtualización](https://en.wikipedia.org/wiki/Paravirtualization)
en la que los hipervisores tienen que *interpretar* cada imagen del
sistema operativo que alojan (llamado *invitado*) y convertirla en
instrucciones del que aloja (llamado *anfitrión* o *host*). La mayor
parte de los hipervisores, como [Xen](https://xenproject.org/)
o [KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine)
incluyen también la capacidad de paravirtualizar ciertos sistemas
operativos en caso de que los anfitriones no tengan soporte; por
ejemplo, KVM se ha asociado
con [QEMU](https://en.wikipedia.org/wiki/QEMU) que lo usa en caso de
que el procesador tenga soporte.

Por encima de los hipervisores están los sistemas de gestión de
máquinas virtuales en la nube que, aunque se puedan usar desde las
mismas herramientas y con el mismo cometido, en realidad abstraen el
trabajo del hipervisor y permiten trabajar con un API uniforme
independientemente del hipervisor real que esté por debajo. Estos
sistemas de gestión de máquinas virtuales pueden ser libres, como
OpenStack u OpenNebula, o privativos, como los que se usan en la
mayoría de los sistemas de la nube. Todos, sin embargo, permiten
realizar una serie de tareas que veremos a continuación.

## Pasos a dar para creación de una instancia en la nube

Aunque los proveedores de nube usan mecanismos diferentes, en realidad
los pasos a dar son muy parecidos, lo que evidentemente es un paso
para que luego se automatice con un interfaz uniforme. Para echar a
andar una instancia, o máquina virtual, en la nube, habrá que hacer
los siguientes pasos

1. Localizar la imagen que deseamos. Esta imagen contendrá el sistema
   operativo, así como alguna utilidad adicional que nos permita
   trabajar fácilmente con sistemas de aprovisionamiento o configurar
   alguna otra cosa. Para ello, suelen tener imágenes o *plantillas*
   que se pueden usar de forma directa, algunas de ellas *oficiales* o
   proporcionadas por los que publiquen el sistema operativo. Antes de
   crear una instancia de la máquina virtual habrá que buscar la forma
   de identificar estas imágenes para crear la instancia con ellas.

2. Crear metadatos relativos a la instancia de la máquina
   virtual. Cosas como el *grupo de recursos*, que indica cómo va a
   escalar, el centro de datos en el que se va a alojar, y alguna cosa
   adicional, como el tipo de instancia que se va a usar.

3. Crear una forma automática de acceder a la máquina virtual,
   generalmente mediante generación y copia a la instancia en
   funcionamiento de la clave pública cuyo par está bajo tu
   control. Dependiendo del sistema, se tendrá que hacer "a mano" o
   usará las claves ya disponibles.

4. Acceso a la propia máquina virtual en funcionamiento,
   principalmente la consola y también a los registros, así como los
   metadatos.

Todas las plataformas suelen tener una utilidad de línea de órdenes, o
varias, que permite acceder al API de la misma una vez identificados
ahí. Generalmente son libres, así que también se pueden usar desde tu
propio programa. A continuación veremos como trabajar en alguna de
ellas.

## Trabajando con máquinas virtuales en la nube

Vamos a ver cómo funcionan algunas de estas utilidades de línea de
órdenes, empezando por el CLI de Azure clásico, luego el moderno, y
más adelante el de OpenStack


### CLI de Azure

El
[CLI de Azure](https://github.com/Azure/azure-cli#installation) en su
segunda versión
está basado en Python y se puede instalar siguiendo las instrucciones
arriba. Es bastante similar al anterior, pero hay muchas tareas que se
realizan mucho más fácilmente usando valores por omisión relativamente
fáciles. Además, devuelve los resultados en JSON por lo que es
relativamente fácil trabajar con ellos de forma automática.

Comencemos por crear un grupo de recursos

```bash
az group create -l westeurope -n CCGroupEU
```

Esto crea un grupo de recursos en Europa Occidental. Vamos a usarlo
más adelante para crear nuestras instancias.

```bash
az vm image list
```

Te devolverá el grupo de máquinas virtuales disponibles. Pero, como se
ha dicho antes, te lo devuelve en JSON, con lo que es conveniente
filtrarlo. Para ello usaremos el tremendamente útil `jq`,
[un lenguaje de peticiones para JSON](https://stedolan.github.io/jq/manual/)
con cierta similitud con los selectores CSS.

Si se añade `--all` te devolverá todas las imágenes disponibles, pero
eso puede tardar bastante tiempo. En todo caso, se puede filtrar de
esta forma.

```bash
az vm image list | jq '.[] | select( .offer | contains("buntu"))'
```

Esta te filtrará solo aquellas imágenes que contengan `buntu` (no
sabemos si va a estar en mayúsculas o minúsculas), devolviendo algo
así:

![Imágenes Ubuntu disponibles](../img/jq.png)

Se puede trabajar también de forma interactiva, lo que tiene al menos
la ventaja de que se completan automáticamente las opciones, y puedes
ver las formas de filtrar.

![Imágenes de Ubuntu desde `az interactive`](../img/az-vm-image.png)

Con esto se pueden buscar, y
filtrar,
[las imágenes que cumplan](https://docs.microsoft.com/es-es/azure/virtual-machines/linux/cli-ps-findimage)
unas condiciones:

```bash
vm image list --publisher RedHat --output table --all
```

Esta orden listará todas las imágenes de RedHat, y además usará un
formato algo más fácil de navegar. `--all` listará todas las imágenes
disponibles, localmente o no. Algunos *publisher* interesantes pueden
ser RedHat, SUSE, saltstack, PuppetLabs, y muchas más que proporcionan
imágenes específicas para aplicaciones tales como Neo4j, MariaDB,
gitlab o Postgres.

También se pueden buscar los proveedores de una imagen
determinada. Por ejemplo

```bash
vm image list --offer CentOS --all --location uksouth --output table
```

listará todas las imágenes que incluyan esa cadena en la `location`
indicada. Esta, por ejemplo,

```bash
vm image list --offer BSD --all --location uksouth --output table
```

mostrará todos los BSD que se ofrecen, la mayoría procedentes de
MicrosoftOSTC (Microsoft Open Source Technology Center). Esta tabla te
muestra también el `URN`, que usaremos a continuación.

> Se ha evitado el centro de datos `westeurope` porque tenía, en el
> momento de las pruebas, un error. En todo caso, se puede usar
> cualquier centro de datos disponible en la suscripción.

De esta imagen hay que usar dos IDs: `urn` y `urnAlias`, que nos
permitirán identificar la imagen con la que vamos a trabajar a
continuación:

```bash
az vm create -g CCGroupEU -n bobot --image UbuntuLTS
```

En este caso creamos la máquina virtual llamada `bobot` con una imagen
de UbuntuLTS y `az` usa una clave SSH pública de nuestro directorio y
nuestro nombre de usuario para copiarlo directamente a la instancia
creada. Puede tardar un rato en crear la instancia, eso sí, pero
devolverá un JSON que incluirá metadatos y su IP pública como
`publicIpAddress`. Una vez hecho eso, te puedes conectar directamente
a ella con su dirección IP y ssh.

Una vez que se deje de usar, conviene pararla con

```bash
az vm stop -g CCGroupEU -n bobot
```
Si no, seguirá disminuyendo el crédito.

<div class='ejercicios' markdown='1'>

Crear una instancia de una máquina virtual Debian y provisionarla
usando alguna de las aplicaciones vistas en
[el tema sobre herramientas de aprovisionamiento](Gestion_de_configuraciones)

</div>

Tanto la elección de la imagen como del centro de datos debe obedecer
a criterios medibles, tales como las prestaciones que se puedan
alcanzar con los mismos. Para ello se pueden
instalar
[benchmarks tales como estos](https://geekflare.com/web-performance-benchmark/) y
diseñar uno que permite elegir en cuál nos vamos a quedar. También se
puede simplemente medir cuanto tardan los tests de la aplicación en
cada uno de los lugares, aunque será conveniente medir también la
latencia, al menos desde local (o desde otra localización de posibles
clientes) de cada uno de los centros de datos.

Para crear una imagen que tenga no solo una IP pública, sino también
una entrada DNS, que puede ser conveniente para referirse a ella en el
futuro, se puede usar la orden siguiente:

```bash
az vm create --name cc-hito-4 --nsg-rule ssh --ssh-key-value\
    @~/.ssh/id_rsa.pub --output tsv --image UbuntuLTS\
    --public-ip-address-dns-name cc-hito-4
```

Aquí no solo hemos creado una máquina cuyo nombre interno es
`cc-hito-4`, sino que también usaremos el mismo nombre para referirnos
a ella desde nuestra máquina local. El nombre completo (Fully
Qualified DNS, FQDNS) será el resultado de componer este nombre + la
*location* + `cloudapp.azure.net`. Por ejemplo,
`cc-hito-4.westeurope.cloudapp.azure.com`.

Dado que estamos escribiendo la salida en TSV ese nombre se presentará
al salir, pero no hace falta capturarlo, porque se puede calcular
automáticamente de esa forma. Si hace falta tener en todo caso la IP o
el nombre, se pueden usar también las peticiones habituales de la
línea de órdenes:

```bash
az vm show -d -n cc-hito-4 --query "fqdns"
az vm show -d -n cc-hito-4 --query "publicIps"
```

Para conocer esos JMESpath que se están escogiendo, conviene mirar la
documentación o simplemente hacer una ejecución inicial sin `--query`
y ver que se devuelve un diccionario o hash con estas dos claves, que
contienen la información indicada.

## CLI de OpenStack

[OpenStack](https://docs.openstack.org/victoria) es un sistema libre
de gestión de nubes privadas que se ha hecho muy popular incluso en
revendedores de sistemas como IBM u otros, que en realidad ofrecen
este tipo de acceso. Se puede probar en alguna instalación disponible
en la Facultad o Escuela o bien
en
[OpenStack Public Cloud Passport](https://www.openstack.org/passport/)
si te admiten.

Como arriba, hay también un
[sistema de línea de órdenes](https://docs.openstack.org/user-guide/cli.html),
inicialmente uno para cada uno de los subsistemas de OpenStack pero
últimamente unificado a una sola orden, `openstack`. Para trabajar con
él, tras descargar el cliente, hay que
[configurar una serie de variables de entorno descargándose un fichero](https://docs.openstack.org/victoria/user/),
que él mismo pone las API keys y demás. Una vez ejecutado ese *script*
de configuración se puede, por ejemplo, crear una clave para acceder
a las instancias que se vayan a crear

```bash
nova keypair-add Try > openstack-key.pem
```

que crea una clave llamada `Try` y la guarda en un fichero de clave
privada.

Sin embargo, al menos en esta instalación de prueba, es más fácil
trabajar con el interfaz gráfico que con la línea de órdenes. En
[este tutorial](https://github.com/naturalis/openstack-docs/wiki/Howto:-Creating-and-using-OpenStack-SSH-keypairs-on-Linux-and-OSX)
te explica cómo crear el par de claves. Una vez creada

* Hay que añadir el puerto 22 de ssh al grupo de seguridad que se vaya
  a usar

* Se tiene que crear una red y una subred para conectar la instancia a
  la subred.

* Se tiene que crear un *router* al cual se conecta la red.

* Finalmente, se crea la instancia. Esto sí se puede hacer desde línea
  de órdenes

```
openstack server create --flavor m1.smaller --image Ubuntu16.04 \
	  --nic net-id=b96fdf8d-99ca-3333-5555-38ccd03a4a3c \
	  --security-group default --key-name Try bobot-x
```

* La orden anterior crea una instancia llamada `bobot-x` con una
  imagen de Ubuntu (una de las que hay por defecto) y una red cuyo ID
  se extrae desde el interfaz gráfico. El *flavor* es el tipo de
  instancia, esta es una de las que hay disponibles.

* Una vez creada la instancia, se le asigna una IP flotante para poder
  acceder desde fuera, teóricamente de esta forma, aunque da error
  (*Conflict*) al menos a mi

```
openstack floating ip create b96fdf8d-99ca-3333-5555-38ccd03a4a3c
```

* Si eso falla, se puede asignar una IP flotante desde el interfaz
  gráfico, yendo a la lista de instancias.

<div class='ejercicios' markdown='1'>

Conseguir una cuenta de prueba en OpenStack y crear una instancia a la
que se pueda acceder, provisionándola con algún *script* disponible.

</div>

## A dónde ir desde aquí

Si no lo has visto, en el [siguiente tema](Gestion_de_configuraciones) pondremos en
práctica todos los conceptos aprendidos en este tema. También se
puede ir a [el hito del proyecto](../proyecto/3.Provisionamiento)
para aplicarlo al mismo. Puedes consultar como documentación adicional
[el tema dedicado a almacenamiento](Almacenamiento) para crear configuraciones que sean
fácilmente gestionables y adaptables a un fin determinado.


Si lo que necesitas es un sistema ligero de virtualización, puedes
mirar cómo virtualizar con [contenedores](Contenedores).

