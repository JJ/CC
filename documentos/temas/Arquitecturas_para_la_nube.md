Arquitecturas software para la nube
=========================

<!--@
next: Provision
-->

<div class="objetivos" markdown="1">

## Objetivos 

### De la asignatura


-  Conocer los conceptos relacionados con el proceso de virtualización
tanto de software como de hardware y ponerlos en práctica.
- Justificar la necesidad de procesamiento virtual frente a real en
el contexto de una infraestructura TIC de una organización.
- Optimizar aplicaciones sobre plataformas virtuales.
- Conocer diferentes tecnologías relacionadas con la virtualización (Computación Nube, Utility Computing, Software as a Service) e implementaciones tales como Google AppSpot, OpenShift o Heroku.</li>


### Específicos 

1. Comprender los ecosistemas de despliegue de aplicaciones modernos
y su relación con la nube.
2. Entender las diferentes arquitecturas de software modernas y su
relación con *cloud computing*.
3. Aprender diseños que se puedan usar más adelante en aplicaciones
desplegables en la nube.

</div>


## Introducción

>Puedes echarle un vistazo a
>[esta colección de transpas](https://www.slideshare.net/jjmerelo/clipboards/my-clips)
>con información de un par de presentaciones sobre arquitectura
>moderna de aplicaciones. Aunque centrado en microservicios,
>[este conjunto de patrones](https://microservices.io/patterns/index.html)
>menciona también algunos de los que veremos aquí.

El panorama informático del siglo XXI está lleno de posibilidades:
múltiples lugares donde ejecutar una aplicación, múltiples servicios
que se pueden usar desde ella, todos conectados a través de Internet, y
metodologías específicas para desarrollar aplicaciones. Se hace
difícil concretar en una arquitectura específica, entendiendo por
arquitectura una visión de bloques de los diferentes componentes de
una aplicación, su situación física y lógica y la relación entre
ellos. Resulta bastante claro, sin embargo, que una arquitectura
monolítica con un cliente ejecutando el interfaz de usuario y un
servidor, replicado o no pero ejecutando todos los componentes de una
aplicación, no resulta adecuada para las aplicaciones modernas ni por
sus características de escalado ni por el reparto de tareas y datos
entre diferentes partes de un equipo de desarrollo.

En este tema introductorio a la asignatura veremos diferentes
arquitecturas de software con ejemplos concretos, ejemplos que se
podrán usar, siquiera de una forma básica, para elegir una aplicación
para la cual crear la arquitectura virtual.

## Arquitecturas software

>En gran parte, este apartado está sacado de
>[Software Architecture Patterns, de Mark Richards](https://www.oreilly.com/programming/free/software-architecture-patterns.csp?intcmp=il-prog-free-article-sa15_sa_patterns),
>un *ebook* gratuito que te puedes descargar dando tu email, lo que
>aconsejo vivamente que hagas. 

En general, las arquitecturas software modernas tienen como objetivo
común el
buscar la consistencia en la velocidad de respuesta al usuario. Otros
elementos comunes son el uso de recursos propios combinados con
recursos de diferentes empresas o *vendors*, y que se basan
en unas metodologías de desarrollo ágil e integración y despliegue
continuo. Veremos qué arquitecturas son las más comunes en este
contexto. 

### Arquitectura en capas

La
[arquitectura en capas](https://en.wikipedia.org/wiki/Multilayered_architecture)
o multilayer es el desarrollo natural de la arquitectura
cliente-servidor, creando 3 o más capas entre las que se suele incluir
la capa de presentación, la de aplicación, la de lógica de negocio y
la de acceso a datos. Muchos marcos de desarrollo modernos trabajan de
esta forma y son relativamente simples de desarrollar. El problema
principal es que solo permiten escalado dentro de cada una de las
capas, siendo al final alguna de ellas un cuello de botella.

### Arquitectura dirigida por eventos

[Este tipo de arquitectura](https://en.wikipedia.org/wiki/Event-driven_architecture) representa un cambio fundamental con
respecto a la arquitectura tradicional. El elemento fundamental de
esta arquitectura es la cola de eventos, que se originan en el
usuario, pero también de una parte a otra de la arquitectura. A través
de una cola de eventos, diferentes procesadores de eventos van
extrayendo eventos de la cola y procesándolos de forma asíncrona. El
hecho de que pueda haber una cantidad de procesadores de eventos
indeterminada y que puedan estar en cualquier sitio (nube privada o
pública) hace que sea una arquitectura que escala de forma fácil,
aunque haya que monitorizar todo el sistema de forma que se pueda
recuperar fácilmente en caso de fallo. También permite desplegar o
rearrancar cada uno de los procesadores de forma independiente.

El principal problema es que es más difícil de testear y también su
desarrollo se hace un poco más complicado que en el caso anterior.

Algunos marcos de aplicaciones como Java Swing usan este tipo de
arquitectura.

### Arquitectura microkernel

Se trata de [una arquitectura](https://viralpatel.net/blogs/microkernel-architecture-pattern-apply-software-systems/) más o menos monolítica, con un núcleo
central al que se pueden añadir funcionalidades mediante plugins. Un
tipo de arquitectura clásico que se usa en CMSs como Joomla o en
sistemas de aprendizaje como Moodle. El problema principal es la
escalabilidad, ya que el núcleo puede representar un cuello de
botella. 

### Arquitectura basada en microservicios.

Una de las arquitecturas más populares hoy en día, los
[microservicios](https://microservices.io) se caracterizan por poder
usar tecnologías subyacentes que van desde la virtualización completa
en la nube hasta el uso de contenedores Docker en una sola máquina
virtual.

Lo principal en una arquitectura de microservicios es que se trata de
unidades que se van a desplegar de forma independiente, diferentes
servicios que trabajarán de forma totalmente independiente unos de
otros. Un servicio es, en sí, un servicio tal como una base de datos o
puede ser un objeto o grupo de objetos que ofrezca alguna
funcionalidad que se pueda separar claramente del resto de la
aplicación.

Dentro de este tipo de arquitectura, el núcleo de la aplicación puede
ser un simple API basado en REST, pero es mucho más común que sea un
sistema con mensajería centralizada, donde un sistema de paso de
mensajes recibe peticiones de servicio y las sirve a quienes lo han
hecho de forma asíncrona. En este sentido, si los servicios están
separados y consideramos que los mensajes son eventos, la arquitectura
sería similar a la basada en eventos anterior, salvo que esta
arquitectura suele estar más acoplada que la basada en eventos.

Como la anterior, tiene la ventaja de poder desplegarse de forma
independiente, poder escalar de forma independiente y, por tanto,
constituye uno de los patrones de arquitectura más populares hoy en
día.

### Arquitectura basada en *espacios*

Entre todas las arquitecturas vistas,
[esta](https://en.wikipedia.org/wiki/Space-based_architecture) es la
más antigua, usándose en arquitecturas distribuidas casi desde
principio de los 90, con lenguajes como Linda introduciendo el
concepto de
[espacio de tuplas](https://en.wikipedia.org/wiki/Tuple_space).

En esta arquitectura, un *espacio* es compartido por una serie de
unidades de procesamiento, que se comunican entre sí principalmente a
través de ese espacio. A diferencia de la arquitectura basada en
eventos, ese espacio está desestructurado, aunque internamente tiene
un espacio de mensajería tal como las arquitecturas mencionadas
anteriormente. Sin embargo, es un [patrón](https://es.slideshare.net/amin59/an-introduction-to-space-based-architecture) con una implementación
relativamente simple que puede servir para aplicaciones a pequeña
escala, aunque es más complicado de desarrollar que otros.

### Resumen

Todos los patrones anteriores se usan en la actualidad junto con el
patrón de aplicación cliente-servidor, que sigue perviviendo, pero que
causa todo tipo de problemas de escalado, sobre todo, aparte de la
dificultad de desarrollo si no se hace con cuidado.

Todas estas arquitecturas, además, asumen un entorno de integración y
despliegue continuo, que a su vez necesita una metodología de
desarrollo basada en tests, tal como la que se verá más adelante. 

Lo principal, en todo caso, es buscar la arquitectura más adecuada
para una aplicación en vez de aceptar como un hecho una arquitectura
cliente servidor o, peor, una arquitectura monolítica de un solo
fichero que tiene toda la funcionalidad de una aplicación. Una
aplicación casi siempre va a necesitar usar APIs de otras, siquiera
para la autenticación, y decenas o posiblemente cientos de servicios
diferentes. Cómo se lleva a la práctica esto y qué tipo de
implicaciones tiene en las herramientas las veremos a continuación.

<div class='ejercicios' markdown='1'>

Buscar una aplicación de ejemplo, preferiblemente propia, y deducir
qué patrón es el que usa. ¿Qué habría que hacer para evolucionar a un
patrón tipo microservicios?

</div>

## Desplegando en la nube: algunas consideraciones

Casi todas las arquitecturas mencionadas anteriormente tienen
características comunes. Primero, usan sistemas de mensajería, interna
o externamente. Segundo, usan algún tipo de API, generalmente basada
en REST. Tercero, están basadas en diferentes componentes. Y, por
último, usan y/o despliegan servicios en la nube. A su vez, esto
implica una serie de cosas que veremos a continuación.

### Descubrimiento de servicios

Una de las características que a veces no se consideran *a priori* de
estas arquitecturas es su naturaleza dinámica. El hecho de que se
añadan nuevos proveedores, procesadores o microservicios implica que
estos nuevos servicios tienen que conocer la configuración del resto
de la nube para coordinarse correctamente y también para que los
sistemas de escalado automático sepan con qué nodos cuentan para
ello. Estos sistemas de descubrimiento con, en una primera
aproximación, unos ficheros de configuración dinámicos y
distribuidos. 

En casi todos los casos en que se despliegue una arquitectura en la
nube se tendrá que hacer uso de este tipo de sistemas. Muchos
*orquestadores* como Kubernetes tienen los suyos propios, pero
familiarizarse con otros
como
[`etcd` o `consul`](https://www.consul.io/intro/vs/zookeeper.html)
puede ayudar a entender su funcionamiento y, sobre todo, a usarlo en
nuestras propias arquitecturas que no usen orquestadores. 

Hay
muchos
[patrones de uso de estos sistemas de descubrimiento de servicios](https://www.nginx.com/blog/service-discovery-in-a-microservices-architecture/),
pero en general se trata de tener, cuando se lanza un nuevo proveedor,
un URL que proporcione información y un cliente que sea capaz de
procesarla. 

### Almacenes de datos: más allá del SQL

Aunque las bases de datos tradicionales, relacionales y basadas en SQL
se adaptan perfectamente a la nube, necesitan que se conozca de
antemano la estructura de la información y sus relaciones, se adaptan
relativamente mal a trabajar con texto desestructurado, y a menos que
todos los datos almacenados tengan la misma estructura, se desperdicia
una cantidad considerable de espacio. Por eso en estas arquitecturas
modernas están complementadas por las bases de datos NoSQL, de las que
lo primero que hay que aprender es que no se trata de sistemas que
usen un lenguaje llamado [NoSQL](https://es.wikipedia.org/wiki/NoSQL) (aunque algunos lo están tratando de
diseñar) sino de base de datos muy diversas y que usan lenguajes
propios o empotrados para acceder a ellas. Hay diferentes tipos de
almacenes de datos: clave-valor, basadas en documentos, orientadas a
columna o a grafos. Una aplicación moderna usará una, o varias, desde
MongoDB hasta Redis pasando por Cassandra o Elastic.

En algunos casos también se pueden usar los sistemas de descubrimiento
mencionados anteriormente, que esencialmente son almacenes
clave-valor. 

### Lenguajes de programación: programación políglota

Nada fuerza a que todos los servicios o componentes tengan que usar el
mismo lenguaje. Los interfaces son genéricos, generalmente REST u otro
tipo de servicios web, pero si no lo son, hay herramientas como [Thrift](https://thrift.apache.org/)
que permiten definir de forma genérica APIs y compilarlas para un
lenguaje determinado. Casi todas las aplicaciones van a usar
JavaScript o alguna de sus variantes (CoffeeScript, TypeScript) en el
interfaz de usuario, pero además habrá componentes que sea mejor
escribir en Scala y otros que sea mejor escribir en Ruby o en
Perl. También los servicios de despliegue y de construcción tendrán su
propio lenguaje, Groovy (en Gradle) o Python. En general, trabajar con
un solo lenguaje limita mucho el tipo de aplicaciones que puedes
hacer, aunque si hay uno que pueda abarcarlo casi todo, ese es
JavaScript.

### De aquí a allí, todo son nubes.

La nube, que parece algo genérico y que a veces se abstrae simplemente
en máquinas virtuales que se pagan por uso, son un panorama mucho más
complejo, que va desde servicios de mensajería hasta contenedores,
pasando por todo tipo de servicios en la nube: almacenamiento, redes
virtuales, conversión de ficheros y todo tipo de cosas. Los tres
niveles clásicos de Infraestructura, Plataforma y Software como
servicio se combinan en una sola aplicación que puede usar una base de
datos (SaaS) o almacén de datos (almacenamiento como servicio) junto
con un sistema de mensajería almacenado en un PaaS y una serie de
procesadores almacenados en máquinas virtuales instanciadas en
diferentes proveedores. Por tanto, distinguir aplicaciones *para PaaS*
de aplicaciones *para IaaS* es totalmente absurdo y cualquier
arquitectura sana incluirá un poco de cada una, a gusto del
arquitecto.

### Los mensajeros están en las nubes

La mayoría de estos sistemas usan mensajería para comunicarse, o para
estar al corriente de eventos, o para gestionar toda la
arquitectura. Este tipo de
[colas de mensajes](https://en.wikipedia.org/wiki/Message_queue) son
quizás las que diferencian más a estas arquitecturas de las
monolíticas, que no las necesitan. Estos sistemas, también llamados
buzones, implementan unos sistemas de comunicación asíncrona y también
sistemas de publicación/suscripción, de forma que servicios pueden
decidir a qué mensajes contestan o de qué tipo de eventos van a
recibir comunicación. Las arquitecturas *serverless*, un tipo de
arquitectura basada en microservicios, tienen estos buzones en su
columna vertebral, usándose para transmitir de un servicio a otro los
datos y también para activar los microservicios cuando suceda un
evento determinado.

Hay una serie de estándares de mensajería, pero muchas de las
implementaciones existentes se acogen a varios para que sea más simple
la interoperabilidad. Y aparte de las [implementaciones libres](https://queues.io/) que uno
puede usar dentro de su arquitectura, los proveedores de cloud tienen
sus propias implementaciones tales como
[Amazon SQS](https://en.wikipedia.org/wiki/Amazon_Simple_Queue_Service)
o [Firebase de Google](https://firebase.google.com/docs/cloud-messaging/).

### Resumiendo: hay todo un mundo ahí fuera

Y es un mundo complejo, pero cuyo conocimiento os acercará mucho más a
la creación de aplicaciones sólidas, eficientes y escalables. Todo lo
de arriba se resume en que hay que continuar aprendiendo lenguajes,
tecnologías, metodologías y arquitecturas. Y no parar de hacerlo, para
la nube o para lo que venga más adelante.

<div class='ejercicios' markdown='1'>

En la aplicación que se ha usado como ejemplo en el ejercicio
anterior, ¿podría usar diferentes lenguajes? ¿Qué almacenes de datos
serían los más convenientes?

</div>


## Bibliografía y otros recursos

Algunos recursos a los que puedes acceder desde la
[Biblioteca de la UGR](https://biblioteca.ugr.es):

-
  [Pattern-oriented software architecture for dummies](https://bencore.ugr.es/iii/encore/record/C__Rb2243562__Ssoftware%20architecture%20patterns.__P1%2C29__Orightresult__X1?lang=spi&suite=pearl),
  aunque es muy básico, por lo menos explica en qué se pueden usar los
  patrones de software y cómo aplicarlos en un momento determinado. 
  
-
  [Practical software architecture](https://bencore.ugr.es/iii/encore/record/C__Rb2557607__Ssoftware%20architecture__Orightresult__U__X6?lang=spi&suite=pearl)
  Una visión más práctica de diferentes arquitecturas de software.

-
  [Building microservices](https://bencore.ugr.es/iii/encore/record/C__Rb2523920__Smicroservices__P0%2C3__Orightresult__U__X6?lang=spi&suite=pearl)
  un recurso electrónico que explica cómo construir microservicios
  desde cero, la fase de modelización a la de construcción del mismo.

## A dónde ir desde aquí

Este tema sirve como introducción para elegir el proyecto que se va a
desarrollar durante la asignatura. Habrá que realizar estos ejercicios
para superar el
[primer hito del proyecto](https://jj.github.io/CC/documentos/proyecto/1.Infraestructura). 

A continuación se
puede echar un vistazo a los
[*PaaS*, plataformas como servicio](PaaS), que pueden resultar útiles
en la misma. En este tema donde se explica cómo se
pueden desplegar aplicaciones para prototipo o para producción de
forma relativamente simple, o bien al tema dedicado a los
[*contenedores*](Contenedores), que es el siguiente en el temario
de la asignatura.
