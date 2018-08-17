---
layout: page
title:  "Простой треугольник"
date: Sat, 17 Mar 2018 00:33:03 +0200
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за стопроцентную достоверность приведенной информации.


Традиционно, уроки OpenGL начинаются с рисования треугольника. Не будем отступать от традиции и мы.


## Рисуем треугольник

Чтобы нарисовать треугольник, нам надо проделать те же действия, что и с рисованием треугольников на бумаге. А именно:

---
* Решить, что мы будем рисовать именно треугольник.
<pre><button class="doit" onclick="doit(line1.textContent)">отправить в терминал</button><code id="line1" data-language="ol">
(glBegin GL_TRIANGLES)
</code></pre>

> Функция [glBegin](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBegin.xml) указывает OpenGL'ю что именно мы собираемся рисовать - точки, линии, треугольники, четырехугоники или полигоны. Соответственно, для этого используются константы GL_POINTS, GL_LINES, GL_TRIANGLES, GL_QUADS и GL_POLYGON.
>
> Эти виды полигонов нам еще встретятся в следующих уроках.

---
* Поставить первую точку
<pre><button class="doit" onclick="doit(line2.textContent)">отправить в терминал</button><code id="line2" data-language="ol">
(glVertex2f 0.0 0.5)
</code></pre>

> Функция glVertex ставит точку по координатам (x,y) или (x,y,z); зависит сколько аргументов мы передадим. Частью чего именно будет эта точка мы уже библиотеке OpenGL сообщили с помощью glBegin.

---
* Поставить вторую точку
<pre><button class="doit" onclick="doit(line3.textContent)">отправить в терминал</button><code id="line3" data-language="ol">
(glVertex2f -0.5 -0.5)
</code></pre>

---
* Поставить третью точку
<pre><button class="doit" onclick="doit(line4.textContent)">отправить в терминал</button><code id="line4" data-language="ol">
(glVertex2f 0.5 -0.5)
</code></pre>

---
* Положить карандаш.
<pre><button class="doit" onclick="doit(line5.textContent)">отправить в терминал</button><code id="line5" data-language="ol">
(glEnd)
</code></pre>

> Функция glEnd сообщает OpenGL'ю, что мы закончили задавать нашу геометрию и он может приступать к обработке переданных точек. На этом этапе как раз и происходит сборка примитивов (наших треугольников) и отправка их в графический конвеер на обработку.


## Несколько слов о glVertex

Библиотека OpenGL имеет несколько разных функций для точек. Это glVertex2d, glVertex2dv, glVertex2f, glVertex2fv, glVertex2i, glVertex2iv, glVertex2s, glVertex2sv, glVertex3d, glVertex3dv, glVertex3f, ..., glVertex4iv, glVertex4s, glVertex4sv. Все эти функции своими суффиксами подсказывают библиотеке какие именно числа мы используем: "f" - float, число с плавающей запятой; "d" - double, число с плавающей запятой двойной точности; "i" - целое; "s" - короткое целое.

Нам эти сложности будут ни к чему. Поэтому мы здесь и дальше будем использовать упрощенную функцию glVertex, которая не являясь стандартной для OpenGL предоставляется используемым языком для абстрагирования от этих сложностей. Эта функция будет превращать (glVertex x y) в (glVertex2f x y) и (glVertex x y z) в (glVertex3f x y z). 


## Все вместе

Итак, вся наша программа в окончательном виде будет выглядеть так:

<pre><button class="doit" onclick="doit(lines.textContent)">отправить в терминал</button><code id="lines" data-language="ol">
(import (lib opengl))

(glBegin GL_TRIANGLES)
   (glVertex 0.0 0.5)
   (glVertex -0.5 -0.5)
   (glVertex 0.5 -0.5)
(glEnd)
</code></pre>

[Дальше](?ru/simple-colored-triangle)