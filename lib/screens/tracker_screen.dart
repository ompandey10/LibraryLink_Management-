import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../theme/app_theme.dart';
import 'book_detail_screen.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Tab bar
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              isScrollable: true,
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(
                0.6,
              ),
              dividerColor: theme.colorScheme.outline,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Active Issues'),
                Tab(text: 'Overdue'),
                Tab(text: 'Reserved'),
                Tab(text: 'Returned'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _ActiveIssuesTab(),
                _OverdueIssuesTab(),
                _ReservedTab(),
                _ReturnedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

// ── Active Issues ─────────────────────────────────────────────

class _ActiveIssuesTab extends StatelessWidget {
  const _ActiveIssuesTab();
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (ctx, p, _) {
        final records = p.activeIssues;
        if (records.isEmpty)
          return _empty(
            ctx,
            Icons.check_circle_outline_rounded,
            'No active issues',
          );
        final pad = math.max(20.0, (MediaQuery.sizeOf(ctx).width - 800) / 2);
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
          itemCount: records.length,
          itemBuilder: (_, i) => _RecordTile(record: records[i], p: p),
        );
      },
    );
  }
}

// ── Overdue Issues ────────────────────────────────────────────

class _OverdueIssuesTab extends StatelessWidget {
  const _OverdueIssuesTab();
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (ctx, p, _) {
        final records = p.overdueIssues;
        if (records.isEmpty)
          return _empty(
            ctx,
            Icons.check_circle_outline_rounded,
            'No overdue items',
          );
        final pad = math.max(20.0, (MediaQuery.sizeOf(ctx).width - 800) / 2);
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
          itemCount: records.length,
          itemBuilder: (_, i) => _RecordTile(record: records[i], p: p),
        );
      },
    );
  }
}

// ── Returned ──────────────────────────────────────────────────

class _ReturnedTab extends StatelessWidget {
  const _ReturnedTab();
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (ctx, p, _) {
        final records = p.returnedRecords.reversed.toList();
        if (records.isEmpty)
          return _empty(ctx, Icons.history, 'No return history');
        final pad = math.max(20.0, (MediaQuery.sizeOf(ctx).width - 800) / 2);
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
          itemCount: records.length,
          itemBuilder: (_, i) => _RecordTile(record: records[i], p: p),
        );
      },
    );
  }
}

class _RecordTile extends StatelessWidget {
  final CirculationRecord record;
  final LibraryProvider p;

  const _RecordTile({required this.record, required this.p});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = record.book;
    final over = record.isOverdue;
    final d = record.daysLeft.abs();
    final c = record.status == BookStatus.returned
        ? AppTheme.statusReturned
        : (over ? AppTheme.statusOverdue : AppTheme.statusIssued);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: book.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      book.effectiveCoverUrl,
                      width: 45,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 45,
                        height: 65,
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
                          book.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'To: ${record.memberName}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          record.status == BookStatus.returned
                              ? 'Returned on ${_fmt(record.returnDate)}'
                              : 'Issued: ${_fmt(record.issueDate)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (record.status == BookStatus.issued)
                    Text(
                      over ? '${d}d overdue' : '${d}d left',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c,
                      ),
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.statusAvailable,
                      size: 20,
                    ),
                ],
              ),
              if (record.status == BookStatus.issued) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          p.returnBook(book.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${book.title} returned')),
                          );
                        },
                        child: const Text('Return'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          p.renewBook(record.id, 14);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${book.title} renewed')),
                          );
                        },
                        child: const Text('Renew'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reserved ──────────────────────────────────────────────────

class _ReservedTab extends StatelessWidget {
  const _ReservedTab();
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (ctx, p, _) {
        final books = p.reservedBooks;
        if (books.isEmpty)
          return _empty(ctx, Icons.bookmark_border_rounded, 'No reservations');
        final pad = math.max(20.0, (MediaQuery.sizeOf(ctx).width - 800) / 2);
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(pad, 20, pad, 32),
          itemCount: books.length,
          itemBuilder: (_, i) => _ReservedTile(book: books[i]),
        );
      },
    );
  }
}

class _ReservedTile extends StatelessWidget {
  final Book book;
  const _ReservedTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<LibraryProvider>(context, listen: false);
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: book.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      book.effectiveCoverUrl,
                      width: 45,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 45,
                        height: 65,
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
                          book.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By: ${book.reservedBy ?? '—'}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    p.cancelReservation(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${book.title} cancelled')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.statusOverdue,
                    side: const BorderSide(
                      color: AppTheme.statusOverdue,
                      width: 1.5,
                    ),
                  ),
                  child: const Text('Cancel Reservation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _empty(BuildContext ctx, IconData ic, String msg) {
  final theme = Theme.of(ctx);
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(ic, size: 56, color: theme.colorScheme.outline),
        const SizedBox(height: 16),
        Text(
          msg,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 18,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    ),
  );
}
