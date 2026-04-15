import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/scanner_providers.dart';
import '../../../data/models/purchase.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(purchasesProvider);
    final productsCache = ref.watch(productsCacheProvider);
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');

    if (purchases.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Historique'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun achat enregistré',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scannez un produit pour commencer',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showDeleteAllDialog(context, ref),
            tooltip: 'Tout supprimer',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          final product = productsCache[purchase.productBarcode];

          return Dismissible(
            key: Key(purchase.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Supprimer?'),
                  content: const Text(
                      'Êtes-vous sûr de vouloir supprimer cet achat?'),
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
              ref.read(purchasesProvider.notifier).deletePurchase(purchase.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achat supprimé')),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product?.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: product!.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[200],
                            child: const Icon(Icons.shopping_basket),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: const Icon(Icons.shopping_basket),
                        ),
                ),
                title: Text(
                  product?.name ?? 'Produit inconnu',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${purchase.store} • ${dateFormat.format(purchase.purchaseDate)}',
                ),
                trailing: Text(
                  currencyFormat.format(purchase.price),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tout supprimer?'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer tous les achats? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              final purchases = ref.read(purchasesProvider);
              for (final purchase in purchases) {
                ref.read(purchasesProvider.notifier).deletePurchase(purchase.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tous les achats ont été supprimés')),
              );
            },
            child: const Text('Supprimer tout'),
          ),
        ],
      ),
    );
  }
}
