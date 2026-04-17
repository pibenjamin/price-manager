import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../../../data/models/purchase.dart';
import '../../../data/models/product.dart';
import 'product_detail_screen.dart';

final selectionModeProvider = StateProvider<bool>((ref) => false);
final selectedPurchasesProvider = StateProvider<Set<String>>((ref) => {});

final purchaseCountByBarcodeProvider =
    Provider.family<int, String>((ref, barcode) {
  final purchases = ref.watch(purchasesProvider).cast<Purchase>();
  return purchases.where((p) => p!.productBarcode == barcode).length;
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatPrice(double value) => '${value.toStringAsFixed(2)} €';
  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider).cast<Purchase>();
    final productsCache = ref.watch(productsCacheProvider);
    final isSelectionMode = ref.watch(selectionModeProvider);
    final selectedIds = ref.watch(selectedPurchasesProvider);

    if (purchases.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('HISTORIQUE')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AUCUN ACHAT ENREGISTRÉ',
                style: TextStyle(
                  color: AppTheme.primaryNeonCyan,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scannez un produit pour commencer',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode
            ? Text('SÉLECTION (${selectedIds.length})')
            : const Text('HISTORIQUE'),
        leading: isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(selectionModeProvider.notifier).state = false;
                  ref.read(selectedPurchasesProvider.notifier).state = {};
                },
              )
            : null,
        actions: [
          if (!isSelectionMode)
            IconButton(
              icon: const Icon(Icons.check_box_outlined),
              onPressed: () {
                ref.read(selectionModeProvider.notifier).state = true;
              },
              tooltip: 'Mode sélection',
            ),
          if (isSelectionMode)
            IconButton(
              icon: Icon(
                selectedIds.length == purchases.length
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onPressed: () {
                if (selectedIds.length == purchases.length) {
                  ref.read(selectedPurchasesProvider.notifier).state = {};
                } else {
                  ref.read(selectedPurchasesProvider.notifier).state =
                      purchases.map((p) => p!.id).toSet();
                }
              },
              tooltip: 'Tout sélectionner',
            ),
          if (isSelectionMode && selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: AppTheme.primaryNeonPink),
              onPressed: () =>
                  _showBulkDeleteDialog(context, ref, selectedIds.length),
            ),
        ],
      ),
      body: Column(
        children: [
          if (isSelectionMode && selectedIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppTheme.bgCard,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        if (selectedIds.length == purchases.length) {
                          ref.read(selectedPurchasesProvider.notifier).state =
                              {};
                        } else {
                          ref.read(selectedPurchasesProvider.notifier).state =
                              purchases.map((p) => p!.id).toSet();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryNeonCyan,
                        side: const BorderSide(color: AppTheme.primaryNeonCyan),
                      ),
                      icon: const Icon(Icons.select_all, size: 18),
                      label: Text(
                        selectedIds.length == purchases.length
                            ? 'TOUT DÉSÉLECTIONNER'
                            : 'TOUT SÉLECTIONNER',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                final product = productsCache[purchase!.productBarcode];
                final isSelected = selectedIds.contains(purchase.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      if (isSelectionMode) {
                        final newSelection = Set<String>.from(selectedIds);
                        if (isSelected) {
                          newSelection.remove(purchase.id);
                        } else {
                          newSelection.add(purchase.id);
                        }
                        ref.read(selectedPurchasesProvider.notifier).state =
                            newSelection;
                      } else {
                        _openProductDetail(context, product, purchase);
                      }
                    },
                    onLongPress: () {
                      if (!isSelectionMode) {
                        ref.read(selectionModeProvider.notifier).state = true;
                        ref.read(selectedPurchasesProvider.notifier).state = {
                          purchase.id
                        };
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryNeonCyan
                              : AppTheme.primaryNeonCyan.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          if (isSelectionMode)
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? AppTheme.primaryNeonCyan
                                    : Colors.white38,
                              ),
                            ),
                          if (!isSelectionMode) const SizedBox(width: 16),
                          Expanded(
                            child: Dismissible(
                              key: Key(purchase.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryNeonPink
                                      .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete,
                                    color: Colors.white, size: 30),
                              ),
                              confirmDismiss: (direction) async {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppTheme.bgCard,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(
                                          color: AppTheme.primaryNeonPink),
                                    ),
                                    title: const Text(
                                      'SUPPRIMER ?',
                                      style: TextStyle(
                                          color: AppTheme.primaryNeonPink),
                                    ),
                                    content: const Text(
                                      'Êtes-vous sûr de vouloir supprimer cet achat ?',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('ANNULER'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('SUPPRIMER'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) {
                                ref
                                    .read(purchasesProvider.notifier)
                                    .deletePurchase(purchase.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ACHAT SUPPRIMÉ'),
                                    backgroundColor: AppTheme.primaryNeonPink,
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppTheme.bgDark,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.primaryNeonCyan
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: product?.imageUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: product!.imageUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Icon(
                                              Icons.shopping_basket,
                                              color: AppTheme.primaryNeonCyan,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                              Icons.broken_image,
                                              color: AppTheme.primaryNeonPink,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.shopping_basket,
                                            color: AppTheme.primaryNeonCyan,
                                          ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product?.name ?? 'PRODUIT INCONNU',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.neonYellow
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: AppTheme.neonYellow),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.repeat,
                                              size: 12,
                                              color: AppTheme.neonYellow),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${ref.watch(purchaseCountByBarcodeProvider(purchase.productBarcode))}x',
                                            style: const TextStyle(
                                              color: AppTheme.neonYellow,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${purchase.store} • ${_formatDate(purchase.purchaseDate)}',
                                    style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryNeonCyan
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppTheme.primaryNeonCyan),
                                  ),
                                  child: Text(
                                    _formatPrice(purchase.price),
                                    style: const TextStyle(
                                      color: AppTheme.primaryNeonCyan,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openProductDetail(
      BuildContext context, Product? product, Purchase purchase) {
    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            product: product,
            purchaseId: purchase.id,
          ),
        ),
      );
    }
  }

  void _showBulkDeleteDialog(BuildContext context, WidgetRef ref, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryNeonPink, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.primaryNeonPink),
            SizedBox(width: 8),
            Text(
              'SUPPRIMER ?',
              style: TextStyle(
                color: AppTheme.primaryNeonPink,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        content: Text(
          'Voulez-vous vraiment supprimer $count achats ?\nCette action est irréversible.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryNeonPink,
            ),
            onPressed: () {
              final selectedIds = ref.read(selectedPurchasesProvider);
              for (final id in selectedIds) {
                ref.read(purchasesProvider.notifier).deletePurchase(id);
              }
              ref.read(selectionModeProvider.notifier).state = false;
              ref.read(selectedPurchasesProvider.notifier).state = {};
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count ACHATS SUPPRIMÉS'),
                  backgroundColor: AppTheme.primaryNeonPink,
                ),
              );
            },
            child: const Text('SUPPRIMER'),
          ),
        ],
      ),
    );
  }
}
