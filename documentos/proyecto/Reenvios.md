# Instrucciones para reenviar un hito

## Descripción

Puedes reenviar los hitos las veces que quieras, pero sigue estas
instrucciones para que se pueda evaluar correctamente.

## Entrega de la práctica

1. Edita el fichero correspondiente al hito, cambiando la versión
   *minor* del mismo e indicando claramente (negrita, cursiva o algún
   resalte de la versión) que se trata de un reenvío. Se trata de que,
   al mirar el fichero (puede no ser en el momento del pull request)
   se puedan identificar claramente cuales se han reenviado. La
   versión tiene que seguir la
   convención [*semantic versioning*](https://semver.org/), es decir,
   esa columna tiene que incluir solamente una cadena de versión.
2. Si se reenvía por segunda o tercera vez, la versión tendrá que
   indicar esto claramente de la forma *2.R2* o con una *R* o *PL*
   (patch level) dentro de las versiones que permitan identificar
   claramente a quien corrija qué es lo que se ha reenviado.
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

Cada reenvío puntuará sobre un punto menos que la nota máxima,
multiplicado por el número de semanas desde corrección de la misma. Es
decir, primera semana, un reenvío, -1 puntos; segunda semana, -2
puntos y así sucesivamente. Si se reenvía en las próximas horas a la
corrección, se podrá rebajar la penalización.

No hay compromiso de fecha de corrección para reenvíos. En general, se
tratarán de tener en una semana desde el envío, pero podría retrasarse
dependiendo de la carga de trabajo.
