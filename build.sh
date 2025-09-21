#!/bin/bash
echo "Running build_runner to generate json_serializable code..."
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "Build completed!"