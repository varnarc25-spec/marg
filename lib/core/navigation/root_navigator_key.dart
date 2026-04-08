import 'package:flutter/material.dart';

/// Single root navigator for [MaterialApp]. Onboarding must use this so pushes
/// are not dropped when [languageProvider] / theme rebuild [MaterialApp].
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
