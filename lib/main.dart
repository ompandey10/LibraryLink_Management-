import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/library_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LibraryProvider(),
      child: const LibraryLinkApp(),
    ),
  );
}

class LibraryLinkApp extends StatelessWidget {
  const LibraryLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LibraryProvider>(context);
    return MaterialApp(
      title: 'LibraryLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: provider.themeMode,
      home: const HomeScreen(),
    );
  }
}
