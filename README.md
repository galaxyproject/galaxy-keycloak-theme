# galaxy-keycloak-theme

A Galaxy-branded Keycloak login and email theme. Theme id: `galaxy`. Built to
match the Galaxy design system -- dark stage, gold accent, Atkinson Hyperlegible
font. Pairs with the `auth.usegalaxy.org` Keycloak instance.

**Supported Keycloak versions:** 26.6.x (the version this theme is built and
tested against).

---

## Local preview

`make dev` boots Keycloak and maildev via docker-compose with the theme mounted
live and caching disabled.

- Login preview: `http://localhost:8080/realms/galaxy-dev/account` -- click
  "Sign in" to reach the branded login page.
- Captured outbound emails: `http://localhost:1080` (maildev UI).

> Note: `docker-compose.yml` and the dev realm config are added by a later
> task. The workflow above describes the intended experience once those land.

---

## Build

```bash
make build
# or, to pin the version string:
make build VERSION=1.2.3
```

Produces `dist/galaxy-keycloak-theme-<version>.jar`. The default version is
read from `VERSION` at the top of the Makefile.

---

## Installing in a Keycloak deployment

1. Download `galaxy-keycloak-theme-<version>.jar` from Releases.
2. Place it in the Keycloak container's `/opt/keycloak/providers/` directory.
3. In Realm Settings -> Themes, set **Login theme** and **Email theme** to `galaxy`
   (or set `loginTheme`/`emailTheme` in your realm provisioning).
4. Keep theme caching enabled in production (the default).

---

## Brand tokens / sync

The brand palette and font stack live in
`theme/galaxy/login/resources/css/tokens.css`. They are mirrored from
galaxy-hub `astro/src/styles/global.css` (the `@theme` block). Long-term, the
intent is to extract these into a shared `@galaxyproject/brand-tokens` package
consumed by both repos so updates propagate automatically.

Font used: **Atkinson Hyperlegible** -- bundled under
`theme/galaxy/login/resources/fonts/` and declared via `@font-face` in
`galaxy.css` so it works without a CDN.

---

## Email theme

Transactional emails (password reset, verification, etc.) are branded with the
Galaxy header. Email templates live under `theme/galaxy/email/`.

---

## Releasing

Push a `vX.Y.Z` tag; the `release` workflow (`.github/workflows/release.yml`)
builds the jar via `make build VERSION=X.Y.Z` and attaches it to a GitHub
Release automatically.

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## Repository layout

```
theme/
  galaxy/
    login/
      resources/
        css/       # tokens.css, galaxy.css
        fonts/     # Atkinson Hyperlegible woff2 files
    email/
      # email templates
META-INF/
  keycloak-themes.json   # declares theme id "galaxy", types login+email
Makefile
.github/workflows/
  release.yml
```
