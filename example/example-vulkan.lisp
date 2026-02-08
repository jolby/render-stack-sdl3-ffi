(cl:defpackage :render-stack-sdl3-ffi.example-vulkan
  (:use :cl)
  (:export #:run))
(cl:in-package :render-stack-sdl3-ffi.example-vulkan)


(cffi:define-foreign-library
    (sdl3-clawed
     :search-path (asdf:system-relative-pathname :render-stack-sdl3-ffi
                                                 "src/lib/build/desktop/"))
  (:unix "libsdl3.clawed.so"))


(defun main-run ()
  ;; Vulkan drivers perform FP operations that trip SBCL's default traps
  (sb-int:with-float-traps-masked (:invalid :overflow :divide-by-zero)
  (%sdl3:init %sdl3:+init-video+)
  (let ((window (cffi:with-foreign-string (name "render-stack-sdl3-ffi Vulkan Example")
                  (%sdl3:create-window name
                                       640 480
                                       0))))
    (when (cffi:null-pointer-p window)
      (error "Failed to create window: ~A" (%sdl3:get-error)))
    (let ((renderer (cffi:with-foreign-string (driver "vulkan")
                      (%sdl3:create-renderer window driver))))
      (when (cffi:null-pointer-p renderer)
        (%sdl3:destroy-window window)
        (error "Failed to create renderer: ~A" (%sdl3:get-error)))
      (unwind-protect
           (progn
             ;; Light greenish background
             (%sdl3:set-render-draw-color-float renderer 0.56 0.83 0.56 1.0)
             (dotimes (i 300)
               (%sdl3:render-clear renderer)
               (%sdl3:render-present renderer)
               (sleep 1/60))
             (%sdl3:destroy-renderer renderer)
             (%sdl3:destroy-window window))
        (%sdl3:quit))))))


(defun run ()
  (unwind-protect
       (let ((errout *error-output*))
         (cffi:load-foreign-library 'sdl3-clawed)
         (flet ((%runner ()
                  (handler-case
                      (main-run)
                    (serious-condition (c) (format errout "~A" c)))))
           (trivial-main-thread:call-in-main-thread #'%runner :blocking t)))
    (cffi:close-foreign-library 'sdl3-clawed)))
