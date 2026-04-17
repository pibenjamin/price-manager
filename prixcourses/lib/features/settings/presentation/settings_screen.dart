/// EPIC 7: Export / Import des Données
/// STORY 7.4: Écran Paramètres
///
/// Responsabilités:
/// - Affiche les stats (nb achats, nb produits)
/// - Propose les boutons Export JSON/CSV
/// - Propose l'import JSON avec options Fusionner/Remplacer
/// - Affiche dialogs de feedback (succès/erreur)
///
/// Wireframe:
///
/// ┌─────────────────────────────────────┐
/// │ ← PARAMÈTRES                        │
/// ├─────────────────────────────────────┤
/// │  DONNÉES                            │
/// │  ┌─────────────────────────────┐   │
/// │  │ X Achats │ X Produits       │   │
/// │  └─────────────────────────────┘   │
/// │                                     │
/// │  EXPORT                             │
/// │  ┌─────────────────────────────┐   │
/// │  │ Export JSON                 │   │
/// │  └─────────────────────────────┘   │
/// │  ┌─────────────────────────────┐   │
/// │  │ Export CSV                  │   │
/// │  └─────────────────────────────┘   │
/// │                                     │
/// │  IMPORT                             │
/// │  ┌─────────────────────────────┐   │
/// │  │ Import JSON                 │   │
/// │  └─────────────────────────────┘   │
/// │                                     │
/// │  À PROPOS                           │
/// │  Version 1.0.0                      │
/// └─────────────────────────────────────┘
///

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/local_storage_service.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../providers/settings_providers.dart';
import '../services/export_import_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(localStorageServiceProvider);
    final purchasesCount = storage.getAllPurchases().length;
    final productsCount = storage.getAllProducts().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PARAMÈTRES'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('DONNÉES'),
            const SizedBox(height: 12),
            _buildStatsCard(purchasesCount, productsCount),
            const SizedBox(height: 24),
            _buildSectionTitle('EXPORT'),
            const SizedBox(height: 12),
            _buildExportCard(context, ref),
            const SizedBox(height: 24),
            _buildSectionTitle('IMPORT'),
            const SizedBox(height: 12),
            _buildImportCard(context, ref),
            const SizedBox(height: 24),
            _buildSectionTitle('À PROPOS'),
            const SizedBox(height: 12),
            _buildAboutCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.primaryNeonCyan,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildStatsCard(int purchases, int products) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppTheme.primaryNeonCyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.shopping_cart, '$purchases', 'Achats'),
          Container(
            height: 50,
            width: 1,
            color: AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
          ),
          _buildStatItem(Icons.inventory_2, '$products', 'Produits'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryNeonPink, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildExportCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neonGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neonGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.data_object, color: AppTheme.neonGreen),
            ),
            title: const Text(
              'Export JSON',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Sauvegarde complète des données',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            trailing:
                const Icon(Icons.chevron_right, color: AppTheme.neonGreen),
            onTap: () => _exportJson(context, ref),
          ),
          const Divider(color: AppTheme.neonGreen, height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neonYellow.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.table_chart, color: AppTheme.neonYellow),
            ),
            title: const Text(
              'Export CSV',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Tableau des achats pour Excel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
            trailing:
                const Icon(Icons.chevron_right, color: AppTheme.neonYellow),
            onTap: () => _exportCsv(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildImportCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppTheme.primaryNeonPink.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryNeonPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.file_upload, color: AppTheme.primaryNeonPink),
        ),
        title: const Text(
          'Import JSON',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Restaurer des données depuis un fichier',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
        trailing:
            const Icon(Icons.chevron_right, color: AppTheme.primaryNeonPink),
        onTap: () => _showImportDialog(context, ref),
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppTheme.primaryNeonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.shopping_bag,
              size: 40,
              color: AppTheme.primaryNeonCyan,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'PrixCourses',
            style: TextStyle(
              color: AppTheme.primaryNeonCyan,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 8),
          Text(
            'Comparateur de prix alimentaire',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          ),
        ],
      ),
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
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryNeonCyan),
        ),
        title: const Text(
          'Importer des données',
          style: TextStyle(color: AppTheme.primaryNeonCyan),
        ),
        content: const Text(
          'Choisissez comment importer les données:',
          style: TextStyle(color: Colors.white70),
        ),
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
            style:
                TextButton.styleFrom(foregroundColor: AppTheme.primaryNeonPink),
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
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryNeonPink),
        ),
        title: const Text(
          'Confirmer le remplacement',
          style: TextStyle(color: AppTheme.primaryNeonPink),
        ),
        content: const Text(
          'Cette action supprimera toutes les données existantes. Cette action est irréversible.',
          style: TextStyle(color: Colors.white70),
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
            style:
                TextButton.styleFrom(foregroundColor: AppTheme.primaryNeonPink),
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
        backgroundColor: AppTheme.bgCard,
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppTheme.primaryNeonCyan),
            const SizedBox(width: 20),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.neonGreen),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppTheme.neonGreen),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: AppTheme.neonGreen)),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
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
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFFF3366)),
        ),
        title: Row(
          children: [
            const Icon(Icons.error, color: Color(0xFFFF3366)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Color(0xFFFF3366))),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
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
