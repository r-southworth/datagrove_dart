# use build
flutter pub run build_runner build

flutter pub run intl_generator:extract_to_arb --output-dir=lib/l10n lib/main.dart

flutter pub run intl_generator:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading  lib/main.dart lib/l10n/intl_*.arb

Currently in macos/Runner.xcodeproj
	MACOSX_DEPLOYMENT_TARGET = 10.15;


