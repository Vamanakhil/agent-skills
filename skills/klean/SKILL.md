---
name: klean
description: >
  Review, design, improve, and production-harden websites and web applications so they
  feel intentional, product-specific, accessible, fast, trustworthy, secure, and
  human-designed rather than statistically generic AI-generated UI. Use when building,
  redesigning, auditing, reviewing, or preparing a website or web app for launch, or when
  asked to make a site "less AI-generated", "more human", or "production ready".
license: MIT
compatibility: opencode, claude-code
metadata:
  version: "1.0.0"
  philosophy: "intent -> evidence -> design -> interaction -> engineering -> verification"
  standards: "WCAG 2.2 AA, OWASP Top 10 2025, Core Web Vitals, Google Search Essentials"
---

# Klean - Website Quality Engineer

Klean is a senior design + engineering review gate. It does not ban visual techniques; it
eliminates unjustified defaults and forces product thinking into every decision. A website
should answer: Why does this exist? Who is it for? What makes it different? What should the
user do next? Why should the user trust it? What happens when things go wrong? Why does this
interface look the way it does?

**Objective:** make AI-assisted websites indistinguishable from work produced by a
thoughtful product designer, frontend engineer, UX researcher, SEO engineer, and security
engineer.

**Operating philosophy:** `Intent -> Evidence -> Design -> Interaction -> Engineering ->
Verification`. Never `Prompt -> Generate -> Polish`.

## Workflow

1. **Establish product truth** before touching UI (see Product Truth).
2. **Determine mode** (see Review Modes). Default: AUDIT when reviewing, REDESIGN when
   changing, LAUNCH when preparing to ship.
3. **Analyze, then act.** Never redesign before understanding the current site/codebase.
4. **Report with evidence** using `OBSERVED -> WHY IT MATTERS -> FIX -> VERIFY` (see
   Evidence-Based Review).
5. **Severe every finding** P0-P3 and fix in priority order (see Severity).

## 1. Reject the Statistical Default

AI models gravitate to the most probable implementation. Treat these as **suspicious
defaults** - investigate whether the product justifies each one; do not mechanically remove
them:

| Category | Suspicious defaults |
|---|---|
| Palette | purple/blue gradients, purple+black, neon accents, generic pastels |
| Surfaces | glassmorphism, liquid/glass effects, excessive blur or drop shadows, rainbow/colored stripes |
| Layout | bento grids, dot grids, radial-orbit diagrams, floating blobs, terminal windows, exactly three pricing tiers, generic SaaS hero, colored left-border accents |
| Icons | excessive Lucide/icon decoration, sparkle icons, animated arrows, emoji as visual language |
| Type | Inter/Geist/Space Grotesk/DM Sans chosen without reason, oversized gradient headlines, excessive em-dashes |
| Motion | pointless hover animations, floating elements, animated arrows |
| Copy | "It's not X, it's Y", checkmark bullet lists, "Unlock your potential", "Seamlessly", "Revolutionize", "Trusted by" without evidence |
| Trust | fake testimonials, fake logos, fake metrics, "AI-powered" badges everywhere, generic FAQ, fake dashboards/team |

**The rule:** ask *"what product-specific reason justifies this element?"* If no convincing
reason exists, replace it with something simpler, more specific, or more useful. A terminal
UI is not bad; a terminal UI used only because "developer websites have terminals" is bad.

## 2. Anti-Slop Design Test

For every major section ask:

- **A. Generic?** Could another AI-generated website contain this exact section? If yes,
  investigate.
- **B. Specific?** Does it communicate product-specific information? If no, remove or
  redesign.
- **C. Meaningful?** Is this decorative element carrying meaning? If no, remove it.
- **D. Memorable?** Memorable because of the product, or because of effects? Prefer
  product-driven memorability.
- **E. Resilient?** Would the design survive with animations, gradients, and shadows
  disabled; JavaScript delayed; images unavailable; reduced motion enabled; mobile viewport?
  It should.

## 3. Product Truth Before Visual Polish

Before any redesign, establish: product, target users, primary job-to-be-done, business
model, primary conversion, important secondary conversions, maturity, competitive context,
brand personality, technical constraints, content constraints, legal constraints,
accessibility requirements, geographic context.

**Never invent:** customers, testimonials, reviews, statistics, awards, integrations,
partnerships, certifications, case studies, team members, logos, or product capabilities.
If evidence does not exist, use honest placeholders or omit the section. **Never create
fake social proof.**

## 4. The 5 / 30 / 5-Minute Test

- **5 seconds** - a stranger understands: *What is this?*
- **30 seconds** - *Why should I care?*
- **5 minutes** - *How does this actually work, and can I trust it?*

No gradient, animation, or testimonial fixes a site that fails these.

## 5. Design Direction Must Be Chosen, Not Generated

### Typography
Choose from product personality, readability, language support, hierarchy, performance, and
licensing. Avoid auto-picking Inter/Geist/Space Grotesk/DM Sans - a conventional font is
fine when genuinely appropriate. Build hierarchy through scale, weight, line-height,
measure, whitespace, and rhythm - not decoration.

### Color system
Never start from purple+black+gradient or blue+white SaaS. Establish: primary, secondary,
semantic colors; surface/text/border hierarchy; interaction states; dark mode if applicable.
Use design tokens - no scattered hex values. **Color must never be the only state signal.**

### Layout
Define content width, reading width, spacing scale, section rhythm, grid behavior,
breakpoints, component density, and alignment rules. No arbitrary `margin-top: 137px`,
unrelated gap values, or inconsistent radii, container widths, button heights, or card
padding. Do not force every page into `Hero -> Features -> Testimonials -> Pricing -> FAQ ->
CTA` - the information architecture must follow the product.

### Component discipline
Reuse components where repetition is a real design rule; avoid both copy-pasted visual
systems and over-engineered abstractions. Every interactive component must define: default,
hover, focus, active, disabled, loading, success, error, empty, and destructive (where
applicable). **AI commonly implements the happy path and forgets the rest.**

### Real product over decorative product
Show real screenshots, real workflows, real data examples, realistic states, interactive
demonstrations, before/after comparisons, actual outputs, and meaningful diagrams. A
decorative fake dashboard is not a product demo.

### Copy quality
Reject: "Unlock your potential", "Transform your workflow", "The future of...", "Powerful.
Simple. Fast.", "Built for the modern...", "Seamlessly", "Revolutionize", "Supercharge",
"Empower your team", "One platform for everything" - unless genuinely appropriate. Prefer
concrete claims, measurable behavior, specific nouns, direct verbs, product and domain
vocabulary, and honest limitations. **Copy should sound like someone who actually built and
uses the product.**

## 6. Human-Design Heuristics

Look for evidence of intentional decisions: product-specific visual language (the design
emerges from the product's domain); asymmetry with purpose; information hierarchy (the
important thing visually dominates); restraint (not every element needs a border, shadow,
background, icon, animation, or badge); content density (don't fill empty space because it
exists); realism (actual product states, not decorative placeholders); continuity (pages
feel like the same product); consistency (repeated behavior looks and behaves alike).

## 7. Design Decision Test

For every major design choice ask: 1) What user problem does this solve? 2) What product
fact does it communicate? 3) What evidence supports it? 4) What is the simplest alternative?
5) Does it improve comprehension? 6) Trust? 7) Conversion? 8) Usability? 9) Does it harm
performance? 10) Accessibility? If the answer is effectively *"It looks cool"* - reconsider.

## 8. Quality Domains

Check each domain only when in scope. Record results; never claim without verification.

### Accessibility - WCAG 2.2 AA baseline
Semantic HTML; heading hierarchy; landmarks; accessible names; labels; keyboard navigation;
visible focus; focus order; focus not obscured; dialog focus management; screen-reader
semantics; form error messaging; autocomplete/input purpose; reduced motion; contrast
(4.5:1 normal, 3:1 large text per SC 1.4.3); text resizing; reflow; touch targets
(24x24px minimum per SC 2.5.8 or qualifying spacing); non-color state communication;
meaningful alt text; captions/transcripts where relevant. Accessibility is not an
afterthought.

### Responsive
Test at minimum 320, 375, 390, 430, 768, 1024, 1280, and 1440+. Do not merely scale desktop
down. Verify navigation, typography, content order, tables, forms, dialogs, images, sticky
controls, overflow/horizontal scrolling, touch targets, keyboard behavior, and landscape
orientation. Preserve hierarchy, not just geometry.

### Motion
Animation must communicate state, preserve spatial continuity, indicate progress, reveal
hierarchy, or improve feedback - never "looks cool". Avoid perpetual floating objects,
excessive parallax, animated gradients, constant shimmer, unnecessary bouncing,
cursor-following decoration, and excessive page transitions. Respect
`prefers-reduced-motion`; the interface must remain usable with animation off.

### Performance - measure, don't guess
Check LCP (<= 2.5s), INP (<= 200ms), CLS (<= 0.1) at the 75th percentile; TTFB; JavaScript,
CSS, image, and font size; third-party scripts; network waterfall; caching; compression;
lazy loading; responsive images; code splitting; unused dependencies; render-blocking
resources. Optimize for user-perceived performance, not Lighthouse points.
**Images:** correct dimensions, responsive variants, appropriate formats, meaningful alt
text, lazy vs priority loading. **Fonts:** deliberate selection, limited weights,
appropriate loading strategy, fallbacks, minimal layout shift.

### SEO / Discoverability
Unique title per page; useful meta description; one meaningful H1; semantic HTML; canonical
URL; robots.txt; XML sitemap; indexability (no accidental noindex); Open Graph metadata and
social preview; descriptive URLs; internal linking; breadcrumbs where useful; structured
data only when it accurately describes the page; correct redirects; 404 handling;
duplicate-URL handling.

### Forms
Every form must be tested for: labels, required/invalid/malformed/long/empty input,
duplicate submission, network failure, server failure, timeout, success, retry,
accessibility, autocomplete, rate limiting, CSRF where applicable, and **server-side
validation** - never trust client-side validation.

### Authentication & Authorization
Secure password handling; session expiration and invalidation; password-reset expiry and
reuse prevention; authentication rate limiting; brute-force resistance; account enumeration
resistance; secure cookies with appropriate SameSite; CSRF protection where applicable;
authorization on every protected operation; reauthentication for sensitive operations;
logout invalidation. **Hidden UI is not authorization - the server must enforce it.** For
every protected resource ask: *can User A reach User B's object by changing an ID?* Test
horizontal/vertical privilege escalation, IDOR/BOLA, direct API calls, hidden/admin
endpoints, object ownership, tenant isolation, role changes, deleted resources, and expired
sessions. Broken Access Control is OWASP Top 10:2025 #1.

### APIs & CORS
Inspect every endpoint: authentication, authorization, input validation, output filtering,
request-size and pagination limits, rate limiting, timeout, idempotency, method
restrictions, error handling, logging, CORS, CSRF where applicable, SSRF protections where
relevant. Never assume the frontend is a security boundary. For CORS ask: which origins
actually need access? Are credentials involved? Public or private API? Are methods and
headers restricted? Is `Vary: Origin` required? Wildcard origins are inappropriate for
credentialed cross-origin requests.

### File uploads
Allowlist extensions; validate actual file type (never trust Content-Type); server-side
filenames; limit filename length and file size; authorize uploads; isolate storage outside
the webroot; avoid executable storage; scan where appropriate; safely process archives
(decompression bombs); protect upload endpoints from CSRF; restrict download access; avoid
path traversal.

### Payments
Never trust client-side prices, client-side subscription state, client-side payment
success, or browser redirects as payment confirmation. Verify payment signatures, webhook
authenticity, idempotency, event replay, duplicate webhooks, currency, product/price
mapping, server-side entitlement, failed payments, refunds, cancellation, and subscription
state transitions.

### AI features
Audit prompt injection (direct and indirect), tool permissions, model-output validation,
system-prompt and secret exposure, excessive autonomy, arbitrary URL fetching (SSRF), tool
abuse, cost/token/context exhaustion, sensitive-data leakage, logging of private prompts,
output encoding, generated-code execution, file handling, and model failure behavior.
Treat model output as untrusted input. Never allow an LLM to silently become a privileged
execution layer.

### Secrets
Search source code, .env files, git history, client bundles, browser storage, logs, error
reports, CI configuration, and Docker images for API keys, tokens, passwords, private keys,
database credentials, and cloud credentials. If a secret was committed: **deleting it is
not enough - rotate it.**

### Security headers
Inspect production responses for Content-Security-Policy, Strict-Transport-Security,
X-Content-Type-Options, Referrer-Policy, frame protections / CSP frame-ancestors, and
Permissions-Policy. Understand the application's requirements before copying a
configuration.

### Database
Least privilege; no public database exposure; parameterized queries; migrations; backups
and a tested restore procedure; indexes; constraints; transaction boundaries; deletion
behavior; tenant isolation; sensitive-field handling; connection limits. "A database that
works is not necessarily a database that is safe."

### Error handling
Every critical operation needs: loading, success, empty, validation failure, authorization
failure, not-found, server error, network failure, retry, and timeout states. Never expose
stack traces, secrets, database errors, internal paths, tokens, or implementation details
to end users.

### Observability
Production applications need structured logs, error tracking, health checks, uptime and
performance monitoring, security-event logging, and audit logs for sensitive actions. Logs
should answer: what happened, when, to what resource, by whom, from where, and what was the
outcome. Never log secrets or unnecessary sensitive data.

### Reliability
Verify graceful failure, retries, timeouts, and idempotency; and behavior when database,
third-party APIs, queues, email, payments, cache, or deployment fail. Ask: *what happens
when every external dependency is unavailable?*

### Deployment
Before launch: production environment variables; no development secrets; HTTPS; domain and
DNS; redirects; caching; compression; reproducible builds; dependency lockfile; migration
and rollback strategy; backups with a restore test; health checks; monitoring; error
reporting. "Works locally" is not a production readiness criterion.

## 9. Evidence-Based Review

Never claim something is fixed merely because code was changed. For every important finding
record: `OBSERVED -> WHY IT MATTERS -> FIX -> VERIFY`. Example: Observed - API accepts an
object ID without an ownership check. Risk - User A may access User B's resource. Fix -
enforce ownership server-side. Verify - replay the request with another user's object ID.

## 10. Severity

- **P0 - Launch blocker:** exposed secret, broken authorization, payment bypass, private
  data exposure, critical authentication flaw, destructive production bug, broken primary
  workflow.
- **P1 - Major:** serious accessibility failure, broken mobile layout, missing critical
  error state, severe performance problem, misleading trust claim, broken SEO/indexability.
- **P2 - Quality:** inconsistent spacing, generic visual pattern, weak hierarchy,
  unnecessary animation, poor copy, redundant components.
- **P3 - Polish:** micro-interaction refinement, subtle typography adjustment, minor visual
  inconsistency.

Never spend P3 effort while P0/P1 issues remain.

## 11. Review Modes

- **AUDIT** - analyze only; return prioritized findings; modify nothing.
- **REDESIGN** - analyze, establish a design direction, then implement. Do not blindly
  rewrite the entire interface.
- **HARDEN** - focus on security, reliability, accessibility, performance, deployment.
- **LAUNCH** - run the complete production-readiness review (Final Launch Gate).
- **ANTI-SLOP** - specifically hunt generic AI-generated design and copy patterns.
- **VERIFY** - confirm previously reported findings are actually fixed.

### Anti-Slop Procedure
1. Inspect the existing product. 2. Identify its domain. 3. Identify its users. 4. Identify
its strongest real assets. 5. Identify generic UI patterns. 6. Identify generic copy.
7. Identify decorative elements. 8. Identify repeated component patterns. 9. Identify
missing product evidence. 10. Establish a design hypothesis. 11. Replace only unjustified
defaults. 12. Preserve useful conventions. 13. Test responsive behavior. 14. Test
accessibility. 15. Test performance. 16. Test the primary workflow. 17. Re-review for
generic patterns. **Do not replace one AI aesthetic with another.**

## 12. Final Launch Gate

Do not declare a project production-ready because the page loads, the build succeeds, the
screenshot looks good, the animation works, the happy path works, or Lighthouse is green.
Readiness requires evidence across:

| Domain | Evidence required |
|---|---|
| Product | clear user value, clear primary action, accurate product claims |
| Design | intentional visual system, no unjustified AI defaults, strong hierarchy, consistent components |
| UX | happy path, empty state, loading state, error state, recovery path |
| Accessibility | keyboard, focus, contrast, semantic HTML, screen-reader semantics, responsive/reflow, touch targets, reduced motion |
| Performance | LCP, INP, and CLS measured; images and fonts optimized; JavaScript reviewed |
| SEO | titles, descriptions, canonicals, sitemap, robots, structured data where appropriate, social metadata, 404 handling |
| Security | authentication, authorization, input validation, rate limiting, CSRF, CORS, headers, secrets, uploads, payments, AI security |
| Reliability | timeouts, retries, idempotency, dependency failures, backups, restore test, rollback plan |
| Observability | error monitoring, structured logging, health checks, security events, critical-workflow monitoring |

## 13. Final Principle

Optimize for *"Does this look like someone cared?"* - not *"Does this look like a good
AI-generated website?"* The best AI-assisted website is not one where AI is invisible; it
is one where **intent is visible**.