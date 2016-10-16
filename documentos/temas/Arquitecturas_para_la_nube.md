Arquitecturas software para la nube
=========================

<!--@
next: Desarrollo basado en pruebas
-->

<div class="objetivos" markdown="1">

<h2>Objetivos </h2>

<h3>De la asignatura</h3>

<ul>
<li> Conocer los conceptos relacionados con el proceso de virtualización
tanto de software como de hardware y ponerlos en práctica.</li>
<li>Justificar la necesidad de procesamiento virtual frente a real en
el contexto de una infraestructura TIC de una organización.</li>
<li>Optimizar aplicaciones sobre plataformas virtuales.</li>
<li>Conocer diferentes tecnologías relacionadas con la virtualización (Computación Nube, Utility Computing, Software as a Service) e implementaciones tales como Google AppSpot, OpenShift o Heroku.</li>
</ul>

<h3>Específicos </h3>

<ol>
<li>Comprender los ecosistemas de despliegue de aplicaciones modernos
y su relación con la nube.</li>
<li> Entender las diferentes arquitecturas de software modernas y su
relación con <em>cloud computing</em>.</li>
<li> Aprender diseños que se puedan usar más adelante en aplicaciones
desplegables en la nube..</li>
</ol>

</div>

## Introducción

>Puedes echarle un vistazo a
>[esta colección de transpas](http://www.slideshare.net/jjmerelo/clipboards/my-clips)
>con información de un par de presentaciones sobre arquitectura
>moderna de aplicaciones. Aunque centrado en microservicios,
>[este conjunto de patrones](http://microservices.io/patterns/index.html)
>menciona también algunos de los que veremos aquí.

El panorama informático del siglo XXI está lleno de posibilidades:
múltiples lugares donde ejecutar una aplicación, múltiples servicios
que se pueden usar desde ella, todo conectado a través de Internet, y
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
>[Software Architecture Patterns, de Mark Richards](http://www.oreilly.com/programming/free/software-architecture-patterns.csp?intcmp=il-prog-free-article-sa15_sa_patterns),
>un *ebook* gratuito que te puedes descargar dando tu email.

En general, todas estas arquitecturas tienen en común que tratan de
buscar la consistencia en la velocidad de respuesta al usuario, que
usan recursos de diferentes empresas, propios y ajenos, y que se basan
en unas metodologías de desarrollo ágil e integración y despliegue
continuo. Veremos de qué arquitecturas se trata

### Arquitectura en capas

La
[arquitectura en capas](https://en.wikipedia.org/wiki/Multilayered_architecture)
o multilayer es el desarrollo natural de la arquitectura
cliente-servidor, creando 3 o más capas entre las que se suele incluir
la capa de presentación, la de aplicación, la de lógica de negocio y
la de acceso a datos. Muchos marcos de desarrollo modernos trabajan de
esta forma y son relativamente simples de desarrollar. El problema
principal es que sólo permiten escalado dentro de cada una de las
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

Argunos marcos de aplicaciones como Java Swing usan este tipo de
arquitectura.

### Arquitectura microkernel

Se trata de [una arquitectura](http://viralpatel.net/blogs/microkernel-architecture-pattern-apply-software-systems/) más o menos monolítica, con un núcleo
central al que se pueden añadir funcionalidades mediante plugins. Un
tipo de arquitectura clásico que se usa en CMSs como Joomla o en
sistemas de aprendizaje como Moodle. El problema principal es la
escalabilidad, ya que el núcleo puede representar un cuello de
botella. 

### Arquitectura basada en microservicios.

Una de las arquitecturas más populares hoy en día, los
[microservicios](http://microservices.io) se caracterizan por poder
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

### Arquitectura basada en espacio

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
anteriormente. Sin embargo, es un [patrón](http://es.slideshare.net/amin59/an-introduction-to-space-based-architecture) con una implementación
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



##Bibliografía y otros recursos

Algunos recursos a los que puedes acceder desde la
[Biblioteca de la UGR](http://biblioteca.ugr.es):

-
  [Pattern-oriented software architecture for dummies](http://bencore.ugr.es/iii/encore/record/C__Rb2243562__Ssoftware%20architecture%20patterns.__P1%2C29__Orightresult__X1?lang=spi&suite=pearl),
  aunque es muy básico, por lo menos explica en qué se pueden usar los
  patrones de software y cómo aplicarlos en un momento determinado. 
  

-
  [Practical software architecture](http://bencore.ugr.es/iii/encore/record/C__Rb2557607__Ssoftware%20architecture__Orightresult__U__X6?lang=spi&suite=pearl)
  Una visión más práctica de diferentes arquitecturas de software.

-
  [Building microservices](http://bencore.ugr.es/iii/encore/record/C__Rb2523920__Smicroservices__P0%2C3__Orightresult__U__X6?lang=spi&suite=pearl)
  un recurso electrónico que explica cómo construir microservicios
  desde cero, la fase de modelización a la de construcción del mismo.

## A dónde ir desde aquí

Este tema sirve como introducción para elegir el proyecto que se va a
desarrollar durante la asignatura. Habrá que realizar estos ejercicios
para superar el
[primer hito del proyecto](http://jj.github.io/CC/documentos/practicas/1.Infraestructura).

A continuación se
puede echar un vistazo a los
[*PaaS*, plataformas como servicio](PaaS), que pueden resultar útiles
en la misma. En este tema donde se explica cómo se
pueden desplegar aplicaciones para prototipo o para producción de
forma relativamente simple, o bien al tema dedicado a los
[*contenedores*](Contenedores), que es el siguiente en el temario
de la asignatura.
