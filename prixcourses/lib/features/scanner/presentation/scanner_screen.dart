import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../providers/scanner_providers.dart';
import '../purchase/presentation/price_entry_screen.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  MobileScannerController? _controller;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;

    setState(() {
      _isProcessing = true;
    });

    ref.read(isLoadingProductProvider.notifier).state = true;

    try {
      final productsCache = ref.read(productsCacheProvider.notifier);
      final product = await productsCache.fetchAndCacheProduct(barcode);

      if (!mounted) return;

      if (product != null) {
        ref.read(scannedProductProvider.notifier).state = product;
        ref.read(scannerErrorProvider.notifier).state = null;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PriceEntryScreen(product: product),
          ),
        );
      } else {
        ref.read(scannerErrorProvider.notifier).state = 'Produit non trouvé';
      }
    } catch (e) {
      if (!mounted) return;
      ref.read(scannerErrorProvider.notifier).state = 'Erreur: ${e.toString()}';
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ref.read(isLoadingProductProvider.notifier).state = false;
      }
    }
  }

  void _showManualEntryDialog() {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Entrée manuelle'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Code-barres',
            hintText: 'Entrez le code-barres',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              if (controller.text.isNotEmpty) {
                _onBarcodeDetected(
                  BarcodeCapture(
                    barcodes: [Barcode(rawValue: controller.text)],
                  ),
                );
              }
            },
            child: const Text('Rechercher'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(isLoadingProductProvider);
    final error = ref.watch(scannerErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: _showManualEntryDialog,
            tooltip: 'Entrée manuelle',
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetected,
          ),
          // Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          // Loading indicator
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Recherche en cours...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          // Error message
          if (error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _showManualEntryDialog,
                        child: const Text('Entrée manuelle'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Instructions
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Pointez la caméra vers un code-barres',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
