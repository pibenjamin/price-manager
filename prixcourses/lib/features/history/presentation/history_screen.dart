/// EPIC 3: Historique des Achats
/// STORY 3.1: Liste des Achats
///
/// Material Design 3 implementation with:
/// - M3 Cards with proper elevation
/// - Selection mode with M3 patterns
/// - Swipe to dismiss with M3 styling

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../scanner/providers/scanner_providers.dart';
import '../../../data/models/purchase.dart';
import '../../../data/models/product.dart';
import 'product_detail_screen.dart';

final selectionModeProvider = StateProvider<bool>((ref) => false);
final selectedPurchasesProvider = StateProvider<Set<String>>((ref) => {});

final purchaseCountByBarcodeProvider =
    Provider.family<int, String>((ref, barcode) {
  final purchases = ref.watch(purchasesProvider).cast<Purchase>();
  return purchases.where((p) => p.productBarcode == barcode).length;
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
    final colorScheme = Theme.of(context).colorScheme;

    if (purchases.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Historique')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: colorScheme.outline,
              ),
              const SizedBox(height: 24),
              Text(
                'Aucun achat enregistré',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Scannez un produit pour commencer',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: isSelectionMode
            ? Text(
                '${selectedIds.length} sélectionné${selectedIds.length > 1 ? 's' : ''}')
            : const Text('Historique'),
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
              icon: const Icon(Icons.checklist),
              onPressed: () {
                ref.read(selectionModeProvider.notifier).state = true;
              },
              tooltip: 'Mode sélection',
            ),
          if (isSelectionMode)
            IconButton(
              icon: Icon(
                selectedIds.length == purchases.length
                    ? Icons.deselect
                    : Icons.select_all,
              ),
              onPressed: () {
                if (selectedIds.length == purchases.length) {
                  ref.read(selectedPurchasesProvider.notifier).state = {};
                } else {
                  ref.read(selectedPurchasesProvider.notifier).state =
                      purchases.map((p) => p.id).toSet();
                }
              },
              tooltip: 'Tout sélectionner',
            ),
          if (isSelectionMode && selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>
                  _showBulkDeleteDialog(context, ref, selectedIds.length),
            ),
        ],
      ),
      body: Column(
        children: [
          if (isSelectionMode && selectedIds.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: colorScheme.primaryContainer,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${selectedIds.length} achat${selectedIds.length > 1 ? 's' : ''} sélectionné${selectedIds.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedIds.length == purchases.length) {
                        ref.read(selectedPurchasesProvider.notifier).state = {};
                      } else {
                        ref.read(selectedPurchasesProvider.notifier).state =
                            purchases.map((p) => p.id).toSet();
                      }
                    },
                    child: Text(
                      selectedIds.length == purchases.length
                          ? 'Tout désélectionner'
                          : 'Tout sélectionner',
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
                final product = productsCache[purchase.productBarcode];
                final isSelected = selectedIds.contains(purchase.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Dismissible(
                    key: Key(purchase.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.delete, color: colorScheme.onError),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Supprimer ?'),
                          content: const Text(
                              'Êtes-vous sûr de vouloir supprimer cet achat ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Annuler'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Supprimer'),
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
                        SnackBar(
                          content: const Text('Achat supprimé'),
                          action: SnackBarAction(
                            label: 'Annuler',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
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
                            ref.read(selectionModeProvider.notifier).state =
                                true;
                            ref.read(selectedPurchasesProvider.notifier).state =
                                {purchase.id};
                          }
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: product?.imageUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: product!.imageUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.shopping_basket,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color:
                                            colorScheme.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.broken_image,
                                          color: colorScheme.outline,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      child: Icon(
                                        Icons.shopping_basket,
                                        color: colorScheme.outline,
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(
                            product?.name ?? 'Produit inconnu',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${purchase.store} • ${_formatDate(purchase.purchaseDate)}',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatPrice(purchase.price),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${ref.watch(purchaseCountByBarcodeProvider(purchase.productBarcode))}x',
                                  style: TextStyle(
                                    color: colorScheme.onSecondaryContainer,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
        title: const Text('Supprimer ?'),
        content: Text(
          'Voulez-vous vraiment supprimer $count achats ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final selectedIds = ref.read(selectedPurchasesProvider);
              for (final id in selectedIds) {
                ref.read(purchasesProvider.notifier).deletePurchase(id);
              }
              ref.read(selectionModeProvider.notifier).state = false;
              ref.read(selectedPurchasesProvider.notifier).state = {};
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$count achats supprimés')),
              );
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
