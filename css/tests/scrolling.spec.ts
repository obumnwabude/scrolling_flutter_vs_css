// Playwright tests for every CSS demo. Run them with `npm test`.
//
// Each test opens a demo page in a real browser (Chrome), scrolls it the way
// a user (or a script) would, and checks the result: usually a scroll offset
// (`scrollTop`, `scrollLeft`) or where an element sits on screen. They are
// the CSS twins of flutter/test/widget_test.dart.
import * as path from 'node:path';
import { test, expect, type Page } from '@playwright/test';

/** The file name of every demo page (without `.html`), and its title. */
const demos = [
  ['how-to-scroll', 'How to Scroll'],
  ['horizontal-scroll', 'Horizontal Scroll'],
  ['prevent-scroll', 'Prevent Scroll'],
  ['nested-scrolling', 'Nested Scrolling'],
  ['pin-item-on-scroll', 'Pin Item on Scroll'],
  ['sticky-section-headers', 'Sticky Section Headers'],
  ['occupy-free-space-or-scroll', 'Occupy Free Space or Scroll'],
  ['collapsing-header', 'Collapsing Header'],
  ['floating-header', 'Floating Header'],
  ['scroll-snap', 'Scroll Snap'],
  ['overscroll-behavior', 'Overscroll Behavior'],
  ['custom-scrollbar', 'Custom Scrollbar'],
  ['scroll-programmatically', 'Scroll Programmatically'],
  ['scroll-progress', 'Scroll Progress'],
  ['infinite-list', 'Infinite List'],
  ['pull-to-refresh', 'Pull to Refresh'],
  ['two-dimensional-scroll', 'Two-Dimensional Scroll'],
] as const;

/** A demo page's file name, like `'how-to-scroll'`, or `'index'`. */
type PageName = (typeof demos)[number][0] | 'index';

/** Opens a demo page straight from disk. No server needed. */
async function open(page: Page, name: PageName) {
  await page.goto('file://' + path.join(__dirname, '..', `${name}.html`));
}

/** The scroll offsets of the element matching [selector]. */
function scrollOf(page: Page, selector: string) {
  return page
    .locator(selector)
    .first()
    .evaluate((el) => ({ top: el.scrollTop, left: el.scrollLeft }));
}

/** Scrolls the element matching [selector] by [top] and [left] pixels. */
async function scrollBy(page: Page, selector: string, top: number, left = 0) {
  await page
    .locator(selector)
    .first()
    .evaluate((el, [top, left]) => el.scrollBy({ top, left, behavior: 'instant' }), [top, left]);
}

/** The position and size of the element matching [selector] on screen. */
async function boxOf(page: Page, selector: string) {
  const box = await page.locator(selector).first().boundingBox();
  if (box === null) throw new Error(`${selector} is not visible`);
  return box;
}

/** The top of the element matching [selector], relative to the viewport. */
function topOf(page: Page, selector: string) {
  return page
    .locator(selector)
    .first()
    .evaluate((el) => el.getBoundingClientRect().top);
}

test('the index links to every demo, numbered in order', async ({ page }) => {
  await open(page, 'index');
  for (const [i, [name, title]] of demos.entries()) {
    const link = page.locator(`a[href="${name}.html"]`);
    await expect(link.locator('.number')).toHaveText(`${i + 1}`);
    await expect(link.locator('.title')).toHaveText(title);
  }
});

test('the floating buttons go to the previous and next demos', async ({ page }) => {
  await open(page, 'horizontal-scroll');
  await page.getByRole('link', { name: 'Next: Prevent Scroll' }).click();
  await expect(page.locator('h1 .title')).toHaveText('Prevent Scroll');
  await page.getByRole('link', { name: 'Previous: Horizontal Scroll' }).click();
  await expect(page.locator('h1 .title')).toHaveText('Horizontal Scroll');
  await page.locator('.demo-nav').getByRole('link', { name: 'All demos' }).click();
  await expect(page.locator('h1')).toHaveText('Scrolling Insights');
});

for (const [name, title] of demos) {
  test(`${title} opens without errors`, async ({ page }) => {
    const errors: Error[] = [];
    page.on('pageerror', (error) => errors.push(error));
    await open(page, name);
    await expect(page.locator('h1 .title')).toHaveText(title);
    expect(errors).toEqual([]);
  });
}

test('How to Scroll: the page scrolls by default', async ({ page }) => {
  await open(page, 'how-to-scroll');
  await page.mouse.wheel(0, 300);
  await expect.poll(() => page.evaluate(() => scrollY)).toBeGreaterThan(0);
});

test('Horizontal Scroll: the row scrolls sideways', async ({ page }) => {
  await open(page, 'horizontal-scroll');
  await scrollBy(page, '.row', 0, 300);
  expect((await scrollOf(page, '.row')).left).toBeGreaterThan(0);
});

test('Prevent Scroll: the wheel does nothing', async ({ page }) => {
  await open(page, 'prevent-scroll');
  await page.mouse.wheel(0, 300);
  await page.waitForTimeout(200);
  expect(await page.evaluate(() => scrollY)).toBe(0);
});

test('Nested Scrolling: inner boxes scroll, the last one grows', async ({ page }) => {
  await open(page, 'nested-scrolling');
  await scrollBy(page, '.same-direction', 100);
  expect((await scrollOf(page, '.same-direction')).top).toBeGreaterThan(0);
  await scrollBy(page, '.opposite-direction', 0, 100);
  expect((await scrollOf(page, '.opposite-direction')).left).toBeGreaterThan(0);
  const grows = page.locator('.grows');
  expect(await grows.evaluate((el) => el.scrollHeight - el.clientHeight)).toBe(0);
});

test('Pin Item on Scroll: the item stays at the top', async ({ page }) => {
  await open(page, 'pin-item-on-scroll');
  await scrollBy(page, '.scroller', 2000);
  const scrollerTop = await topOf(page, '.scroller');
  // 16px of padding at the top of the scroller.
  expect(await topOf(page, '.pinned')).toBeCloseTo(scrollerTop + 16, 0);
});

test('Sticky Section Headers: a header sticks in its section', async ({ page }) => {
  await open(page, 'sticky-section-headers');
  await scrollBy(page, '.scroller', 300);
  const scrollerTop = await topOf(page, '.scroller');
  expect(await topOf(page, 'section:nth-child(1) h3')).toBeCloseTo(scrollerTop, 0);
  await scrollBy(page, '.scroller', 2000);
  expect(await topOf(page, 'section:nth-child(1) h3')).toBeLessThan(scrollerTop);
});

test('Occupy Free Space or Scroll: fills, then scrolls', async ({ page }) => {
  await open(page, 'occupy-free-space-or-scroll');
  const scroller = page.locator('.scroller');
  const overflow = () => scroller.evaluate((el) => el.scrollHeight - el.clientHeight);
  expect((await boxOf(page, '.filler')).height).toBeGreaterThan(120);
  expect(await overflow()).toBe(0);
  for (let i = 0; i < 10; i++) await page.click('#add');
  expect(await overflow()).toBeGreaterThan(0);
});

test('Collapsing Header: leaves a 56px bar pinned', async ({ page }) => {
  await open(page, 'collapsing-header');
  await scrollBy(page, '.scroller', 1000);
  const scrollerTop = await topOf(page, '.scroller');
  const header = await boxOf(page, '.header');
  expect(header.y + header.height - scrollerTop).toBeCloseTo(56, 0);
});

test('Floating Header: hides on scroll down, shows on scroll up', async ({ page }) => {
  await open(page, 'floating-header');
  await scrollBy(page, '.scroller', 600);
  await expect(page.locator('.header')).toHaveClass(/hidden/);
  await scrollBy(page, '.scroller', -50);
  await expect(page.locator('.header')).not.toHaveClass(/hidden/);
});

test('Scroll Snap: comes to rest on a whole card', async ({ page }) => {
  await open(page, 'scroll-snap');
  await scrollBy(page, '.carousel', 0, 100);
  await page.waitForTimeout(500);
  const carousel = await boxOf(page, '.carousel');
  const centers = await page.locator('.carousel > div').evaluateAll((cards) =>
    cards.map((card) => {
      const box = card.getBoundingClientRect();
      return box.left + box.width / 2;
    })
  );
  const middle = carousel.x + carousel.width / 2;
  expect(centers.some((center) => Math.abs(center - middle) < 2)).toBe(true);
});

test('Overscroll Behavior: contain sets the property', async ({ page }) => {
  await open(page, 'overscroll-behavior');
  await expect(page.locator('.contain')).toHaveCSS('overscroll-behavior-y', 'contain');
  await expect(page.locator('.inner').first()).toHaveCSS('overscroll-behavior-y', 'auto');
});

test('Custom Scrollbar: uses the demo colors', async ({ page }) => {
  await open(page, 'custom-scrollbar');
  await expect(page.locator('.scroller')).toHaveCSS('scrollbar-color', 'rgb(76, 175, 80) rgb(179, 229, 252)');
});

test('Scroll Programmatically: buttons move the list', async ({ page }) => {
  await open(page, 'scroll-programmatically');
  const scroller = page.locator('.scroller');
  await page.click('#bottom');
  await expect
    .poll(() => scroller.evaluate((el) => el.scrollTop + el.clientHeight - el.scrollHeight))
    .toBeGreaterThan(-2);
  await page.click('#top');
  await expect.poll(() => scrollOf(page, '.scroller').then((s) => s.top)).toBe(0);
  await page.click('#item');
  await expect(page.locator('#item-25')).toBeInViewport();
});

test('Scroll Progress: the bar fills as you scroll', async ({ page }) => {
  await open(page, 'scroll-progress');
  const width = () => page.locator('.progress').evaluate((el) => el.getBoundingClientRect().width);
  expect(await width()).toBeCloseTo(0, 0);
  await scrollBy(page, '.scroller', 500);
  await expect.poll(width).toBeGreaterThan(0);
});

test('Infinite List: loads more near the end', async ({ page }) => {
  await open(page, 'infinite-list');
  await expect(page.locator('.stack > div')).toHaveCount(20);
  await page.evaluate(() => scrollTo({ top: document.body.scrollHeight, behavior: 'instant' }));
  await expect(page.locator('.stack > div')).toHaveCount(40);
});

test('Two-Dimensional Scroll: one box scrolls both ways', async ({ page }) => {
  await open(page, 'two-dimensional-scroll');
  await scrollBy(page, '.grid-scroller', 200, 200);
  const { top, left } = await scrollOf(page, '.grid-scroller');
  expect(top).toBeGreaterThan(0);
  expect(left).toBeGreaterThan(0);
});

// Tagged @mobile, so it runs in the phone-sized project only (see
// playwright.config.ts).
test('Pull to Refresh: pulling down refreshes', { tag: '@mobile' }, async ({ page }) => {
  await open(page, 'pull-to-refresh');
  const scroller = page.locator('.scroller');
  const touch = (type: 'touchstart' | 'touchmove' | 'touchend', y: number) =>
    scroller.dispatchEvent(type, {
      touches: type === 'touchend' ? [] : [{ identifier: 0, clientX: 100, clientY: y }],
    });
  await expect(page.getByText('Refreshed 0 times')).toBeVisible();
  await touch('touchstart', 200);
  await touch('touchmove', 300);
  await touch('touchend', 300);
  await expect(page.getByText('Refreshed 1 time')).toBeVisible();
});
