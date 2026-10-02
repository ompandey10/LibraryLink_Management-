import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});
  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final _ctrl = TextEditingController();
  String _q = '';
  String _statusFilter = 'All'; // All, Available, Issued, Reserved, Overdue
  final List<String> _statusFilters = [
    'All',
    'Available',
    'Issued',
    'Reserved',
    'Overdue',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LibraryProvider>(
      builder: (context, p, _) {
        final results = p.searchAndFilter(_q, statusFilter: _statusFilter);
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: LayoutBuilder(
            builder: (ctx, constraints) {
              final pad = math.max(20.0, (constraints.maxWidth - 800) / 2);
              return Column(
                children: [
                  // Search field
                  Padding(
                    padding: EdgeInsets.fromLTRB(pad, 12, pad, 0),
                    child: TextField(
                      controller: _ctrl,
                      onChanged: (v) => setState(() => _q = v),
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'Search by title, author or ISBN…',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          size: 22,
                        ),
                        suffixIcon: _q.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 20,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                onPressed: () {
                                  _ctrl.clear();
                                  setState(() => _q = '');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filters
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Filters
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _statusFilters.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final c = _statusFilters[i];
                              final sel = _statusFilter == c;
                              return GestureDetector(
                                onTap: () => setState(() => _statusFilter = c),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: sel
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    c,
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
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Category Filters
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: p.categories.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final c = p.categories[i];
                              final sel = p.selectedCategory == c;
                              return GestureDetector(
                                onTap: () => p.setCategory(c),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: sel
                                        ? theme.colorScheme.secondary
                                        : theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: sel
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.outline,
                                    ),
                                  ),
                                  child: Text(
                                    c,
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Count
                  Padding(
                    padding: EdgeInsets.fromLTRB(pad, 16, pad, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${results.length} book${results.length == 1 ? '' : 's'}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // Results
                  Expanded(
                    child: results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: theme.colorScheme.outline,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No books found',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontSize: 18,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: pad),
                            itemCount: results.length,
                            itemBuilder: (_, i) => BookCard(
                              book: results[i],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookDetailScreen(bookId: results[i].id),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddBookDialog(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddBookDialog(BuildContext context) {
    final theme = Theme.of(context);
    final titleCtrl = TextEditingController();
    final authorCtrl = TextEditingController();
    final isbnCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final pagesCtrl = TextEditingController();
    final yearCtrl = TextEditingController(text: '2024');
    final copiesCtrl = TextEditingController(text: '1');
    String selectedCategory = 'Fiction';
    final categories = Provider.of<LibraryProvider>(context, listen: false).categories
        .where((c) => c != 'All')
        .toList();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.library_add_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              const Text('Add New Book'),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        prefixIcon: Icon(Icons.book_rounded),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Title is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: authorCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Author *',
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Author is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: isbnCtrl,
                      decoration: const InputDecoration(
                        labelText: 'ISBN *',
                        prefixIcon: Icon(Icons.qr_code_rounded),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'ISBN is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedCategory = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: pagesCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Pages',
                              prefixIcon: Icon(Icons.description_rounded),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: yearCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              prefixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: copiesCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Total Copies',
                        prefixIcon: Icon(Icons.content_copy_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.notes_rounded),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final provider =
                      Provider.of<LibraryProvider>(ctx, listen: false);
                  provider.addBook(
                    title: titleCtrl.text.trim(),
                    author: authorCtrl.text.trim(),
                    isbn: isbnCtrl.text.trim(),
                    category: selectedCategory,
                    description: descCtrl.text.trim(),
                    pages: int.tryParse(pagesCtrl.text) ?? 0,
                    year: int.tryParse(yearCtrl.text) ?? 2024,
                    totalCopies: int.tryParse(copiesCtrl.text) ?? 1,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('"${titleCtrl.text.trim()}" added to library!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
