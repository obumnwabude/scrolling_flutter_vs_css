#!/usr/bin/env bash
#
# Builds the Android app (APK) and publishes it as a GitHub Release, so
# anyone can download it and install it on their phone.
#
# Nothing runs this automatically. Run it by hand, from anywhere in the
# repository:
#
#   scripts/release-apk.sh
#
# It needs the GitHub CLI (https://cli.github.com), signed in with
# `gh auth login`. The release is tagged with the version in
# flutter/pubspec.yaml (`version: 1.0.0+2` becomes `v1.0.0`), so bump that
# version before each new release.

set -euo pipefail

FLUTTER="${FLUTTER:-flutter}"
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT/flutter"

if [ ! -d android ]; then
  echo "flutter/android is missing. Generate it first, from the flutter folder:"
  echo "  flutter create --org com.obumnwabude --platforms=web,android,ios ."
  exit 1
fi

# The version before the "+", like 1.0.0.
VERSION="$(sed -nE 's/^version: *([^+ ]+).*/\1/p' pubspec.yaml)"
TAG="v$VERSION"
APK="scrolling-insights-$TAG.apk"

if git rev-parse --quiet --verify "refs/tags/$TAG" >/dev/null; then
  echo "$TAG already exists. Bump the version in flutter/pubspec.yaml first."
  exit 1
fi

echo "1/2 Building the APK..."
# One APK that runs on every Android phone. It is signed with the debug
# key unless you set up your own (see flutter.dev/to/android-signing), which
# is fine for a demo app that people install by hand.
$FLUTTER build apk --release
cp build/app/outputs/flutter-apk/app-release.apk "build/$APK"

echo "2/2 Creating the $TAG release on GitHub..."
gh release create "$TAG" "build/$APK" \
  --title "Scrolling Insights $TAG" \
  --notes "The Flutter demos of Scrolling Insights: Flutter vs CSS, as an Android app.

Download \`$APK\` on your Android phone and open it to install. Your phone may ask you to allow installing apps from your browser or files app first."

echo "Done. The release is at: $(gh release view "$TAG" --json url --jq .url)"
