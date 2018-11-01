---
layout: page
title:  "Система координат"
date: Mon Jul 16 20:01:58 EEST 2018
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за стопроцентную достоверность приведенной информации.


## Система координат

Здесь мы введем две новые функции, которые помогут нам во многих следующих примерах.

Первой идет функция **iota**, которая генерирует список элементов. Выглядит эта функция довольно просто - (iota *количество-элементов* *начальный-элемент* *разница-между-элементами*). Вызов (iota 21 -1 0.1) создаст нам список '(-1 -9/10 -4/5 -7/10 -3/5 -1/2 -2/5 -3/10 -1/5 -1/10 0 1/10 1/5 3/10 2/5 1/2 3/5 7/10 4/5 9/10) что в привычной десятичной нотации будет выглядеть как '(-1 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9).

Вторая - **for-each** вида (for-each *функция* *список*) выполняет заданную *функцию* для всех элементов *списка*.

Попробуем нарисовать оси координат используя уже знакомые нам функции glVertex2f, glColor3f и введенные в этом разделе iota и for-each.

## Все вместе

Итак, вся наша программа в окончательном виде будет выглядеть так:

<pre><button class="doit" onclick="doit(xy.textContent)">отправить в терминал</button><code id="xy" data-language="ol">
(import (lib gl2))

(glClear GL_COLOR_BUFFER_BIT)

(glBegin GL_LINES)
   (glColor3f 1 0 0) ; x
      (glVertex2f -1 0)
      (glVertex2f +1 0)
   (for-each (lambda (x)
         (glVertex2f x -0.04)
         (glVertex2f x 0.04))
      (iota 21 -1 0.1))
(glEnd)

(glBegin GL_LINES)
   (glColor3f 0 1 0) ; y
      (glVertex2f 0 -1)
      (glVertex2f 0 1)
   (for-each (lambda (x)
         (glVertex2f -0.02 x)
         (glVertex2f 0.02 x))
      (iota 21 -1 0.1))
(glEnd)
</code></pre>

## Ортографическая проекция

Окно вывода у нас не квадратное, это нормально. Но если мы хотим выводить примитивы не растянутыми горизонтально, а в корректном соотношении сторон, то вот следующий пример:

<pre><button class="doit" onclick="doit(ortho.textContent)">отправить в терминал</button><code id="ortho" data-language="ol">
(import (lib gl2))

(glClear GL_COLOR_BUFFER_BIT)
(glMatrixMode GL_MODELVIEW_MATRIX)
(glOrtho -2 2 -1.3 1.3 -1 1)

(glBegin GL_LINES)
   (glColor3f 1 0 0) ; x
      (glVertex2f -1 0)
      (glVertex2f +1 0)
   (for-each (lambda (x)
         (glVertex2f x -0.04)
         (glVertex2f x 0.04))
      (iota 21 -1 0.1))
(glEnd)

(glBegin GL_LINES)
   (glColor3f 0 1 0) ; y
      (glVertex2f 0 -1)
      (glVertex2f 0 1)
   (for-each (lambda (x)
         (glVertex2f -0.04 x)
         (glVertex2f 0.04 x))
      (iota 21 -1 0.1))
(glEnd)
</code></pre>
