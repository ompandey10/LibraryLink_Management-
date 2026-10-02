import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../theme/app_theme.dart';

class BookDetailScreen extends StatelessWidget {
  final String bookId;
  const BookDetailScreen({super.key, required this.bookId});

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LibraryProvider>(
      builder: (context, p, _) {
        final b = p.getById(bookId);
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: CustomScrollView(
            slivers: [
              // ── Hero AppBar ──
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                iconTheme: IconThemeData(color: theme.colorScheme.primary),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Blurred background
                      Image.network(b.effectiveCoverUrl, fit: BoxFit.cover),
                      Container(
                        color: theme.colorScheme.surface.withOpacity(0.85),
                      ),
                      // Centered clear cover
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              b.effectiveCoverUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Container(
                                width: 140,
                                height: 210,
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.menu_book,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Body ──
              SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (ctx, constraints) {
                    final pad = math.max(
                      24.0,
                      (constraints.maxWidth - 800) / 2,
                    );
                    return Container(
                      color: theme.scaffoldBackgroundColor,
                      padding: EdgeInsets.fromLTRB(pad, 24, pad, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(b.title, style: theme.textTheme.headlineLarge),
                          const SizedBox(height: 8),
                          Text(
                            'By ${b.author}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tags row
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _statusTag(b.status),
                              _tag('${b.effectiveYear}', theme),
                              _tag('${b.pages} pages', theme),
                              if (b.rating != null)
                                _tag('★ ${b.rating}', theme),
                              if (b.language != null) _tag(b.language!, theme),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'ISBN ${b.isbn} ${b.publisher != null ? " • ${b.publisher}" : ""}',
                            style: theme.textTheme.bodySmall,
                          ),

                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 24),

                          // Description
                          Text(
                            'SYNOPSIS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            b.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 24),

                          // ── Actions ──
                          Text(
                            'Availability: ${b.availableCopies} of ${b.totalCopies}',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          if (b.availableCopies > 0 ||
                              b.status == BookStatus.available)
                            _availableActions(context, p, b, theme),
                          if (b.availableCopies < b.totalCopies)
                            _issuedInfo(context, p, b, theme),
                          if (b.status == BookStatus.reserved)
                            _reservedInfo(context, p, b, theme),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tag(String t, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Text(t, style: theme.textTheme.bodySmall),
    );
  }

  Widget _statusTag(BookStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: status.color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              color: status.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ── Available ───────────────────────────────────────────────

  Widget _availableActions(
    BuildContext ctx,
    LibraryProvider p,
    Book b,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACTIONS',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _issueDialog(ctx, p, b, theme),
                icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                label: const Text('Issue Book'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _reserveDialog(ctx, p, b, theme),
                icon: const Icon(Icons.touch_app_outlined, size: 20),
                label: const Text('Reserve'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Issued ──────────────────────────────────────────────────

  Widget _issuedInfo(
    BuildContext ctx,
    LibraryProvider p,
    Book b,
    ThemeData theme,
  ) {
    final activeRecords = p.circulationRecords
        .where((r) => r.bookId == b.id && r.status == BookStatus.issued)
        .toList();
    if (activeRecords.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'ACTIVE CIRCULATION',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        ...activeRecords.map((r) {
          final over = r.isOverdue;
          final d = r.daysLeft.abs();
          final c = over ? AppTheme.statusOverdue : AppTheme.statusIssued;
          return Column(
            children: [
              _infoBox(theme, c, [
                _kv('Patron', r.memberName, theme),
                _kv('Issued', _fmt(r.issueDate), theme),
                _kv('Due Date', _fmt(r.dueDate), theme),
                _kv(
                  'Status',
                  over
                      ? 'Overdue by $d day${d == 1 ? "" : "s"}'
                      : '$d day${d == 1 ? "" : "s"} remaining',
                  theme,
                  color: c,
                ),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    p.returnBook(b.id);
                    Navigator.pop(ctx);
                    _snack(ctx, '${b.title} returned', theme);
                  },
                  icon: const Icon(Icons.assignment_return_outlined, size: 20),
                  label: const Text('Process Return'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  // ── Reserved ────────────────────────────────────────────────

  Widget _reservedInfo(
    BuildContext ctx,
    LibraryProvider p,
    Book b,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'RESERVATION STATUS',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        _infoBox(theme, AppTheme.statusReserved, [
          _kv('Patron', b.reservedBy ?? '—', theme),
          _kv('Status', 'Awaiting pickup', theme),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              p.cancelReservation(b.id);
              Navigator.pop(ctx);
              _snack(ctx, 'Reservation cancelled', theme);
            },
            icon: const Icon(Icons.cancel_outlined, size: 20),
            label: const Text('Cancel Reservation'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.statusOverdue,
              side: const BorderSide(color: AppTheme.statusOverdue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Shared helpers ──────────────────────────────────────────

  Widget _infoBox(ThemeData theme, Color borderColor, List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: Column(children: rows),
    );
  }

  Widget _kv(String k, String v, ThemeData theme, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: theme.textTheme.bodySmall),
          Text(
            v,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext ctx, String msg, ThemeData theme) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────

  void _issueDialog(
    BuildContext ctx,
    LibraryProvider p,
    Book b,
    ThemeData theme,
  ) {
    final nc = TextEditingController();
    int days = 14;
    showDialog(
      context: ctx,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (dCtx, setS) {
            return AlertDialog(
              title: const Text('Issue Book'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.title, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nc,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      labelText: 'Patron Name',
                      labelStyle: theme.textTheme.bodyMedium,
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Duration',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [7, 14, 21, 30].map((d) {
                      final sel = days == d;
                      return GestureDetector(
                        onTap: () => setS(() => days = d),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: sel
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sel
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            '$d days',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: sel
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: sel
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final n = nc.text.trim();
                    if (n.isEmpty) return;
                    p.issueBook(b.id, n, days);
                    Navigator.pop(dCtx);
                    _snack(ctx, 'Issued to $n for $days days', theme);
                  },
                  child: const Text('Confirm Issue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _reserveDialog(
    BuildContext ctx,
    LibraryProvider p,
    Book b,
    ThemeData theme,
  ) {
    final nc = TextEditingController();
    showDialog(
      context: ctx,
      builder: (dCtx) {
        return AlertDialog(
          title: const Text('Reserve Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(b.title, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              TextField(
                controller: nc,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  labelText: 'Patron Name',
                  labelStyle: theme.textTheme.bodyMedium,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final n = nc.text.trim();
                if (n.isEmpty) return;
                p.reserveBook(b.id, n);
                Navigator.pop(dCtx);
                _snack(ctx, 'Reserved for $n', theme);
              },
              child: const Text('Confirm Reserve'),
            ),
          ],
        );
      },
    );
  }
}
