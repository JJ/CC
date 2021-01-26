# Configuración de microservicios

<!--@
prev: REST
next: Microservicios
-->

<div class="objetivos" markdown="1">

## Objetivos

### Cubre los siguientes objetivos de la asignatura

1. Conocer los conceptos relacionados con el proceso de virtualización
   tanto de software como de hardware y ponerlos en práctica.

### Objetivos específicos

1. Entender los mecanismos de diseño, prueba y despliegue de un
   microservicio antes de efectuarlo y enviarlo a la nube.

2. Aplicar el concepto de *DevOps* a este tipo específico de plataforma.

3. Aprender prácticas seguras en el desarrollo de aplicaciones en la
   nube.

</div>

# Introducción

La
[configuración externa](https://microservices.io/patterns/externalized-configuration.html)
es
uno de los patrones imprescindibles en la creación de aplicaciones
nativas en la nube. Una de las principales formas de llevar a cabo la misma es el uso de un servicio
externo para todas las diferentes opciones que haya que usar en cada
uno de las instancias de los servicios que se vayan a usar. Otra forma
es la propuesta por la [aplicación de 12 factores](https://12factor.net/config),
que dice que hay que almacenar la aplicación en el entorno. No tiene
que ser necesariamente *las* variables de entorno, claro.

Hay varios servidores de configuración distribuida, pero el más
usado es `etcd`; otras alternativas son Zookeeper y
Consul. Comenzaremos por el primero.

En todo caso, el principio esencial que rige esto es el de
configuración como código, que significa especialmente que la
configuración debe tratarse como código pero también que la
configuración debe ser *externa* al código. Nada que sea configurable
debe estar incluido en el código, y mucho menos como un literal sin
ningún tipo de configuración.  Llevándolo un poco más allá, la
configuración, siguiendo el principio de *separation of concerns*,
debe ser un objeto externo que encapsule todo lo necesario para
acceder a la configuración que una aplicación necesita.

En todo caso, se ebe evitar la configuración también desde línea de
órdenes, aunque se puede dejar como *fallback* en caso de que otros no
funcionen, de la misma forma, la configuración "por omisión" puede
usarse como una característica para test o desarrollo, pero que se
debe evitar de cualquier forma en producción.

En general, la configuración debe usar, aparte de los sistemas de
configuración distribuida de la que vamos a hablar más abajo, las
variables de configuración y los ficheros de configuración o *ficheros
de entorno* que siguen el mismo formato `clave=valor` y que permiten
trabajar con este entorno con un fichero (una vez más, configuración
como código) que esté bajo control de un sistema de control de fuentes
y permita su evolución y también su despliegue fácilmente.

Por ejemplo, la
siguiente
[clase](https://github.com/JJ/node-app-cc/blob/master/lib/Config.js)
en JavaScript incorpora diferentes formas de configuración y le da un
interfaz común, cono los atributos de un objeto.

```javascript

const { config }  = require("dotenv").config();

class Config {
  constructor() {
    this.listening_ip_address = process.env.LISTENING_IP_ADDRESS || process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0';
    this.port = process.env.PORT || process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 5000;
  }

}

module.exports = { Config };
```

Usa el módulo [`dotenv`](https://www.npmjs.com/package/dotenv), que
incorpora como variables de entorno lo que se escriba en un fichero
`.env` con el formato indicado anteriormente.

Esto se puede usar directamente de la siguiente forma:

```javascript
"use strict";

const express = require('express');
const app = require("./Rutas.js");
const { Config } = require("./Config.js");

const config = new Config;

app.use(express.static(__dirname + '/public'));

// Escucha en un puerto determinado.
app.listen(config.port, config.listening_ip_address, function() {
  console.log("Node app is running at " + config.listening_ip_address + ":" + config.port );
});
```

De forma que únicamente trabajando con un objeto de clase `Config`
encapsulamos todos los sistemas de configuración que se pudieran usar,
incluso los siguientes (que se pueden incorporar más adelante a la
misma clase). De esta forma se consigue la *separation of concerns*:
la configuración es sólo cosa de la clase Config. El fichero principal
de la aplicación, `config.js`, sólo tiene que preocuparse de
arrancarla usando el interfaz correspondiente.

## Usando `etcd3`

De forma estricta, el único sistema de configuración distribuida que
ahora mismo (2021) se usa de forma general
es [`etcd3`](https://etcd.io). Esencialmente, es un sistema de
almacenamiento clave/valor distribuido, que permite configurar las
aplicaciones de forma sencilla y con un mínimo adicional de
configuración, ya que etcd3 funciona en un puerto conocido y
accesible.

Se
puede instalar el cliente y servidor directamente de los
repositorios, y a continuación es conveniente escribir `export
ETCDCTL_API=3` para que funcione correctamente
el [cliente](https://etcd.io/docs/v3.4.0/dl-build/).

Con estos sistemas de configuración distribuida, se debe tanto
establecer la configuración (antes de lanzarlo), como leer la
configuración. Y evidentemente, la configuración se tendrá que
almacenar en algún lugar. Por ejemplo, este script en Python (que está
alojado [aquí](https://github.com/JJ/tests-python) servirá para
establecer un valor leyéndolo desde varias fuentes diferentes:

```python
import etcd3
from dotenv import load_dotenv
import os
import sys

def main( argv = [] ):
    PORT_VAR_NAME= 'hugitos:PORT'
    etcd = etcd3.client()
    if ( argv ):
        etcd.put(PORT_VAR_NAME,argv[0])
    else:
        load_dotenv()
        if (os.getenv('PORT')):
            etcd.put(PORT_VAR_NAME,os.getenv('PORT'))
        else:
            etcd.put(PORT_VAR_NAME,3000)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1:])
    else:
        main()
```

Primero, establece el espacio de nombres y nombre de la variable que
vamos a usar, `hugitos`, que ese va a ser el nombre de la
aplicación. Sólo vamos a usar una variable aquí. Se lee en la
siguiente secuencia:

1. Se usa el primer argumento en la línea de órdenes si existe
2. Se lee el fichero `.env` (vía `load_dotenv`). Esa orden pone como
   variable de entorno lo que haya en el fichero; si existe esa
   variable de entorno, se usa.
3. Si nada de eso ocurre, se usa un valor por omisión.

Una vez hecho eso, las variables van a estar obligatoriamente
almacenadas en ese sistema de configuración distribuida. Pero eso
tiene que estar rodeado por un wrapper que se pueda usar en un *mock*
para hacer tests locales.

Esta clase, por ejemplo, encapsula la configuración y la incluye en un
objeto que puede usar cualquier modo de configuración presente:

```python
import etcd3
from dotenv import load_dotenv
import os
import sys


class Config:

    def __init__(self):
        PORT_VAR_NAME= 'hugitos:PORT'
        try:
            etcd = etcd3.client()
            self.port = int(etcd.get(PORT_VAR_NAME)[0].decode("utf8") )
        except:
            load_dotenv()
            if (os.getenv('PORT')):
                self.port = os.getenv('PORT')
            else:
                self.port = 3000
```

De forma que no es realmente necesario trabajar con *mocks*, sino que
se usa el método de configuración que haya presente, empezando, como
es natural, por `etcd`. Si no, se usa configuración local. Los tests
automáticamente usarán la configuración por omisión.

<div class='ejercicios' markdown="1">

Instalar `etcd3`, averiguar qué bibliotecas funcionan bien con el
lenguaje que estemos escribiendo el proyecto (u otro lenguaje), y
hacer un pequeño ejemplo de almacenamiento y recuperación de una
clave; hacer el almacenamiento desde la línea de órdenes (con
`etcdctl`) y la recuperación desde el mini-programa que hagáis.

</div>

## A dónde ir desde aquí

En el [siguiente tema](Microservicios.md) veremos cómo hacer efectivamente el
despliegue en la nube.
