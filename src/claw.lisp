(uiop:define-package :sdl3
  (:use :cl))

(claw:defwrapper (:render-stack-sdl3-ffi
                  (:system :render-stack-sdl3-ffi/wrapper)
                  (:headers "SDL3/SDL.h"
                            "SDL3/SDL_platform.h"
                            "SDL3/SDL_vulkan.h"
                            "SDL3/SDL_opengl.h")
                  (:includes :sdl3-includes)
                  (:defines "SDL_MAIN_HANDLED" 1)
                  (:targets
                   ((:and :x86-64 :linux) "x86_64-pc-linux-gnu"
                    (:headers "src/lib/SDL_build_config.x86_64-pc-linux-gnu.h"))
                   ((:and :aarch64 :android) "aarch64-linux-android")
                   ((:and :x86-64 :windows) "x86_64-w64-mingw32"))
                  (:persistent t :depends-on (:claw-utils))
                  (:include-definitions "^SDL\\w+")
                  (:exclude-definitions "_h_$"))
  :in-package :%sdl3
  :trim-enum-prefix t
  :recognize-bitfields t
  :recognize-strings t
  :with-adapter (:static :path "src/lib/adapter.c")
  :override-types ((:string claw-utils:claw-string)
                   (:pointer claw-utils:claw-pointer))
  :symbolicate-names (:in-pipeline
                      (:by-removing-prefixes "SDL" "SDL_")))
