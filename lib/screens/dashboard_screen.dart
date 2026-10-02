import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigate;
  const DashboardScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LibraryProvider>(
      builder: (context, p, _) {
        final w = MediaQuery.sizeOf(context).width;
        final pad = math.max(20.0, (w - 800) / 2);
        return ListView(
          padding: EdgeInsets.fromLTRB(pad, 8, pad, 32),
          children: [
            // ── Greeting ──
            Text('Good morning,', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 2),
            Text('Library Manager', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 24),

            // ── Quick Actions ──
            _sectionLabel(
              'QUICK ACTIONS',
              theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _quickAction(
                    context,
                    Icons.search,
                    'Search',
                    () => onNavigate?.call(1),
                  ),
                  _quickAction(
                    context,
                    Icons.add_box,
                    'Issue',
                    () => onNavigate?.call(1),
                  ),
                  _quickAction(
                    context,
                    Icons.keyboard_return,
                    'Return',
                    () => onNavigate?.call(2),
                  ),
                  _quickAction(
                    context,
                    Icons.bookmark,
                    'Reservations',
                    () => onNavigate?.call(2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Stats Grid ──
            LayoutBuilder(
              builder: (ctx, constraints) {
                final cols = constraints.maxWidth > 600 ? 5 : 2;
                return GridView.count(
                  crossAxisCount: cols,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: constraints.maxWidth > 600 ? 1.6 : 1.3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      label: 'Total Books',
                      value: '${p.totalBooks}',
                      icon: Icons.library_books_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    StatCard(
                      label: 'Available',
                      value: '${p.availableBooks.length}',
                      icon: Icons.check_circle_rounded,
                      color: AppTheme.statusAvailable,
                    ),
                    StatCard(
                      label: 'Issued',
                      value: '${p.issuedBooks.length}',
                      icon: Icons.schedule_rounded,
                      color: AppTheme.statusIssued,
                    ),
                    StatCard(
                      label: 'Reserved',
                      value: '${p.reservedBooks.length}',
                      icon: Icons.bookmark_rounded,
                      color: AppTheme.statusReserved,
                    ),
                    StatCard(
                      label: 'Overdue',
                      value: '${p.overdueBooks.length}',
                      icon: Icons.warning_rounded,
                      color: AppTheme.statusOverdue,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // ── Due Soon ──
            if (p.dueSoonBooks.isNotEmpty) ...[
              _sectionLabel('DUE SOON', AppTheme.statusDueSoon),
              const SizedBox(height: 12),
              ...p.dueSoonBooks.map((b) => _alertRow(context, b, false, theme)),
              const SizedBox(height: 24),
            ],

            // ── Recently Added ──
            _sectionLabel(
              'RECENTLY ADDED',
              theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: p.books.length > 6 ? 6 : p.books.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) =>
                    _miniCard(context, p.books.reversed.toList()[i], theme),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.outline),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _alertRow(
    BuildContext context,
    Book b,
    bool overdue,
    ThemeData theme,
  ) {
    final c = overdue ? AppTheme.statusOverdue : AppTheme.statusDueSoon;
    final d = b.daysLeft.abs();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: b.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: c.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                overdue ? Icons.warning_rounded : Icons.timer_rounded,
                color: c,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${b.issuedTo} · ${overdue ? '$d day${d == 1 ? '' : 's'} overdue' : '$d day${d == 1 ? '' : 's'} left'}',
                      style: TextStyle(fontSize: 13, color: c),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: c.withOpacity(0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniCard(BuildContext context, Book b, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: b.id)),
      ),
      child: SizedBox(
        width: 110,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                b.effectiveCoverUrl,
                height: 140,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 140,
                  width: 110,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.menu_book,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              b.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
