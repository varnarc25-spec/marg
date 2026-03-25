import 'package:flutter/material.dart';

IconData healthHomeMemberIcon(String key) {
  switch (key) {
    case 'Myself':
      return Icons.person_rounded;
    case 'Spouse':
      return Icons.favorite_rounded;
    case 'Children':
      return Icons.child_care_rounded;
    case 'Parents':
      return Icons.elderly_rounded;
    default:
      return Icons.person_rounded;
  }
}
