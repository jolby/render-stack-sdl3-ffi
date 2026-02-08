(cl:defpackage :render-stack-sdl3-ffi.example-opengl
  (:use :cl)
  (:export #:run))
(cl:in-package :render-stack-sdl3-ffi.example-opengl)


(cffi:define-foreign-library
    (sdl3-clawed
     :search-path (asdf:system-relative-pathname :render-stack-sdl3-ffi
                                                 "src/lib/build/desktop/"))
  (:unix "libsdl3.clawed.so"))

(cffi:define-foreign-library libgl
  (:unix "libGL.so.1"))


(cffi:defcfun ("glClearColor" gl-clear-color) :void
  (r :float) (g :float) (b :float) (a :float))

(cffi:defcfun ("glClear" gl-clear) :void
  (mask :unsigned-int))

(defconstant +gl-color-buffer-bit+ #x00004000)


(defun main-run ()
  (%sdl3:init %sdl3:+init-video+)
  ;; Request OpenGL 3.3 core profile
  ;; NOTE: claw's defctype wrapping the gl-attr defcenum prevents CFFI
  ;; keyword dispatch, so we pass integer enum values directly.
  (%sdl3:gl-set-attribute 17 3)  ; :context-major-version
  (%sdl3:gl-set-attribute 18 3)  ; :context-minor-version
  (%sdl3:gl-set-attribute 20     ; :context-profile-mask
                          %sdl3:+gl-context-profile-core+)
  (%sdl3:gl-set-attribute 5 1)   ; :doublebuffer
  (let ((window (cffi:with-foreign-string (name "render-stack-sdl3-ffi OpenGL Example")
                  (%sdl3:create-window name
                                       640 480
                                       %sdl3:+window-opengl+))))
    (when (cffi:null-pointer-p window)
      (error "Failed to create window: ~A" (%sdl3:get-error)))
    (let ((ctx (%sdl3:gl-create-context window)))
      (when (cffi:null-pointer-p ctx)
        (%sdl3:destroy-window window)
        (error "Failed to create GL context: ~A" (%sdl3:get-error)))
      (unwind-protect
           (progn
             (%sdl3:gl-make-current window ctx)
             (%sdl3:gl-set-swap-interval 1)
             ;; Clear to cornflower blue and swap a few times
             (gl-clear-color 0.39 0.58 0.93 1.0)
             (dotimes (i 300)
               (gl-clear +gl-color-buffer-bit+)
               (%sdl3:gl-swap-window window)
               (sleep 1/60))
             (%sdl3:gl-destroy-context ctx)
             (%sdl3:destroy-window window))
        (%sdl3:quit)))))


(defun run ()
  (unwind-protect
       (let ((errout *error-output*))
         (cffi:load-foreign-library 'sdl3-clawed)
         (cffi:load-foreign-library 'libgl)
         (flet ((%runner ()
                  (handler-case
                      (main-run)
                    (serious-condition (c) (format errout "~A" c)))))
           (trivial-main-thread:call-in-main-thread #'%runner :blocking t)))
    (cffi:close-foreign-library 'libgl)
    (cffi:close-foreign-library 'sdl3-clawed)))
