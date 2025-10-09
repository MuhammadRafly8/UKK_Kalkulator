// lib/settings/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/shared/providers/thame_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeProvider).themeMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Terang'),
              leading: Radio<AppTheme>(
                value: AppTheme.light,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setTheme(value);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Gelap'),
              leading: Radio<AppTheme>(
                value: AppTheme.dark,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setTheme(value);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Mengikuti Sistem'),
              leading: Radio<AppTheme>(
                value: AppTheme.system,
                groupValue: currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setTheme(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}