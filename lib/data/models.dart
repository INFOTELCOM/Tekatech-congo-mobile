import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String title;
  final IconData icon;
  final String heroTitle;
  final String heroSubtitle;
  final List<String> included;
  final List<ServiceCase> whenToCall;

  const ServiceItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.included,
    required this.whenToCall,
  });
}

class ServiceCase {
  final String title;
  final String description;
  const ServiceCase(this.title, this.description);
}

class NewsArticle {
  final String id;
  final String title;
  final String date;
  final String excerpt;
  final List<String> paragraphs;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.paragraphs,
  });
}

class FaqItem {
  final String question;
  final String answer;
  const FaqItem(this.question, this.answer);
}

class ProcessStep {
  final String number;
  final String title;
  final String description;
  const ProcessStep(this.number, this.title, this.description);
}

class ValueItem {
  final String title;
  final String description;
  final IconData icon;
  const ValueItem(this.title, this.description, this.icon);
}
