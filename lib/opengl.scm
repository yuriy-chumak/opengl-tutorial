(define-library (lib opengl)
   (export
      (exports (EGL version-1-1))
      (exports (OpenGL ES version-2-0))
      (exports (otus ffi))

      glBegin glEnd
      glVertex glVertex2f glVertex3f
      glColor glColor3f glColor4f

      glMatrixMode
         GL_MODELVIEW_MATRIX GL_PROJECTION_MATRIX GL_TEXTURE_MATRIX
      glMultMatrix glMultMatrixf glMultMatrixd
      glOrtho glPushMatrix glPopMatrix

      gl:set-window-title finish)

   (import
      (scheme core)
      (r5rs srfi-1)

      (EGL version-1-1)
      (OpenGL ES version-2-0)

      (otus ffi)
      (owl interop) (owl ff) (owl io)
      (owl string) (owl math))

   (begin

   (define GL_MODELVIEW_MATRIX               #x0BA6)
   (define GL_PROJECTION_MATRIX              #x0BA7)
   (define GL_TEXTURE_MATRIX                 #x0BA8)

; opengl server
(fork-server 'opengl (lambda ()
   ; some internal staff
   (define identity-matrix '(
      (1 0 0 0)
      (0 1 0 0)
      (0 0 1 0)
      (0 0 0 1)))
   (define (matrix-multiply matrix1 matrix2)
   (map
      (lambda (row)
         (apply map
            (lambda column
               (apply + (map * row column)))
            matrix2))
      matrix1))

; main loop
(let this ((dictionary #empty))
(let* ((envelope (wait-mail))
       (sender msg envelope))
   (tuple-case msg
      ((debug)
         (mail sender dictionary)
         (this dictionary))

      ; display
      ((set-display display)
         (this (put dictionary 'display display)))
      ((get-display)
         (mail sender (get dictionary 'display 0))
         (this dictionary))

      ; surface
      ((set-surface surface)
         (this (put dictionary 'surface surface)))
      ((get-surface)
         (mail sender (get dictionary 'surface 0))
         (this dictionary))

      ; context
      ((set-context context)
         (this (put dictionary 'context context)))
      ((get-context)
         (mail sender (get dictionary 'context 0))
         (this dictionary))

      ; shaders
      ((set-program program)
         (this (put dictionary 'program program)))
      ((get-program)
         (mail sender (get dictionary 'program 0))
         (this dictionary))

      ; matrices
      ((set-matrix-mode mode)
         (this (put dictionary 'matrix-mode mode)))
;      ((set-model-view-matrix matrix)
;         (this (put dictionary 'model-view matrix)))
;      ((set-projection-matrix matrix)
;         (this (put dictionary 'projection matrix)))
      ((push-matrix)
         (this (put dictionary 'matrices-stack (cons
            (get dictionary (get dictionary 'matrix-mode GL_MODELVIEW_MATRIX) identity-matrix)
            (get dictionary 'matrices-stack #null)))))
      ((pop-matrix)
         (let ((stack (get dictionary 'matrices-stack #null)))
            (print "stack: " stack)
            (if (null? stack)
               (this dictionary)
               (this (put (put dictionary 'matrices-stack (cdr stack))
                        (get dictionary 'matrix-mode GL_MODELVIEW_MATRIX)
                        (car stack))))))

      ((mult-matrix matrix)
         ; default matrix (if no mode) is modelview
         (this (put dictionary (get dictionary 'matrix-mode GL_MODELVIEW_MATRIX)
                  (matrix-multiply
                     (get dictionary (get dictionary 'matrix-mode GL_MODELVIEW_MATRIX) identity-matrix)
                     matrix))))

      ; drawing
      ((glBegin mode)
         (let*((dictionary (put dictionary 'mode mode))
               (dictionary (put dictionary 'vertices #null))
               (dictionary (put dictionary 'colors #null))
               (dictionary (put dictionary 'vbos ((lambda ()
                              (define vbo '(0))
                              (glGenBuffers 1 vbo)
                              (define cbo '(0))
                              (glGenBuffers 1 cbo)
                              (list (car vbo) (car cbo)))))))
            (this dictionary)))
      ((glColor r g b a)
         (let ((dictionary (put dictionary 'color (list r g b a))))
            (this dictionary)))
      ((glVertex x y z)
         (let*((dictionary (put dictionary 'vertices (append
                              (get dictionary 'vertices '())
                              (list x y z))))
               (dictionary (put dictionary 'colors (append
                              (get dictionary 'colors '())
                              (get dictionary 'color '(1 1 1 1))))))
            (this dictionary)))
      ((glEnd)
         (let ((vbos (get dictionary 'vbos '(0 0)))
               (mode (get dictionary 'mode GL_TRIANGLES))
               (vertices (get dictionary 'vertices '()))
               (colors (get dictionary 'colors '()))
               (vPosition (glGetAttribLocation (get dictionary 'program 0) "vPosition"))
               (vColor    (glGetAttribLocation (get dictionary 'program 0) "vColor")))
            (glBindBuffer GL_ARRAY_BUFFER (first vbos))
            (glBufferData GL_ARRAY_BUFFER (* 4 (length vertices)) vertices GL_STATIC_DRAW) ; 4 = sizeof(float)
            (glBindBuffer GL_ARRAY_BUFFER (second vbos))
            (glBufferData GL_ARRAY_BUFFER (* 4 (length colors)) colors GL_STATIC_DRAW) ; 4 = sizeof(float)

            (glUseProgram (get dictionary 'program 0))
            ; matrices
            (glUniformMatrix4fv (glGetUniformLocation (get dictionary 'program 0) (c-string "uModelViewMatrix"))
               1 GL_FALSE (apply append (get dictionary GL_MODELVIEW_MATRIX identity-matrix)))
            (glUniformMatrix4fv (glGetUniformLocation (get dictionary 'program 0) (c-string "uProjectionMatrix"))
               1 GL_FALSE (apply append (get dictionary GL_PROJECTION_MATRIX identity-matrix)))
            ; vertices
            (glBindBuffer GL_ARRAY_BUFFER (first vbos))
            (glVertexAttribPointer vPosition 3 GL_FLOAT GL_FALSE 0 #false)
            (glEnableVertexAttribArray vPosition)
            ; colors
            (glBindBuffer GL_ARRAY_BUFFER (second vbos))
            (glVertexAttribPointer vColor 4 GL_FLOAT GL_FALSE 0 #false)
            (glEnableVertexAttribArray vColor)
            ;(print "mode: " mode)
            ;(print "(/ (length vertices) 3): " (/ (length vertices) 3))
            ;(print vertices)
            (glDrawArrays mode 0 (/ (length vertices) 3))

            ; free resources
            (glDeleteBuffers (length vbos) vbos))
         (print) ; hack, this forces ui switch from console to canvas
         (this dictionary))

      (else
         (print-to stderr "Unknown opengl server command " msg)
         (this dictionary)))))))

(define opengl:init
(let*((init (lambda (title)
               (let ((major (make-32bit-array 1))
                     (minor (make-32bit-array 1))
                     (numConfigs (make-32bit-array 1))
                     (attribList '(
                        #x3024 5 ; red
                        #x3023 6 ; green
                        #x3022 5 ; blue
                        #x3021 8 ; alpha
                        #x3025 8 ; depth
                        ;#x3026 ; stencil
                        #x3032 0 ; sample buffers
                        #x3038)) ; EGL_NONE
                     (config (make-vptr-array 1))
                     (contextAttribs '(
                        #x3098 2 #x3038 #x3038))) ; EGL_CONTEXT_CLIENT_VERSION, 2, EGL_NONE, EGL_NONE
               (print) ; empty print, some king of 'flag' in output

               (define display (eglGetDisplay #false))
               (mail 'opengl (tuple 'set-display display))

               (eglInitialize display major minor)
               (print "eglInitialize: " (car major) "." (car minor))

               (eglGetConfigs display config 0 numConfigs)
               (print "eglGetConfigs: " (car numConfigs))

               (eglChooseConfig display attribList config (car numConfigs) numConfigs)
               (define surface (eglCreateWindowSurface display (car config) 2 #false)) ; temp "2" instead of XCreateWindow
               (mail 'opengl (tuple 'set-surface surface))

               (define context (eglCreateContext display (car config) EGL_NO_CONTEXT contextAttribs))
               (mail 'opengl (tuple 'set-context context))

               ; default opengl shaders
               (define vertex-shader "
                  attribute vec4 vPosition;
                  attribute vec4 vColor;

                  uniform mat4 uProjectionMatrix;
                  uniform mat4 uModelViewMatrix;

                  varying vec4 va_Color;
                  void main()
                  {
                     gl_Position = uProjectionMatrix * (uModelViewMatrix * vPosition);
                     va_Color = vColor;
                  }")
               (define fragment-shader "
                  precision mediump float;

                  varying vec4 va_Color;
                  void main()
                  {
                     gl_FragColor = va_Color;
                  }")

               (define (CreateGLProgram vstext fstext)
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

               (define shader-program (CreateGLProgram vertex-shader fragment-shader))
               (glUseProgram shader-program)
               (mail 'opengl (tuple 'set-program shader-program))

               #true))))
   (case-lambda
      (() (init ""))
      ((title) (init title)))))

   (opengl:init "lib/opengl")

   (define (gl:set-window-title title)
      #true) ; do nothing
   (define (finish)
      (print)) ; do nothing


   ; opengl function emulation
   (define (glBegin mode)
      (mail 'opengl (tuple 'glBegin mode)))
   (define (glEnd)
      (mail 'opengl (tuple 'glEnd)))
   ; vertex
   (define (glVertex2f x y)
      (mail 'opengl (tuple 'glVertex x y 0)))
   (define (glVertex3f x y z)
      (mail 'opengl (tuple 'glVertex x y z)))
   (define glVertex (case-lambda
      ((x y)
         (glVertex2f x y))
      ((x y z)
         (glVertex3f x y z))))
   ; colors
   (define (glColor3f r g b)
      (mail 'opengl (tuple 'glColor r g b 1)))
   (define (glColor4f r g b a)
      (mail 'opengl (tuple 'glColor r g b a)))

   (define glColor (case-lambda
      ((r g b)
         (glColor3f r g b))
      ((r g b a)
         (glColor4f r g b a))))

   ; matrices
   (define (glMatrixMode mode)
      (mail 'opengl (tuple 'set-matrix-mode mode)))
   (define (glPopMatrix)
      (mail 'opengl (tuple 'pop-matrix)))
   (define (glPushMatrix)
      (mail 'opengl (tuple 'push-matrix)))

   (define (glMultMatrix matrix)
      (mail 'opengl (tuple 'mult-matrix matrix)))
   (define glMultMatrixf glMultMatrix)
   (define glMultMatrixd glMultMatrix)

   (define (glOrtho left right  bottom top  near far)
      (glMultMatrix
         (let ((Tx (/ (+ right left) (- right left)))
               (Ty (/ (+ top bottom) (- top bottom)))
               (Tz (/ (+ far near)   (- far near))))
               (list
                  (list (/ 2 (- right left)) 0 0 Tx)
                  (list 0 (/ 2 (- top bottom)) 0 Ty)
                  (list 0 0 (/ -2 (- far near))  Tz) ; z is reversed
                  (list 0 0 0                    1)))))
   

))
