import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../data/models/product.dart';
import '../../../core/theme/app_theme.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../../history/presentation/price_evolution_screen.dart';
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
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.primaryNeonPink, width: 2),
        ),
        title: const Row(
          children: [
            Icon(Icons.add_circle, color: AppTheme.primaryNeonPink),
            SizedBox(width: 8),
            Text(
              'NOUVEAU MAGASIN',
              style: TextStyle(
                color: AppTheme.primaryNeonPink,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Entrez le nom de votre magasin:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customStoreController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.primaryNeonCyan),
              decoration: InputDecoration(
                hintText: 'Ex: Petit Casino, Spar...',
                hintStyle: TextStyle(
                  color: AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
                ),
                prefixIcon:
                    const Icon(Icons.store, color: AppTheme.primaryNeonPink),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedStore = null;
              });
            },
            child: const Text('ANNULER'),
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
            child: const Text('AJOUTER'),
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
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  Future<void> _savePurchase() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('VEUILLEZ SÉLECTIONNER UN MAGASIN'),
          backgroundColor: AppTheme.primaryNeonPink,
        ),
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
          content: Text('ACHAT ENREGISTRÉ !'),
          backgroundColor: AppTheme.neonGreen,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERREUR: $e'),
          backgroundColor: AppTheme.primaryNeonPink,
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
    final lastPurchase =
        ref.watch(lastPurchaseProvider(widget.product.barcode));
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('ENREGISTRER L\'ACHAT'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryNeonCyan),
                ),
                child: Row(
                  children: [
                    if (widget.product.imageUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.primaryNeonCyan
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.bgDark,
                              child: const Icon(Icons.image,
                                  color: AppTheme.primaryNeonCyan),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.bgDark,
                              child: const Icon(Icons.broken_image,
                                  color: AppTheme.primaryNeonPink),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.bgDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppTheme.primaryNeonCyan
                                  .withValues(alpha: 0.5)),
                        ),
                        child: const Icon(Icons.shopping_basket,
                            size: 40, color: AppTheme.primaryNeonCyan),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              color: Colors.white,
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
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12),
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
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _getNutriScoreColor(
                                        widget.product.nutriScore!)),
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
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryNeonPurple,
                                side: const BorderSide(
                                    color: AppTheme.primaryNeonPurple),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.history, size: 16),
                              label: const Text(
                                'VOIR DÉTAIL',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (lastPurchase != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryNeonCyan.withValues(alpha: 0.2),
                        AppTheme.primaryNeonPurple.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryNeonCyan),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.history,
                          color: AppTheme.primaryNeonCyan),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DERNIER ACHAT',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  letterSpacing: 1),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${currencyFormat.format(lastPurchase.price)} à ${lastPurchase.store}',
                              style: const TextStyle(
                                color: AppTheme.primaryNeonCyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              dateFormat.format(lastPurchase.purchaseDate),
                              style: const TextStyle(
                                  color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color:
                            AppTheme.primaryNeonPurple.withValues(alpha: 0.5)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppTheme.primaryNeonPurple),
                      SizedBox(width: 12),
                      Text(
                        'PREMIER ACHAT DE CE PRODUIT',
                        style: TextStyle(
                          color: AppTheme.primaryNeonPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                    color: AppTheme.primaryNeonCyan, fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'PRIX',
                  labelStyle: const TextStyle(color: AppTheme.primaryNeonCyan),
                  prefixText: '€ ',
                  prefixStyle: const TextStyle(color: AppTheme.primaryNeonCyan),
                  hintText: '0.00',
                  hintStyle: TextStyle(
                      color: AppTheme.primaryNeonCyan.withValues(alpha: 0.3)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ENTREZ UN PRIX';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'PRIX INVALIDE';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedStore == null &&
                                _formKey.currentState?.validate() == false
                            ? AppTheme.primaryNeonPink
                            : AppTheme.primaryNeonPink.withValues(alpha: 0.5),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _isCustomStore ? null : _selectedStore,
                        isExpanded: true,
                        dropdownColor: AppTheme.bgCard,
                        style: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: AppTheme.primaryNeonPink),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        hint: _isCustomStore && _selectedStore != null
                            ? Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: AppTheme.neonYellow, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedStore!,
                                    style: const TextStyle(
                                      color: AppTheme.neonYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Sélectionnez un magasin',
                                style: TextStyle(color: Colors.white54),
                              ),
                        items: [
                          ..._defaultStores.map((store) => DropdownMenuItem(
                                value: store,
                                child: Row(
                                  children: [
                                    const Icon(Icons.store,
                                        color: AppTheme.primaryNeonPink,
                                        size: 18),
                                    const SizedBox(width: 12),
                                    Text(store),
                                  ],
                                ),
                              )),
                          const DropdownMenuItem<String>(
                            value: '__ADD_NEW__',
                            child: Row(
                              children: [
                                Icon(Icons.add_circle,
                                    color: AppTheme.neonYellow, size: 18),
                                SizedBox(width: 12),
                                Text(
                                  'Ajouter un nouveau...',
                                  style: TextStyle(
                                    color: AppTheme.neonYellow,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
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
                      ),
                    ),
                  ),
                  if (_selectedStore == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 12),
                      child: Text(
                        'SÉLECTIONNEZ UN MAGASIN',
                        style: TextStyle(
                          color: AppTheme.primaryNeonPink,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'DATE D\'ACHAT',
                    labelStyle: TextStyle(color: AppTheme.neonYellow),
                    prefixIcon:
                        Icon(Icons.calendar_today, color: AppTheme.neonYellow),
                  ),
                  child: Text(
                    dateFormat.format(_purchaseDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _savePurchase,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryNeonCyan,
                  foregroundColor: AppTheme.bgDark,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving ? 'ENREGISTREMENT...' : 'ENREGISTRER',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
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
        return AppTheme.neonGreen;
      case 'B':
        return const Color(0xFF7CFC00);
      case 'C':
        return AppTheme.neonYellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return const Color(0xFFFF4444);
      default:
        return Colors.grey;
    }
  }
}
