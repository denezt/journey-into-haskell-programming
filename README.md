# Haskell Webscraper

A minimal Haskell webscraper that:
- Fetches an HTML page
- Prints the page `<title>`
- Extracts and lists all links (`href`, anchor text)
- Optionally filters links by a keyword (in href or text)

## Requirements

- GHC (Glasgow Haskell Compiler)

### Install system level dependencies
- `sudo apt install cabal-install`
- `sudo apt install haskell-stack`
- `sudo apt install hindent`

## Check:

``` bash
ghc --version
cabal --version
```

###  Install & Build
``` bash 
make deps
make build
```

### Run 
``` bash
make run URL=https://garagebarge.com

```

``` bash
make run URL=https://garagebarge.com KW=haskell
```

### Clean
``` bash
make clean
make distclean
```

### Notes

* Uses http-conduit for HTTP and tagsoup for HTML parsing.
* All I/O and network errors will surface via exceptions by default. For production, add retry/backoff and structured error handling.

---

### Quick Start (copy/paste)

``` bash
# Create the files from this answer in place, then:
make deps
make build
make run URL=https://garagebarge.com
```