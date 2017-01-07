---
layout: index

apuntes: T

prev: Automatizando_cloud
next: Contenedores
---

Gestión de infraestructuras virtuales
===

<!--@
prev: Automatizando_cloud
next: Contenedores
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
3. Conocer los sistemas de orquestación de máquinas virtuales.

</div>

## Introducción

Antes de poder provisionar una máquina o conjunto de máquinas
virtuales, es necesario poder crearlas. En el espíritu DevOps, tiene
que haber una forma de hacerlo automáticamente y de forma reproducible
con código, usando el código como infraestructura; también de forma
que sea totalmente portable de una infraestructura a otra; en general,
debe haber una forma de que las infraestructuras como servicio (IaaS)
sean controladas programáticamente, aparte de las otras dos formas que
suelen ofrecer, a través de la web y a través de los interfaces de
línea de órdenes. La primera forma no es escalable, porque sólo
permite crear infraestructuras una por una; la segunda no es portable,
porque cada web tiene sus propias órdenes. Sólo el código permite
reproducir configuraciones de un vendedor a otro sin ningún problema.

Estas herramientas se denominan herramientas de *orquestación* o de
*gestión de configuraciones*, aunque estas herramientas también
incluyen a otras de más bajo nivel como Ansible o Chef. En realidad
hoy en día la única herramienta existente y en uso amplio es
Vagrant. Otras herramientas, como Vortex, parecen abandonadas y otras
como Juju o [Cobbler](http://cobbler.github.io/manuals/quickstart/)
funcionan a otro nivel diferente, trabajando para configurar desde
cero *bare metal* o máquinas sin ningún sistema operativo instalado
que usan arranque remoto.

La ventaja de Vagrant es que puede trabajar de forma indistinta con
máquinas virtuales locales o remotas e incluso, en las últimas
versiones, con contenedores, simplemente cambiando los *drivers* con
los que va a trabajar. Lo veremos a continuación.

No vamos a dedicar demasiado tiempo a la creación y configuración de
máquinas virtuales específicas, aunque en el tema adicional de
[uso de sistemas en la nube](Uso_de_sistemas) se explica como
trabajar con máquinas virtuales con `kvm` y cómo definir, desde la
línea de órdenes, máquinas virtuales en sistemas en cloud como Azure. 


Orquestación de máquinas virtuales
---------------

A un nivel superior al provisionamiento de máquinas virtuales está la configuración,
orquestación y gestión de las mismas, herramientas como
[Vagrant](https://vagrantup.com) ayudan a hacerlo, aunque también
Puppet e incluso Juju pueden hacer muchas de las funciones de
Vagrant, salvo por el hecho de que no pueden trabajar directamente con
el hipervisor. Algunas alternativas son
[Vortex](https://www.npmjs.com/package/vortex) que parece estar
prácticamente sin desarrollo, pero en general el
mercado está bastante copado por Vagrant para sistemas en nube o
locales. 

La ventaja de Vagrant es que permite gestionar el ciclo de vida
completo de una máquina virtual, desde la creación hasta su
destrucción pasando por el provisionamiento y la monitorización o
conexión con la misma. Además, permite trabajar con todo tipo de
hipervisores y provisionadores tanto de contenedores, como en cloud,
como en local.

Sigue las
[instrucciones en la web](https://www.vagrantup.com/downloads.html),
para instalarte Vagrant. Es una aplicación escrita en Ruby, por lo que
tendrás que tener una instalación preparada. Te aconsejamos que uses
un gestor de versiones como [RVM](http://rvm.io) o RBEnv para poder
trabajar con él en espacio de usuario fácilmente.

>Tendrás que tener
>[algunas nociones de Ruby](http://rubytutorial.wikidot.com/introduccion)
>para trabajar con Vagrant, que no es sino un DSL (Domain Specific
>Language) construido sobre él, al menos tendrás que saber como
>instalar *gemas* (bibliotecas), que se usarán para los *plugin* de
>Vagrant y también cómo trabajar con bucles y variables, que se usarán
>en el fichero de definición de máquinas virtuales denominado
>`Vagrantfile`. 

Con Vagrant [te puedes descargar directamente](https://gist.github.com/dergachev/3866825)
[una máquina configurada de esta lista](http://www.vagrantbox.es/) o
bien cualquier otra máquina configurada en el formato `box`, que es el
que uno de los que usa Vagrant.

Trabajemos con la configuración por omisión añadiendo la siguiente
`box`:

	vagrant box add centos7 https://github.com/vezzoni/vagrant-vboxes/releases/download/0.0.1/centos-7-x86_64.box

Para conocer todos los comandos de vagrant, `vagrant help` o `vagrant
list-commands`. En este caso usamos un subcomando de `vagrant box`,
que permite añadir nuevas imágenes a nuestro gestor de máquinas
virtuales; `add` añade uno nuevo en este caso usando el gestor por
omisión que es Virtual Box. El nombre añadido, `viniciusfs/centos7` es
el indicado por la propia orden cuando se ejecuta con un nombre
arbitrario. 

El formato determinará en qué tipo de hipervisor se puede ejecutar; en
general, Vagrant usa VirtualBox, y los `.box` se pueden importar
directamente en esta aplicación; los formatos vienen listados en la
página anterior.

A continuación

	vagrant init centos7

creará un `Vagrantfile` en el directorio en el que te encuentres, por
lo que es conveniente que el directorio esté vacío. En este caso crea
[este fichero](https://github.com/JJ/CC/blob/master/ejemplos/vbox-centos7/Vagrantfile)
en el que realmente sólo se configura el nombre de la máquina
(`centos7`) pero que a base de des-comentar otras líneas se puede
llegar a configurar completa.

Para comenzar a usar la máquina virtual se usa

	vagrant up

En ese momento Virtual Box arrancará la máquina y te podrás conectar a
ella usando

	vagrant ssh

Si quieres conectar por `ssh` desde algún otro programa, por ejemplo,
Ansible, tendrás que fijarte en cómo se configura la conexión y que
puerto se usa. Generalmente, una máquina virtual va a usar el puerto
2222 de ssh y para que accedas desde *fuera* de Vagrant tendrás además
que copiar tu clave pública, lo que puedes hacer copiando y pegándola
desde un terminal o bien
[usando el propio Vagrantfile](http://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm)
añadiendo las dos líneas siguientes:

	#Copy public key
	ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
	config.vm.provision 'shell', inline: "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys", privileged: false

Una vez creada la máquina, para que use estas líneas y se provisione
hay que hacer

	vagrant provision

Hay que seguir teniendo en cuenta que se usa el puerto 2222, o sea que
para conectarte a la máquina (o usar un provisionador de forma externa
a Vagrant) tendrás que hacerlo así:

	ssh vagrant@127.0.0.1 -p 2222


Para suspender el estado de la máquina virtual y guardarlo se usa

	vagrant suspend

Esto dejará la máquina virtual en el estado en el que esté, que se
podrá recuperar en la próxima sesión. Cuando quieras deshacerte de
ella,

	vagrant destroy

<div class='ejercicios' markdown='1'>

	Instalar una máquina virtual Debian usando Vagrant y conectar con ella.
	
</div>

### Trabajando con otro tipo de máquinas virtuales e hipervisores.

En [`vagrantbox.es`](http://vagrantbox.es) la mayor parte de las
imágenes tienen formato VirtualBox, pero algunas tienen formato
"Vagrant-lxc" (para usar en el sistema de virtualización lxc), VMWare,
KVM, Parallels o `libvirt`. Ninguno de estos formatos está instalado
por defecto en Vagrant y habrá que instalar un plugin. Instalemos el
[plugin de `libvirt`](https://github.com/vagrant-libvirt/vagrant-libvirt),
por ejemplo, siguiendo las instrucciones de su repositorio; de hecho,
para instalar libvirt habrá que seguir también las instrucciones en el
mismo repositorio, que incluyen instalar
`qemu`. [libVirt](https://libvirt.org/) es una librería que abstrae
todas las funciones de virtualización, permitiendo trabajar de forma
uniforme con diferentes hipervisores tales como Xen e incluso el
propio `lxc` mencionado anteriormente. Una vez instalada esta
biblioteca, no hay que preocuparse tanto por el sistema de
virtualización que tengamos debajo e incluso podemos trabajar con ella
de forma programática para crear y configurar máquinas virtuales sin
tener que recurrir a sistemas de orquestación o provisionamiento.  

Simultáneamente a la instalación, podemos descargarnos esta máquina
virtual que está en ese formato. 

	vagrant box add viniciusfs/centos7 https://atlas.hashicorp.com/viniciusfs/boxes/centos7/

A continuación, la inicialización será de la misma forma

	vagrant init viniciusfs/centos7
	
crea un fichero `Vagrantfile` (y así te lo dice) que ya sabemos que permite trabajar
y llevar a cabo cualquier configuración adicional.

>Podemos añadirle también la clave pública propia si queremos usarlo
> "desde fuera".

Una vez hecho eso
ya podemos inicializar la máquina y trabajar con ella (pero antes voy
a apagar la máquina Azure que tengo ejecutándose desde que empecé a
contar lo anterior)

	sudo vagrant up --provider=libvirt
	
donde la principal diferencia es que le estamos indicando que queremos
usar el *proveedor* libvirt, en vez de el que usa por omisión, Virtual
Box. Dado que este proveedor conecta con un daemon que se ejecuta en
modo privilegiado, habrá que usar `sudo` en este caso. 

>Puede que tengas [un problema con libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt/issues/669) con "dhcp_leases: undefined method" o similar comprobad la versión que tenéis. Si estáis usando la 0.0.36 desinstaladla e instalad la 0.0.35 como indican en el mismo issue. 

Usando este sudo,  puedes conectarte con la máquina usando

	sudo vagrant ssh

Y todos los demás comandos, también con `sudo`. 
	
<div class='ejercicios' markdown='1'>

	Instalar una máquina virtual ArchLinux o FreeBSD para KVM, otro
    hipervisor libre, usando Vagrant y conectar con ella. 
	
</div>



## Provisionando máquinas virtuales.

Una vez creada la máquina virtual se puede entrar en ella y
configurarla e instalar todo lo necesario desde la línea de órdenes. Pero, por supuesto,
sabiendo lo que sabemos sobre provisionamiento por el tema correspondiente, Vagrant permite
[provisionarla de muchas maneras diferentes](https://www.vagrantup.com/docs/provisioning/index.html). En
general, Vagrant usará opciones de configuración diferente dependiendo
del provisionador, subirá un fichero a un directorio temporal del
mismo y lo ejecutará (tras ejecutar todo lo necesario para el mismo). 

La provisión tiene lugar cuando se *alza* una máquina virtual (con
`vagrant up`) o bien explícitamente haciendo `vagrant provision`. En
cualquier caso se lee del Vagrantfile y se llevan a cabo las acciones
especificadas en el fichero de configuración. 

En general, trabajar con un provisionador requiere especificar de cuál
se trata y luego dar una serie de órdenes específicas. Comenzaremos
por el
[*shell*](http://docs.vagrantup.com/v2/provisioning/shell.html), que
es el más simple y, en realidad, equivale a entrar en la máquina y dar
las órdenes a mano. Instalaremos, como hemos hecho en otras ocasiones,
el utilísimo editor `emacs`usando este
[`Vagrantfile`](../../ejemplos/vagrant/provision/Vagrantfile):

	VAGRANTFILE_API_VERSION = "2"

	Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
		config.vm.box = "centos7"

	    config.vm.provision "shell",
			inline: "yum install -y emacs"
	end

Recordemos que se trata de un programa en Ruby en el cual configuramos
la máquina virtual. La 4ª línea indica el nombre de la máquina con la
que vamos a trabajar (que puede ser la usada en el caso anterior);
recordemos también que, por omisión, se trabaja con VirtualBox (si se
hiciera con algún otro tipo de hipervisor habría que usar el *plugin*
correspondiente e inicializar la máquina de alguna otra forma). La
parte en la que efectivamente se hace la provisión va justamente a
continuación. La orden `config.vm.provision` indica que se va a usar
el sistema de provisión del `shell`, es decir, órdenes de la línea de
comandos; se le pasa un hash en Ruby  (variable: valor, tal como en
javascript, separados por comas) en el que la clave `inline` indica el
comando que se va a ejecutar, en este caso `yum`, el programa para
instalar paquetes en CentOS, y al que se le indica `-y` para que
conteste *Yes* a todas las preguntas sobre la instalación. 

Este Vagrantfile no necesita nada especial para ejecutarse: se le
llama directamente cuando se ejecuta `vagrant up` o explícitamente
cuando se llama con `vagrant provision`. Lo único que hará es instalar
este programa bajándose todas sus dependencias (y tardará un rato).

<div class='ejercicios' markdown='1'>

	Crear un script para provisionar de forma básica una máquina
    virtual para el proyecto que se esté llevando a cabo en la asignatura. 
	
</div>

<div class='nota' markdown='1'>

El provisionamiento por *shell* admite
[muchas más opciones](http://docs.vagrantup.com/provisioning/shell.html):
se puede usar un fichero externo o incluso alojado en un sitio web
(por ejemplo, un Gist alojado en Github). Por ejemplo,
[este para provisionar nginx y node](https://gist.github.com/DamonOehlman/5754302)
(no leer hasta después de hacer el ejercicio anterior).

</div>

El problema con los guiones de *shell* (y no sé por qué diablos pongo
guiones si pongo shell, podía poner scripts de shell directamente y
todo el mundo me entendería, o guiones de la concha y nadie me
entendería) es que son específicos de una máquina. Por eso Vagrant
permite muchas otras formas de configuración, incluyendo casi todos
los sistemas de provisionamiento populares (Chef, Puppet, Ansible,
Salt) y otros sistemas com Docker, que también hemos visto. La ventaja
de estos sistemas de más alto nivel es que permiten trabajar
independientemente del sistema operativo. Cada uno de ellos tendrá sus
opciones específicas, pero veamos cómo se haría lo anterior usando el
provisionador
[chef-solo](https://www.vagrantup.com/docs/provisioning/chef_solo.html).

Para empezar, hay que provisionar la máquina virtual para que funcione
con chef-solo y hay que hacerlo desde shell o Ansible;
[este ejemplo](../../ejemplos/vagrant/provision/chef-with-shell/Vagrantfile)
que usa
[este fichero shell](../../ejemplos/vagrant/provision/chef-with-shell/chef-solo.sh)
puede provisionar, por ejemplo, una máquina CentOS. 

Una vez preinstalado chef (lo que también podíamos haber hecho con
[una máquina que ya lo tuviera instalado, de las que hay muchas en `vagrantbox.es`](http://www.vagrantbox.es/)git co
y de hecho es la mejor opción porque `chef-solo` no se puede instalar en
la versión 6.5 de CentOS fácilmente por no tener una versión
actualizada de Ruby)
incluimos en el Vagrantfile. las órdenes para usarlo en
[este Vagrantfile](../../ejemplos/vagrant/provision/chef/Vagrantfile) 

	VAGRANTFILE_API_VERSION = "2"

	Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
		config.vm.box = "centos7"

	    config.vm.provision "chef_solo" do |chef|
			chef.add_recipe "emacs"
		end

	end

Este fichero usa un bloque de Ruby para pasarle variables y
simplemente declara que se va a usar la receta `emacs`, que
previamente tendremos que haber creado en un subdirectorio cookbooks
que descienda exactamente del mismo directorio y que contenga
simplemente `package 'emacs'` que tendrá que estar en un fichero 

	cookbooks/emacs/recipes/default.rb
	
Con todo esto se puede configurar emacs. Pero, la verdad, seguro que
es más fácil hacerlo en Ansible y/o en otro sistema operativo que no
sea CentOS porque yo, por lo pronto, no he logrado instalar chef-solo
en ninguna de las máquinas pre-configuradas de VagrantBoxes. 

<div class='ejercicios' markdown='1'>

	Configurar tu máquina virtual usando `vagrant` con el provisionador
	ansible
	
</div>

Desde Vagrant se puede crear también una
[caja base](https://www.vagrantup.com/docs/boxes/base.html) con lo
mínimo necesario para poder funcionar, incluyendo el soporte para ssh
y provisionadores como Chef o Puppet. Se puede crear directamente en
VirtualBox y usar
[`vagrant package`](https://www.vagrantup.com/docs/cli/package.html)
para *empaquetarla* y usarla para su consumo posterior. 

## Configuración de sistemas distribuidos.

Vagrant es sumamente útil cuando se trata de configurar varios
sistemas a la vez, por la posibilidad que tiene de trabajar con
diferentes proveedores pero también por tratarse de un programa en
Ruby que puede simplemente guardar el estado común e implantarlo en
las máquinas virtuales que se vayan creando.

A la vez, sistemas operativos como CoreOS son interesantes
precisamente por la facilidad para configurarlos como sistemas
distribuidos, que proviene de su diseño para ser anfitriones de
contenedores pero también a su uso de `etcd`, una base de datos
clave-valor distribuida que se usa en este caso principalmente para
guardar las configuraciones. 

Veamos en el siguiente ejemplo cómo se
puede
[configurar un sistema con varias máquinas virtuales coordinadas usando CoreOS](https://github.com/JJ/vagrant-coreos/blob/master/Vagrantfile) (originalmente
estaba [aquí](https://github.com/coreos/coreos-vagrant). Es un fichero
un tanto largo y complicado, pero veamos las partes más
interesantes. Primero, usa un fichero externo de
configuración,
[`config.rb`](https://github.com/JJ/vagrant-coreos/blob/master/config.rb). A
pesar de su nombre, no es un fichero de Chef, simplemente un fichero
que se va a incluir en la configuración de Vagrant que se llama así. 

~~~
# Size of the CoreOS cluster created by Vagrant
$num_instances=3

# Used to fetch a new discovery token for a cluster of size $num_instances
$new_discovery_url="https://discovery.etcd.io/new?size=#{$num_instances}"

# Automatically replace the discovery token on 'vagrant up'

if File.exists?('user-data') && ARGV[0].eql?('up')
  require 'open-uri'
  require 'yaml'

  token = open($new_discovery_url).read

  data = YAML.load(IO.readlines('user-data')[1..-1].join)

  if data.key? 'coreos' and data['coreos'].key? 'etcd'
    data['coreos']['etcd']['discovery'] = token
  end

  if data.key? 'coreos' and data['coreos'].key? 'etcd2'
    data['coreos']['etcd2']['discovery'] = token
  end

  # Fix for YAML.load() converting reboot-strategy from 'off' to `false`
  if data.key? 'coreos' and data['coreos'].key? 'update' and data['coreos']['update'].key? 'reboot-strategy'
    if data['coreos']['update']['reboot-strategy'] == false
      data['coreos']['update']['reboot-strategy'] = 'off'
    end
  end

  yaml = YAML.dump(data)
  File.open('user-data', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
end
~~~
Este fichero, después de definir el número de máquinas virtuales que
  tenemos, busca un fichero llamado `user-data` que es privado porque
  contiene un *token* obtenido de https://discovery.etcd.io. Este
  token da acceso al registro de todas las instancias de `etcd` con
  las que vamos a
  trabajar. En
  [la muestra](https://github.com/JJ/vagrant-coreos/blob/master/user-data.sample) indica
  qué es lo que hay que hacer para obtenerla. Por lo demás, lo único
  que hay que cambiar es el número de instancias que se desean. 
  
El `Vagrantfile`, por otro lado, realiza una serie de adaptaciones de
la máquina virtual usada y crea una red privada virtual que una a las
tres máquinas, de forma que se puedan comunicar de forma segura. Una
vez ejecutado `vagrant up` se puede acceder a las máquinas por ssh con
el nombre definido (`core-0x`) pero también se pueden usar para
escalar aplicaciones basadas en contenedores en
el
[*cluster* de CoreOS](https://coreos.com/os/docs/latest/cluster-architectures.html) creado,
con el que puedes
ejecutar
[múltiples copias de tu aplicación](https://coreos.com/os/docs/latest/cluster-architectures.html) para
replicación o escalado automático. 


## Algunos ejemplos interesantes

La migración a la nube ha hecho que se creen ciertos sistemas
operativos cuyo fin sea servir de soporte exclusivamente a servicios
en la misma. Uno de ellos es [Scotch Box](https://box.scotch.io/), que
empaqueta una serie de herramientas de cliente servidor para ejecutar
una pila de desarrollo completa,
o
[`bosh-lite`](https://atlas.hashicorp.com/cloudfoundry/boxes/bosh-lite) para
[BOSH, una herramienta de gestión de sistemas distribuidos](https://bosh.io/) o
[una máquina virtual para empezar con ciencia de datos](https://atlas.hashicorp.com/data-science-toolbox/boxes/dst).

Pero una de las más interesantes que podemos usar
es
[CoreOS](https://coreos.com/os/docs/latest/booting-on-vagrant.html),
un sistema operativo diseñado para ejecutar contenedores. 

A donde ir desde aquí
-------

Este es el último tema del curso, pero a partir de aquí se puede
seguir aprendiendo sobre DevOps en [el blog](https://devops.com/) o
[en IBM](http://www.ibm.com/ibm/devops/us/en/). Libros como
[DevOps for Developers](https://www.amazon.es/dp/B009D6ZB0G?tag=atalaya-21&camp=3634&creative=24822&linkCode=as4&creativeASIN=B009D6ZB0G&adid=0PB61Y2QD9K49W3EP8MN&)
pueden ser también de ayuda.


	
