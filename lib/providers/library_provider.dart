import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/book.dart';

class LibraryProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  LibraryProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode');
    if (themeStr != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeStr,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString());
    notifyListeners();
  }

  final List<String> categories = [
    'All',
    'Classic',
    'Fiction',
    'Sci-Fi',
    'Romance',
    'Fantasy',
    'Non-Fiction',
    'Mystery',
    'Philosophy',
  ];
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void setCategory(String c) {
    _selectedCategory = c;
    notifyListeners();
  }

  final List<Book> _books = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      isbn: '9780743273565',
      category: 'Classic',
      pages: 180,
      year: 1925,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780743273565-L.jpg',
      description: 'A masterpiece of American fiction set in the Jazz Age, exploring themes of wealth, class, idealism, and the American Dream.',
      totalCopies: 5,
      availableCopies: 5,
      publisher: 'Scribner',
      language: 'English',
      rating: 4.5,
    ),
    Book(
      id: '2',
      title: '1984',
      author: 'George Orwell',
      isbn: '9780451524935',
      category: 'Sci-Fi',
      pages: 328,
      year: 1949,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg',
      description: 'A dystopian masterpiece exploring totalitarianism and mass surveillance. Winston Smith navigates life under the omnipresent Big Brother.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 11)),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      issuedTo: 'Aarav Sharma',
      totalCopies: 3,
      availableCopies: 2,
    ),
    Book(
      id: '3',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      isbn: '9780060935467',
      category: 'Fiction',
      pages: 281,
      year: 1960,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780060935467-L.jpg',
      description: 'A gripping story about racial injustice, moral growth, and compassion in the American South during the 1930s.',
      status: BookStatus.reserved,
      reservedBy: 'Priya Patel',
      totalCopies: 2,
      availableCopies: 2,
    ),
    Book(
      id: '4',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      isbn: '9780141439518',
      category: 'Romance',
      pages: 432,
      year: 1813,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg',
      description: 'A witty, romantic novel following Elizabeth Bennet and the proud Mr. Darcy through love, reputation, and class in Regency England.',
      totalCopies: 4,
      availableCopies: 4,
    ),
    Book(
      id: '5',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      isbn: '9780547928227',
      category: 'Fantasy',
      pages: 310,
      year: 1937,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780547928227-L.jpg',
      description: 'Bilbo Baggins embarks on an unexpected journey through a world of dragons, trolls, and treasure.',
      totalCopies: 6,
      availableCopies: 6,
    ),
    Book(
      id: '6',
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      isbn: '9780062316097',
      category: 'Non-Fiction',
      pages: 498,
      year: 2011,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780062316097-L.jpg',
      description: 'A brief history of humankind from the Cognitive Revolution to the biotechnological future.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 28)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      issuedTo: 'Rahul Verma',
      totalCopies: 3,
      availableCopies: 2,
    ),
    Book(
      id: '7',
      title: 'The Da Vinci Code',
      author: 'Dan Brown',
      isbn: '9780307474278',
      category: 'Mystery',
      pages: 454,
      year: 2003,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780307474278-L.jpg',
      description: 'Robert Langdon uncovers a conspiracy hidden in the works of Leonardo da Vinci in this gripping thriller.',
      totalCopies: 3,
      availableCopies: 3,
    ),
    Book(
      id: '8',
      title: 'Dune',
      author: 'Frank Herbert',
      isbn: '9780441172719',
      category: 'Sci-Fi',
      pages: 688,
      year: 1965,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780441172719-L.jpg',
      description: 'An epic science fiction saga set on the desert planet Arrakis, exploring politics, religion, ecology, and human potential.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      issuedTo: 'Sneha Gupta',
      totalCopies: 2,
      availableCopies: 1,
    ),
    Book(
      id: '9',
      title: 'The Catcher in the Rye',
      author: 'J.D. Salinger',
      isbn: '9780316769488',
      category: 'Classic',
      pages: 277,
      year: 1951,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780316769488-L.jpg',
      description: 'The story of teenage rebellion and angst featuring the iconic Holden Caulfield.',
      totalCopies: 4,
      availableCopies: 4,
    ),
    Book(
      id: '10',
      title: 'The Alchemist',
      author: 'Paulo Coelho',
      isbn: '9780061122415',
      category: 'Fiction',
      pages: 208,
      year: 1988,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780061122415-L.jpg',
      description: 'A magical story of a young shepherd boy who travels from Spain to Egypt in search of a treasure hidden in the Pyramids.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      issuedTo: 'Neha Singh',
      totalCopies: 5,
      availableCopies: 4,
    ),
    Book(
      id: '11',
      title: 'Harry Potter and the Sorcerer\'s Stone',
      author: 'J.K. Rowling',
      isbn: '9780590353427',
      category: 'Fantasy',
      pages: 309,
      year: 1997,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780590353427-L.jpg',
      description: 'The first book in the global phenomenon follows an orphaned boy who discovers he is a wizard.',
      status: BookStatus.reserved,
      reservedBy: 'Aditi Rao',
      totalCopies: 8,
      availableCopies: 8,
    ),
    Book(
      id: '12',
      title: 'Thinking, Fast and Slow',
      author: 'Daniel Kahneman',
      isbn: '9780374533557',
      category: 'Non-Fiction',
      pages: 499,
      year: 2011,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780374533557-L.jpg',
      description: 'A groundbreaking tour of the mind, explaining the two systems that drive the way we think and make choices.',
      totalCopies: 3,
      availableCopies: 3,
    ),
    Book(
      id: '13',
      title: 'The Martian',
      author: 'Andy Weir',
      isbn: '9780553418026',
      category: 'Sci-Fi',
      pages: 369,
      year: 2011,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780553418026-L.jpg',
      description: 'Six days ago, astronaut Mark Watney became one of the first people to walk on Mars. Now, he\'s sure he\'ll be the first person to die there.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      issuedTo: 'Karan Mehta',
      totalCopies: 4,
      availableCopies: 3,
    ),
    Book(
      id: '14',
      title: 'Steve Jobs',
      author: 'Walter Isaacson',
      isbn: '9781451648539',
      category: 'Non-Fiction',
      pages: 630,
      year: 2011,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9781451648539-L.jpg',
      description:
          'The exclusive, authorized biography of Apple co-founder Steve Jobs.',
      totalCopies: 2,
      availableCopies: 2,
    ),
    Book(
      id: '15',
      title: 'The Fault in Our Stars',
      author: 'John Green',
      isbn: '9780525478812',
      category: 'Romance',
      pages: 313,
      year: 2012,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780525478812-L.jpg',
      description: 'Two teen cancer patients embark on a life-affirming journey to visit a reclusive author in Amsterdam.',
      totalCopies: 5,
      availableCopies: 5,
    ),
    Book(
      id: '16',
      title: 'Animal Farm',
      author: 'George Orwell',
      isbn: '9780451526342',
      category: 'Classic',
      pages: 144,
      year: 1945,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780451526342-L.jpg',
      description: 'A brilliant political satire and allegorical novella about the Russian Revolution.',
      totalCopies: 7,
      availableCopies: 7,
    ),
    Book(
      id: '17',
      title: 'Educated',
      author: 'Tara Westover',
      isbn: '9780399590504',
      category: 'Non-Fiction',
      pages: 334,
      year: 2018,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780399590504-L.jpg',
      description: 'An unforgettable memoir about a young girl who, kept out of school, leaves her survivalist family and goes on to earn a PhD from Cambridge University.',
      status: BookStatus.issued,
      issueDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 9)),
      issuedTo: 'Pooja Desai',
      totalCopies: 3,
      availableCopies: 2,
    ),
    Book(
      id: '18',
      title: 'A Brief History of Time',
      author: 'Stephen Hawking',
      isbn: '9780553380163',
      category: 'Philosophy',
      pages: 212,
      year: 1988,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/9780553380163-L.jpg',
      description: 'A landmark volume in science writing by one of the great minds of our time, exploring the cosmos from the Big Bang to black holes.',
      totalCopies: 4,
      availableCopies: 4,
    ),
  ];

  late final List<CirculationRecord> _circulationRecords = [
    CirculationRecord(
      id: 'c1',
      bookId: '2',
      book: _books.firstWhere((b) => b.id == '2'),
      memberName: 'Aarav Sharma',
      issueDate: DateTime.now().subtract(const Duration(days: 11)),
      dueDate: DateTime.now().add(const Duration(days: 3)),
      status: BookStatus.issued,
    ),
    CirculationRecord(
      id: 'c2',
      bookId: '6',
      book: _books.firstWhere((b) => b.id == '6'),
      memberName: 'Rahul Verma',
      issueDate: DateTime.now().subtract(const Duration(days: 28)),
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: BookStatus.issued,
    ),
    CirculationRecord(
      id: 'c3',
      bookId: '8',
      book: _books.firstWhere((b) => b.id == '8'),
      memberName: 'Sneha Gupta',
      issueDate: DateTime.now().subtract(const Duration(days: 7)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: BookStatus.issued,
    ),
    // ── New active issues ──
    CirculationRecord(
      id: 'c4',
      bookId: '10',
      book: _books.firstWhere((b) => b.id == '10'),
      memberName: 'Neha Singh',
      issueDate: DateTime.now().subtract(const Duration(days: 4)),
      dueDate: DateTime.now().add(const Duration(days: 10)),
      status: BookStatus.issued,
    ),
    CirculationRecord(
      id: 'c5',
      bookId: '13',
      book: _books.firstWhere((b) => b.id == '13'),
      memberName: 'Karan Mehta',
      issueDate: DateTime.now().subtract(const Duration(days: 15)),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      status: BookStatus.issued,
    ),
    CirculationRecord(
      id: 'c6',
      bookId: '17',
      book: _books.firstWhere((b) => b.id == '17'),
      memberName: 'Pooja Desai',
      issueDate: DateTime.now().subtract(const Duration(days: 5)),
      dueDate: DateTime.now().add(const Duration(days: 9)),
      status: BookStatus.issued,
    ),
    // ── Returned history (makes the Circulation tab look real) ──
    CirculationRecord(
      id: 'c7',
      bookId: '1',
      book: _books.firstWhere((b) => b.id == '1'),
      memberName: 'Vikram Joshi',
      issueDate: DateTime.now().subtract(const Duration(days: 30)),
      dueDate: DateTime.now().subtract(const Duration(days: 16)),
      returnDate: DateTime.now().subtract(const Duration(days: 18)),
      status: BookStatus.returned,
    ),
    CirculationRecord(
      id: 'c8',
      bookId: '4',
      book: _books.firstWhere((b) => b.id == '4'),
      memberName: 'Meera Kapoor',
      issueDate: DateTime.now().subtract(const Duration(days: 25)),
      dueDate: DateTime.now().subtract(const Duration(days: 11)),
      returnDate: DateTime.now().subtract(const Duration(days: 12)),
      status: BookStatus.returned,
    ),
    CirculationRecord(
      id: 'c9',
      bookId: '5',
      book: _books.firstWhere((b) => b.id == '5'),
      memberName: 'Arjun Nair',
      issueDate: DateTime.now().subtract(const Duration(days: 20)),
      dueDate: DateTime.now().subtract(const Duration(days: 6)),
      returnDate: DateTime.now().subtract(const Duration(days: 8)),
      status: BookStatus.returned,
    ),
    CirculationRecord(
      id: 'c10',
      bookId: '7',
      book: _books.firstWhere((b) => b.id == '7'),
      memberName: 'Ishita Reddy',
      issueDate: DateTime.now().subtract(const Duration(days: 18)),
      dueDate: DateTime.now().subtract(const Duration(days: 4)),
      returnDate: DateTime.now().subtract(const Duration(days: 5)),
      status: BookStatus.returned,
    ),
    CirculationRecord(
      id: 'c11',
      bookId: '9',
      book: _books.firstWhere((b) => b.id == '9'),
      memberName: 'Rohan Iyer',
      issueDate: DateTime.now().subtract(const Duration(days: 22)),
      dueDate: DateTime.now().subtract(const Duration(days: 8)),
      returnDate: DateTime.now().subtract(const Duration(days: 9)),
      status: BookStatus.returned,
    ),
  ];

  List<Book> get books => _books;
  List<Book> get issuedBooks => _books
      .where(
        (b) =>
            b.status == BookStatus.issued || b.availableCopies < b.totalCopies,
      )
      .toList();
  List<Book> get reservedBooks =>
      _books.where((b) => b.status == BookStatus.reserved).toList();
  List<Book> get availableBooks =>
      _books.where((b) => b.availableCopies > 0).toList();
  List<Book> get overdueBooks => _books.where((b) => b.isOverdue).toList();
  List<Book> get dueSoonBooks => _books
      .where(
        (b) =>
            b.status == BookStatus.issued &&
            b.dueDate != null &&
            !b.isOverdue &&
            b.daysLeft <= 7,
      )
      .toList();
  int get totalBooks => _books.length;

  List<CirculationRecord> get circulationRecords => _circulationRecords;
  List<CirculationRecord> get activeIssues =>
      _circulationRecords.where((r) => r.status == BookStatus.issued).toList();
  List<CirculationRecord> get overdueIssues =>
      activeIssues.where((r) => r.isOverdue).toList();
  List<CirculationRecord> get returnedRecords => _circulationRecords
      .where((r) => r.status == BookStatus.returned)
      .toList();

  List<Book> searchAndFilter(String query, {String statusFilter = 'All'}) {
    var r = _books.toList();
    if (_selectedCategory != 'All')
      r = r.where((b) => b.category == _selectedCategory).toList();

    if (statusFilter != 'All') {
      if (statusFilter == 'Available')
        r = r.where((b) => b.availableCopies > 0).toList();
      else if (statusFilter == 'Issued')
        r = r.where((b) => b.availableCopies < b.totalCopies).toList();
      else if (statusFilter == 'Reserved')
        r = r.where((b) => b.status == BookStatus.reserved).toList();
      else if (statusFilter == 'Overdue')
        r = r.where((b) => b.isOverdue).toList();
    }

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      r = r
          .where(
            (b) =>
                b.title.toLowerCase().contains(q) ||
                b.author.toLowerCase().contains(q) ||
                b.isbn.contains(q),
          )
          .toList();
    }
    return r;
  }

  Book getById(String id) => _books.firstWhere((b) => b.id == id);

  void issueBook(String id, String user, int days) {
    final b = getById(id);
    if (b.availableCopies <= 0) return;

    // Prevent duplicate active issues for the same user and book
    final existingIssue = _circulationRecords.where(
      (r) =>
          r.bookId == id &&
          r.memberName == user &&
          r.status == BookStatus.issued,
    );
    if (existingIssue.isNotEmpty) return;

    b.availableCopies--;
    if (b.availableCopies == 0 && b.status == BookStatus.available) {
      b.status = BookStatus.issued;
    }
    b.issuedTo = user;
    b.issueDate = DateTime.now();
    b.dueDate = DateTime.now().add(Duration(days: days));

    _circulationRecords.add(
      CirculationRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bookId: id,
        book: b,
        memberName: user,
        issueDate: b.issueDate!,
        dueDate: b.dueDate,
      ),
    );

    notifyListeners();
  }

  void reserveBook(String id, String user) {
    final b = getById(id);
    if (b.availableCopies <= 0 && b.status != BookStatus.available) return;
    b.status = BookStatus.reserved;
    b.reservedBy = user;
    notifyListeners();
  }

  void returnBook(String id) {
    final b = getById(id);
    if (b.availableCopies < b.totalCopies) {
      b.availableCopies++;
    }
    if (b.availableCopies == b.totalCopies) {
      b.status = BookStatus.available;
    }
    b.issuedTo = null;
    b.issueDate = null;
    b.dueDate = null;
    b.reservedBy = null;

    final activeRecord = _circulationRecords
        .where((r) => r.bookId == id && r.status == BookStatus.issued)
        .toList();
    if (activeRecord.isNotEmpty) {
      final record = activeRecord.first;
      record.status = BookStatus.returned;
      record.returnDate = DateTime.now();
    }

    notifyListeners();
  }

  void renewBook(String recordId, int days) {
    final recordIndex = _circulationRecords.indexWhere((r) => r.id == recordId);
    if (recordIndex != -1) {
      final record = _circulationRecords[recordIndex];
      if (record.status == BookStatus.issued && record.dueDate != null) {
        record.book.dueDate = record.book.dueDate!.add(Duration(days: days));
        _circulationRecords[recordIndex] = CirculationRecord(
          id: record.id,
          bookId: record.bookId,
          book: record.book,
          memberName: record.memberName,
          issueDate: record.issueDate,
          dueDate: record.book.dueDate,
          status: record.status,
        );
        notifyListeners();
      }
    }
  }

  void cancelReservation(String id) {
    final b = getById(id);
    if (b.status != BookStatus.reserved) return;
    b.status = BookStatus.available;
    b.reservedBy = null;
    notifyListeners();
  }

  void addBook({
    required String title,
    required String author,
    required String isbn,
    required String category,
    String description = '',
    int pages = 0,
    int year = 2024,
    int totalCopies = 1,
  }) {
    final newId = (DateTime.now().millisecondsSinceEpoch).toString();
    _books.add(Book(
      id: newId,
      title: title,
      author: author,
      isbn: isbn,
      category: category,
      description: description.isEmpty
          ? 'A recently added book to the library collection.'
          : description,
      pages: pages,
      year: year,
      coverUrl: 'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg',
      totalCopies: totalCopies,
      availableCopies: totalCopies,
    ));
    notifyListeners();
  }
}
