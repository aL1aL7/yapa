#!/usr/bin/env bash
set -e

# Read current version from pubspec.yaml (e.g. "1.0.2+5")
CURRENT=$(grep '^version:' pubspec.yaml | sed 's/version: //')
VERSION_NAME="${CURRENT%+*}"

NEW_VERSION="${VERSION_NAME}"

# Update pubspec.yaml
sed -i "s/^version: .*/version: ${NEW_VERSION}/" pubspec.yaml

echo "Building ${VERSION_NAME} ..."

flutter build apk --release

# Rename APK to yapa-{versionName}.apk
APK_SRC="build/app/outputs/flutter-apk/app-release.apk"
APK_DST="build/app/outputs/flutter-apk/yapa-${NEW_VERSION}.apk"
mv "$APK_SRC" "$APK_DST"

echo ""
echo "Done: ${APK_DST}  (build ${NEW_VERSION})"
