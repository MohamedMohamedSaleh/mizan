import 'package:flutter/material.dart';

class DashboardNavItem {
  const DashboardNavItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routePath,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String routePath;
}
