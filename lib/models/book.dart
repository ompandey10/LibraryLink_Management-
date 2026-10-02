import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum BookStatus { available, issued, reserved, returned }

extension BookStatusX on BookStatus {
  String get label {
    switch (this) {
      case BookStatus.available:
        return 'Available';
      case BookStatus.issued:
        return 'Issued';
      case BookStatus.reserved:
        return 'Reserved';
      case BookStatus.returned:
        return 'Returned';
    }
  }

  Color get color {
    switch (this) {
      case BookStatus.available:
        return AppTheme.statusAvailable;
      case BookStatus.issued:
        return AppTheme.statusIssued;
      case BookStatus.reserved:
        return AppTheme.statusReserved;
      case BookStatus.returned:
        return AppTheme.statusReturned;
    }
  }

  IconData get icon {
    switch (this) {
      case BookStatus.available:
        return Icons.check_circle_outline_rounded;
      case BookStatus.issued:
        return Icons.schedule_rounded;
      case BookStatus.reserved:
        return Icons.bookmark_border_rounded;
      case BookStatus.returned:
        return Icons.history_rounded;
    }
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final String isbn;
  final String description;
  final String category;
  final int pages;
  final int year; // Keep for backward compatibility
  final String coverUrl; // Keep for backward compatibility

  // New fields
  final String? publisher;
  final int? publicationYear;
  final String? language;
  final String? coverImageUrl;
  final String? shelfLocation;
  int totalCopies;
  int availableCopies;
  final double? rating;
  final List<String>? tags;
  final DateTime? dateAdded;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Legacy state fields (to keep old UI working if they directly access it, though we will update UI)
  BookStatus status;
  DateTime? dueDate;
  DateTime? issueDate;
  String? reservedBy;
  String? issuedTo;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.description,
    required this.category,
    required this.pages,
    required this.year,
    required this.coverUrl,
    this.publisher,
    this.publicationYear,
    this.language,
    this.coverImageUrl,
    this.shelfLocation,
    this.totalCopies = 1,
    int? availableCopies,
    this.rating,
    this.tags,
    this.dateAdded,
    this.createdAt,
    this.updatedAt,
    this.status = BookStatus.available,
    this.dueDate,
    this.issueDate,
    this.reservedBy,
    this.issuedTo,
  }) : availableCopies = availableCopies ?? 1;

  bool get isOverdue =>
      status == BookStatus.issued &&
      dueDate != null &&
      dueDate!.isBefore(DateTime.now());

  int get daysLeft =>
      dueDate != null ? dueDate!.difference(DateTime.now()).inDays : 0;

  String get effectiveCoverUrl => coverImageUrl ?? coverUrl;
  int get effectiveYear => publicationYear ?? year;
}

class CirculationRecord {
  final String id;
  final String bookId;
  final Book book; // Reference for easy display
  final String memberName;
  final DateTime issueDate;
  final DateTime? dueDate;
  DateTime? returnDate;
  BookStatus status;

  CirculationRecord({
    required this.id,
    required this.bookId,
    required this.book,
    required this.memberName,
    required this.issueDate,
    this.dueDate,
    this.returnDate,
    this.status = BookStatus.issued,
  });

  bool get isOverdue =>
      status == BookStatus.issued &&
      dueDate != null &&
      dueDate!.isBefore(DateTime.now());

  int get daysLeft =>
      dueDate != null ? dueDate!.difference(DateTime.now()).inDays : 0;
}
