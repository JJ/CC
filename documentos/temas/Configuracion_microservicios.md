---
layout: index

apuntes: T

prev: REST
next: Microservicios
---

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

# Configuración externa

La
[configuración externa](https://microservices.io/patterns/externalized-configuration.html)
es
uno de los patrones imprescindibles en la creación de aplicaciones
nativas en la nube. Lo principal de la misma es el uso de un servicio
externo para todas las diferentes opciones que haya que usar en cada
uno de las instancias de los servicios que se vayan a usar. También es
parte de la [aplicación de 12 factores](https://12factor.net/config),
que dice que hay que almacenar la aplicación en el entorno. No tiene
que ser necesariamente *las* variables de entorno, claro.

> Hay varios servidores de configuración distribuida, pero el más
> usado es `etcd` (otras alternativas son Zookeeper y Consul). Se
> puede instalar el cliente y servidor directamente de los
> repositorios, y a continuación es conveniente escribir `export
> ETCDCTL_API=3` para que funcione correctamente
> el [cliente](https://etcd.io/docs/v3.4.0/dl-build/).

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

En el [siguiente tema](Microservicios) veremos cómo hacer efectivamente el
despliegue en la nube.
