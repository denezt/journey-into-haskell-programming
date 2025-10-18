# Simple Makefile for a Haskell (ghc) project using cabal.
# Requirements: ghc and cabal-install on PATH.

PROJECT_NAME := haskell-webscraper

.PHONY: all deps build run clean distclean

all: build

deps:
	@echo "==> Ensuring dependencies are installed (via cabal)..."
	cabal update
	cabal v2-build --only-dependencies

build:
	@echo "==> Building $(PROJECT_NAME)..."
	cabal v2-build

# Usage: make run URL=https://garagebarge.com [KW=haskell]
run:
	@if [ -z "$(URL)" ]; then \
		echo "Please provide URL, e.g. 'make run URL=https://garagebarge.com'"; \
		exit 1; \
	fi
	@echo "==> Running $(PROJECT_NAME)..."
	@if [ -z "$(KW)" ]; then \
		cabal v2-run $(PROJECT_NAME) -- $(URL); \
	else \
		cabal v2-run $(PROJECT_NAME) -- $(URL) $(KW); \
	fi

clean:
	@echo "==> Cleaning build artifacts..."
	cabal v2-clean || true

distclean: clean
	@echo "==> Removing cabal/dist and cache (leave ~/.cabal alone)..."
	rm -rf dist-newstyle
