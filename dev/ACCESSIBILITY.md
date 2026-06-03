# Galaxy Keycloak Theme -- Accessibility Notes

## Overview

The Galaxy login theme is CSS-only: it adds brand colors, Atkinson Hyperlegible
typeface, and a logo injection, but does **not** override any Keycloak FreeMarker
login templates. Keycloak's stock form markup -- label/input associations, ARIA
attributes, focus order, and error messaging -- is preserved unchanged. The
theme layers on top of the `keycloak` base theme, so its built-in accessibility
semantics remain fully intact.

---

## Typography

**Font:** Atkinson Hyperlegible (both 400 and 700 weights are bundled as
woff2). This typeface was designed specifically for low-vision readers,
prioritizing letter-form distinction over aesthetic neutrality. The font-stack
falls back to `system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI',
Roboto, 'Helvetica Neue', Arial, sans-serif` for offline or font-load-failure
scenarios.

---

## WCAG 2.1 Contrast Ratios

Ratios computed with the standard relative-luminance formula (IEC 61966-2-1
sRGB linearisation). Thresholds: **4.5:1** for normal text, **3.0:1** for large
text (18 pt / 14 pt bold) and non-text UI components.

| Pair | Foreground | Background | Ratio | AA Normal (>=4.5) | AA Large/UI (>=3.0) |
|------|-----------|------------|-------|-------------------|---------------------|
| Gold button text | `#2c3143` | `#ffd700` | 9.20:1 | PASS | PASS |
| Page title / labels | `#2c3143` | `#ffffff` | 12.90:1 | PASS | PASS |
| Link (resting) | `#25537b` | `#ffffff` | 8.07:1 | PASS | PASS |
| Link hover | `#2c3143` | `#ffffff` | 12.90:1 | PASS | PASS |
| Body / help text | `#58585a` | `#ffffff` | 7.10:1 | PASS | PASS |

---

## Failures and Remediation

### Link hover -- resolved

The original design used `--color-galaxy-gold-dark` (`#d19e00`) as the link
hover color, which is only 2.44:1 on white -- below both AA thresholds. Rather
than treat it as an acceptable transient state, the hover was changed to darken
the link to `galaxy-dark` (`#2c3143`, 12.90:1) and add an underline, so the
hover affordance stays clearly readable. No remaining pairs fail AA at their
applicable threshold.

---

## Template Overrides

None. The theme sets `parent: keycloak` in `theme.properties` and provides only
CSS/font/image assets. All FreeMarker templates (`login.ftl`, `login-reset-password.ftl`,
etc.) are inherited from the Keycloak base theme without modification, so:

- Every `<label>` is associated to its `<input>` via `for`/`id` as Keycloak
  ships it.
- ARIA live regions for error feedback are intact.
- Tab/focus order is determined by source order in Keycloak's own templates.
- Keyboard operability of all form controls is unchanged.
