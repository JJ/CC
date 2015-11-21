---
layout: index


prev: Desarrollo_basado_en_pruebas
next: Tecnicas_de_virtualizacion
---

Desplegando aplicaciones en la nube: Uso de PaaS
==

<!--@
prev: Desarrollo_basado_en_pruebas
next: Tecnicas_de_virtualizacion
-->

<div class="objetivos" markdown="1">

##Objetivos


### Cubre los siguientes objetivos de la asignatura

2. Conocer los conceptos relacionados con el proceso de virtualización
tanto de software como de hardware y ponerlos en práctica.

4. Justificar la necesidad de procesamiento virtual frente a real en
   el contexto de una infraestructura TIC de una organización.

### Objetivos específicos

5. Comprender los conceptos necesarios para trabajar con diferentes
   plataformas PaaS

6. Aplicar el concepto de *DevOps* a este tipo específico de plataforma.

7. Aplicar el sistema de control de fuentes `git` para despliegue de aplicaciones en la nube.

</div>


Cuando uno quiere parte del trabajo de instalación ya hecho, o al menos preparado
para hacer con la pulsación de un botón, a la vez que tiene
flexibilidad para trabajar con marcos de aplicaciones más allá de lo
que ofrece programar *plugins* (como en el SaaS), necesita un
[Platform as a Service o PaaS](http://en.wikipedia.org/wiki/Platform_as_a_service). Un
PaaS proporciona una pila que incluye, generalmente, almacenamiento de
datos, un marco concreto para trabajar (tal como Django o Ruby on
Rails) y, adicionalmente, un servidor web.

Esto conlleva una cierta falta de flexibilidad: se pueden usar las
pilas que proporciona en servicio y el usuario sólo puede subir su
aplicación que las use, no instalar elementos adicionales que necesiten permisos de
superusuario. Pero, por otro lado, ofrece la comodidad de tener que
concentrarse sólo en la aplicación en sí y no en la
infraestructura si se trata de una aplicación que use los marcos más
comunes. Es, por eso, menos *DevOps* que una solución *IaaS*,
pero por otro lado también tiene una parte que es la configuración y
despliegue de la aplicación en sí y los tests que se vayan a usar. Y
los PaaS de hoy en día admiten tantas opciones de configuración que,
salvo en casos muy específicos multi-máquina, pueden cubrir las
necesidades de una organización pequeña o mediana.

Usando un servicio PaaS
-----

La mayoría de los servicios PaaS están ligados a una *pila* de
soluciones determinada o a un vendedor determinado, es decir, a una
serie de aplicaciones que trabajan unas sobre otras cada una usando el
servicio de la anterior. Han surgido
muchos, por ejemplo, en torno a [node.js](http://nodejs.org), un
intérprete de JavaScript asíncrono que permite crear fácilmente
aplicaciones REST.

>Pila que se ha venido en llamar [MEAN](http://mean.io/#!/) y incluye
>también Mongo y Express.

Algunos servicios PaaS son específicos (sólo alojan una solución
determinada, como [CloudAnt](https://cloudant.com/) que aloja una base
de datos con CouchDB o genéricos), permitiendo una serie de soluciones
en general relativamente limitada; [Heroku](https://www.heroku.com) y
[OpenShift](https://www.openshift.com) están entre estos últimos, pero
también [hay otros](http://ocdevel.com/blog/nodejs-paas-comparison)
como [AppFog](https://www.appfog.com/product/) y otros muchos, depende
del tipo de pila que quieras alojar; los tres anteriores son los que
trabajan bien con
node.js,
[igual que nitrous.io](http://blog.blakepatches.me/blog/2013/11/04/comparison-of-node-dot-js-hosting/)
o
[IBM BlueMix](https://console.ng.bluemix.net/#/pricing/cloudOEPaneId=pricing).

>Después de probar casi todos los servicios anteriores, me da la
>impresión de que poco hay más allá de Heroku y Openshift. AppFog y
>Nodejitsu, después de la efervescencia inicial, dan 30 días de prueba
>solamente. Me falta por probar nitrous.io, pero del resto, al menos
>los que funcionan con node.js, poco más hay.  

[dotCloud (que ya no se puede usar de forma gratuita)](https://docs.dotcloud.com/services/perl/)
trabaja con Perl, por ejemplo, como
[Stackato y otras](http://showmetheco.de/articles/2011/8/three-perl-cloud-hosting-platforms.html).

<div class='ejercicios' markdown="1">

Darse de alta en algún servicio PaaS tal como Heroku,
[Nodejitsu](https://www.nodejitsu.com/), [BlueMix](https://console.ng.bluemix.net/) u OpenShift.

</div>

Estos servicios proveen un número limitado de máquinas virtuales y
siguen en general un modelo *freemium*: capacidades básicas son
gratuitas y para conseguir mayores prestaciones o un uso más
intensivo, o bien capacidades que no entren en el paquete básico, hay
que pasar al modelo de pago. Estas máquinas virtuales se denominan
[*dynos*](https://devcenter.heroku.com/articles/dynos) en Heroku y
simplemente aplicaciones en OpenShift, aunque los *dynos* son mucho
más flexibles que las aplicaciones de OpenShift. Generalmente, los
PaaS proporcionan un *toolbelt* o herramientas de línea de órdenes que
permiten controlarlos directamente desde nuestra aplicación; estos
conjuntos de herramientas acceden a un API que también podemos
manipular en caso necesario. Tanto desde estas herramientas como desde
el panel de control, los PaaS permiten *escalar* fácilmente una
aplicación, añadiéndole nuevos *nodos* sin necesidad de modificar la
aplicación. El propio *middleware* del PaaS se encarga de equilibrar
la carga

> Aunque
> [no necesariamente lo hace de la mejor forma](http://genius.com/James-somers-herokus-ugly-secret-annotated). Heroku
> cambió el enrutado de forma que ya no funciona tan bien como lo
> hacía 5 años atrás.

entre los diferentes nodos que uno tenga. La ventaja es que te ofrece
un PaaS es que, aunque evidentemente haya que pagar por lo que se
consume, sólo hay que hacerlo mientras se necesita; una vez pasado el
pico, se puede escalar *hacia abajo* eliminando los nodos que uno no
necesite; por supuesto, el propio PaaS suele proveer de herramientas
que hagan esto de forma más o menos automática.

La interacción con los PaaS se hace en general a través de una
herramienta de línea de órdenes que permite, para empezar, crear
fácilmente a partir de una plantilla una aplicación básica con las
características definidas; en ambos casos habrá que descargar una
aplicación libre para llevar a cabo ciertas tareas como monitorizar el
estatus y hacer tests básicos; una vez creado el fuente de la
aplicación el despliegue en la máquina virtual se hace mediante
`git` tal como hemos contado anteriormente.

Los lenguajes más habituales en las PaaS son los de scripting, que
permiten crear aplicaciones rápidamente; las bases de datos
disponibles son tanto las clásicas DBMS aunque, con más frecuencia, se
usan las bases de datos NoSQL como MongoDB, Redis o CouchDB.

En cualquier caso, los PaaS suelen tener un panel de control que
permite hacer ciertas cosas como configurar *plugins* o *add-ons*
desde la web fácilmente. Estos suelen seguir el mismo modelo *freemium*:
diferentes tamaños o instancias son gratuitas o tienen un coste; en
algunos casos cualquier instancia tiene un coste, y en algunas
plataformas, como Heroku, hay que introducir datos de facturación
(para cuando se excedan los límites gratuitos) en casi todos los
*add-ons*, lo que deja una cantidad limitada para uso de pruebas o
enseñanza.

<div class='ejercicios' markdown="1">

Crear una aplicación en OpenShift y dentro de ella instalar
WordPress.

</div>

>En todo caso, no está mal tener disponible una tarjeta de crédito,
>posiblemente virtual o de prepago, para trabajar con todo tipo de
>infraestructuras de nube en pruebas; puedes acceder a muchos más
>servicios y posibilidades y, aunque se excedan los límites gratuitos,
>el coste no suele ser grande.

Los PaaS no dejan acceso completo a la máquina virtual que ejecuta
nuestra aplicación y, en muchos casos, tienen también otras
limitaciones. Por ejemplo, no dejan conectar por `ssh` o no tienen un
sistema de ficheros permanente, de forma que hay que usar de forma
forzosa un almacenamiento de datos que sea un *add-on* o bien otro
externo que se ofrezca de forma independiente (pero siguiendo el mismo
modelo). También hay que tener en cuenta que las prestaciones que
vamos a poder obtener de los *tier* gratuitos no van a ser como para
poder montar una *startup* y forrarnos: son muy limitadas, tanto en
latencia como en CPU como en memoria.

En general, el enfoque para este tipo de herramientas (y para casi
todo el desarrollo web moderno) es trabajar con servidores REST que
envíen al cliente algún tipo de información de la que este estará
encargado y plasmará. También eso facilita el desarrollo de cualquier
tipo de cliente, móvil, navegador o incluso middleware, que puede
estar incluido en la misma aplicación. Por eso haremos un pequeño
recorrido por el concepto de servicios REST, basados en los verbos del
protocolo HTTP.

<div class='nota' markdown='1'>

Este
[vídeo explica como usar `heroku` para aplicaciones en Ruby](http://www.youtube.com/watch?v=dqAXmratgzE);
en
[este un poco más extenso y hecho por una persona de Heroku](http://www.youtube.com/watch?v=VZgHItD9bAQ)
te explica cómo usarlo. No hay muchos vídeos en español, pero en
[este explica cómo crear una aplicación Django y subirla a Heroku](http://www.youtube.com/watch?v=3k2eg0stnCI)
y
[este es una introducción general con ejemplos de Ruby](https://www.youtube.com/watch?v=ii9G9JMvoXM)

</div>

## Creando una aplicación para su despliegue en un PaaS

Para diseñar interfaces REST de forma bastante simple, hay un [módulo de
node.js llamado express](http://expressjs.com/). La idea de este módulo
es reflejar en el código, de la forma más natural posible, el diseño del
interfaz REST.

Pero primero hay que instalarlo. Node.js tiene un sistema de gestión de
módulos bastante simple llamado [npm](https://npmjs.org/) que ya hemos usado. Tras seguir las instrucciones en el
sitio para instalarlo (o, en el caso de Ubuntu, instalarlo desde
Synaptic o con `apt-get`), vamos al directorio en el que vayamos a crear
el programa y escribimos

`npm install express --save`

en general, no hace falta tener permiso de administrador, sólo el
necesario para crear, leer y ejecutar ficheros en el directorio en el
que se esté trabajando. `--save` guarda la dependencia en `package.json` siempre que esté en el mismo directorio, que convendría que estuviera, así no tenemos que recordar qué es lo que está instalado.

Tras la instalación, el programa que hemos visto más arriba se
transforma en el siguiente:

	#!/usr/bin/env node

	var express=require('express');
	var app = express();
	var port = process.env.PORT || 8080;

	app.get('/', function (req, res) {
		res.send( { Portada: true } );
	});

	app.get('/proc', function (req, res) {
		res.send( { Portada: false} );
	});  

	app.listen(port);
	console.log('Server running at http://127.0.0.1:'+port+'/');


Para empezar, `express` nos evita todas las molestias de tener que
procesar nosotros la línea de órdenes: directamente escribimos una
función para cada respuesta que queramos tener, lo que facilita mucho la
programación. Las órdenes reflejan directamente las órdenes de
HTTP a las que queremos responder, en este caso `get` y por
otro lado se pone directamente la función para cada una de ellas. Dentro
de cada función de respuesta podemos procesar las órdenes que queramos.

Por otro lado, se usa `send`  para enviar el resultado,
[una orden más flexible](http://expressjs.com/api.html#res.send)
que admite todo
tipo de datos que son procesados para enviar al cliente la respuesta
correcta. Tampoco hace falta establecer explícitamente el tipo MIME que
se devuelve, encargándose `send` del mismo.

En los dos casos, las peticiones devuelven JSON. Una aplicación de
este tipo puede devolver cualquier cosa, HTML o texto, pero conviene
acostumbrarse a pensar en estas aplicaciones como servidores a los
cuales se va a acceder desde un cliente, sea un programa que use un
cliente REST o sea desde el navegador usando jQuery o JavaScript.

>Realizar una aplicación básica que use `express` para devolver alguna
>estructura de datos del modelo que se viene usando en el curso.

Con el mismo `express` se pueden generar aplicaciones no tan básicas
instalando [`express-generator`](http://expressjs.com/es/starter/generator.html) o el generador de aplicaciones [`yeoman`](http://yeoman.io)

    express prueba-rest

Se indica el camino completo a la aplicación, que sería el
puesto. Con esto se genera un directorio prueba-rest. Cambiándoos al
mismo y escribiendo simplemente `npm install` se instalarán las
dependencias necesarias. La aplicación estará en el fichero `index.js`,
lista para funcionar, pero evidentemente habrá que adaptarla a nuestras
necesidades particulares.

El acceso a los parámetros de la llamada y la realización de diferentes
actividades según el mismo se denomina enrutado. En express se pueden
definir los parámetros de forma bastante simple, usando marcadores
precedidos por `:`. Por ejemplo, si queremos tener diferentes contadores
podríamos usar el [programa
siguiente](https://github.com/JJ/node-app-cc/blob/master/index.js):

	var express = require('express');
	var app = express();

	// recuerda ejecutar antes grunt creadb
	var db_file = "porrio.db.sqlite3";
	var apuesta = require("./Apuesta.js");
	var porra = require("./Porra.js");

	var porras = new Array;

	app.set('port', (process.env.PORT || 5000));
	app.use(express.static(__dirname + '/public'));

	app.put('/porra/:local/:visitante/:competition/:year', function( req, response ) {
		var nueva_porra = new porra.Porra(req.params.local,req.params.visitante,
						  req.params.competition, req.params.year );
		porras.push(nueva_porra);
		response.send(nueva_porra);
	});

	app.get('/porras', function(request, response) {
		response.send( porras );
	});

	app.listen(app.get('port'), function() {
	  console.log("Node app is running at localhost:" + app.get('port'));
	});


Este [programa
(express-count.js)](https://github.com/JJ/node-app-cc/blob/master/index.js)
introduce otras dos órdenes REST: PUT, que, como recordamos, sirve para
crear nuevos recurso y es idempotente (se puede usar varias veces con el
mismo resultado) y además GET. Esa orden la vamos a usar para crear
contadores a los que posteriormente accederemos con `get`. PUT no es una
orden a la que se pueda acceder desde el navegador, así que para usarla
necesitaremos hacer algo así desde la línea de órdenes:
`curl -X PUT http://127.0.0.1:8080/porra/local/visitante/Copa/2013` para lo que
previamente habrá que haber instalado `curl`, claro. Esta orden llama a
PUT sobre el programa, y crea un partido con esas características. Una
vez creado, podemos acceder a él desde la línea de órdenes o desde el
navegador; la dirección `http://127.0.0.1:8080/porras` nos devolverá
en formato JSON todo lo que hayamos almacenado hasta el momento.

Todas las órdenes definen una *ruta*, que es como se denominan cada
una de las funciones del API REST. Las
[rutas](https://www.packtpub.com/books/content/understanding-express-routes)
pueden ser simples cadenas (como `/porras` en el caso de `get`) o
incluir parámetros, como en el caso de `put`:
`/porra/:local/:visitante/:competition/:year` incluye una orden al
principio y cuatro parámetros. Estos parámetros se recuperan dentro de
la función *callback* como atributos de la variable `req.params`,
tales como `req.params.local` en las siguientes líneas.

> Realizar u na app en express que incluya variables como en el caso
> anterior.

## Probando nuestra aplicación en la nube

Porque esté en la nube no significa que no tengamos que testearla como cualquier hija de vecina. En este caso no vamos a usar tests unitarios, sino test funcionales (o como se llamen); de lo que se trata es que tenemos que levantar la web y que vaya todo medianamente bien.

Los tests podemos integrarlos, como es natural, en el mismo marco que el resto de la aplicación, sólo que tendremos que usar librerías de aserciones ligeramente diferentes, en este caso `supertest`

	var request = require('supertest'),
	app = require('../index.js');

	describe( "PUT porra", function() {
		it('should create', function (done) {
		request(app)
			.put('/porra/uno/dos/tres/4')
			.expect('Content-Type', /json/)
			.expect(200,done);
		});
	});

(que tendrá que estar incluido en el directorio `test/`, como el resto). En vez de ejecutar la aplicación (que también podríamos hacerlo), lo que hacemos es que añadimos al final de `index.js` la línea:

	module.exports = app;

con lo que se exporta la app que se crea; `require` ejecuta el código y recibe la variable que hemos exportado, que podemos usar como si se tratara de parte de esta misma aplicación. `app` en este test, por tanto, contendrá lo mismo que en la aplicación principal, `index.js`. Usamos el mismo estilo de test con `mocha` que [ya se ha visto](http://jj.github.io/desarrollo-basado-pruebas) pero usamos funciones específicas:

* `request` hace una llamada sobre `app` como si la hiciéramos *desde fuera*; `put`, por tanto, llamará a la ruta correspondiente, que crea un partido sobre el que apostar.
* `expect` expresa qué se puede esperar de la respuesta. Por ejemplo, se puede esperar que sea de tipo JSON (porque es lo que enviamos, un JSON del partido añadido) y además que sea de tipo '200', respuesta correcta. Y como esta es la última de la cadena, llamamos a `done` que es en realidad una función que usa como parámetro el callback.

Podemos hacer más pruebas, usando get, por ejemplo. Pero se deja como ejercicio al alumno.

Estas pruebas permiten que no nos encontremos con sorpresas una vez que despeguemos en el PaaS. Así sabemos que, al menos, todas las rutas que hemos creado funcionan correctamente.

<div class='ejercicios' markdown="1">

 Crear pruebas para las diferentes rutas de la aplicación.

</div>

## Desplegando en el PaaS

Podemos, por ejemplo, desplegarlo en Heroku.

> Sitios como Openshift o Nodester tienen sistemas también similares,
> pero por lo pronto vamos a usar este, que tiene un sistema un poco
> más abierto y completo.

Tras abrir una cuenta en Heroku, crear una
[aplicación en Node](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction)
es bastante directo. Primero, hay que tener en cuenta que en el PaaS,
como debería de ser obvio, se trata de aplicaciones web. Por eso la
aplicación más simple que se propone usa ya `express` (o, para el
caso, cualquier otro marco de servicios REST).

1. Descarga
   [el *cinturón de herramientas* de Heroku](https://devcenter.heroku.com/articles/getting-started-with-nodejs#set-up)
2. Haz *login* con `heroku login`.
3. Descarga
   [la aplicación de ejemplo para node](https://github.com/heroku/node-js-getting-started.git). Es
   una aplicación simple de node y express. Heroku tiene una serie de
   ejemplos para diferentes lenguajes de programación. Por ejemplo,
   [para PHP](https://devcenter.heroku.com/articles/getting-started-with-php#prepare-the-app). Heroku
   admite [7 lenguajes, Scala, Clojure, Java, Ruby y Python](https://devcenter.heroku.com/start)
4. Con `heroku create` (dentro del directorio descargado) se crea la
   aplicación en heroku. Previamente lo único que había era un repo,
   con esta orden se crea una aplicación en heroku y se conecta con el
   repositorio descargado; esencialmente lo que se hace es que se
   añade un destino, `heroku` al que podemos hacer push. Con esto se
   crea una app de nombre aleatorio, que luego podremos modificar.
Puedes darle también un nombre a la aplicación y asignarle un servidor
   en Europa (legalmente obligatorio) escribiendo `heroku apps:create
   --region eu nombre_muy_chulo` Si te asignan un nombre puedes
   cambiarlo también más adelante, en la web y en el repo.

Esto crea una aplicación en la web de Heroku, que al hacer `git push
heroku master` se pondrá en marcha. La mayoría de los PaaS usa `git
push` como modo de despliegue, que permite tener controlada la versión
de todos los ficheros que hay en el mismo y además, con los *ganchos*
post-`push`, [compilar y ejecutar la aplicación a través de los llamados
*Buildpacks*](http://www.jamesward.com/2012/07/18/the-magic-behind-herokus-git-push-deployment).  

<div class='ejercicios' markdown="1">

 Instalar y echar a andar tu primera aplicación en Heroku.

</div>

Sólo hemos, por lo pronto, desplegado la aplicación por omisión.

>Y en esta aplicación por omisión se ha usado también el *buildpack*,
>es decir, el proceso y herramientas de construcción, que esté programado para tu pila, el de
>Node o el que sea. Pero si eres un poco atrevido, puedes
>[crear tu propio Buildpack](https://devcenter.heroku.com/articles/buildpack-api),
>que puede estar escrito en cualquier lenguaje y consiste en realidad
>en tres scripts.

Se
habrá generado un fichero denominado `index.js` que será,
efectivamente, el que se ejecute. Pero ¿cómo sabe Heroku qué es lo que
hay que ejecutar? Si miramos el fichero `Procfile` encontraremos algo
así

	web: node index.js

Este [Procfile](https://devcenter.heroku.com/articles/procfile) se usa
para indicar a heroku qué es lo que tiene que ejecutar. En casi todos
los casos se tratará de una aplicación web, y por tanto la parte
izquierda, `web:` será común. Dependiendo del lenguaje, variará la
parte derecha; en este caso le estamos indicando la línea de órdenes
que hay que ejecutar para *levantar* la web que hemos creado.

Localmente, se recrea (aproximadamente) el entorno de Heroku usando
Foreman. Para ejecutar localmente nuestra aplicación ejecutaremos

	foreman start web

`foreman` leerá el `Procfile` y ejecutará la
tarea correspondiente a `web`, en este caso `index.js`.  Podemos
interrumpirlo simplemente tecleando Ctrl-C.

[`foreman`](http://blog.daviddollar.org/2011/05/06/introducing-foreman.html)
actúa como un envoltorio de tu aplicación, ejecutando todo lo
necesario para que funcione (no sólo la web, sino bases de datos o
cualquier otra cosa que haya que levantar antes) codificando por
colores la salida correspondiente a cada proceso y presentando también
el registro o *log* de la misma de forma más amigable.

<div class='ejercicios' markdown="1">

Usar como base la aplicación de ejemplo de heroku y combinarla con la
aplicación en node que se ha creado anteriormente. Probarla de forma
local con `foreman`. Al final de cada modificación, los tests tendrán
que funcionar correctamente; cuando se pasen los tests, se puede
volver a desplegar en heroku.

>Como en todos los ejemplos anteriores, se puede cambiar "node" y
>"heroku" por la herramienta que se haya elegido.
</div>

Si está `package.json` bien configurado, por ejemplo, de esta forma

    "scripts": {
	  "test": "mocha",
	  "start": "node index.js"
	},


se puede arrancar también la aplicación, sin ningún tipo de
envoltorio, simplemente con `npm start`, que ejecutará lo que hay a su
izquierda. La clave `scripts` de `package.json` contiene una serie de
tareas o procesos que se pueden comenzar; en ese sentido, la
funcionalidad se solapa con el `Gruntfile` que se ha visto
anteriormente.

>Siempre hay más de una manera de hacer las cosas.

Ahora hay que gestionar los dos repositorios de `git` que
tenemos. `heroku create` (en cualquiera de sus formas) crea un destino
`heroku` dentro de la configuración de `git` de forma que se pueda
hacer `git push heroku master`; `heroku` aquí no es más que un alias a
la dirección de tu aplicación, que si miras en `.git/config` estará
definido de una forma similar a la siguiente

    [remote "heroku"]
	   url = git@heroku.com:porrio.git
	   fetch = +refs/heads/*:refs/remotes/heroku/*

Es el mismo resultado que si hubiéramos dado la orden

    git remote add heroku git@heroku.com:porrio.git

es decir, crear un alias para la dirección real del repositorio en
Heroku (que puedes consultar desde tu panel de control; será algo
diferente a lo que hay aquí e igual que el `nombre_muy_chulo` que
hayas decidido darle. Si vas a subir a Heroku una aplicación ya
creada, tendrás que añadir esta orden. Si te has descargado el ejemplo
de GitHub y seguido las instrucciones anteriores, tendrás que crear un
repositorio vacío propio en GitHub y añadirle este como `origin` de la
forma siguiente

	# Borra el origen inicial, que será el de la aplicación de ejemplo
	git remote rm origin
	# Crea el nuevo origin
	git remote add origin git@github.com:mi-nick/mi-app.git

Todo esto puedes ahorrártelo si desde el principio haces un *fork* de
la aplicación de node y trabajas con ese *fork*; el origen estará ya
definido.

Ahora tienes dos repositorios: el que está efectivamente desplegado y
el que contiene los fuentes. ¿No sería una buena idea que se trabajara
con uno sólo? Efectivamente, [GitHub permite desplegar directamente a
Heroku cuando se hace un `push` a la rama `master`](http://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository),
aunque no es inmediato, sino que pasa por usar un servicio de
integración continua, que se asegure de que todo funciona
correctamente.

Para eso, evidentemente, el sitio en el que se despliegue debe estar
preparado. No es el caso de Heroku.

>Heroku tiene, sin embargo,
>[una beta reciente en GitHub y posiblemente funcione en el futuro próximo](https://github.com/github/github-services/tree/master/docs), que necesita un servicio
>intermedio para llevarlo a cabo, aunque
>[se puede probar ahora mismo en beta](https://devcenter.heroku.com/articles/github-integration)

Otros sistemas, como
[ AWS CodeDeploy de Amazon pueden desplegar a una instancia en la nube de esta empresa](https://medium.com/aws-activate-startup-blog/simplify-code-deployments-with-aws-codedeploy-e95599091304). Sin
embargo,
[no es complicado configurar un servicio de integración continua como Snap CI](http://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository). Después
de [darte de alta en el Snap CI](https://snap-ci.com/), la
configuración se hace desde un panel de control y, si ya lo tienes
configurado para Travis (como deberías) el propio sitio detecta la
configuración automáticamente.

Para añadir el paso de despliegue a Heroku hay que hacer un paso
adicional: en el menú de Configuración se puede añadir un paso
adicional tras el de Test, en el que no hay que más que decirle el
repositorio de Heroku al que se va a desplegar.

![Panel de control de Snap CI con despliegue a Heroku](img/despliegue-snap-ci.png)

Con esto, un simple push a una rama determinada, que sería la
`master`, se hará que se pruebe y, en caso de pasar los tests, se
despliegue automáticamente en Heroku.


<div class='ejercicios' markdown="1">
 Haz alguna modificación a tu aplicación en node.js para Heroku, sin
 olvidar añadir los tests para la nueva funcionalidad, y configura el
 despliegue automático a Heroku usando Snap CI o
 [alguno de los otros servicios, como Codeship, mencionados en StackOverflow](http://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository)
 </div>

En principio se ha preparado [a la aplicación](https://github.com/JJ/node-app-cc/blob/master/index.js) para su despliegue en un solo PaaS, Heroku. Pero, ¿se podría desplegar en otro PaaS también?

Hay que dar un paso atrás y ver qué es necesario para desplegar en Heroku, aparte de lo obvio, tener una cuenta. Hacen falta varias cosas:

1. Un `packaje.json`, aunque en realidad esto no es específico de Heroku sino de cualquier aplicación y cualquier despliegue.
2. El fichero `Procfile` con el trabaja Foreman y que distribuye las tareas entre los diferentes *dynos*: `web`, `worker` y los demás.
3. Requisitos específicos de IP y puerto al que escuchar y que se pasan a `app.listen`. Estos parámetros se definen como variables de entorno.

Teniendo en cuenta esto, no es difícil cambiar la aplicación para que pueda funcionar correctamente al menos en esos dos PaaS, que son los más populares. En Openshift, en realidad, no hace falta `Procfile`. Como no tiene el concepto de diferentes tipos de dynos, usa directamente `package.json` para iniciar la aplicación. Por otro lado, los requisitos específicos de puerto e IP se tienen en cuenta en estas dos órdenes:

	var server_ip_address = process.env.OPENSHIFT_NODEJS_IP
	                          || '0.0.0.0';
	app.set('port', (process.env.PORT
	                 || process.env.OPENSHIFT_NODEJS_PORT
					 || 5000));

En la primera se establece la IP en la que tiene que escuchar la aplicación. En el caso por omisión, el segundo, la dirección `0.0.0.0` indica que Express escuchará en todas las IPs. Sin embargo, eso no es correcto ni posible en OpenShift, que tiene una IP específica, contenida en la variable de entorno `OPENSHIFT_NODEJS_IP` y que será una IP de tipo local (aunque realmente esto no tiene que importarnos salvo por el caso de que no podremos acceder a esa IP directamente).

En cuanto al puerto, en los dos casos hay variables de entorno para definirlo. Simplemente las vamos comprobando con \|\| (OR) y si no está establecida ninguna, se asigna el valor por defecto, que también sirve para la ejecución local.

<div class='ejercicios' markdown="1">
 Preparar la aplicación con la que se ha
 venido trabajando hasta este momento para ejecutarse en un PaaS, el
 que se haya elegido.
</div>

También en OpenShift se puede desplegar automáticamente usando Travis,
por ejemplo. De hecho, incluso en Heroku se puede trabajar también con
Travis para el despliegue automático, aunque es mucho más simple
hacerlo con Snap CI como se ha indicado más arriba.


## Bases de datos como servicio y su uso en PaaS

Como las bases de datos son, en realidad, una aplicación como otra
cualquiera,
[las bases de datos como servicio, bases de datos en la nube o *DBaaS*](http://en.wikipedia.org/wiki/Cloud_database)
encajan mejor dentro de este texto que de ningún otro sitio, aunque en
realidad no son una solución completa, sino que se tienen que combinar
con un PaaS o un IaaS para crear una aplicación. Sin embargo, es
conveniente tener conocimiento de ellas, puesto que los PaaS que se
han visto las usan. Por eso conviene conocerlas: permite que se tenga
un backend totalmente independiente del despliegue que se vaya a
hacer, sea en un sevidor propio, IaaS o un PaaS; permiten también
prototipado rápido de una aplicación, al permitir usar una base de
datos externa para integración continua y pruebas y, finalmente, en
caso de despliegue final de la aplicación, permiten pagar sólo por lo
que se usa, sin tener ningún tipo de infraestructura permanente.

Los DBaaS ofrecen acceso tanto bases de datos clásicas, es decir, con
el lenguaje SQL, como a bases de datos *sin esquemas* o NoSQL como
Redis, CouchDB, Riak o MongoDB. También hay modelos *freemium* o gratuitos
con tarjeta de crédito, tales como
[Amazon DynamoDB](http://aws.amazon.com/es/dynamodb/?nc2=h_l3_db) o
[ClearDB, que provee servicio MySQL](https://www.cleardb.com/pricing.view). La
mayoría de los PaaS, por otro lado, ofrecen también DBaaS como
añadidos a sus plataformas; es decir, tarde o temprano se acabarán
usando.



## Un ejemplo de base de datos NoSQL: Redis

Vamos a aprovechar que estamos hablando de nuevas bases de datos para
trabajar con [Redis](http://redis.io). Redis es una base de datos no
persistente, en memoria, de altas prestaciones, y que permite trabajar
de forma muy eficiente con estructuras de datos simples. Otros
sistemas noSQL como CouchDB o MongoDB también son bastante populares,
pero Redis se está convirtiendo en uno de los estándares emergentes y
tiene buen soporte en JavaScript, tanto en cliente como en node.

En vez de ir
[característica por característica u orden por orden (que, además, son un montón)](http://redis.io/commands),
vamos a empezar
trabajando con un sistema cliente-servidor para hacer porras
futbolísticas con el que seguiremos trabajando más adelante. Pero
antes, una aproximación básica a Redis en [el siguiente programa](https://github.com/JJ/node-app-cc/blob/master/redis.js), que
prueba las principales características trabajando con pares
variable-valor y *hashes*:


	var redis = require('redis');
	var url = require('url');

	var redisURL = url.parse(process.env.REDISCLOUD_URL);
	console.log(redisURL);
	var client = redis.createClient(redisURL.port, redisURL.hostname, {no_ready_check: true, auth_pass: redisURL.auth.split(":")[1]});

	client.set("zape", "zipi", redis.print );
	client.get("zape", function (err, reply) {
		console.log( 'Get ' );
		if ( err ) {
		console.log( err );
		} else {
		console.log(reply.toString());
		}
	});
	client.hset("un_foo", "bar", "baz", redis.print);
	client.hset("un_foo", "quux", "zuuz", redis.print);
	client.hkeys("un_foo", function (err, replies) {
		console.log( 'hkeys');
		replies.forEach(function (reply, i) {
			console.log("    " + i + ": " + reply);
		});
		console.log( "End " );
		client.end();
	});


El programa tiene tres partes. En la primera se conecta al DBaaS que
previamente hemos tenido que crear en RedisLabs o, para el caso, en
nuestro propio ordenador. Las credenciales para acceder al sitio están
metidas en una variable de entorno, REDISCLOUD_URL. El URL de esa variable te la
habrán asignado en redislabs cuando hayas creado un recurso gratuito,
y será por el estilo de
`pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345`, pero
tendrás que combinarla con la clave para acceder a la base de datos de
esta forma:

	export REDISCLOUD_URL=http://daigual:esta_es_la_clave@cosas.garantiadata.com:12345

; lo que tendrás que escribir en la línea de órdenes y nunca, nunca,
dejar en el sistema de control de fuentes.
Es un URL un tanto complejo, pero la parte principal es la que hay
detrás del `//`, de la forma `usuario:clave@dominio:puerto`. Es imprescindible
autenticarse, para que sólo uno pueda usar el recurso. En realidad, el
usuario no se usa, por eso pone `daigual`, sin embargo la clave es la
que estableceremos para el recurso cuando nos demos de alta; por
defecto, es la misma que se usa para la cuenta general, aunque puedes
establecer claves específicas para cada uno de los depósitos de
datos. Previamente a esto habrá que haber creado una *suscripción* de
Redis en "My Resources -> Manage"; hay derecho al menos a uno gratuito
por persona aunque sólo te permiten
[25 MB y 10 conexiones simultáneas](https://redislabs.com/pricing).

>Redis, de todas formas, es software libre y puedes instalarlo sin
>ninguna limitación en tu propio alojamiento si lo tienes; también en tu
>infraestructura en la nube.

La siguiente parte del programa es la que establece un par
variable-valor: `zipi - zape`, es decir, que asociamos a la clave
`zipi` el valor `zape`; a continuación lo recuperamos usando la forma
asíncrona habitual de node: se solicita el valor y se le pasa una
función *callback* a la que se llame cuando se haya recibido la
respuesta.

>En realidad y teniendo en cuenta que es asíncrono, no podemos
>recuperar el valor hasta que hayamos recibido el callback; es un
>error poner las órdenes de esta forma porque puede suceder que cuando
>se trate de recuperar el valor todavía no se haya establecido en el
>servidor. En este caso, sin embargo, funciona por la rapidez de
>Redis, aunque no tiene por qué funcionar en todos los casos.

El tercer bloque trabaja con un [HSET](http://redis.io/commands/HSET),
un conjunto de pares clave-valor indexados, a su vez, con una sola
clave. Redis tiene varios tipos de datos y tratándose de una base de
datos NoSQL,
[sus propios comandos para acceder a los mismos](http://openmymind.net/2011/11/8/Redis-Zero-To-Master-In-30-Minutes-Part-1/). Usamos
dos sentencias con la misma clave, `un_foo`, que será la clave del
HSET, y le asignamos dos pares variable-valor. Es una estructura de
datos un poco más compleja, que nos puede servir para almacenar las
porras más adelante. Como en el caso anterior, convendría haberlo
hecho esto de forma asíncrona, pero también, y en general (y en
Redis), también funciona de esta forma.

> Redis también permite trabajar con conjuntos usando la orden
> [SADD](http://redis.io/commands/sadd). Se trataría de varias
> variables asignadas a un solo valor (el nombre del conjunto). Crear
> un programa que cree un conjunto, el de todas las porras existentes,
> por ejemplo.

Es importante también que el cliente de Redis se cierre, como se hace
en la penúltima línea con `client.end();`. Si no, el programa queda en espera. Esa orden,
efectivamente, termina el programa (aparte del cliente de
Redis). Cualquier programa en Redis tiene que terminar de esa forma.

<div class='ejercicios' markdown="1">
1.  Instalar o darse de alta en un servicio Redis en la nube y
realizar sobre él las operaciones básicas desde el panel de control.

2. Instalar un cliente de línea de órdenes de Redis o un cliente REST
y realizar desde él las operaciones básicas de creación y lectura de
información.

3. Ejecutar ejemplos de cualquier lenguaje de programación sobre la
instalación realizada.
</div>

## Poniendo en práctica Redis en porr.io

El problema principal con Redis es rediseñar la aplicación desde
nuestra mente base-de-datos-relacional para aprovechar sus
fortalezas. Redis almacena estructuras de datos sólo indexadas por
clave. Se puede acceder a todas las claves o hacer búsquedas con
patrones. Con los resultados del ejemplo anterior se puede instalar el
cliente de redis (`sudo apt-get redis-cli`) y acceder de esta forma

```
redis-cli -h pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com -p
12345 -a esta-es-la-clave
```

es decir, usando el URL anterior (que se pasa con la opción `-h` a la
línea de órdenes) y la clave que hayamos establecido (con `-a`) y
podemos hacer consultas usando las órdenes de Redis, por ejemplo:

	pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345> keys *
	1) "Granada-C\xc3\xb3rdoba-Liga-2018"
	2) "zape"
	3) "un_foo"
	...

Aunque las claves estén almacenadas al alimón, en realidad las órdenes
que se pueden aplicar sobre ellas son diferentes: `zape` tenía
asignada una cadena, y `un_foo` un hash. Eso lo averiguamos con `type`

	Pub-Redis-12345.Us-east-1-2.3.ec2.garantiadata.com:12345> type "zape"
	string
	pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345> type "un_foo"
	hash


Con esto, la estrategia de usar tablas para cosas se va un poco por
ahí. Tenemos que pensar en almacenar claves, con un criterio.
razonable, y poder recuperarlas en función del contenido de
claves. Afortunadamente, Redis es muy rápido y el hecho de que no se
puedan hacer merges realmente no importa demasiado. Es más, la
complejidad de las peticiones y el tiempo que tardan no depende del
número de claves que haya.

Como buena práctica lo que se suele hacer es usar *prefijos* separados
por `:` para distribuir las claves en diferentes "espacios de
nombres". Por ejemplo, podíamos meter todas claves referidas a porras
en el espacio `porra:` y podríamos buscarlas usando `keys
"porra:*"`. Algo así hacemos en el siguiente programa:

	var redis = require('redis');
	var url = require('url');

	var apuesta = require("./Apuesta.js"),
	porra = require("./Porra.js");

	var redisURL = url.parse(process.env.REDISCLOUD_URL);
	var client = redis.createClient(redisURL.port, redisURL.hostname, {no_ready_check: true, auth_pass: redisURL.auth.split(":")[1]});

	var esta_porra = new porra.Porra("FLA", "FLU", "Premier", 1950+Math.floor(Math.random()*70) );
	console.log(esta_porra);
	for ( var i in esta_porra.vars() ) {
		client.hset(esta_porra.ID, "var:"+esta_porra.vars()[i], esta_porra[i], redis.print);
	}

	var bettors = ['UNO', 'OTRO','OTROMAS'];

	for ( var i in bettors ) {
		var esta_apuesta = new apuesta.Apuesta(esta_porra, bettors[i], Math.floor(Math.random()*5), Math.floor(Math.random()*4) );
		client.hset(esta_porra.ID, "bet:"+esta_apuesta.quien, esta_apuesta.resultado());
		client.sadd(esta_porra.ID+":"+esta_apuesta.resultado(), esta_apuesta.quien,redis.print );

	}

	client.hkeys(esta_porra.ID, function (err, replies) {
		console.log( 'hkeys');
		replies.forEach(function (reply, i) {
			console.log("    " + i + ": " + reply);
		});
		console.log( "End " );
		client.end();
	});



El
[programa, denominado obviamente `porredis.js`](https://github.com/JJ/node-app-cc/)
también se divide en varias partes. La primera parte es la conexión a
la base de datos, que es exactamente igual que en el programa
anterior. A continuación se crea una porra con elementos aleatorios
(el año) para que se cree ligeramente diferente en cada ejecución.

> Si tenéis curiosidad de qué se trata esta porra, es del célebre
> [derby entre el Fluminense y el Flamingo](http://es.wikipedia.org/wiki/Fla-Flu),
> tradicionales rivales del estado de Río de Janeiro.

Vamos a usar un HSET para almacenar cada porra, y usamos un campo con
el prefijo `var` para cada una de las variables de la porra; como
clave usamos la propia clave de la porra. Esta clave la vamos a usar
para almacenar todo y además tiene elementos para acceder rápidamente
a todas las porras de un año o de un equipo.

Las apuestas de la porra, con tres apostadores, las generamos
aleatoriamente también en el siguiente bloque. Almacenamos las
apuestas en dos sitios. En una BD relacional esto sería anatema, pero
aquí no es un gran problema: Redis es suficientemente rápido, y se
trata de que podamos acceder rápidamente a la información. Vamos a
usar el mismo hash para almacenar los nombres de los apostantes, y
conjuntos para almacenar todos los que han apostado por un resultado
determinado. De esa forma, a partir del ID de una porra y del
resultado podemos acceder, en una sola petición, a los ganadores de la
misma, si es que los hay. Por ejemplo, se busca así todos los
resultados de una porra:

	pub-redis-13876.us-east-1-2.3.ec2.garantiadata.com:13876> keys "FLA-FLU*1998:*"
	1) "FLA-FLU-Premier-1998:4-2"
	2) "FLA-FLU-Premier-1998:3-2"

(se puede hacer algo equivalente desde el cliente en node). Y una vez
localizado el resultado,


	pub-redis-13876.us-east-1-2.3.ec2.garantiadata.com:13876> smembers "FLA-FLU-Premier-1998:3-2"
	1) "OTRO"
	2) "OTROMAS"


que da como afortunados ganadores a OTRO y a OTROMAS. Siempre
aciertan, los tíos.

El último bloque del programa recupera todas las apuestas que haya
almacenadas para una porra determinada, las tres que se han hecho. El
resultado será algo así:


	Reply: 1
	Reply: 1
	Reply: 1
	Reply: 1
	Reply: 1
	Reply: 1
	Reply: 1
	hkeys
		0: var:local
		1: var:visitante
		2: var:competition
		3: var:year
		4: bet:UNO
		5: bet:OTRO
		6: bet:OTROMAS
	End


Las primeras `Reply`s son el número de registros insertados. El resto
muestra las claves del *hash* que se ha creado, que serán siempre las
mismas. Por supuesto, la final del programa se cierra el cliente.

>Hacer un programa que recupere los ganadores de una porra almacenados
>en Redis.

También hay bases de datos SQL que se pueden usar desde la nube. Por
ejemplo, [ElephantSQL](http://www.elephantsql.com/) ofrece la base de
datos PostgreSQL como un servicio, también en modo Freemium. El modo
[gratuito ofrece 20 megas](http://www.elephantsql.com/plans.html) y
cinco conexiones concurrentes, pero para pruebas y prototipos es
suficiente.

Como en el caso anterior, se usa un URL de conexión para acceder a los
servicios, algo del tipo

	postgres://usuario:clave@fizzy-cherry.db.elephantsql.com:5432/usuario

al que puedes acceder, tras crear un servicio, en
[el área de cliente](https://customer.elephantsql.com/customer/).

Una vez establecida la conexión, el resto del acceso se hace de forma
tradicional, como en el siguiente programa

	#!/usr/bin/env node

	var fs = require('fs')
	, pg = require('pg')
	, connectionString = process.env.DATABASE_URL;

	var apuesta = require("./Apuesta.js");
	var porra = require("./Porra.js");

	var client = new pg.Client(connectionString);
	client.connect();

	// Crea la base de datos
	var create_sql = fs.readFileSync("porrio.sql","utf8");
	console.log(create_sql);
	var query = client.query(create_sql);
	query.on('end', function() {

		console.log("Creada");
		client.end();
	});

Este programa crea las dos tablas que se van a usar para almacenar los
datos. `porrio.sql` contiene una declaración SQL así:

	CREATE TABLE IF NOT EXISTS  apuesta(partido varchar(50),
       quien_apuesta varchar(50) not null,
       goles_local  int not null,
       goles_visitante  int not null);

	CREATE TABLE IF NOT EXISTS partido( id varchar(50) not null primary key,
       equipo_local varchar(50) not null,
       equipo_visitante varchar(50) not null,
       competicion varchar(20)  not null,
       year  int not null);

Donde es importante que añadamos `IF NOT EXISTS` para que no dé error
cuando ejecutemos el programa por segunda vez. Estas tablas almacenan
los datos de las porras y las apuestas de las mismas y, por integridad
referencial, la apuesta almacena el ID del partido que tiene que estar
en la otra tabla.

El programa conecta usando el URL de conexión, que se ha leído de una
variable de entorno también como es habitual; el fichero con la
definición de la tabla se lee de forma síncrona, pero la petición,
tras la declaración de la misma con `client.query`, se hace de forma
asíncrona: cuando termina la petición se cierra el cliente. Como en el
caso de Redis más arriba, el cliente mantiene el programa en ejecución
si no se cierra explícitamente.

Por otro lado, usamos el
[driver `Pg` de PostgreSQL para node](https://github.com/brianc/node-postgres). El
método que hemos usado, `query`, sirve para cualquier orden SQL, pero
admite una serie de plugins que permite acceder a las características
de PostgreSQL: transacciones y tipos, por ejemplo.

<div class='ejercicios'>
Realizar un pequeño programa, en el lenguaje elegido y sobre la base
de datos "tradicional" elegida (PostgreSQL o cualquier otro online)
que realice el ciclo básico de una base de datos. Puede ser la
aplicación de calificación de empresas realizada anteriormente.
</div>


A dónde ir desde aquí
-----

En el [siguiente tema](Tecnicas_de_virtualizacion) usaremos
diferentes técnicas de virtualización para la creación de contenedores
y jaulas que aislan procesos, usuarios y recursos del resto del sistema, creando por tanto máquinas *virtuales*. Previamente habrá que [realizar la
práctica correspondiente a esta materia](../practicas/2.XaaS).
