.PHONY: all format analyze test test-engine test-app fix clean run run-widgetbook

# Device to run on: chrome, macos, ios, android (default: chrome)
DEVICE ?= chrome

## Run all checks (format, analyze, test)
all: format analyze test

## Run the app (use DEVICE=macos, DEVICE=ios, etc.)
run:
	cd apps/grids && flutter run -d $(DEVICE)

## Run the Widgetbook background demo
run-widgetbook:
	cd apps/grids && flutter run -d $(DEVICE) -t tool/background_demo.dart

## Format all Dart code
format:
	dart format .

## Run the analyzer across all packages
analyze:
	flutter analyze apps/ packages/

## Run all tests
test: test-engine test-app

## Run engine tests (pure Dart — no Flutter SDK needed)
test-engine:
	cd packages/engine && dart test

## Run app tests
test-app:
	cd apps/grids && flutter test

## Apply auto-fixes
fix:
	dart fix --apply

## Delete build artifacts
clean:
	cd apps/grids && flutter clean
	cd packages/engine && rm -rf .dart_tool
	cd packages/tools && rm -rf .dart_tool
