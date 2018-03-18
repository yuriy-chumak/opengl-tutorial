---
layout: page
title:  "Первый треугольник"
date: Sat, 17 Mar 2018 00:33:03 +0200
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за 100% достоверность приведенной информации.
</br>

Традиционно, уроки OpenGL начинаются с рисования треугольника. Не будем отступать от традиции и мы.

Чтобы нарисовать треугольник, нам надо проделать те же действия, что и с рисованием треугольников на бумаге. А именно:

* Решить, что мы будем рисовать именно треугольник (на будущее - мы, в принципе, можем решить и "я не знаю, что это будет - треугольник или полигон"; но сейчас - треугольник).
<pre><button class="doit" onclick="doit(line1.textContent)">отправить в терминал</button><code id="line1" data-language="ol">
(glBegin GL_TRIANGLES)
</code></pre>

* Поставить первую точку
<pre><button class="doit" onclick="doit(line2.textContent)">отправить в терминал</button><code id="line2" data-language="ol">
(glVertex 0.0 0.5)
</code></pre>

* Поставить вторую точку
<pre><button class="doit" onclick="doit(line3.textContent)">отправить в терминал</button><code id="line3" data-language="ol">
(glVertex -0.5 -0.5)
</code></pre>

* Поставить третью точку
<pre><button class="doit" onclick="doit(line4.textContent)">отправить в терминал</button><code id="line4" data-language="ol">
(glVertex 0.5 -0.5)
</code></pre>

* Положить карандаш.
<pre><button class="doit" onclick="doit(line5.textContent)">отправить в терминал</button><code id="line5" data-language="ol">
(glEnd)
</code></pre>

Отправьте все примеры в терминал последовательно, либо сразу все вместе из примера ниже.
<pre><button class="doit" onclick="doit(lines.textContent)">отправить в терминал</button><code id="lines" data-language="ol">
(glBegin GL_TRIANGLES)
(glVertex 0.0 0.5)
(glVertex -0.5 -0.5)
(glVertex 0.5 -0.5)
(glEnd)
</code></pre>

Temp (цветной треугольник):
<pre><button class="doit" onclick="doit(temp.textContent)">отправить в терминал</button><code id="temp" data-language="ol">
(glBegin GL_TRIANGLES)
(glColor 1.0 0.0 0.0)
(glVertex 0.0 0.5)
(glColor 0.0 1.0 0.0)
(glVertex -0.5 -0.5)
(glColor 0.0 0.0 1.0)
(glVertex 0.5 -0.5)
(glEnd)
</code></pre>


Теперь разберем эту "программу" построчно.

## glBegin

Функция [glBegin](https://www.khronos.org/registry/OpenGL-Refpages/gl2.1/xhtml/glBegin.xml) указывает OpenGL'ю что именно мы собираемся рисовать - точки, линии, треугольники, четырехугоники или полигоны. Соответственно, для этого используются константы GL_POINTS, GL_LINES, GL_TRIANGLES, GL_QUADS и GL_POLYGON.

Эти виды полигонов нам еще встретятся в следующих уроках.

## glVertex

Функция glVertex ставит точку по координатам (x,y) или (x,y,z); зависит сколько аргументов мы передадим. Частью чего именно будет эта точка мы уже библиотеке OpenGL сообщили с помощью glBegin.

## glEnd

Функция glEnd сообщает OpenGL'ю, что мы закончили задавать нашу геометрию и он может ее отобразить в окне вывода.
