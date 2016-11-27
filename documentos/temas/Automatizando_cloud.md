---
layout: index

apuntes: T

prev: Almacenamiento
next: Automatizando_cloud
---

Automatización de tareas en la nube
==

<!--@
prev: Almacenamiento
next: Automatizando_cloud
-->

<div class="objetivos" markdown="1">

<h2>Objetivos</h2>

1.   Conocer las diferentes tecnologías y herramientas de
virtualización tanto para procesamiento, comunicación y
almacenamiento. 

2. Diseñar, construir y analizar las prestaciones de un centro de
proceso de datos virtual. 

3. Documentar y mantener una plataforma virtual.

4. Realizar tareas de administración de infraestructuras virtuales.

</div>

Introducción
------------------

El objetivo de las plataformas de virtualización es, eventualmente,
crear y gestionar una máquina virtual completa que funcione de forma aislada 
del resto del sistema y que permita trabajar con sistemas
virtualizados de forma flexible, escalable y adaptada a cualquier
objetivo. Eventualmente, el objetivo de este este tema es aprender a
crear
[infraestructura como servicio tal como vimos en el primer tema](Intro_concepto_y_soporte_fisico). Para
ello necesitamos configurar una serie de infraestucturas virtuales,
especialmente
[almacenamiento como se vio en el tema anterior](Intro_concepto_y_soporte_fisico).

Los programas que permiten crear infraestructuras virtuales completas
se denominan
[hipervisores](http://en.wikipedia.org/wiki/Hypervisor). Un hipervisor
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

![Ilustración de los dos tipos de hipervisores (alojada en la Wikipedia)](http://upload.wikimedia.org/wikipedia/commons/e/e1/Hyperviseur.png)

Para apoyar la virtualización, casi todos los procesadores actuales y
especialmente [los de las líneas más populares basadas en la
arquitectura x86 tienen una serie de instrucciones que permiten usarla de manera segura y eficiente](http://en.wikipedia.org/wiki/X86_virtualization). Esta
arquitectura tiene dos ramas: la Intel y la AMD, cada uno de los
cuales tiene un conjunto de instrucciones diferentes para llevarla a
cabo. Aunque la mayoría de los procesadores lo incluyen, los
portátiles de gama baja y algunos ordenadores de sobremesa antiguos no
la incluyen, por lo que habrá que comprobar si nuestro procesador lo
hace. Si no lo hiciera, se habla de
[paravirtualización](http://en.wikipedia.org/wiki/Paravirtualization)
en la que los hipervisores tienen que *interpretar* cada imagen del
sistema operativo que alojan (llamado *invitado*) y convertirla en
instrucciones del que aloja (llamado *anfitrión* o *host*). La mayor
parte de los hipervisores, como
[Xen](http://en.wikipedia.org/wiki/Xen) o [KVM](
http://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) incluyen
también la capacidad de paravirtualizar ciertos sistemas operativos en
caso de que los anfitriones no tengan soporte; por ejemplo, KVM se ha
asociado con [QEMU](http://en.wikipedia.org/wiki/QEMU) que lo usa en
caso de que el procesador tenga soporte. 

Por encima de los hipervisores están los sistemas de gestión de
máquinas virtuales en la nube que, aunque se puedan usar desde las
mismas herramientas y con el mismo cometido, en realidad abstraen el
trabajo del hipervisor y permiten trabajar con un API uniforme
independientemente del hipervisor real que esté por debajo. Estos
sistemas de gestión de máquinas virtuales pueden ser libres, como
OpenStack u OpenNebula, o privativos, como los que se usan en la
mayoría de los sistemas de la nube. Todos, sin embargo, permiten
realizar una serie de tareas que veremos a continuación. 


Trabajando con máquinas virtuales en la nube
----

Azure permite,
[tras la creación de almacenamiento virtual](Almacenamiento), la
creación de máquinas virtuales, como es natural. Se puede crear una
máquina virtual desde el panel de control, pero también desde la [línea
de órdenes](https://github.com/WindowsAzure/azure-sdk-tools-xplat). Primero
hay que saber qué imágenes hay disponibles:

	azure vm image list

Por ejemplo, se puede escoger la imagen
`b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu_DAILY_BUILD-trusty-14_04-LTS-amd64-server-20131221-en-us-30GB`
de la última versión de Ubuntu (para salir dentro de cuator meses) o
alguna más probada como la
`b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-13_10-amd64-server-20131215-en-us-30GB`
Con

	azure vm image show b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-13_10-amd64-server-20131215-en-us-30GB
	
nos muestra detalles sobre la imagen; entre otras cosas dónde está
disponible y sobre si es Premium o no (en este caso no lo es). Con
esta (o con otra) podemos crear una máquina virtual

	azure vm create peasomaquina b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-13_10-amd64-server-20131215-en-us-30GB peasousuario PeasoD2clav= --location "West Europe" --ssh

En esta clave tenemos que asignar un nombre de máquina (que se
convertirá en un nombre de dominio `peasomaquina.cloudapp.net`, un
nombre de usuario (como `peasousuario`) que será el superusuario de la
máquina, una clave como `PeasoD2clav=` que debe incluir mayúsculas,
minúsculas, números y caracteres especiales (no uséis esta, hombre),
una localización que en nuestro caso, para producción, será
conveniente que sea *West Europa* pero que para probar podéis
llevárosla a la localización exótica que queráis y, finalmente, para
poder acceder a ella mediante ssh, la última opción, si no no tengo
muy claro cómo se podrá acceder. Una vez hecho esto, conviene que se
cree un par clave pública/privada y se copie al mismo para poder
acceder fácilmente.

La máquina todavía no está funcionando. Con `azure vm list` nos
muestra las máquinas virtuales que tenemos y el nombre que se le ha
asignado y finalmente con `azure vm start` se arranca la máquina y
podemos conectarnos con ella usando `ssh` Una de las primeras cosas
que hay que hacer cuando se arranque es actualizar el sistema para
evitar problemas de seguridad. A partir de ahi, podemos instalar lo
que queramos. El arranque tarda cierto tiempo y dependerá de la
disponibilidad de recursos; evidentemente, mientras no esté arrancada
no se puede usar, pero conviene de todas formas apagarla con 

	azure vm shutdown maquina
	
cuando terminemos la sesión y no sea necesaria, sobre todo porque,
dado que se pagan por tiempo de uso, se puede incurrir en costes
innecesarios. 

<div class='ejercicios' markdown='1'>

Crear una máquina virtual ubuntu e instalar en ella un servidor
nginx para poder acceder mediante web.

</div>

En principio, para configurar la máquina virtual hay que hacerlo como
siempre se ha hecho: trabajando desde línea de órdenes, editando ficheros de configuración e instalando
los paquetes que hagan falta. Pero
[conociendo `juju`](Contenedores) tambien
[se puede trabajar con él](https://juju.ubuntu.com/docs/config-azure.html)
para instalar lo que haga falta. Se puede empezar, por ejemplo
[instalando el GUI de juju](https://juju.ubuntu.com/docs/howto-gui-management.html)
para poder a partir de ahí manejar despliegues en máquinas virtuales
desde él. 

<div class='ejercicios' markdown='1'>

Usar `juju` para hacer el ejercicio anterior.

</div>

Trabajar con estas máquinas virtuales como se tratara de máquinas
reales no tiene mucho sentido. El uso de infraestructuras virtuales,
precisamente, lo que permite es automatizar la creación y
provisionamiento de las mismas de forma que se puedan crear y
configurar máquinas en instantes y personalizarlas de forma
masiva. Veremos como hacerlo en el
[siguiente tema](Gestion_de_configuraciones). 

A dónde ir desde aquí
-----

En el [siguiente tema](Gestion_de_configuraciones) pondremos en
práctica todos los conceptos aprendidos en este tema y
[el anterior](Almacenamiento) para crear configuraciones que sean
fácilmente gestionables y adaptables a un fin determinado.
Antes, habrá que hacer y entregar la
[tercera práctica](../practicas/3.MV).

Si lo que necesitas es un sistema ligero de virtualización, puedes
mirar cómo virtualizar con [contenedores](Contenedores.mv).

