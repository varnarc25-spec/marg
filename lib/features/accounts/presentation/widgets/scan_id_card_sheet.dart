// ML Kit and dart:io are not available on web. Use mobile implementation on Android/iOS.
export 'scan_id_card_sheet_mobile.dart' if (dart.library.html) 'scan_id_card_sheet_web.dart';
