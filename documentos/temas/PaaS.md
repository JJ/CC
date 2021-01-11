# Desplegando aplicaciones en la nube: Uso de PaaS y DBaaS

<!--@
prev: Microservicios
next: Intro_gestion_de_configuraciones
-->

<div class="objetivos" markdown="1">

## Objetivos

### Cubre los siguientes objetivos de la asignatura

1. Conocer los conceptos relacionados con el proceso de virtualización
   tanto de software como de hardware y ponerlos en práctica.

2. Justificar la necesidad de procesamiento virtual frente a real en
   el contexto de una infraestructura TIC de una organización.

### Objetivos específicos

1. Comprender los conceptos necesarios para trabajar con diferentes
   plataformas PaaS

2. Aplicar el concepto de *DevOps* a este tipo específico de plataforma.

3. Aplicar el sistema de control de fuentes `git` para despliegue de
   aplicaciones en la nube.

</div>

## Introducción

> Esta [presentación](https://jj.github.io/pispaas/) es un resumen del
> concepto de Plataforma como Servicio (PaaS) y alguna cosa adicional que no
> está incluida en este tema pero que conviene conocer de todas formas.

Cuando uno quiere desplegar una aplicación sobre una infraestructura ya
definida y que no va a cambiar, teniendo parte del trabajo de instalación ya
hecho, o al menos preparado para hacerse con la pulsación de un botón, a la vez
que tiene flexibilidad para trabajar con marcos de aplicaciones más allá de lo
que ofrece programar *plugins* (como en el *SaaS*), necesita un
[*Platform as a Service* o PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service).
Un PaaS proporciona una *pila*, es decir, varias capas de servicios apilados de
forma que cada uno usa al siguiente, que incluye, generalmente, almacenamiento
de datos, un marco concreto para trabajar (tal como Django o Ruby on Rails) y,
adicionalmente, un servidor web.

El elegir un PaaS conlleva una cierta falta de flexibilidad: se pueden usar las
pilas que proporciona en servicio y el usuario solo puede subir su aplicación
que las use, no instalar elementos adicionales que necesiten permisos de
superusuario. Pero, por otro lado, ofrece la comodidad de tener que
concentrarse solo en la aplicación en sí y no en la infraestructura si se trata
de una aplicación que use los marcos más comunes. Es, por eso, menos *DevOps*
que una solución *IaaS*, pero por otro lado también tiene una parte que es la
configuración y despliegue de la aplicación en sí y los tests que se vayan a
usar. Hay que tener en cuenta que, en general, la definición de la
infraestructura depende del PaaS que se use y por eso es bastante menos
portable que usar un IaaS. Sin embargo, para un microservicio específico, o
para una parte de la aplicación que sea invariable, puede ser bastante útil y
conveniente.

## Usando un servicio PaaS

La mayoría de los servicios PaaS están ligados a una *pila* de
soluciones determinada o a un vendedor determinado, es decir, a una
serie de aplicaciones que trabajan unas sobre otras cada una usando el
servicio de la anterior. Han surgido
muchos, por ejemplo, en torno a [node.js](https://nodejs.org), un
intérprete de JavaScript asíncrono que permite crear fácilmente
aplicaciones REST.

> Pila que se ha venido en
> llamar [MEAN](https://en.wikipedia.org/wiki/MEAN_(software_bundle)) e incluye
> también Mongo y Express.

Algunos servicios PaaS son específicos (solo alojan una solución determinada,
como [CloudAnt](https://www.ibm.com/cloud/cloudant) que aloja una base de datos
con CouchDB o genéricos), permitiendo una serie de soluciones en general
relativamente limitada; [Heroku](https://www.heroku.com) es el más
conocido, pero también
[hay otros](https://www.codediesel.com/nodejs/5-paas-solutions-to-host-your-nodejs-apps/),
dependiendo del tipo de pila que quieras alojar; los tres anteriores son los
que trabajan bien con node.js, [igual que `platform.sh`](https://platform.sh/) o
[IBM BlueMix](https://cloud.ibm.com/) (que ofrece un período de prueba
gratuito, que no se puede renovar, lo sé por experiencia, y que ahora
está integrado directamente ne la nube de IBM).

> Después de probar casi todos los servicios anteriores, me da la
> impresión de que poco hay más allá de Heroku y los incluidos en GCP,
> AWS y Azure. AppFog, después de la efervescencia inicial, dan 30
> días de prueba solamente. nitrous.io también da un periodo de prueba
> y se puede usar como IaaS, pero del resto, al menos los que
> funcionan con node.js, poco más hay.

[AppAgile](https://cloud.telekom.de/en/infrastructure/appagile-paas-big-data/paas)
trabaja con Perl, por ejemplo, como lo hacía Stackato y otras. En general, si
necesitas otros lenguajes, tendrás que buscar porque la oferta variará. El más
fiables es Heroku, que ofrece bastantes opciones a la hora de
elegir lenguajes.

<div class='ejercicios' markdown="1">

Darse de alta en algún servicio PaaS tal como Heroku
o [BlueMix](https://cloud.ibm.com/) o usar alguno de los PaaS de otros
servicios cloud en los que ya se esté dado de alta.

</div>

Estos servicios proveen un número limitado de máquinas virtuales y
siguen en general un modelo *freemium*: capacidades básicas son
gratuitas y para conseguir mayores prestaciones o un uso más
intensivo, o bien capacidades que no entren en el paquete básico, hay
que pasar al modelo de pago. Estas máquinas virtuales se denominan
[*dynos*](https://devcenter.heroku.com/articles/dynos) en Heroku.

Para trabajar con estas configuraciones, generalmente, los
PaaS proporcionan un *toolbelt* o herramientas de línea de órdenes que
permiten controlarlos directamente desde nuestra aplicación; estos
conjuntos de herramientas acceden a un API que también podemos
manipular en caso necesario. Tanto desde estas herramientas como desde
el panel de control, los PaaS permiten *escalar* fácilmente una
aplicación, añadiéndole nuevos *nodos* sin necesidad de modificar la
aplicación. El propio *middleware* del PaaS se encarga de equilibrar
la carga

> Aunque
> [no necesariamente lo hace de la mejor forma](https://genius.com/James-somers-herokus-ugly-secret-annotated).
> Heroku cambió el enrutado de forma que ya no funciona tan bien como lo hacía
> 5 años atrás.

entre los diferentes nodos que uno tenga. La ventaja es que te ofrece
un PaaS es que, aunque evidentemente haya que pagar por lo que se
consume, solo hay que hacerlo mientras se necesita; una vez pasado el
pico, se puede escalar *hacia abajo* eliminando los nodos que uno no
necesite; por supuesto, el propio PaaS suele proveer de herramientas
que hagan esto de forma más o menos automática.

La interacción con los PaaS se hace en general a través de una
herramienta de línea de órdenes que permite, para empezar, crear
fácilmente, a partir de una plantilla, una aplicación básica con las
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

Crear una aplicación en Heroku o en algún otro PaaS en el que se
haya dado uno de alta. Realizar un despliegue de prueba usando alguno
de los ejemplos incluidos con el PaaS.

</div>

>En todo caso, no está mal tener disponible una tarjeta de crédito,
>preferiblemente virtual o de prepago, para trabajar con todo tipo de
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
[vídeo explica como usar `heroku` para aplicaciones en Ruby](https://www.youtube.com/watch?v=dqAXmratgzE);
en
[este un poco más extenso y hecho por una persona de Heroku](https://www.youtube.com/watch?v=VZgHItD9bAQ)
te explica cómo usarlo. No hay muchos vídeos en español, pero en
[este explica cómo crear una aplicación Django y subirla a Heroku](https://www.youtube.com/watch?v=3k2eg0stnCI)
y
[este es una introducción general con ejemplos de Ruby](https://www.youtube.com/watch?v=ii9G9JMvoXM).
En
[este otro encuentras cómo hacer un despliegue de Python y Flask en Heroku](https://www.youtube.com/watch?v=pmRT8QQLIqk).

</div>

## Desplegando en el PaaS

Como ejemplo vamos a usar Heroku.

> Los PaaS de los "cloud players" tienen sistemas también similares,
> pero por lo pronto vamos a usar este, que tiene un sistema un poco
> más abierto y completo.

Tras abrir una cuenta en Heroku, crear una
[aplicación en Node](https://devcenter.heroku.com/articles/getting-started-with-nodejs#introduction)
es bastante directo. Primero, hay que tener en cuenta que en el PaaS, como
debería de ser obvio, se trata de aplicaciones web. Por eso la aplicación más
simple que se propone usa ya `express` (o, para el caso, cualquier otro marco
de servicios REST).

1. Descarga
   [el *cinturón de herramientas* de Heroku](https://devcenter.heroku.com/articles/getting-started-with-nodejs#set-up)
2. Haz *login* con `heroku login`.
3. Descarga
   [la aplicación de ejemplo para node](https://github.com/heroku/node-js-getting-started). Es
   una aplicación simple de node y express. Heroku tiene una serie de
   ejemplos para diferentes lenguajes de programación. Por ejemplo,
   [para PHP](https://devcenter.heroku.com/articles/getting-started-with-php#prepare-the-app).
   Heroku admite
   [7 lenguajes, que incluyen Scala, Clojure, Java, Ruby y Python](https://devcenter.heroku.com/start),
   aparte de permitir también despliegue de contenedores.
4. Con `heroku create` (dentro del directorio descargado) se crea la
   aplicación en heroku. Previamente lo único que había era un repo,
   con esta orden se crea una aplicación en heroku y se conecta con el
   repositorio descargado; esencialmente lo que se hace es que se
   añade un destino, `heroku` al que podemos hacer push. Con esto se
   crea una app de nombre aleatorio, que luego podremos modificar.

Puedes darle también un nombre a la aplicación y asignarle un servidor en
Europa (legalmente obligatorio) escribiendo `heroku apps:create --region eu
nombre_muy_chulo` Si te asignan un nombre puedes cambiarlo también más
adelante, en la web y en el repo.

Esto crea una aplicación en la web de Heroku, que al hacer `git push heroku
master` se pondrá en marcha. La mayoría de los PaaS usa `git push` como modo de
despliegue, que permite tener controlada la versión de todos los ficheros que
hay en el mismo y además, con los *ganchos* post-`push`,
[compilar y ejecutar la aplicación a través de los llamados *Buildpacks*](https://jamesward.com/2012/07/18/the-magic-behind-herokus-git-push-deployment/).

<div class='ejercicios' markdown="1">

Instalar y echar a andar tu primera aplicación en Heroku.

</div>

Solo hemos, por lo pronto, desplegado la aplicación por omisión.

> Y en esta aplicación por omisión se ha usado también el *buildpack*, es
> decir, el proceso y herramientas de construcción, que esté programado para tu
> pila, el de Node o el que sea. Pero si eres un poco atrevido, puedes
> [crear tu propio Buildpack](https://devcenter.heroku.com/articles/buildpack-api),
> que puede estar escrito en cualquier lenguaje y consiste en realidad en tres
> scripts.

Se
habrá generado un fichero denominado `index.js` que será,
efectivamente, el que se ejecute. Pero ¿cómo sabe Heroku qué es lo que
hay que ejecutar? Si miramos el fichero `Procfile` encontraremos algo
así

```plain
web: node index.js
```

Este [Procfile](https://devcenter.heroku.com/articles/procfile) se usa para
indicar a heroku qué es lo que tiene que ejecutar. En casi todos los casos se
tratará de una aplicación web, y por tanto la parte izquierda, `web:` será
común. Dependiendo del lenguaje, variará la parte derecha; en este caso le
estamos indicando la línea de órdenes que hay que ejecutar para *levantar* la
web que hemos creado.

Localmente, se recrea (aproximadamente) el entorno de Heroku usando Foreman. En
versiones tempranas de `heroku` estaba incluido, pero ahora tendrás que
instalarlo de forma independiente.

Para ejecutar localmente nuestra aplicación ejecutaremos

```shell
foreman start web
```

`foreman` leerá el `Procfile` y ejecutará la
tarea correspondiente a `web`, en este caso `index.js`.  Podemos
interrumpirlo simplemente tecleando Ctrl-C.

[`foreman`](https://github.com/ddollar/foreman)
actúa como un envoltorio de tu aplicación, ejecutando todo lo
necesario para que funcione (no solo la web, sino bases de datos o
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

```json
    "scripts": {
      "test": "mocha",
      "start": "node index.js"
    },
```

se puede arrancar también la aplicación, sin ningún tipo de
envoltorio, simplemente con `npm start`, que ejecutará lo que hay a su
izquierda. La clave `scripts` de `package.json` contiene una serie de
tareas o procesos que se pueden comenzar; en ese sentido, la
funcionalidad se solapa con el `Gruntfile` que se ha visto
anteriormente, sin embargo y como se ha visto en el hito anterior,
aconsejamos vivamente tener todas las tareas centralizadas en un solo
sistema de lanzamiento de tareas.

>Siempre hay más de una manera de hacer las cosas.

Ahora hay que gestionar los dos repositorios de `git` que
tenemos. `heroku create` (en cualquiera de sus formas) crea un destino
`heroku` dentro de la configuración de `git` de forma que se pueda
hacer `git push heroku master`; `heroku` aquí no es más que un alias a
la dirección de tu aplicación, que si miras en `.git/config` estará
definido de una forma similar a la siguiente

```ini
[remote "heroku"]
   url = git@heroku.com:porrio.git
   fetch = +refs/heads/*:refs/remotes/heroku/*
```

Es el mismo resultado que si hubiéramos dado la orden

```shell
git remote add heroku git@heroku.com:porrio.git
```

es decir, crear un alias para la dirección real del repositorio en
Heroku (que puedes consultar desde tu panel de control; será algo
diferente a lo que hay aquí e igual que el `nombre_muy_chulo` que
hayas decidido darle. Si vas a subir a Heroku una aplicación ya
creada, tendrás que añadir esta orden. Si te has descargado el ejemplo
de GitHub y seguido las instrucciones anteriores, tendrás que crear un
repositorio vacío propio en GitHub y añadirle este como `origin` de la
forma siguiente

```shell
# Borra el origen inicial, que será el de la aplicación de ejemplo
git remote rm origin
# Crea el nuevo origin
git remote add origin git@github.com:mi-nick/mi-app.git
```

Todo esto puedes ahorrártelo si desde el principio haces un *fork* de
la aplicación de node y trabajas con ese *fork*; el origen estará ya
definido.

Ahora tienes dos repositorios: el que está efectivamente desplegado y el que
contiene los fuentes. ¿No sería una buena idea que se trabajara con uno solo?
Efectivamente,
[GitHub permite desplegar directamente a Heroku](https://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository)
cuando se hace un `push` a la rama `master`, aunque no es inmediato, sino que
pasa por usar un servicio de integración continua, que se asegure de que todo
funciona correctamente.

Otros sistemas, como
[AWS CodeDeploy de Amazon pueden desplegar a una instancia en la nube de esta empresa](https://medium.com/aws-activate-startup-blog/simplify-code-deployments-with-aws-codedeploy-e95599091304).
Sin embargo,
[no es complicado configurar un servicio de integración continua como Snap CI](https://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository).
Después de [darte de alta en el Snap CI](https://snap-ci.com/), la
configuración se hace desde un panel de control y, si ya lo tienes configurado
para Travis (como deberías) el propio sitio detecta la configuración
automáticamente.

Para añadir el paso de despliegue a Heroku desde un sistema de integración
continua hay que hacer una configuración adicional adicional: en el menú de
Configuración se puede añadir un paso adicional tras el de Test, en el que no
hay que más que decirle el repositorio de Heroku al que se va a desplegar.

![Panel de control de Snap CI con despliegue a Heroku](/documentos/img/despliegue-snap-ci.png)

Con esto, un simple push a una rama determinada, que sería la
`master`, se hará que se pruebe y, en caso de pasar los tests, se
despliegue automáticamente en Heroku.

<div class='ejercicios' markdown="1">

Haz alguna modificación a tu aplicación en node.js para Heroku, sin olvidar
añadir los tests para la nueva funcionalidad, y configura el despliegue
automático a Heroku usando
[algún servicio de los mencionados en
StackOverflow](https://stackoverflow.com/questions/17558007/deploy-to-heroku-directly-from-my-github-repository)

</div>

En principio se ha preparado
[a la aplicación](https://github.com/JJ/node-app-cc/blob/master/lib/index.js) para
su despliegue en un solo PaaS, Heroku. Pero, ¿se podría desplegar en otro PaaS
también?

Hay que dar un paso atrás y ver qué es necesario para desplegar en Heroku,
aparte de lo obvio, tener una cuenta. Hacen falta varias cosas:

1. Un `packaje.json`, aunque en realidad esto no es específico de Heroku sino
   de cualquier aplicación y cualquier despliegue. En general, hará falta un
   fichero de una herramienta de construcción al que se pueda invocar para
   arrancar la aplicación.
2. El fichero `Procfile` con el trabaja Foreman y que distribuye las tareas
   entre los diferentes *dynos*: `web`, `worker` y los demás. Desde este
   fichero habrá que usar el target que hayamos definido previamente para
   arrancar el servicio.
3. Requisitos específicos de IP y puerto al que escuchar y que se pasan a
   `app.listen`. Estos parámetros se definen como variables de entorno, como se
   ha explicado en el capítulo anterior.

Teniendo en cuenta esto, no es difícil cambiar la aplicación para que pueda
funcionar correctamente al menos en esos dos PaaS, que son los más populares.


```javascript
const server_ip_address = process.env.OPENSHIFT_NODEJS_IP
                              || '0.0.0.0';
app.set('port', (process.env.PORT
                     || process.env.OPENSHIFT_NODEJS_PORT
                     || 5000));
```

En la primera se establece la IP en la que tiene que escuchar la aplicación. En
el caso por omisión, el segundo, la dirección `0.0.0.0` indica que Express
escuchará en todas las IPs. Sin embargo, eso no era correcto ni
posible en entornos como OpenShift, que tiene una IP específica,
contenida en la variable de entorno `OPENSHIFT_NODEJS_IP` y que será
una IP de tipo local (aunque realmente esto no
tiene que importarnos salvo por el caso de que no podremos acceder a esa IP
directamente).

En cuanto al puerto, en los dos casos hay variables de entorno para
definirlo. Simplemente las vamos comprobando con \|\| (OR) y si no está
establecida ninguna, se asigna el valor por defecto, que también sirve
para la ejecución local.

En Heroku se puede trabajar también con
Travis para el despliegue automático, aunque es mucho más simple
hacerlo con Snap CI como se ha indicado más arriba.

## Creando nuevas funcionalidades

Tal como "sale de la caja", un PaaS permite usar solo los lenguajes y
add-ons que tiene previstos. De hecho, eso es lo que define un PaaS:
una pila predefinida que se puede usar directamente.

Sin embargo, la diferencia entre PaaS e IaaS se diluye cada vez
más. Aunque ningún PaaS te va a permitir acceder al hipervisor y
definir el sistema operativo y todo lo que incluye, sí es cierto que
los más populares tienen una serie de mecanismos que permiten usar
prácticamente cualquier lenguaje, biblioteca y mecanismo de despliegue
de la aplicación.

Este sistema se llama
[*buildpacks* en Heroku](https://devcenter.heroku.com/articles/buildpacks)
y
[otros PaaS](https://www.activestate.com/blog/paas-buildpacks/)
basados en CloudFoundry y en Stackato. En general, estos mecanismos
incluyen operaciones para

* Detectar si los fuentes tienen los ficheros correctos para ser
  desplegados. Por ejemplo, el `package.json` en el caso de node.js
* Compilar los fuentes, o en general generar la aplicación que se vaya
  a ejecutar directamente.
* Informar al PaaS del resultado de estas operaciones.

En Heroku se trata de tres scripts llamados de esa forma.

<div class='ejercicios' markdown="1">

Crear una aplicación mínima y usar un buildpack no estándar para
desplegarla en Heroku. Esto será imprescindible si se usan lenguajes
como Rust, por ejemplo.

</div>

## Bases de datos como servicio y su uso en PaaS

Como las bases de datos son, en realidad, una aplicación como otra
cualquiera,
[las bases de datos como servicio, bases de datos en la nube o *DBaaS*](https://en.wikipedia.org/wiki/Cloud_database)
encajan mejor dentro de este capítulo que de ningún otro sitio, aunque en
realidad no son una solución completa, sino que se tienen que combinar
con un PaaS o un IaaS para crear una aplicación. Sin embargo, es
conveniente tener conocimiento de ellas, puesto que los PaaS que se
han visto las usan. Por eso conviene conocerlas: permite que se tenga
un backend totalmente independiente del despliegue que se vaya a
hacer, sea en un servidor propio, IaaS o un PaaS; permiten también
prototipado rápido de una aplicación, al permitir usar una base de
datos externa para integración continua y pruebas y, finalmente, en
caso de despliegue final de la aplicación, permiten pagar solo por lo
que se usa, sin tener ningún tipo de infraestructura permanente.

Los DBaaS ofrecen acceso tanto bases de datos clásicas, es decir, con
el lenguaje SQL, como a bases de datos *sin esquemas* o NoSQL como
Redis, CouchDB, Riak o MongoDB. También hay modelos *freemium* o gratuitos
con tarjeta de crédito, tales como
[Amazon DynamoDB](https://aws.amazon.com/es/dynamodb/?nc2=h_l3_db) o
[ClearDB, que provee servicio MySQL](https://www.cleardb.com/pricing.view). La
mayoría de los PaaS, por otro lado, ofrecen también DBaaS como
añadidos a sus plataformas; es decir, tarde o temprano se acabarán
usando.



## Un ejemplo de base de datos NoSQL: Redis

Vamos a aprovechar que estamos hablando de nuevas bases de datos para
trabajar con [Redis](https://redis.io). Redis es una base de datos no
persistente, en memoria, de altas prestaciones, y que permite trabajar
de forma muy eficiente con estructuras de datos simples. Otros
sistemas noSQL como CouchDB o MongoDB también son bastante populares,
pero Redis se está convirtiendo en uno de los estándares emergentes y
tiene buen soporte en JavaScript, tanto en cliente como en node.

En vez de ir
[característica por característica u orden por orden (que, además, son un montón)](https://redis.io/commands),
vamos a empezar trabajando con un sistema cliente-servidor para hacer
porras futbolísticas con el que seguiremos trabajando más
adelante. Pero antes, una aproximación básica a Redis
en
[el siguiente programa](https://github.com/JJ/node-app-cc/blob/master/pruebas/redis.js),
que prueba las principales características trabajando con pares
variable-valor y *hashes*:


```shell
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
```

El programa tiene tres partes. En la primera se conecta al DBaaS que
previamente hemos tenido que crear en RedisLabs o, para el caso, en
nuestro propio ordenador. Las credenciales para acceder al sitio están
metidas en una variable de entorno, REDISCLOUD_URL. El URL de esa variable te la
habrán asignado en redislabs cuando hayas creado un recurso gratuito,
y será por el estilo de
`pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345`, pero
tendrás que combinarla con la clave para acceder a la base de datos de
esta forma:

```shell
export
REDISCLOUD_URL=https://daigual:esta_es_la_clave@cosas.garantiadata.com:12345
```


; lo que tendrás que escribir en la línea de órdenes y nunca, nunca,
dejar en el sistema de control de fuentes.  Es un URL un tanto
complejo, pero la parte principal es la que hay detrás del `//`, de la
forma `usuario:clave@dominio:puerto`. Es imprescindible autenticarse,
para que solo uno pueda usar el recurso. En realidad, el usuario no se
usa, por eso pone `daigual`, sin embargo la clave es la que
estableceremos para el recurso cuando nos demos de alta; por defecto,
es la misma que se usa para la cuenta general, aunque puedes
establecer claves específicas para cada uno de los depósitos de
datos. Previamente a esto habrá que haber creado una *suscripción* de
Redis en "My Resources -> Manage"; hay derecho al menos a uno gratuito
por persona aunque solo te
permiten
[30 MB y 10 conexiones simultáneas](https://redislabs.com/redis-enterprise-cloud/pricing/).

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

El tercer bloque trabaja con un [HSET](https://redis.io/commands/HSET),
un conjunto de pares clave-valor indexados, a su vez, con una sola
clave. Redis tiene varios tipos de datos y tratándose de una base de
datos NoSQL,
[sus propios comandos para acceder a los mismos](https://openmymind.net/2011/11/8/Redis-Zero-To-Master-In-30-Minutes-Part-1/).
Usamos
dos sentencias con la misma clave, `un_foo`, que será la clave del
HSET, y le asignamos dos pares variable-valor. Es una estructura de
datos un poco más compleja, que nos puede servir para almacenar las
porras más adelante. Como en el caso anterior, convendría haberlo
hecho esto de forma asíncrona, pero también, y en general (y en
Redis), también funciona de esta forma.

> Redis también permite trabajar con conjuntos usando la orden
> [SADD](https://redis.io/commands/sadd). Se trataría de varias
> variables asignadas a un solo valor (el nombre del conjunto). Crear
> un programa que cree un conjunto, el de todas las porras existentes,
> por ejemplo.

Es importante también que el cliente de Redis se cierre, como se hace
en la penúltima línea con `client.end();`. Si no, el programa queda en
espera. Esa orden, efectivamente, termina el programa (aparte del
cliente de Redis). Cualquier programa en Redis tiene que terminar de
esa forma.

<div class='ejercicios' markdown="1">
1.  Darse de alta en un servicio Redis en la nube y
realizar sobre él las operaciones básicas desde el panel de control.

2. Instalar un cliente de línea de órdenes de Redis o una biblioteca cliente REST
y realizar desde él las operaciones básicas de creación y lectura de
información.

3. Ejecutar ejemplos de cualquier lenguaje de programación sobre la
instalación realizada.

</div>

## Poniendo en práctica Redis en porr.io

El problema principal con Redis es rediseñar la aplicación desde
nuestra mente base-de-datos-relacional para aprovechar sus
fortalezas. Redis almacena estructuras de datos solo indexadas por
clave. Se puede acceder a todas las claves o hacer búsquedas con
patrones. Con los resultados del ejemplo anterior se puede instalar el
cliente de redis (`sudo apt-get redis-cli`) y acceder de esta forma

```shell
redis-cli -h pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com -p
12345 -a esta-es-la-clave
```

es decir, usando el URL anterior (que se pasa con la opción `-h` a la
línea de órdenes) y la clave que hayamos establecido (con `-a`) y
podemos hacer consultas usando las órdenes de Redis, por ejemplo:

```shell
    pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345> keys *
    1) "Granada-C\xc3\xb3rdoba-Liga-2018"
    2) "zape"
    3) "un_foo"
    ...
```

Aunque las claves estén almacenadas al alimón, en realidad las órdenes
que se pueden aplicar sobre ellas son diferentes: `zape` tenía
asignada una cadena, y `un_foo` un hash. Eso lo averiguamos con `type`

```shell
    Pub-Redis-12345.Us-east-1-2.3.ec2.garantiadata.com:12345> type "zape"
    string
    pub-redis-12345.us-east-1-2.3.ec2.garantiadata.com:12345> type "un_foo"
    hash
```

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

```javascript
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
```


El
[programa, denominado obviamente `porredis.js`](https://github.com/JJ/node-app-cc/)
también
se divide en varias partes. La primera parte es la conexión a la base
de datos, que es exactamente igual que en el programa anterior. A
continuación se crea una porra con elementos aleatorios (el año) para
que se cree ligeramente diferente en cada ejecución.

> Si tenéis curiosidad de qué se trata esta porra, es del célebre
> [derby entre el Fluminense y el Flamingo](https://es.wikipedia.org/wiki/Fla-Flu),
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

```shell
    pub-redis-13876.us-east-1-2.3.ec2.garantiadata.com:13876> keys "FLA-FLU*1998:*"
    1) "FLA-FLU-Premier-1998:4-2"
    2) "FLA-FLU-Premier-1998:3-2"
```

(se puede hacer algo equivalente desde el cliente en node). Y una vez
localizado el resultado,

```shell
    pub-redis-13876.us-east-1-2.3.ec2.garantiadata.com:13876> smembers "FLA-FLU-Premier-1998:3-2"
    1) "OTRO"
    2) "OTROMAS"
```

que da como afortunados ganadores a OTRO y a OTROMAS. Siempre
aciertan, los tíos.

El último bloque del programa recupera todas las apuestas que haya
almacenadas para una porra determinada, las tres que se han hecho. El
resultado será algo así:

```plain
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
```


Las primeras `Reply`s son el número de registros insertados. El resto
muestra las claves del *hash* que se ha creado, que serán siempre las
mismas. Por supuesto, la final del programa se cierra el cliente.

>Hacer un programa que recupere los ganadores de una porra almacenados
>en Redis.

También hay bases de datos SQL que se pueden usar desde la nube. Por
ejemplo, [ElephantSQL](https://www.elephantsql.com/) ofrece la base de
datos PostgreSQL como un servicio, también en modo Freemium. El modo
[gratuito ofrece 20 megas](https://www.elephantsql.com/plans.html) y
cinco conexiones concurrentes, pero para pruebas y prototipos es
suficiente.

Como en el caso anterior, se usa un URL de conexión para acceder a los
servicios, algo del tipo

```plain
    postgres://usuario:clave@fizzy-cherry.db.elephantsql.com:5432/usuario
```

al que puedes acceder, tras crear un servicio, en
[el área de cliente](https://customer.elephantsql.com/customer/).

Una vez establecida la conexión, el resto del acceso se hace de forma
tradicional, como en el siguiente programa

```javascript
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
```

Este programa crea las dos tablas que se van a usar para almacenar los
datos. `porrio.sql` contiene una declaración SQL así:

```sql
    CREATE TABLE IF NOT EXISTS  apuesta(partido varchar(50),
       quien_apuesta varchar(50) not null,
       goles_local  int not null,
       goles_visitante  int not null);

    CREATE TABLE IF NOT EXISTS partido( id varchar(50) not null primary key,
       equipo_local varchar(50) not null,
       equipo_visitante varchar(50) not null,
       competicion varchar(20)  not null,
       year  int not null);
```

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
de datos "tradicional" elegida (PostgreSQL o cualquiera que se pueda usar online)
que realice el ciclo básico de una base de datos. Puede ser la
aplicación de calificación de empresas realizada anteriormente.
</div>


## A dónde ir desde aquí

En el [siguiente tema](Tecnicas_de_virtualizacion.md) usaremos diferentes
técnicas de virtualización para la creación de contenedores que aíslan
procesos, usuarios y recursos del resto del sistema, creando por tanto máquinas
*virtuales*. Previamente habrá que [realizar la práctica correspondiente a esta
materia](../proyecto/4.PaaS.md).
