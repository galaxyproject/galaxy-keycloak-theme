# Base Theme Selector Notes -- Keycloak 26.6.2

Captured from live render: `http://localhost:8080/realms/galaxy-dev/protocol/openid-connect/auth?client_id=account&response_type=code&redirect_uri=...`

Theme parent: `keycloak` (classic PatternFly v3/v4 login theme).

---

## Confirmed Selector Table

| Role | Assumed selector | Actual (confirmed or corrected) |
|------|------------------|---------------------------------|
| Page body / background | `body.login-pf`, `.login-pf-page` | **CORRECTED**: `body` has `class=""` (empty) in 26.6.2; `login-pf` is on `<html class="login-pf">`, not body. Use `html.login-pf` or just `.login-pf-page` for background. |
| Login card (white box) | `.login-pf-page .card-pf` | **CONFIRMED**: `<div class="card-pf">` is a direct child of `.login-pf-page`. |
| Header wrapper (holds realm name; where logo goes) | `#kc-header-wrapper` | **CONFIRMED**: `<div id="kc-header-wrapper" class="">Galaxy</div>` inside `<div id="kc-header" class="login-pf-page-header">`. Logo targeting: `#kc-header-wrapper`. |
| Header container | `.login-pf-page .login-pf-header` | **CONFIRMED**: `<header class="login-pf-header">` inside `.card-pf`. Note: the outer header div uses `login-pf-page-header` (on `#kc-header`); the inner card header is `login-pf-header`. |
| Page title | `#kc-page-title` | **CONFIRMED**: `<h1 id="kc-page-title">Sign in to your account</h1>` inside `<header class="login-pf-header">`. |
| Form | `#kc-form-login` | **CONFIRMED**: `<form id="kc-form-login" ...>` inside `#kc-form-wrapper` inside `#kc-form`. |
| Text inputs | `.pf-c-form-control` | **CONFIRMED**: `<input id="username" class="pf-c-form-control" ...>` and `<input id="password" class="pf-c-form-control" ...>`. Both inputs carry exactly `pf-c-form-control`. |
| Primary submit button | `.pf-c-button.pf-m-primary`, `input#kc-login` | **CONFIRMED**: `<input class="pf-c-button pf-m-primary pf-m-block btn-lg" id="kc-login" type="submit" ...>`. Also carries `pf-m-block` and `btn-lg`. |
| Form options / links | `#kc-form-options a`, `#kc-registration a`, `.login-pf-page a` | **CONFIRMED with nuance**: "Forgot Password?" link is inside an anonymous `<div class="">` sibling of `#kc-form-options` (not inside `#kc-form-options` itself -- that div is empty when remember-me is off). "Register" link is in `#kc-registration` inside `#kc-registration-container`. Use `.login-pf-page a` to catch all links, or target `#kc-form-options`, `#kc-registration`, `#kc-info-wrapper` individually. |
| Social / IdP providers block | `#kc-social-providers` | **NOT PRESENT** -- no IdP is configured in the dev realm. The block does not render at all when there are no social providers. Will appear when an IdP is added; target `#kc-social-providers` and its `ul`/`li`/`a` children for Task 9. |

---

## Key Structural Markup (verbatim from live HTML)

```html
<html class="login-pf" lang="en">
<body class="" data-page-id="login-login">

<div class="login-pf-page">
  <div id="kc-header" class="login-pf-page-header">
    <div id="kc-header-wrapper" class="">Galaxy</div>
  </div>
  <div class="card-pf">
    <header class="login-pf-header">
      <h1 id="kc-page-title">Sign in to your account</h1>
    </header>
    <div id="kc-content">
      <div id="kc-content-wrapper">
        <div id="kc-form">
          <div id="kc-form-wrapper">
            <form id="kc-form-login" ...>
              <input id="username" class="pf-c-form-control" type="text" ...>
              <input id="password" class="pf-c-form-control" type="password" ...>
              <div id="kc-form-options"></div>          <!-- empty when no remember-me -->
              <input class="pf-c-button pf-m-primary pf-m-block btn-lg"
                     id="kc-login" type="submit" value="Sign In">
            </form>
          </div>
        </div>
        <div id="kc-info" class="login-pf-signup">
          <div id="kc-info-wrapper">
            <div id="kc-registration-container">
              <div id="kc-registration">
                <a ...>Register</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

---

## Stylesheet Href Pattern

Build hash: `kx559` (changes between builds/restarts -- do not hard-code).

Base pattern: `/resources/<hash>/login/galaxy/`

Sheets loaded (in order):
1. `/resources/kx559/common/keycloak/vendor/patternfly-v4/patternfly.min.css`
2. `/resources/kx559/common/keycloak/vendor/patternfly-v3/css/patternfly.min.css`
3. `/resources/kx559/common/keycloak/vendor/patternfly-v3/css/patternfly-additions.min.css`
4. `/resources/kx559/common/keycloak/lib/pficon/pficon.css`
5. `/resources/kx559/login/galaxy/css/login.css` -- inherited from parent theme
6. `/resources/kx559/login/galaxy/css/tokens.css` -- galaxy brand tokens
7. `/resources/kx559/login/galaxy/css/galaxy.css` -- galaxy overrides (last; highest specificity)

All three galaxy theme sheets returned HTTP 200 in testing.

---

## Notes for Tasks 7-9

- **Background targeting**: Use `html.login-pf` or `.login-pf-page` -- NOT `body.login-pf` (body class is empty).
- **Card**: `.card-pf` is a direct child of `.login-pf-page`; `.login-pf-page .card-pf` works.
- **Logo (Task 8)**: inject via `#kc-header-wrapper::before` with `content: url(...)` or background-image, or replace text with an `<img>`-equivalent CSS trick. The wrapper contains plain text ("Galaxy") with no extra markup.
- **Input group**: Password field is wrapped in `<div class="pf-c-input-group">` alongside the show/hide toggle button (`<button class="pf-c-button pf-m-control">`). Style `input.pf-c-form-control` directly; avoid styling `.pf-c-input-group` unless you want to affect the wrapper box.
- **Submit button is an `<input>`, not `<button>`**: `input#kc-login` / `input.pf-c-button.pf-m-primary` -- pseudo-elements (`::before`/`::after`) do not work on `<input>` elements.
- **"Forgot Password?" link**: not inside `#kc-form-options` -- it's in an adjacent unnamed `<div class="">`. Best targeted as `#kc-form-wrapper a` or `.login-pf-page a`.
- **Registration link**: `#kc-registration a` -- confirmed present when `registrationAllowed: true`.
- **Social providers (Task 9)**: `#kc-social-providers` only renders with a configured IdP; target its `ul li a.zocial` children. In dev, add an IdP to the realm to test.
- **`data-page-id`** on body: `login-login` on the main login page, `login-error` on error pages. Can be used for page-specific overrides.
