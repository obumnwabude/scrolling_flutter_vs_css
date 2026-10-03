#!/usr/bin/env bash
#
# Builds the CSS demos and the Flutter web app into one static site, and
# pushes it to the `gh-pages` branch, which GitHub Pages serves at:
#
#   https://<user>.github.io/<repo>/          a landing page (pages/index.html)
#   https://<user>.github.io/<repo>/css/      the CSS demos
#   https://<user>.github.io/<repo>/flutter/  the Flutter web app
#
# Nothing runs this automatically. Run it by hand, from anywhere in the
# repository, whenever you want to publish:
#
#   scripts/deploy-pages.sh
#
# `main` never contains build output: the site is built in a temporary
# folder and committed only to `gh-pages`. The first time, set the
# repository's Settings > Pages > Source to "Deploy from a branch", with the
# `gh-pages` branch and the `/ (root)` folder.

set -euo pipefail

FLUTTER="${FLUTTER:-flutter}"
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

# The repository's name, from the `origin` remote. GitHub Pages serves a
# project's site under /<repo>/, so the Flutter app must know that path.
REPO="$(basename -s .git "$(git remote get-url origin)")"
BASE="/$REPO/"

if [ -n "$(git status --porcelain)" ]; then
  echo "Note: you have uncommitted changes. They will be deployed too."
fi

if [ ! -d flutter/web ]; then
  echo "flutter/web is missing. Generate it first, from the flutter folder:"
  echo "  flutter create --org com.obumnwabude --platforms=web,android,ios ."
  exit 1
fi

SITE="$(mktemp -d)"
WORKTREE="$(mktemp -d)"
cleanup() {
  git worktree remove --force "$WORKTREE" 2>/dev/null || true
  rm -rf "$SITE" "$WORKTREE"
}
trap cleanup EXIT

echo "1/4 Building the Flutter web app..."
# --base-href tells the app it lives under /<repo>/flutter/, not at the
# root of the domain. Without it, it can't find its own files.
(cd flutter && $FLUTTER build web --release --base-href "${BASE}flutter/")
cp -R flutter/build/web "$SITE/flutter"

echo "2/4 Copying the CSS demos..."
# Only what the browser needs: no tests, no node_modules, no configs.
mkdir "$SITE/css"
cp css/*.html css/*.css css/*.js "$SITE/css/"

echo "3/4 Adding the landing page..."
cp pages/index.html "$SITE/index.html"
# Tells GitHub Pages to serve the files as they are, without running Jekyll.
touch "$SITE/.nojekyll"

echo "4/4 Pushing to the gh-pages branch..."
# A worktree is a second checkout of the same repository in another folder.
# It lets us commit to gh-pages without leaving (or touching) main.
git fetch --quiet origin gh-pages 2>/dev/null || true
if git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
  git worktree add --quiet -B gh-pages "$WORKTREE" origin/gh-pages
else
  # First deploy: start gh-pages as an empty branch with no history.
  git worktree add --quiet --detach "$WORKTREE"
  git -C "$WORKTREE" checkout --quiet --orphan gh-pages
  git -C "$WORKTREE" rm -rf --quiet .
fi

# Replace everything on the branch with the new site.
find "$WORKTREE" -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
cp -R "$SITE"/. "$WORKTREE"/

git -C "$WORKTREE" add -A
if git -C "$WORKTREE" diff --cached --quiet; then
  echo "Nothing changed since the last deploy."
else
  git -C "$WORKTREE" commit --quiet -m "Deploy from main at $(git rev-parse --short HEAD)"
  git -C "$WORKTREE" push --quiet origin gh-pages
  OWNER="$(git remote get-url origin | sed -E 's#.*[:/]([^/]+)/[^/]+$#\1#')"
  echo "Deployed. In a minute or two, it's live at https://$OWNER.github.io$BASE"
fi
