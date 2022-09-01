Currently this does not work with stable flutter, it requires at least beta to fix some bugs in the flutter/webview event system

# use build
flutter pub run build_runner build

flutter pub run intl_generator:extract_to_arb --output-dir=lib/l10n lib/main.dart

flutter pub run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading  lib/main.dart lib/l10n/intl_*.arb

Currently in macos/Runner.xcodeproj
	MACOSX_DEPLOYMENT_TARGET = 10.15;


