# Intellizen Automation Solutions – website

Static marketing site built with Vite, React 19, TypeScript, React Router and Motion.

## Requirements

- Node.js 22.22 or later.
- Microsoft Edge or Google Chrome on the machine that runs `npm run build`, for prerendering. Set `BROWSER_PATH` if it is installed somewhere unusual.

## Scripts

```bash
npm install
npm run dev      # local dev server
npm run build    # sitemap, WebP images, type-check, build to dist/ and prerender every page
npm run images   # only refresh the WebP image sizes
npm run preview  # serve the built dist/ folder
npm run lint
```

## Images

- Product photos live in `public/assets/products/<slug>/render-N.jpg` (2400px) with a `-sm.jpg` (1200px). Blog covers are `public/assets/blog/<slug>.jpg` (1600px).
- `scripts/image-variants.mjs` makes WebP copies of each one at 480px (`-xs`), 800px (`-md`), 1200px (`-sm`) and full size. It runs as part of the build and only redoes images whose JPEG changed; `--force` redoes all of them.
- Components get the WebP set through `srcSetFor()` and `thumbVersion()` in `src/utils/image.ts`, so browsers download the smallest size that fits. The JPEGs stay for social previews and as the `src` fallback.

## SEO

- `npm run build` writes `public/sitemap.xml` from the page list in `scripts/generate-sitemap.mjs`, then `scripts/prerender.mjs` opens every sitemap URL in a headless browser and saves the rendered HTML to `dist/<route>/index.html`. Search engines and link previews get the real title, description, canonical URL, Open Graph tags, structured data and page text without running JavaScript.
- If no browser is found, prerendering is skipped with a warning and the site still works as a single-page app. Build locally (or on a CI image with Chrome) to deploy the prerendered version.
- Unknown URLs get `dist/404.html` with a real 404 status on Apache (`public/.htaccess`) and Netlify. Vercel still falls back to `dist/app.html` through `vercel.json`; the not-found page carries `noindex` either way. If prerendering is skipped, `.htaccess` and a generated `dist/_redirects` fall back to `index.html` so the single-page app keeps working.
- Each page sets its own tags through `src/components/ui/Seo/Seo.tsx`. Shared structured data (organisation, local business, breadcrumbs, FAQ) lives in `src/data/schema.ts`.
- The live domain is set in `siteUrl` in `src/data/site.ts` and in `public/robots.txt`. Update both if the domain changes.

## After launch

1. Add the site to Google Search Console and Bing Webmaster Tools and submit `https://intellizen.co.in/sitemap.xml`.
2. Create or claim the Google Business Profile for the Derabassi address so the local listing matches the website.
3. Before adding analytics or advertising tags for a campaign, update `src/data/legal.ts` (Privacy and Cookie Policy) and add a consent banner where required.

## Assets

- Logos, product photos and icons live in `public/assets/`.
- Product and blog illustrations are rendered by `node scripts/product-art/render.mjs` (needs Edge or Chrome). Each product has a 2400px image and a 1200px `-sm` version used on smaller screens.
- Real photos can replace the illustrations by updating the `images` and `imageAlts` lists in `src/data/products.ts`.
