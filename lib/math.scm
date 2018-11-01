(define-library (lib math)
   (import (scheme core)
           (otus ffi))
   (export
      sin cos
)

(begin

   (define libm (load-dynamic-library #f))

   (define sin (libm type-inexact "sin" fft-double))
   (define cos (libm type-inexact "cos" fft-double))
))
