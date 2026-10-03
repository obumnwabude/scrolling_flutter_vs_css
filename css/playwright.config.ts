import { defineConfig, devices } from '@playwright/test';

// Playwright runs this TypeScript file (and the tests) directly. No build
// step. `npm run typecheck` checks the types with the TypeScript compiler.
export default defineConfig({
  testDir: 'tests',
  projects: [
    // Every test, except the ones tagged @mobile, runs in desktop Chrome.
    {
      name: 'desktop',
      use: { ...devices['Desktop Chrome'] },
      grepInvert: /@mobile/,
    },
    // Tests tagged @mobile (like pull to refresh, which needs touch) run in
    // a phone-sized, touch-enabled Chrome instead.
    {
      name: 'mobile',
      use: { ...devices['Pixel 7'] },
      grep: /@mobile/,
    },
  ],
});
