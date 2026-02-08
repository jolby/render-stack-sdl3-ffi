SHELL := /bin/sh

CWD := $(shell pwd)
SBCL ?= sbcl
QL ?= $(HOME)/quicklisp/setup.lisp

SBCL_FLAGS := --noinform --disable-debugger --non-interactive
ASDF_BOOT := --eval '(require :asdf)' --eval "(pushnew \#p\"$(CWD)/\" asdf:*central-registry*)"
QL_BOOT := --eval '(load "$(QL)")'

.PHONY: build run-vulkan run-opengl check-quicklisp

check-quicklisp:
	@test -f "$(QL)" || { \
	  echo "Quicklisp not found at $(QL). Override QL=/path/to/quicklisp/setup.lisp"; \
	  exit 1; \
	}

build:
	cd src/lib && ./build.sh desktop

run-vulkan: check-quicklisp build
	$(SBCL) $(SBCL_FLAGS) $(QL_BOOT) $(ASDF_BOOT) \
	  --eval '(ql:quickload :render-stack-sdl3-ffi/example-vulkan :silent t)' \
	  --eval '(render-stack-sdl3-ffi.example-vulkan:run)'

run-opengl: check-quicklisp build
	$(SBCL) $(SBCL_FLAGS) $(QL_BOOT) $(ASDF_BOOT) \
	  --eval '(ql:quickload :render-stack-sdl3-ffi/example-opengl :silent t)' \
	  --eval '(render-stack-sdl3-ffi.example-opengl:run)'
