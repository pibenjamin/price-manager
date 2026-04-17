/// EPIC 1: Scanner de Produits
/// STORY 1.1: Écran Scanner
///
/// Responsabilités:
/// - Caméra avec MobileScanner
/// - Animation de scan moderne
/// - Dialogue entrée manuelle
///
/// Critères d'acceptation:
/// - GIVEN: L'utilisateur est sur l'écran Scanner
/// - WHEN: La caméra détecte un code-barres
/// - THEN: Le produit est recherché via Open Food Facts

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../scanner/providers/scanner_providers.dart';
import '../../purchase/presentation/price_entry_screen.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with TickerProviderStateMixin {
  MobileScannerController? _controller;
  bool _isProcessing = false;
  bool _isNavigating = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _pauseScanner() {
    _controller?.stop();
  }

  void _resumeScanner() {
    _controller?.start();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing || _isNavigating) return;

    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();
    ref.read(isLoadingProductProvider.notifier).state = true;

    try {
      final productsCache = ref.read(productsCacheProvider.notifier);
      final product = await productsCache.fetchAndCacheProduct(barcode);

      if (!mounted) return;

      if (product != null) {
        HapticFeedback.heavyImpact();
        ref.read(scannedProductProvider.notifier).state = product;
        ref.read(scannerErrorProvider.notifier).state = null;

        setState(() {
          _isNavigating = true;
          _isProcessing = false;
        });
        ref.read(isLoadingProductProvider.notifier).state = false;
        _pauseScanner();

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PriceEntryScreen(product: product),
          ),
        );

        if (mounted) {
          setState(() {
            _isNavigating = false;
          });
          _resumeScanner();
        }
      } else {
        HapticFeedback.vibrate();
        ref.read(scannerErrorProvider.notifier).state = 'PRODUIT NON TROUVÉ';
      }
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      ref.read(scannerErrorProvider.notifier).state = 'ERREUR: ${e.toString()}';
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
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit_document, color: colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Entrée manuelle',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 20,
            letterSpacing: 2,
          ),
          decoration: const InputDecoration(
            labelText: 'Code-barres',
            hintText: '3017620422003',
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0, 0.25, 0.65, 1],
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.primary
                          .withValues(alpha: _pulseAnimation.value),
                      width: 3,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _buildCorner(colorScheme.primary),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Transform.rotate(
                          angle: 1.5708,
                          child: _buildCorner(colorScheme.secondary),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Transform.rotate(
                          angle: 3.1416,
                          child: _buildCorner(colorScheme.tertiary),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Transform.rotate(
                          angle: 4.7124,
                          child: _buildCorner(colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black87,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Recherche en cours...',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (error != null)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Card(
                color: colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.onErrorContainer,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onErrorContainer,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _showManualEntryDialog,
                        icon: const Icon(Icons.edit),
                        label: const Text('Entrée manuelle'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pointez vers un code-barres',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color, width: 3),
          left: BorderSide(color: color, width: 3),
        ),
      ),
    );
  }
}
