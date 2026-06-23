# Add File Upload and Processing Options to CaptureScreen

The goal is to allow users to upload images from their gallery in the `CaptureScreen` and then choose whether to process them using OCR or QR/Barcode scanning.

## Proposed Changes

### Dependencies

#### [pubspec.yaml](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/pubspec.yaml)

- Added `image_picker` dependency (already done via shell command).

---

### Screens

#### [capture_screen.dart](file:///C:/Users/edwip/OneDrive/Documents/TaskApp/taskapp/lib/screens/capture_screen.dart)

- Import `package:image_picker/image_picker.dart`.
- Refactor `_scanText` and `_scanQR` to use a shared `_processImage(String path, String mode)` method.
- Add `_pickFile` method to handle image selection from gallery.
- Add `_showProcessingOptionDialog` to let the user choose between OCR and QR after picking a file.
- Update UI to include an "Upload" button in the capture controls.

```dart
// Simplified view of the new processing logic
Future<void> _processImage(String path, String mode) async {
  setState(() => _isBusy = true);
  try {
    final inputImage = InputImage.fromFilePath(path);
    if (mode == "OCR") {
      final recognizedText = await _textRecognizer.processImage(inputImage);
      if (recognizedText.text.isNotEmpty) {
        _showTaskDialog(recognizedText.text, "OCR");
      }
    } else {
      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        final code = barcodes.first.displayValue;
        if (code != null) {
          _showTaskDialog(code, "QR/Barras");
        }
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error $mode: $e')));
  } finally {
    setState(() => _isBusy = false);
  }
}
```

## Verification Plan

### Manual Verification
- Run the app and navigate to the `CaptureScreen`.
- Verify the new "Cargar" (Upload) button is visible.
- Click "Cargar", select an image from the gallery.
- Verify that a bottom sheet appears asking for "OCR" or "QR".
- Select "OCR" and verify it extracts text from the selected image.
- Select "QR" and verify it reads a code from the selected image.
- Verify that the camera-based OCR and QR still work as expected.
