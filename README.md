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
- SDL3 native library

## Usage

```lisp
(ql:quickload :render-stack-sdl3-ffi)
```

## Regenerating Bindings

To regenerate bindings after SDL3 updates:

```lisp
(ql:quickload :render-stack-sdl3-ffi/wrapper)
(claw:generate :render-stack-sdl3-ffi)
```

## Related Projects

- [render-stack-sdl3](https://github.com/jolby/render-stack-sdl3) - Lispy wrappers built on this FFI layer
- [aw-sdl3](https://github.com/borodust/aw-sdl3) - Original inspiration

## License

MIT
