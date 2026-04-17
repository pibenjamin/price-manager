import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_theme.dart';
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
  late AnimationController _scanLineController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scanLineAnimation;

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

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scanLineController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pulseController.dispose();
    _scanLineController.dispose();
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
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PriceEntryScreen(product: product),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
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
            Icon(Icons.edit, color: AppTheme.primaryNeonPink),
            SizedBox(width: 8),
            Text(
              'ENTRÉE MANUELLE',
              style: TextStyle(
                color: AppTheme.primaryNeonPink,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: AppTheme.primaryNeonCyan,
            fontSize: 24,
            letterSpacing: 4,
          ),
          decoration: InputDecoration(
            hintText: 'Code-barres',
            hintStyle: TextStyle(
              color: AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULER'),
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
            child: const Text('RECHERCHER'),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('SCAN // PRIXCOURSES'),
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
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0, 0.2, 0.7, 1],
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
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryNeonCyan,
                      width: 3 * _pulseAnimation.value,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryNeonCyan
                            .withValues(alpha: 0.5 * _pulseAnimation.value),
                        blurRadius: 30 * _pulseAnimation.value,
                        spreadRadius: 5 * _pulseAnimation.value,
                      ),
                      BoxShadow(
                        color: AppTheme.primaryNeonPink
                            .withValues(alpha: 0.3 * _pulseAnimation.value),
                        blurRadius: 20 * _pulseAnimation.value,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: _cornerGlow(AppTheme.primaryNeonCyan),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Transform.rotate(
                          angle: 1.5708,
                          child: _cornerGlow(AppTheme.primaryNeonPink),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Transform.rotate(
                          angle: 3.1416,
                          child: _cornerGlow(AppTheme.primaryNeonPurple),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Transform.rotate(
                          angle: 4.7124,
                          child: _cornerGlow(AppTheme.neonYellow),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _scanLineAnimation,
                        builder: (context, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Align(
                              alignment: Alignment(
                                  0, _scanLineAnimation.value * 2 - 1),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppTheme.primaryNeonCyan,
                                      AppTheme.primaryNeonCyan,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryNeonCyan,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'RECHERCHE...',
                      style: TextStyle(
                        color: AppTheme.primaryNeonCyan,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (error != null)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryNeonPink, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryNeonPink.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppTheme.primaryNeonPink,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.primaryNeonPink,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: _showManualEntryDialog,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryNeonCyan),
                      ),
                      child: const Text('ENTRÉE MANUELLE'),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryNeonCyan.withValues(alpha: 0.5),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, color: AppTheme.primaryNeonCyan),
                  SizedBox(width: 12),
                  Text(
                    'POINTEZ VERS UN CODE-BARRES',
                    style: TextStyle(
                      color: AppTheme.primaryNeonCyan,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
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

  Widget _cornerGlow(Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.8),
            color.withValues(alpha: 0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
