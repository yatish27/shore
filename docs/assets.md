# Asset Pipeline

Shore uses a modern Rails 8 asset pipeline with three gems working together:

- **[Propshaft](https://github.com/rails/propshaft)** — Fingerprints assets and moves them to public. Replaces Sprockets. It does not compile or transform anything.
- **[jsbundling-rails](https://github.com/rails/jsbundling-rails)** — Hooks into `rails assets:precompile` to bundle JavaScript via Bun.
- **[cssbundling-rails](https://github.com/rails/cssbundling-rails)** — Hooks into `rails assets:precompile` to compile CSS via Tailwind.

## How it fits together

```
Source JS/TSX ──→ Bun ──→ Built JS ──→ Propshaft ──→ public/assets
Source CSS ──→ Tailwind ──→ Built CSS ──→ Propshaft ──→ public/assets
Static files (images, fonts) ──→ Propshaft ──→ public/assets
```

## What Bun does

Bun is the package manager and bundler. It replaces npm and esbuild. It bundles all JS and TSX into IIFE format with external source maps.

## What Propshaft does

Propshaft fingerprints assets and moves them to public. It appends a digest hash to each filename, enabling far-future cache headers. It does not compile, minify, or transform assets — that is Bun and Tailwind's job.

## Development

In development, Bun and Tailwind run in watch mode alongside the Rails server. When you edit JavaScript or TypeScript, Bun rebuilds. When you edit Tailwind classes, the Tailwind watcher rebuilds CSS.

## Production

In the Dockerfile, assets are precompiled during the image build:

1. `bun install` — Installs JS dependencies
2. `rails assets:precompile` — Triggers Bun to bundle JS, Tailwind to compile CSS, and Propshaft to fingerprint and move everything to public
3. `node_modules` is removed to keep the Docker image small

```
rails assets:precompile
│
│  Step 1: Build assets
│
├──→ jsbundling-rails ──→ bun run build ──→ app/assets/builds/
├──→ cssbundling-rails ──→ bun run build:css ──→ app/assets/builds/
│
│  Step 2: Fingerprint and publish
│
└──→ Propshaft ──→ Fingerprints all assets ──→ public/assets/
```

Assets are served with a 1-year cache header since every file is fingerprinted with a unique digest.

## Layouts

There are two layouts, each loading different JavaScript:

- **Default layout** — Loads standard JS for regular Rails pages
- **Inertia layout** — Loads the React + Inertia bundle for interactive pages

Both share the same Tailwind CSS.
