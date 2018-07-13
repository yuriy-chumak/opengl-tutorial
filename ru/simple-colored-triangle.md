---
layout: page
title:  "Простой цветной треугольник"
date: Fri Jul 13 15:32:06 EEST 2018
categories: ru
---

> Внимание, эта статья находится в процессе создания; ее содержание может (и будет) меняться, пока полностью не удовлетворит автора. А до тех пор я не ручаюсь за стопроцентную достоверность приведенной информации.


В прошлом уроке мы нарисовали белый (если вы ничего не трогали) треугольник. В этом мы добавим цвет. Согласитесь, цвет несет достаточно много информации и в отдельных случаях просто незаменим. Например, цветом удобно выделять оси координат и проекции векторов на них.

Итак, давайте сделаем наш треугольник цветным.


## Цветной треугольник

Для этого нам надо просто задать цвет.

---
* Задаем цвет треугольника (в нашем случае - розовый)
<pre><button class="doit" onclick="doit(color.textContent)">отправить в терминал</button><code id="color" data-language="ol">
(glColor3f 1.0 0.0 0.4)
</code></pre>

> glColor3f принимает три параметра - R (red, красный), G (green, зеленый) и B (blue, синий) компоненты цвета. Это три вещественных числа от 0 до 1, указывающие на уровень яркости соответствующего компонента цветовой матрицы. 0 - компонент выключен, 1 - полностью включен. Красный цвет - это 1,0,0; синий - 0,0,1; а желтый - 0,1,1.


* Указываем, что рисуем треугольник.
<pre><button class="doit" onclick="doit(line1.textContent)">отправить в терминал</button><code id="line1" data-language="ol">
(glBegin GL_TRIANGLES)
</code></pre>

---
* Ставим первую точку
<pre><button class="doit" onclick="doit(line2.textContent)">отправить в терминал</button><code id="line2" data-language="ol">
(glVertex2f 0.0 0.5)
</code></pre>

---
* Ставим вторую точку
<pre><button class="doit" onclick="doit(line3.textContent)">отправить в терминал</button><code id="line3" data-language="ol">
(glVertex2f -0.5 -0.5)
</code></pre>

---
* Ставим третью точку
<pre><button class="doit" onclick="doit(line4.textContent)">отправить в терминал</button><code id="line4" data-language="ol">
(glVertex2f 0.5 -0.5)
</code></pre>

---
* Кладем карандаш.
<pre><button class="doit" onclick="doit(line5.textContent)">отправить в терминал</button><code id="line5" data-language="ol">
(glEnd)
</code></pre>


## Несколько слов о glColor

Точно так же, как и у glVertex (смотрим [прошлый урок](?ru/simple-triangle)) функция glColor имеет много суффиксов. Вот некоторые из них: glColor3b, glColor3ubv, glColor4s, glColor3f, и т.д. Все эти функции своими суффиксами тоже подсказывают библиотеке какие именно числа мы используем.

И точно так же как с glVertex мы будем использовать упрощенную функцию glColor. Эта функция будет превращать (glColor r g b) в (glColor3f r g b) и (glColor r g b a) в (glColor4f r g b a).


## Все вместе

Итак, вся наша программа в окончательном виде будет выглядеть так:

<pre><button class="doit" onclick="doit(lines.textContent)">отправить в терминал</button><code id="lines" data-language="ol">
(import (lib opengl))

(glColor 1.0 0.0 0.4)
(glBegin GL_TRIANGLES)
   (glVertex 0.0 0.5)
   (glVertex -0.5 -0.5)
   (glVertex 0.5 -0.5)
(glEnd)

(finish)
</code></pre>

А это разноцветный треугольник:

<pre><button class="doit" onclick="doit(lines2.textContent)">отправить в терминал</button><code id="lines2" data-language="ol">
(import (lib opengl))

(glBegin GL_TRIANGLES)
   (glColor3f 1.0 0.0 0.0)
   (glVertex 0.0 0.5)
   
   (glColor3f 0.0 1.0 0.0)
   (glVertex -0.5 -0.5)
   
   (glColor3f 0.0 0.0 1.0)
   (glVertex 0.5 -0.5)
(glEnd)

(finish)
</code></pre>
