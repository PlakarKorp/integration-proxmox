GO=go
EXT=

PLAKAR  ?= plakar
VERSION ?= v1.1.0

GOOS   := $(shell go env GOOS)
GOARCH := $(shell go env GOARCH)
PTAR   := proxmox_$(VERSION)_$(GOOS)_$(GOARCH).ptar

all: build

build:
	${GO} build -v -o proxmoxImporter${EXT} ./plugin/importer
	${GO} build -v -o proxmoxExporter${EXT} ./plugin/exporter

test:
	${GO} vet ./...
	${GO} test -race ./...

package: build
	rm -f $(PTAR)
	$(PLAKAR) pkg create ./manifest.yaml $(VERSION)

uninstall:
	-$(PLAKAR) pkg rm proxmox

install: package
	$(PLAKAR) pkg add ./$(PTAR)

reinstall: uninstall install

clean:
	rm -f proxmoxImporter proxmoxExporter proxmox_*.ptar

.PHONY: all build test package uninstall install reinstall clean
