(asdf:defsystem :render-stack-sdl3-ffi
  :description "Thin CFFI bindings for SDL3"
  :version "0.1.0"
  :author "Joel Boehland"
  :license "MIT"
  :depends-on (:render-stack-sdl3-ffi-bindings))


(asdf:defsystem :render-stack-sdl3-ffi/wrapper
  :description "CLAW wrapper generator for SDL3 bindings"
  :version "0.1.0"
  :author "Joel Boehland"
  :license "MIT"
  :depends-on (:alexandria :uiop :cffi :claw-utils :claw)
  :serial t
  :components ((:file "src/claw")
               (:module :sdl3-includes :pathname "src/lib/sdl/include/")))


(asdf:defsystem :render-stack-sdl3-ffi/example
  :description "render-stack-sdl3-ffi example"
  :version "0.1.0"
  :author "Joel Boehland"
  :license "MIT"
  :depends-on (:alexandria :static-vectors :render-stack-sdl3-ffi
                           :claw :cffi-c-ref :trivial-main-thread)
  :pathname "example/"
  :components ((:file "example")))
