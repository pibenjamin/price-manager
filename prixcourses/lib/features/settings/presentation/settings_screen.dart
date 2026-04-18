/// EPIC 7: Export / Import des Données
/// STORY 7.4: Écran Paramètres
///
/// Material Design 3 implementation with:
/// - M3 Cards and ListTiles
/// - M3 Dialogs and buttons
/// - Statistics display with M3 patterns

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../scanner/providers/scanner_providers.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(localStorageServiceProvider);
    final purchasesCount = storage.getAllPurchases().length;
    final productsCount = storage.getAllProducts().length;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Données', colorScheme),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    Icons.shopping_cart,
                    '$purchasesCount',
                    'Achats',
                    colorScheme.primary,
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: colorScheme.outlineVariant,
                  ),
                  _buildStatItem(
                    context,
                    Icons.inventory_2,
                    '$productsCount',
                    'Produits',
                    colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Export', colorScheme),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.data_object, color: colorScheme.primary),
                  title: const Text('Export JSON'),
                  subtitle: const Text('Sauvegarde complète des données'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportJson(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.table_chart, color: colorScheme.tertiary),
                  title: const Text('Export CSV'),
                  subtitle: const Text('Tableau des achats pour Excel'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _exportCsv(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Import', colorScheme),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(Icons.file_upload, color: colorScheme.secondary),
              title: const Text('Import JSON'),
              subtitle: const Text('Restaurer des données depuis un fichier'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showImportDialog(context, ref),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('À propos', colorScheme),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'PrixCourses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(color: colorScheme.outline),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Comparateur de prix alimentaire',
                    style: TextStyle(
                      color: colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: TextStyle(
        color: colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  Future<void> _exportJson(BuildContext context, WidgetRef ref) async {
    _showLoadingDialog(context, 'Export en cours...');

    final settings = ref.read(settingsNotifierProvider);
    final path = await settings.exportToJson();

    if (context.mounted) {
      Navigator.pop(context);
      if (path != null) {
        _showSuccessDialog(
            context, 'Export réussi !', 'Fichier enregistré:\n$path');
      } else {
        _showErrorDialog(
            context, 'Erreur', 'Impossible d\'exporter les données.');
      }
    }
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    _showLoadingDialog(context, 'Export en cours...');

    final settings = ref.read(settingsNotifierProvider);
    final path = await settings.exportToCsv();

    if (context.mounted) {
      Navigator.pop(context);
      if (path != null) {
        _showSuccessDialog(
            context, 'Export réussi !', 'Fichier enregistré:\n$path');
      } else {
        _showErrorDialog(
            context, 'Erreur', 'Impossible d\'exporter les données.');
      }
    }
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importer des données'),
        content: const Text('Choisissez comment importer les données:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _importJson(context, ref, replace: false);
            },
            child: const Text('Fusionner'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showReplaceConfirmDialog(context, ref);
            },
            child: const Text('Remplacer'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showReplaceConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer le remplacement'),
        content: const Text(
          'Cette action supprimera toutes les données existantes. Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _importJson(context, ref, replace: true);
            },
            child: const Text('Remplacer'),
          ),
        ],
      ),
    );
  }

  Future<void> _importJson(BuildContext context, WidgetRef ref,
      {required bool replace}) async {
    _showLoadingDialog(context, 'Import en cours...');

    final settings = ref.read(settingsNotifierProvider);
    final result = await settings.importFromJson(replace: replace);

    if (context.mounted) {
      Navigator.pop(context);
      if (result != null && result.success) {
        _showSuccessDialog(
          context,
          'Import réussi !',
          '${result.purchasesImported} achats\n${result.productsImported} produits importés',
        );
      } else if (result != null) {
        _showErrorDialog(
          context,
          'Import partiel',
          result.errors.join('\n'),
        );
      } else {
        _showErrorDialog(
            context, 'Erreur', 'Aucun fichier sélectionné ou format invalide.');
      }
    }
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
