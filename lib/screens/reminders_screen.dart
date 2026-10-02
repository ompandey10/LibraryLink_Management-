import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../theme/app_theme.dart';
import 'book_detail_screen.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

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
    return '${d.day} ${m[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LibraryProvider>(
      builder: (ctx, p, _) {
        final over = p.overdueIssues;
        final soon = p.activeIssues
            .where((r) => r.dueDate != null && !r.isOverdue && r.daysLeft <= 7)
            .toList();
        final all = [...over, ...soon];
        final pad = math.max(20.0, (MediaQuery.sizeOf(ctx).width - 800) / 2);

        if (all.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  size: 56,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No pending alerts',
                  style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
          children: [
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${all.length} Active Alert${all.length == 1 ? '' : 's'}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${over.length} overdue · ${soon.length} due soon',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (over.isNotEmpty) ...[
              _label('OVERDUE ATTENTION', AppTheme.statusOverdue),
              const SizedBox(height: 12),
              ...over.map((r) => _tile(context, r, true, p, theme)),
              const SizedBox(height: 24),
            ],

            if (soon.isNotEmpty) ...[
              _label('DUE SOON', AppTheme.statusDueSoon),
              const SizedBox(height: 12),
              ...soon.map((r) => _tile(context, r, false, p, theme)),
            ],
          ],
        );
      },
    );
  }

  Widget _label(String t, Color c) {
    return Text(
      t,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: c,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _tile(
    BuildContext ctx,
    CirculationRecord r,
    bool over,
    LibraryProvider p,
    ThemeData theme,
  ) {
    final c = over ? AppTheme.statusOverdue : AppTheme.statusDueSoon;
    final d = r.daysLeft.abs();
    final b = r.book;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: b.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.withOpacity(0.4)),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      b.effectiveCoverUrl,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 50,
                        height: 75,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.menu_book,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(b.author, style: theme.textTheme.bodySmall),
                        const SizedBox(height: 8),
                        Text(
                          'Patron: ${r.memberName}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Issued: ${_fmt(r.issueDate)} • Due: ${_fmt(r.dueDate)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          over ? Icons.warning_rounded : Icons.timer_rounded,
                          color: c,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          over
                              ? "$d day${d == 1 ? "" : "s"} overdue"
                              : "$d day${d == 1 ? "" : "s"} left",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: c,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      p.returnBook(b.id);
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(content: Text('${b.title} returned')),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Return'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      p.renewBook(r.id, 14);
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text('${b.title} renewed for 14 days'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: const Text('Renew'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
