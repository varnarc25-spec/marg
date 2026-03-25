import 'package:flutter/foundation.dart';
import 'home_section.dart';

@immutable
class HomeResponse {
  const HomeResponse({required this.status, required this.sections});

  final String status;
  final List<HomeSection> sections;
}
