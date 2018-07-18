---
layout: page
title:  "Система координат"
date: Mon Jul 16 20:01:58 EEST 2018
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за стопроцентную достоверность приведенной информации.


## Система координат

<pre><button class="doit" onclick="doit(xy.textContent)">отправить в терминал</button><code id="xy" data-language="ol">
(import (lib opengl))

(glBegin GL_LINES)
   (glColor 1 0 0) ; x
      (glVertex -1 0)
      (glVertex +1 0)
   (for-each (lambda (x)
         (glVertex (/ x 10) -0.04)
         (glVertex (/ x 10) 0.04))
      (iota 20 -10))
(glEnd)

(glClearColor 1 0 0 1)
(glBegin GL_LINES)
   (glColor 0 1 0) ; y
      (glVertex 0 -1)
      (glVertex 0 1)
   (for-each (lambda (x)
         (glVertex -0.04 (/ x 10))
         (glVertex 0.04 (/ x 10)))
      (iota 20 -10))
(glEnd)

(finish)
</code></pre>

## Ортографическая проекция

<pre><button class="doit" onclick="doit(ortho.textContent)">отправить в терминал</button><code id="ortho" data-language="ol">
(import (lib opengl))

(glClear GL_COLOR_BUFFER_BIT)
;(glMatrixMode GL_MODELVIEW_MATRIX)
(glOrtho -2 2 -1.2 1.2 -1 1)

(glBegin GL_LINES)
   (glColor 1 0 0) ; x
      (glVertex -1 0)
      (glVertex +1 0)
   (for-each (lambda (x)
         (glVertex (/ x 10) -0.04)
         (glVertex (/ x 10) 0.04))
      (iota 20 -10))
(glEnd)

(glClearColor 1 0 0 1)
(glBegin GL_LINES)
   (glColor 0 1 0) ; y
      (glVertex 0 -1)
      (glVertex 0 1)
   (for-each (lambda (x)
         (glVertex -0.04 (/ x 10))
         (glVertex 0.04 (/ x 10)))
      (iota 20 -10))
(glEnd)

(finish)
</code></pre>
