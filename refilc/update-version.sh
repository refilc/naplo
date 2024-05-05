#!/bin/sh

# Ask for version
echo "Enter new version (5.0.0):"
read version

# Ask for build number
echo "Enter new build number (250):"
read build

# Update version in pubspec.yaml
sed -i '' "s/version: .*/version: $version+$build/" pubspec.yaml

# Update version in project.pbxproj
sed -i '' "s/CURRENT_PROJECT_VERSION = .*/CURRENT_PROJECT_VERSION = $build;/" ios/Runner.xcodeproj/project.pbxproj
sed -i '' "s/MARKETING_VERSION = .*/MARKETING_VERSION = $version;/" ios/Runner.xcodeproj/project.pbxproj
