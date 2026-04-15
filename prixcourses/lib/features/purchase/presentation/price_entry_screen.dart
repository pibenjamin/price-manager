import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/product.dart';
import '../../../core/constants/app_constants.dart';
import '../../scanner/providers/scanner_providers.dart';

class PriceEntryScreen extends ConsumerStatefulWidget {
  final Product product;

  const PriceEntryScreen({super.key, required this.product});

  @override
  ConsumerState<PriceEntryScreen> createState() => _PriceEntryScreenState();
}

class _PriceEntryScreenState extends ConsumerState<PriceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  String? _selectedStore;
  DateTime _purchaseDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
      });
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

    setState(() {
      _isSaving = true;
    });

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
          content: Text('Achat enregistré!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastPurchase = ref.watch(lastPurchaseProvider(widget.product.barcode));
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');

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
              // Product Info Card
              Card(
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
                              color: Colors.grey[200],
                              child: const Icon(Icons.image),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.shopping_basket, size: 40),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.product.brand != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.product.brand!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            if (widget.product.nutriScore != null) ...[
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(
                                  'Nutri-Score: ${widget.product.nutriScore}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: _getNutriScoreColor(
                                    widget.product.nutriScore!),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Last Purchase Info
              if (lastPurchase != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.history),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Dernier achat:'),
                              Text(
                                '${currencyFormat.format(lastPurchase.price)} à ${lastPurchase.store}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dateFormat.format(lastPurchase.purchaseDate),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 12),
                        Text('Premier achat de ce produit'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Price Input
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Prix',
                  prefixText: '€ ',
                  hintText: '0.00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Veuillez entrer un prix valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Store Selection
              DropdownButtonFormField<String>(
                value: _selectedStore,
                decoration: const InputDecoration(
                  labelText: 'Magasin',
                  prefixIcon: Icon(Icons.store),
                ),
                items: StoreConstants.allStores.map((store) {
                  return DropdownMenuItem(
                    value: store,
                    child: Text(store),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStore = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un magasin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Selection
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

              // Save Button
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

  Color _getNutriScoreColor(String score) {
    switch (score.toUpperCase()) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
