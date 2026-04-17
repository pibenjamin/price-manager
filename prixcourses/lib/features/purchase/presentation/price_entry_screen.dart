/// EPIC 2: Enregistrement d'un achat
/// STORY 2.2: Écran Prix
///
/// Responsabilités:
/// - Formulaire de saisie du prix
/// - Sélection du magasin
/// - Sélection de la date
///
/// Critères d'acceptation:
/// - GIVEN: Le produit est scanné
/// - WHEN: L'utilisateur entre prix, magasin, date
/// - THEN: L'achat est enregistré dans Hive

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/product.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../../history/presentation/product_detail_screen.dart';

class PriceEntryScreen extends ConsumerStatefulWidget {
  final Product product;

  const PriceEntryScreen({super.key, required this.product});

  @override
  ConsumerState<PriceEntryScreen> createState() => _PriceEntryScreenState();
}

class _PriceEntryScreenState extends ConsumerState<PriceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _customStoreController = TextEditingController();
  String? _selectedStore;
  DateTime _purchaseDate = DateTime.now();
  bool _isSaving = false;
  bool _isCustomStore = false;

  static const List<String> _defaultStores = [
    'Carrefour',
    'Leclerc',
    'Auchan',
    'Intermarché',
    'Lidl',
    'Aldi',
    'Casino',
    'Système U',
    'Biocoop',
    'Netto',
    'Naturalia',
    'Super U',
    'Proxy',
    'Carrefour Drive',
    'Leclerc Drive',
  ];

  @override
  void dispose() {
    _priceController.dispose();
    _customStoreController.dispose();
    super.dispose();
  }

  void _showCustomStoreDialog() {
    _customStoreController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_circle),
            SizedBox(width: 8),
            Text('Nouveau magasin'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _customStoreController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nom du magasin',
                hintText: 'Ex: Petit Casino, Spar...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedStore = null);
            },
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final storeName = _customStoreController.text.trim();
              if (storeName.isNotEmpty) {
                Navigator.pop(context);
                setState(() {
                  _selectedStore = storeName;
                  _isCustomStore = true;
                });
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _purchaseDate = picked);
    }
  }

  Future<void> _savePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un magasin')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(purchasesProvider.notifier).addPurchase(
            productBarcode: widget.product.barcode,
            price: double.parse(_priceController.text),
            store: _selectedStore!,
            purchaseDate: _purchaseDate,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Achat enregistré !'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Color _getNutriScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A':
        return const Color(0xFF00B050);
      case 'B':
        return const Color(0xFF92D050);
      case 'C':
        return const Color(0xFFFFC000);
      case 'D':
        return const Color(0xFFFF9900);
      case 'E':
        return const Color(0xFFFF0000);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastPurchase =
        ref.watch(lastPurchaseProvider(widget.product.barcode));
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer l\'achat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (widget.product.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 80,
                              height: 80,
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.image),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80,
                              height: 80,
                              color: colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_basket),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.product.brand != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.product.brand!,
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (widget.product.nutriScore != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getNutriScoreColor(
                                          widget.product.nutriScore!)
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: _getNutriScoreColor(
                                        widget.product.nutriScore!),
                                  ),
                                ),
                                child: Text(
                                  'NUTRI-SCORE: ${widget.product.nutriScore}',
                                  style: TextStyle(
                                    color: _getNutriScoreColor(
                                        widget.product.nutriScore!),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        product: widget.product,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.info_outline, size: 16),
                                label: const Text('Voir détail'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (lastPurchase != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: const Text('Dernier achat'),
                    subtitle: Text(
                      '${currencyFormat.format(lastPurchase.price)} à ${lastPurchase.store}',
                    ),
                    trailing: Text(
                      dateFormat.format(lastPurchase.purchaseDate),
                      style: TextStyle(color: colorScheme.outline),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Card(
                  child: ListTile(
                    leading:
                        Icon(Icons.info_outline, color: colorScheme.tertiary),
                    title: const Text('Premier achat de ce produit'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 24,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  prefixText: '€ ',
                  hintText: '0.00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un prix';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Prix invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _isCustomStore ? null : _selectedStore,
                decoration: const InputDecoration(
                  labelText: 'Magasin',
                ),
                items: [
                  ..._defaultStores.map((store) => DropdownMenuItem(
                        value: store,
                        child: Text(store),
                      )),
                  const DropdownMenuItem(
                    value: '__ADD_NEW__',
                    child: Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Ajouter un nouveau...'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == '__ADD_NEW__') {
                    _showCustomStoreDialog();
                  } else {
                    setState(() {
                      _selectedStore = value;
                      _isCustomStore = false;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value == '__ADD_NEW__') {
                    return 'Sélectionnez un magasin';
                  }
                  return null;
                },
              ),
              if (_isCustomStore && _selectedStore != null) ...[
                const SizedBox(height: 8),
                Chip(
                  avatar: const Icon(Icons.star, size: 16),
                  label: Text(_selectedStore!),
                  onDeleted: () {
                    setState(() {
                      _selectedStore = null;
                      _isCustomStore = false;
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date d\'achat',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(dateFormat.format(_purchaseDate)),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _savePurchase,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Enregistrement...' : 'Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
