Provisionamiento en infraestructuras virtuales
===

<!--@
prev: Arquitecturas_para_la_nube
next: Automatizando_cloud
-->

<div class="objetivos" markdown="1">

<h2>Objetivos de la asignatura</h2>

* Diseñar, construir y analizar las prestaciones de un centro de
  proceso de datos virtual. 
  
* Documentar y mantener una plataforma virtual.

* Realizar tareas de administración en infraestructura virtual.

<h2>Objetivos específicos</h2>

1. Aprender lenguajes de configuración usados en infraestructuras virtuales.
2. Saber cómo aplicarlos en un caso determinado.
3. Conocer los sistemas de gestión de la configuración,
provisionamiento y monitorización más usados hoy en día.

</div>

Introducción
---

Los [gestores de configuraciones](https://en.wikipedia.org/wiki/Configuration_management) trabajan sobre máquinas virtuales ya
creadas y en funcionamiento, describiendo la configuración que
necesitan para ejecutar una aplicación
determinada. Proporcionan
[infraestructura como código](https://en.wikipedia.org/wiki/Infrastructure_as_Code),
permitiendo describir los sistemas en los que se va a ejecutar código
como si de un programa se tratara, con todo lo que ello conlleva:
control de código y testeo, por ejemplo.

Las *recetas* usadas por los gestores de configuraciones
se ejecutan directamente si ya tenemos tal máquina provisionada con al
menos un sistema operativo, pero
es más eficiente e independiente de la configuración específica
trabajar con ellos desde programas de orquestación de máquinas
virtuales como
[Vagrant](https://en.wikipedia.org/wiki/Vagrant_%28software%29)

Hay muchos gestores de
configuraciones:
[Chef](https://www.chef.io/chef/),
[Salt](https://docs.saltstack.com/en/latest/),
Ansible, [`mgmt`](https://github.com/purpleidea/mgmt) (este último un
poco experimental) y Puppet, por
ejemplo. Todos son libres, pero
[tienen características específicas](https://en.wikipedia.org/wiki/Comparison_of_open_source_configuration_management_software)
que hay que tener en cuenta a la hora de elegir uno u otro. En el caso
específico de
[sistemas operativos](https://en.wikipedia.org/wiki/Configuration_management#Operating_System_configuration_management),
que es del que vamos a hablar aquí, 
se trata de gestionar automáticamente todas las tareas de
configuración de un sistema, automatizando la edición de ficheros de
configuración, instalación de software y configuración del mismo,
creación de usuarios y autenticación, de forma que se pueda hacer de
forma automática y masiva. 

Para poder configurar máquinas virtuales específicas primero hay que
instanciarlas. Dejaremos para más adelante cómo hacerlo de forma
independiente del proveedor de tales servicios y veremos a
continuación cómo preparar una máquina virtual para ser provisionada.

En general, estas herramientas suelen usar
un
[lenguaje de dominio específico](https://en.wikipedia.org/wiki/Domain-specific_language),
con una pequeña cantidad de órdenes relacionada con lo que hacen:
establecer una configuración determinada en un servidor. Este lenguaje
puede consistir en versiones reducidas de lenguajes como Ruby o en
conjuntos de diccionarios específicos de JSON o de YAML, dos lenguajes
de serialización de estructuras de datos.

Generalmente, también, se trata
de
[lenguajes declarativos](https://en.wikipedia.org/wiki/Declarative_programming) en
el sentido que suelen especificar la configuración que se quiere
alcanzar, no qué acciones hay que llevar a cabo para alcanzar esa
configuración; la propia lógica de la herramienta suele encargarse de
ello. Por esa misma razón se usa el concepto de *idempotencia* si se
aplica dos veces una configuración, el resultado es el mismo. 

En cualquier caso, la configuración más simple que se puede hacer es
usar un lenguaje de scripting como `bash` o algún otro que se sepa que
va a estar instalado en el ordenador a configurar; Perl y Python
suelen ser buenos candidatos porque están instalados en casi todas las
configuraciones base. El problema que tiene, sobre todo el primero, es
la falta de idempotencia, la mala gestión de los errores, y, sobre
todo, la no idempotencia. 

## Configurando una instancia

Se puede crear una máquina virtual de muchas formas, usando el
interfaz web o el de línea de órdenes del proveedor de servicios
correspondiente. Consulta el manual de la misma sobre cómo
hacerlo. Sin embargo, si quieres hacer el provisionamiento desde
*fuera*, no puedes usar una imagen cualquiera. Esta imagen tendrá que
tener:

* Un servidor `ssh` activado. Casi todas las imágenes de sistemas
  operativos en los servicios de nube lo tienen, pero a menudo también
  hay que activar los puertos correspondientes (llamados
  *endpoints*). Esto es imprescindible para la conexión.

* Algún lenguaje de programación, el que sea necesario para el sistema
  de provisionamiento que se use. Normalmente se trata de Python
  (Ansible) o Perl (Rex), pero puede ser también otro lenguaje de
  *scripting* como Ruby.

* A veces hace falta instalar algún paquete adicional. Por ejemplo
  `python-apt` si quieres usar directamente las órdenes
  correspondientes de Ansible en vez de ejecutar otras órdenes. Chef
  tiene que estar instalado en el destino o *target*, por lo que en
  muchos casos los servicios de nube ofrecen imágenes con él ya
  instalado.

Cada imagen suele tener un usuario con privilegios de administrador
configurado. Consultar en cada lugar cuál es, pero una vez hecho eso,
el siguiente paso en el provisionamiento es crear un par de clave
pública/privada y copiar la pública al objetivo. A partir de ahí ya se
puede provisionar, empezando por Chef.


## Gestionando configuraciones con Salt

[Salt](https://www.saltstack.com/) es otra herramienta de configuración
que se ha hecho popular en los últimos años. Aunque algo más
complicada de configurar que Ansible, tiene como ventaja que permite
modularizar la configuración para poder adaptarla a sistemas de la
forma más conveniente. `salt-ssh` está basado en Python y solo
requiere, en principio, que este lenguaje esté instalado en el sistema
que se va a provisionar. 

La mejor forma de empezar es
[instalarlo desde Github](https://github.com/saltstack/salt) aunque
nosotros vamos a trabajar con
[`salt-ssh`](https://docs.saltstack.com/en/latest/topics/ssh/), un
sistema que no requiere ningún tipo de instalación en el ordenador
objetivo y que se puede usar, hasta cierto punto, como Ansible. Vamos
a usarlo para
[instalar los servicios necesarios para el bot de Telegram en Scala](https://github.com/JJ/BoBot)
que hemos visto en alguna otra ocasión.

Una vez instalado `salt-ssh`, una de los principales problemas es que
requiere una cierta cantidad de configuración global. Generalmente
vamos a usar un directorio tal como `~/lib/salt/` como directorio de
trabajo y configuración; y este directorio va a estar fuera del
repositorio y en un directorio de superusuario por omisión. Se puede
usar el directorio local, pero en ese caso habrá que decir
específicamente donde se encuentra cada tipo de fichero. En el
[`README.md` del bot](https://github.com/JJ/BoBot/tree/master/provision)
vienen las instrucciones necesarias para crear ese fichero de
provisionamiento y la configuración global. 

Pero para configurar nuestro propio sistema, uno de los
más importantes es el fichero `roster`:

~~~
app: 
  host: 104.196.9.185
  user: one_user
sudo: True
~~~

Aquí no solo se declara la dirección a la que vamos a conectar, sino
también si hace falta ser sudo o no. Con esto podemos ejecutar ya
parte de la configuración que vamos a ejecutar más adelante:

	salt-ssh '*' --roster-file=./roster -r "sudo apt-get install python-apt" -c ~/lib/salt --force-color

En este caso, se trata de ejecutar una orden para poder instalar
`python-apt`, un módulo para poder ejecutar órdenes de instalación de
paquetes directamente desde Python.

Pero para efectivamente provisionar se usan ficheros `salt-stack`. Por
ejemplo,
[estos ficheros instalan Java](https://github.com/JJ/BoBot/tree/master/provision/java)
en la versión necesaria para poder instalar más adelante Scala. Y
Scala lo instalamos en
[este fichero](https://github.com/JJ/BoBot/blob/master/provision/scala/scala.sls)

~~~
include:
  - javasetup

scala:
pkg.installed
~~~


Este fichero se ejecutaría con

	salt-ssh app state.apply scala --roster-file=./roster -c ~/lib/salt --force-color

Este programa, como Ansible, actúa de manera descriptiva. Indica que
el paquete scala tiene que estar instalado, pero para ello tiene que
cumplir una serie de prerrequisitos incluidos en el fichero
`javasetup.sls`; el nombre de estado se tiene que corresponder con el
nombre del fichero en sí. Este a su vez requiere la instalación de otra serie
de paquetes, e incluye otro fichero. Lo bueno es que esos dos
ficheros, `javasetup` y `java`, se pueden usar para todos los paquetes
que usen esa máquina virtual; para instalar Scala solo hay que crear
este último fichero.

Todos estos, por cierto, tienen que ejecutarse desde directorios
específicos, al menos la forma más simple de hacerlo es copiar todos
los ficheros `.sls` a `~/lib/salt/states` y hacerlo desde ahí.

En general, y por la forma que tiene un poco rígida de hacer las
cosas, resulta algo más complicado usarlo que Ansible o incluso
Chef. Sin embargo y limitado a `salt-ssh`, una vez que la
configuración está completa y si se tienen configuraciones base,
construir a partir de ellas es relativamente sencillo. 

<div class='ejercicios' markdown='1'>

Provisionar una máquina virtual en algún entorno con los que
trabajemos habitualmente usando Salt. 
	  
</div>

Otros sistemas de gestión de configuración
---

Las principales alternativas a Chef son [Ansible](https://www.ansible.com),
[Salt]() y [Puppet](https://puppet.com/docs/puppet/3.8/pre_install.html). Todos ellos se comparan en
[este artículo](https://www.infoworld.com/article/2614204/data-center/puppet-or-chef--the-configuration-management-dilemma.html),
aunque los principales contendientes son
[Puppet y Chef, sin que ninguno de los dos sea perfecto](https://www.infoworld.com/d/data-center/puppet-or-chef-the-configuration-management-dilemma-215279?source=fssr). 

De todas ellas, vamos a
[ver Ansible](https://semaphoreci.com/community/tutorials/introduction-to-ansible)
que parece ser uno de los que se está desarrollando con más intensidad
últimamente. [Ansible es](https://en.wikipedia.org/wiki/Ansible_%28software%29) un
sistema de gestión remota de configuración que permite gestionar
simultáneamente miles de sistemas diferentes. Está basado en YAML para
la descripción de los sistemas y escrito en Python. 

Se instala como un módulo de Python, usando por ejemplo la utilidad de
instalación de módulos `pip` (que habrá que instalar si no se tiene)

```
sudo pip install paramiko PyYAML jinja2 httplib2 ansible
```

>`sudo` no hace falta si usas un gestor de entornos como `pyenv`

El resto de las utilidades son también necesarias y en realidad se
instalan automáticamente al instalar ansible. Estas utilidades se
tienen que instalar *en el anfitrión*, no hace falta instalarlas en el
invitado, que lo único que necesitará, en principio, es tener activada
la conexión por ssh y tener una cuenta válida y forma válida de
acceder a ella.

Cada máquina que se añada al control de Ansible se tiene que añadir a
un
[fichero, llamado inventario](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html),
que contiene las diferentes máquinas controladas por el mismo. Por
ejemplo

```
 $ echo "ansible-iv.cloudapp.net" > ~/ansible_hosts
```

se puede ejecutar desde el *shell* para meter (`echo`) una cadena con
una dirección (en este caso, una máquina virtual de Azure) en el
fichero `ansible_hosts` situado en mi directorio raíz. El lugar de ese
fichero es arbitrario, por lo que habrá que avisar a Ansible donde
está usando una variable de entorno:

	export ANSIBLE_HOSTS=~/ansible_hosts
	
Y, con un nodo, ya se puede comprobar si Ansible funciona con 

	$ ansible all -u jjmerelo -m ping
	
Esta orden hace un *ping*, es decir, simplemente comprueba si la
máquina es accesible desde la máquina local. `-u ` incluye el nombre
del usuario (si es diferente del de la máquina local); habrá que
añadir `--ask-pass` si no se ha configurado la máquina remota para
poder acceder a ella sin clave. 

De forma básica, lo que hace Ansible es simplemente ejecutar comandos
de forma remota y simultáneamente. Para hacerlo, podemos usar el
[inventario para agrupar los servidores](https://docs.ansible.com/intro_inventory.html), por ejemplo

	[azure]
	iv-ansible.cloudapp.net

crearía un grupo `azure` (con un solo ordenador), en el cual podemos
ejecutar comandos de forma remota

	$ ansible azure -u jjmerelo -a df
	
nos mostraría en todas las maquinas de azure la organización del
sistema de ficheros (que es lo que hace el comando `df`). Una vez más,
`-u` es opcional. 

Esta orden usa un *módulo* de ansible y se puede ejecutar también de
esta forma:

	$ ansible azure -m shell ls
	
haciendo uso del módulo `shell`. Hay muchos
[más módulos](https://docs.ansible.com/modules.html) a los que se le
pueden enviar comandos del tipo "variable = valor". Por ejemplo, se
puede trabajar con servidores web o
[copiar ficheros](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html#file-transfer)
o
[incluso desplegar aplicaciones directamente usando el módulo `git`](https://docs.ansible.com/intro_adhoc.html#managing-packages)

<div class='ejercicios' markdown='1'>

Desplegar los fuentes de una aplicación cualquiera, propia o libre,  que se
encuentre en un servidor git público en la máquina virtual Azure (o
una máquina virtual local) usando `ansible`.

</div>

Finalmente, el concepto similar a las recetas de Chef en Ansible son los
[*playbooks*](https://davidwinter.me/introduction-to-ansible/),
ficheros en YAML que le dicen a la máquina virtual qué es lo que hay
que instalar en *tareas*, de la forma siguiente

```
	---
	- hosts: azure
	  sudo: yes
	  tasks:
		- name: Update emacs
		  apt: pkg=emacs state=present
```

Esto se guarda en un fichero y se
[le llama, por ejemplo, emacs.yml](../../ejemplos/ansible/emacs.yml),
y se ejecuta con 

```
ansible-playbook ../../ejemplos/ansible/emacs.yml 
```

(recordando siempre el temita del nombre de usuario), lo que dará, si
todo ha ido bien, un resultado como el siguiente

![Instalación de emacs usando ansible](../img/ansible.png)

En el fichero YAML lo que se está expresando es un array asociativo
con las claves `hosts`, `sudo` y `tasks`. En el primero ponemos el
bloque de servidores en el que vamos a actuar, en el segundo si hace
falta hacer sudo o no y en el tercero las tareas que vamos a ejecutar,
en este caso una sola. El apartado de tareas es un vector de hashes,
cada uno de los cuales tiene en `name` el nombre de la tarea, a título
informativo y en las otras claves lo que se va a hacer; `apt` indicará
que hay que instalar un paquete (`pkg`) llamado `emacs` y que hay que
comprobar si está presente o no (`state`). El que se trabaje con
*estados* y no de forma imperativa hace que los *playbooks* sean
*idempotentes*, es decir, si se ejecutan varias veces darán el mismo
resultado que si se ejecutan una sola vez. 

<div class='ejercicios' markdown='1'>

1. Desplegar la aplicación que se haya usado anteriormente  con todos los módulos necesarios
usando un *playbook* de Ansible.

</div>

## Bibliografía

Uno de los libros más interesantes
es
[Infrastructure as Code, de Kief Morris](https://amzn.to/2i3svim). Hace
un resumen muy acertado de todos los principios que rigen la gestión
de infraestructura virtual a través de código y un repaso de todas las
herramientas usadas en el mismo. También está disponible
como
[recurso electrónico](https://bencore.ugr.es/iii/encore/record/C__Rb2606707__Sinfrastructure%20as%20code__Orightresult__X6?lang=spi&suite=pearl) en
la biblioteca de la [UGR](https://www.ugr.es). 

A donde ir desde aquí
-------

Para empezar, hay que
hacer [el hito del proyecto correspondiente](../proyecto/2.Provisionamiento.md).

Desde aquí puedes ir directamente al tema de 
[orquestación de máquinas virtuales](Orquestacion.md), donde se
aprenderá a trabajar con configuraciones más complejas que usen varias
máquinas virtuales a la vez, pero en la asignatura continuaremos
con [la automatización de tareas en la nube](Automatizando_cloud.md)
para aprender como trabajar con diferentes proveedores cloud usando
sus propias herramientas.  


A partir de aquí se puede
seguir aprendiendo sobre DevOps en [el blog](https://devops.com/) o
[en IBM](https://www.ibm.com/cloud-computing/products/devops/). Libros como
[DevOps for Developers](https://www.amazon.es/dp/B009D6ZB0G?tag=atalaya-21&camp=3634&creative=24822&linkCode=as4&creativeASIN=B009D6ZB0G&adid=0PB61Y2QD9K49W3EP8MN&)
pueden ser también de ayuda. Esta
[comparativa de sistemas de configuración](https://en.wikipedia.org/wiki/Comparison_of_open-source_configuration_management_software)
te permite ver todos los que hay, ver la última columna cuáles son los
más recientemente actualizados y qué esperar de cada uno de
ellos. También en este
[gist explica las diferencias entre herramientas en este área](https://gist.github.com/jaceklaskowski/bd3d06489ec004af6ed9),
incluyendo también Puppet e incluso Docker. En
[presentaciones como esta se habla de CAPS: Chef, Ansible, Puppet and Salt](https://es.slideshare.net/DanielKrook/caps-whats-best-for-deploying-and-managing-openstack-chef-vs-ansible-vs-puppet-vs-salt)
como una categoría en sí. En
[este artículo](https://www.infoworld.com/article/2609482/data-center/data-center-review-puppet-vs-chef-vs-ansible-vs-salt.html)
también los comparan y en
[este último](https://jjasghar.github.io/blog/2015/12/20/chef-puppet-ansible-salt-rosetta-stone/)
llevan a cabo la configuración de un servidor simple usando los
cuatro. 


	
