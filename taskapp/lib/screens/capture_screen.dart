import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _controller;
  bool _isBusy = false;
  final TextRecognizer _textRecognizer = TextRecognizer();
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller?.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    _barcodeScanner.close();
    super.dispose();
  }

  Future<void> _scanText() async {
    if (_controller == null || !_controller!.value.isInitialized || _isBusy) return;

    setState(() => _isBusy = true);
    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      if (recognizedText.text.isNotEmpty) {
        _showTaskDialog(recognizedText.text, "OCR");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error OCR: $e')));
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _scanQR() async {
    if (_controller == null || !_controller!.value.isInitialized || _isBusy) return;

    setState(() => _isBusy = true);
    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        final code = barcodes.first.displayValue;
        if (code != null) {
          _showTaskDialog(code, "QR/Barras");
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error QR: $e')));
    } finally {
      setState(() => _isBusy = false);
    }
  }

  void _showTaskDialog(String content, String source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tarea Detectada ($source)'),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: content.length > 30 ? content.substring(0, 30) : content,
                description: content,
                category: TaskCategory.personal,
                priority: TaskPriority.medium,
                dueDate: DateTime.now(),
                startTime: TimeOfDay.now(),
                endTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
              );
              context.read<TaskProvider>().addTask(newTask);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarea agregada exitosamente')));
            },
            child: const Text('Agregar Tarea'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Capturar Tarea')),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          if (_isBusy) const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CaptureButton(
                    icon: Icons.text_fields,
                    label: 'OCR',
                    onTap: _scanText,
                  ),
                  _CaptureButton(
                    icon: Icons.qr_code_scanner,
                    label: 'QR',
                    onTap: _scanQR,
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

class _CaptureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CaptureButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: onTap,
          backgroundColor: AppTheme.primaryBlue,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
