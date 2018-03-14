---
layout: html
title:  Summary
categories: index
---
> Тот, кто перестает учиться — стареет, будь то в двадцать или восемьдесят. Тот, кто продолжает обучение — остается молодым. Самая важная вещь в жизни – сохранить свой ум молодым.
> <br/> <span style="float: right;">Г. Форд</span>
<br/>

### Вступление

Здравствуйте, инженеры.

Вы придумали нечто новое/интересное и хотели бы предварительно как-нибудь визуализировать свою идею, взглянуть на нее "со стороны", покруть так и эдак, да и просто визуально оценить привлекательность/осуществимость своего возможного будущего детища? Или вы поспорили с коллегой по поводу его очередной идеи и хотите показать очевидную бредовость оной? А может вам просто скучно и вы хотите провести простую симуляцию давно забытой темы, на которую хоть и положили болт, но она внезапно напомнила о себе и вызвала приятные воспоминания? Отлично, вы же инженер, за чем дело стало - вперед!

Ах, вам, наверное, для этого чего-то не хватает? Например, вы не хотите штудировать 700-страничный труд по пользованию автокадом? Или может вам лень перечитать 500 страниц руководства по блендеру? Или вы никак не можете вспомнить тот седьмой том учебника по матлабу, где описана симуляция и визуализация простых объектов на примере турбовинтового двигателя, в то время как вам всего-то надо столкнуть и посмотреть как падают вниз три костяшки домино?

Если я угадал, то вы зашли по правильному адресу. Здесь вашему внимаю предлагается набор уроков для инженеров по широко известной в очень широких кругах библиотеке OpenGL и по чуть менее известной в менее широких кругах библиотеке newton-dynamics.

Подчеркиваю - для инженеров, а не для программистов! Пускай программисты, для которых аналогичных уроков в сети очень много, занимаются динамическим освещением, мягкими тенями, SSAO и инстансингом - это не наши задачи. Наши задачи, это быстро отрисовать график возникшей в голове функции в объеме, динамически меняя ее параметры; или сбросить с шарика конус, рассматривая с разных углов как он красиво перекатывается по заданной сплайн-поверхности; ну или запустить в космосе пару сотен сфер с совершенно бредовым законом гравитации и посмотреть что из этого получится.

Конечно, немного попрограммировать вам придется. Но без этого все равно никак не обойтись - раз уж сел за компьютер, то нужно же как-то этому компьютеру объяснить, что ты от него хочешь. Но, обещаю, программирования будет минимум - такой минимум, что даже после полного прохождения всех уроков вы все равно не сможете гордо заявить "я теперь программист".


### Оглавление

...

Тестовый код:
<pre><button class="doit" onclick="doit(sample1.textContent)">отправить в терминал</button><code id="sample1" data-language="ol">
(glClearColor 0.3 0.3 0.3 1)
(glClear GL_COLOR_BUFFER_BIT)
</code></pre>

Большой пример с шейдерами:
<pre><button class="doit" onclick="doit(sample2.textContent)">отправить в терминал</button><code id="sample2" data-language="ol">
(define (CreateProgram vstext fstext)
(let ((po (glCreateProgram))
      (vs (glCreateShader GL_VERTEX_SHADER))
      (fs (glCreateShader GL_FRAGMENT_SHADER)))
   (if (= po 0)
      (runtime-error "Can't create shader program." #f))

   ; пример, как можно передать в функцию массив указателей на строки:
   ; vertex shader:
   ; http://steps3d.narod.ru/tutorials/lighting-tutorial.html
   (glShaderSource vs 1 (list (c-string vstext)) #false)
   (glCompileShader vs)
   (let ((isCompiled '(0)))
      (glGetShaderiv vs GL_COMPILE_STATUS isCompiled)

      (if (eq? (car isCompiled) 0)
         (let*((maxLength "??")
               (_ (glGetShaderiv vs GL_INFO_LOG_LENGTH maxLength))
               (maxLengthValue (+ (ref maxLength 0) (* (ref maxLength 1) 256)))
               (errorLog (make-string maxLengthValue 0))
               (_ (glGetShaderInfoLog vs maxLengthValue maxLength errorLog)))
            (runtime-error errorLog vs))))
   (glAttachShader po vs)

   ; fragment shader:
   (glShaderSource fs 1 (list (c-string fstext)) #false)
   (glCompileShader fs)
   (let ((isCompiled '(0)))
      (glGetShaderiv fs GL_COMPILE_STATUS isCompiled)

      (if (eq? (car isCompiled) 0)
         (let*((maxLength "??")
               (_ (glGetShaderiv fs GL_INFO_LOG_LENGTH maxLength))
               (maxLengthValue (+ (ref maxLength 0) (* (ref maxLength 1) 256)))
               (errorLog (make-string maxLengthValue 0))
               (_ (glGetShaderInfoLog fs maxLengthValue maxLength errorLog)))
            (runtime-error errorLog fs))))

   (glAttachShader po fs)

   (glLinkProgram po)
   (glDetachShader po fs)
   (glDetachShader po vs)

   po ; return result index
))

(define program (CreateProgram
"  attribute vec4 vPosition;
   void main()
   {
      gl_Position = vPosition;
   }"

"  precision mediump float;
   void main()
   {
      gl_FragColor = vec4( 0.0, 0.3, 0.0, 1.0 );
   }"))

(print "program: " program)

(define pos (glGetAttribLocation program "vPosition"))
(print "pos: " pos)

(define vpo '(0))
(glGenBuffers 1 vpo)
(print "vpo: " vpo)
(glBindBuffer GL_ARRAY_BUFFER (car vpo))

(define vertices '(0.0 0.5  -0.5 -0.5  0.5 -0.5))
(glBufferData GL_ARRAY_BUFFER (* 4 (length vertices)) vertices GL_STATIC_DRAW)


(glUseProgram program)
(glBindBuffer GL_ARRAY_BUFFER (car vpo))
(glVertexAttribPointer pos 2 GL_FLOAT GL_FALSE 0 #false)
(glEnableVertexAttribArray pos)
(glDrawArrays GL_TRIANGLES 0 3)
</code></pre>

<small style="float: right">Copyright (c) 2018 Yuriy Chumak</small>
