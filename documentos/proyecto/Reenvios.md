---
layout: index


---
# Instrucciones para reenviar un hito

## Descripción

Puedes reenviar los hitos las veces que quieras, pero sigue estas
instrucciones para que se pueda evaluar correctamente.

## Entrega de la práctica

1. Edita el fichero correspondiente al hito, cambiando la versión
   *minor* del mismo e indicando claramente (negrita, cursiva o algún
   resalte de la versión, además de una letra o palabra al final de la
   misma) que se trata de un reenvío. Se trata de que, al mirar el
   fichero (puede no ser en el momento del pull request) se puedan
   identificar claramente, entre todos, cuales se han reenviado. La
   versión tiene que seguir la
   convención [*semantic versioning*](https://semver.org/), es decir,
   esa columna tiene que incluir solamente una cadena de versión.
2. Si se reenvía por segunda o tercera vez, la versión tendrá que
   indicar esto claramente de la forma *2-R2* o con una *R* o *PL*
   (*patch level*) dentro de las versiones que permitan identificar
   claramente a quien corrija qué es lo que se ha reenviado. Una vez
   más, se confronta con la hoja de notas y se ve en cuales el número
   de correcciones no coincide con el nivel de revisión. Si hay una
   corrección, sólo se corregirán los que lleven R o R1.
3. Indica claramente en el PR los cambios que se han hecho en el hito,
   y cómo se corresponden con los comentarios hechos en la corrección.
4. Así mismo, indica qué issues del propio proyecto se han creado para
   corregir el proyecto en este hito; estos *issues* tendrán que estar
   asignados al *milestone* o *milestones* correspondientes a este
   hito.

Como es natural, para que se acepte el reenvío el proyecto deberá
pasar los tests, incluyendo tests adicionales que hayan podido
introducirse durante la corrección del mismo (y que no se hayan pasado
en la entrega por ser anterior a la introducción de dicho test).

## Valoración

Cada reenvío podrá puntuar sobre un punto menos que la nota máxima.
