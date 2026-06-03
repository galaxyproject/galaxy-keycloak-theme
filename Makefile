VERSION ?= 0.0.0-dev
JAR := dist/galaxy-keycloak-theme-$(VERSION).jar
.DEFAULT_GOAL := build

.PHONY: build clean dev smoke fonts

fonts:
	./scripts/fetch-fonts.sh

build: fonts
	mkdir -p dist
	rm -f $(JAR)
	zip -q -r $(JAR) META-INF theme
	@echo "Built $(JAR)"

clean:
	rm -rf dist .keycloak-data

dev:
	docker compose up --build

smoke:
	./scripts/smoke-test.sh
