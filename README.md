# render-stack-sdl3-ffi

Thin CFFI bindings for SDL3, generated using [CLAW](https://github.com/borodust/claw).

## Purpose

Provides raw Common Lisp CFFI bindings to the SDL3 library. Based on the structure of [aw-sdl3](https://github.com/borodust/aw-sdl3).

## Supported Platforms

- x86_64 Linux
- aarch64 Android
- x86_64 Windows

## Dependencies

- CFFI
- claw-utils
- SDL3 native library (built via CMake, see below)

## Building the Native Library

```bash
make build
```

This produces `src/lib/build/desktop/libsdl3.clawed.so`.

## Usage

```lisp
(ql:quickload :render-stack-sdl3-ffi)
```

All SDL3 symbols are exported from the `%sdl3` package (e.g., `%sdl3:init`, `%sdl3:create-window`).

### Examples

**Vulkan** — Opens a 640x480 Vulkan-surface window for 5 seconds:

```bash
make run-vulkan
```

**OpenGL** — Opens a 640x480 OpenGL 3.3 core window, clears to cornflower blue for ~5 seconds:

```bash
make run-opengl
```

Or from the REPL:

```lisp
;; Vulkan
(asdf:load-system :render-stack-sdl3-ffi/example-vulkan)
(render-stack-sdl3-ffi.example-vulkan:run)

;; OpenGL
(asdf:load-system :render-stack-sdl3-ffi/example-opengl)
(render-stack-sdl3-ffi.example-opengl:run)
```

## Regenerating Bindings

After SDL3 updates, regenerate the CLAW bindings:

```lisp
;; 1. Build SDL3 and copy the build config header
;;    cp src/lib/build/desktop/sdl/include/build_config/SDL_build_config.h \
;;       src/lib/SDL_build_config.x86_64-pc-linux-gnu.h

;; 2. Regenerate
(pushnew :claw-regen-adapter *features*)
(cffi:load-foreign-library 
  (merge-pathnames ".local/lib/libresect.so" (user-homedir-pathname)))
(ql:quickload :render-stack-sdl3-ffi/wrapper :force t)
(claw:load-wrapper :render-stack-sdl3-ffi)
```

## Related Projects

- [render-stack-sdl3](https://github.com/jolby/render-stack-sdl3) - Lispy wrappers built on this FFI layer
- [aw-sdl3](https://github.com/borodust/aw-sdl3) - Original inspiration

## License

MIT
