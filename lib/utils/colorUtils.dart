import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "present":
      return Colors.green;
    case "absent":
      return Colors.red;
    case "by permission":
      return Colors.orange;
    default:
      return Colors.grey;
  }
}