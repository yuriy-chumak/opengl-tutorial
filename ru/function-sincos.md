---
layout: page
title:  "Система координат"
date: Mon Jul 16 20:01:58 EEST 2018
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за стопроцентную достоверность приведенной информации.


## Sin

Снова используем iota и for-each. Полезные очень функции, да.

## Все вместе

Итак, вся наша программа в окончательном виде будет выглядеть так:

<pre><button class="doit" onclick="doit(sincos.textContent)">отправить в терминал</button><code id="sincos" data-language="ol">
(import (lib gl2))
(import (lib math))

(glClear GL_COLOR_BUFFER_BIT)
(glMatrixMode GL_MODELVIEW_MATRIX)
(glLoadIdentity)
(glOrtho -2 2 -1.3 1.3 -1 1)

(glBegin GL_LINES)
   (glColor3f 1 0 0) ; x
      (glVertex2f -1 0)
      (glVertex2f +1 0)
   (for-each (lambda (x)
         (glVertex2f x -0.02)
         (glVertex2f x 0.02))
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

(define libm (load-dynamic-library #f))
(define sin (libm fft-double "sin" fft-double))

(glBegin GL_LINE_STRIP)
   (glColor3f 0 0 1)
   (for-each (lambda (x)
         (glVertex2f x (sin x)))
      (iota 21 -1 0.1))
(glEnd)

</code></pre>
