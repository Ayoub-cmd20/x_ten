import 'package:flutter/material.dart';

class ProfessionalService {
  final String id;
  final String title;
  final String shortDescription;
  final String description;
  final IconData icon;

  final List<String> features;

  final String? priceFrom;

  const ProfessionalService({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.icon,
    required this.features,
    this.priceFrom,
  });
}