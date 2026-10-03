# Scrolling Insights: CSS

The CSS side of [Scrolling Insights: Flutter vs CSS](../README.md). One HTML page per scrolling behavior, with its twin in [`../flutter`](../flutter).

## Running

Open `index.html` in a browser. That's it: no build step, no server, no framework.

Each page shows its number and the key CSS for its demo at the top, and floating buttons at the bottom right to move to the previous demo, all demos, or the next demo. Open the page's source to see the rest. Every page starts with a comment that explains the technique and names its Flutter equivalent.

Try the demos with a mouse, a trackpad, and a phone. Scrolling feels different on each, and some demos (like Pull to Refresh) only respond to touch. To try touch on a laptop, turn on device emulation in your browser's dev tools.

## Files

- `index.html`: links to every demo, numbered and grouped the same way as the Flutter app. Each group has its own color.
- `all.css`: styles shared by every page. It defines the three demo colors as CSS variables (`--container`, `--child`, `--highlight`), the `.block` box that every demo is built from, and `.stack`, a vertical list with gaps.
- `fill.js`: fills any element that has a `data-fill="N"` attribute with N red items. It only keeps the HTML short. It has nothing to do with scrolling.
- One `.html` file per demo. Each page has its own `<style>` (and a `<script>`, where JavaScript is needed), so you can read a demo in one file.

## JavaScript

Most demos are pure CSS. Five use a little JavaScript, because CSS can't do that part on its own:

- Occupy Free Space or Scroll: the "Add item" button.
- Floating Header: knowing which way you are scrolling.
- Scroll Programmatically: `scrollTo()` and `scrollIntoView()` (though the `#item-25` link works with no JavaScript).
- Infinite List: an `IntersectionObserver` to load more items.
- Pull to Refresh: touch events to follow the pull.

## Browser Support

Most of what these demos use works in every current browser. Two features are newer:

- Scroll-driven animations (`animation-timeline: scroll()`), used in Collapsing Header and Scroll Progress.
- `scrollbar-color` and `scrollbar-width`, used in Custom Scrollbar.

Where a browser lacks them, the demos still work: the header still collapses (without shrinking its title), the progress bar stays hidden, and the scrollbar keeps its default look (or uses the `::-webkit-scrollbar` fallback). Check [caniuse.com](https://caniuse.com) for current support.

## Tests

`tests/scrolling.spec.ts` uses [Playwright](https://playwright.dev) to open each page in Chrome and check that it scrolls (or doesn't) as the demo says. Every test runs on a desktop viewport, except Pull to Refresh (tagged `@mobile`), which runs on a phone-sized, touch-enabled one. The tests and `playwright.config.ts` are in TypeScript. Playwright runs them directly, with no build step.

You need [Node.js](https://nodejs.org). Then, from this folder:

```bash
npm install
npx playwright install chromium
npm test
```

Other scripts:

- `npm run test:ui` opens Playwright's UI mode, where you can run each test and watch it scroll, step by step.
- `npm run typecheck` checks the types in the tests with the TypeScript compiler.
- `npm run report` opens the HTML report of the last run.

## Running from VS Code

Open the repository's root folder in VS Code. In the Run and Debug view, pick:

- CSS demos in Chrome: opens `index.html` in Chrome, with the debugger attached.
- CSS tests: runs `npm test` in a terminal.
- Flutter and CSS side by side: opens the Flutter app and the CSS demos in two Chrome windows.

With the recommended Playwright extension, you can also run each test from the Testing view.
