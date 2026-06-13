import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import '../../config/app_colors.dart';
import '../../services/freshness_ai_service.dart';
import '../../providers/service_providers.dart';
import '../../widgets/freshness_gauge.dart';
import '../../widgets/status_badge.dart';

class CameraCheckScreen extends ConsumerStatefulWidget {
  final String skuId;
  final String skuName;
  final String supplierId;
  final String supplierName;
  final String notes;

  const CameraCheckScreen({
    Key? key,
    required this.skuId,
    required this.skuName,
    required this.supplierId,
    required this.supplierName,
    required this.notes,
  }) : super(key: key);

  @override
  ConsumerState<CameraCheckScreen> createState() => _CameraCheckScreenState();
}

class _CameraCheckScreenState extends ConsumerState<CameraCheckScreen> with SingleTickerProviderStateMixin {
  late FreshnessAiService _aiService;
  Timer? _analysisTimer;
  FreshnessResult? _latestResult;
  bool _isAnalyzing = false;
  String? _imagePath;
  
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _aiService = ref.read(freshnessAiServiceProvider);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);

    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(_cameras![0], ResolutionPreset.medium, enableAudio: false);
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
          _startAnalysisLoop();
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startAnalysisLoop() {
    // Analyze every 2 seconds
    _analysisTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_isAnalyzing || !mounted || _cameraController == null || !_cameraController!.value.isInitialized) return;
      if (_cameraController!.value.isTakingPicture) return;
      
      setState(() => _isAnalyzing = true);
      
      try {
        final XFile file = await _cameraController!.takePicture();
        final result = await _aiService.analyzeFreshness(file.path);
        
        if (mounted) {
          setState(() {
            _latestResult = result;
            
            // Hapus foto lama agar penyimpanan HP tidak penuh (memory leak)
            if (_imagePath != null && _imagePath != file.path) {
              try { File(_imagePath!).deleteSync(); } catch (_) {}
            }
            _imagePath = file.path;
            
            _isAnalyzing = false;
          });
        }
      } catch (e) {
        print('Camera capture / inference failed: $e');
        if (mounted) {
          setState(() => _isAnalyzing = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    _cameraController?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _proceedToDecision() {
    if (_latestResult == null) return;
    
    context.push(
      '/qc-decision',
      extra: {
        'skuId': widget.skuId,
        'skuName': widget.skuName,
        'supplierId': widget.supplierId,
        'supplierName': widget.supplierName,
        'notes': widget.notes,
        'freshnessScore': _latestResult!.freshnessScore,
        'freshnessStatus': _latestResult!.freshnessStatus,
        'confidenceScore': _latestResult!.confidenceScore,
        'aiRecommendation': _latestResult!.recommendation,
        'imagePath': _imagePath,
      },
    );
  }

  Color _getStatusColor() {
    if (_latestResult == null) return AppColors.borderColor;
    if (_latestResult!.freshnessStatus == 'FRESH') return AppColors.freshGreen;
    if (_latestResult!.freshnessStatus == 'WARNING') return AppColors.freshYellow;
    return AppColors.freshRed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real Camera Preview Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              color: Colors.black,
              child: _isCameraInitialized && _cameraController != null
                  ? CameraPreview(_cameraController!)
                  : const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),

          // Overlays
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.skuName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _pulseAnimation.value,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getStatusColor().withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FreshnessGauge(
                        score: _latestResult?.freshnessScore ?? 0,
                        radius: 50,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_latestResult != null) ...[
                              StatusBadge(status: _latestResult!.freshnessStatus),
                              const SizedBox(height: 8),
                              Text(
                                'Confidence: ${_latestResult!.confidenceScore}%',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                              ),
                            ] else ...[
                              const Text('Menunggu Frame...', style: TextStyle(color: AppColors.textSecondary)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgTertiary,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Text(
                      _latestResult?.recommendation ?? 'Mengarahkan kamera untuk inference...',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {}, // Proof is automatically taken now
                          icon: Icon(_imagePath != null ? Icons.check : Icons.camera_alt),
                          label: Text(_imagePath != null ? 'Capture Evidence' : 'Analyze Freshness'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _latestResult != null ? _proceedToDecision : null,
                          child: const Text('Continue to QC Decision'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
