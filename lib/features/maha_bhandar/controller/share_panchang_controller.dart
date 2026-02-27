import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

class SharePachangController extends ChangeNotifier {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> shareCustomDesign(BuildContext context) async {
    RenderBox? box;
    try {
      // Capture widget as image
      final Uint8List? image = await screenshotController.capture(
        delay: const Duration(milliseconds: 100), // Ensure render complete
      );
      
      if (image == null) {
        _showErrorSnackBar(context, 'Failed to capture image');
        return;
      }

      // Get RenderBox for iOS positioning (must be before async gap)
      if (context.mounted) {
        box = context.findRenderObject() as RenderBox?;
      }

      // Save to temp directory
      final directory = await getTemporaryDirectory();
      final fileName = 'panchang_${DateTime.now().millisecondsSinceEpoch}.png';
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(image);

      // Verify file exists
      if (!await file.exists()) {
        _showErrorSnackBar(context, 'Failed to save image');
        return;
      }

      const String shareUrl = '${AppConstants.baseUrl}/download';
      
      // Platform-specific share text formatting
      final String shareText = _buildShareText(shareUrl);

      // Share with platform-specific options
      final result = await Share.shareXFiles(
        [XFile(path)],
        text: shareText,
        subject: 'आज का पंचांग - दिव्य तिथि विवरण',
        // iOS-specific: anchor point for share sheet
        sharePositionOrigin: _getSharePositionOrigin(box),
      );

      // Handle share result
      _handleShareResult(context, result);

    } catch (error) {
      debugPrint('Error capturing or sharing image: $error');
      _showErrorSnackBar(context, 'Sharing failed: $error');
    } finally {
      // Clean up temp file after delay
      _cleanupTempFile(box, context);
    }

    notifyListeners();
  }

  String _buildShareText(String shareUrl) {
    if (Platform.isIOS) {
      // iOS: Cleaner formatting, emojis work better without markdown
      return '📜 आज का पंचांग - दिव्य तिथि विवरण\n\n'
          'शुभ तिथि और नक्षत्र जानें!\n'
          'अपने दिन की शुरुआत करें शुभ समय के अनुसार।\n\n'
          'देखें Mahakal.com ऐप पर!\n'
          'डाउनलोड करें और पुण्य लाभ प्राप्त करें!\n\n'
          'Download App: $shareUrl';
    } else {
      // Android: Rich formatting with markdown-style emphasis
      return '📜 **आज का पंचांग - दिव्य तिथि विवरण** ✨\n\n'
          '🔆 **शुभ तिथि और नक्षत्र जानें!**\n'
          '📅 **अपने दिन की शुरुआत करें शुभ समय के अनुसार।**\n\n'
          'अभी देखें Mahakal.com ऐप पर! 🔱💖\n'
          '📲 **डाउनोड करें और पुण्य लाभ प्राप्त करें!** 🙏\n\n'
          '🔹 Download App Now: $shareUrl';
    }
  }

  Rect? _getSharePositionOrigin(RenderBox? box) {
    if (!Platform.isIOS || box == null) return null;
    
    try {
      final Size size = box.size;
      final Offset position = box.localToGlobal(Offset.zero);
      
      // Ensure valid non-zero rect for iOS
      if (size.isEmpty) {
        // Fallback to screen center if widget has no size
        return Rect.fromCenter(
          center: Offset(
            WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width / 2,
            WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.height / 3,
          ),
          width: 1,
          height: 1,
        );
      }
      
      return position & size;
    } catch (e) {
      debugPrint('Error getting share position: $e');
      return null;
    }
  }

  void _handleShareResult(BuildContext context, ShareResult result) {
    if (!context.mounted) return;
    
    switch (result.status) {
      case ShareResultStatus.success:
        _showSuccessSnackBar(context, 'Shared successfully');
        break;
      case ShareResultStatus.dismissed:
        // User cancelled, no action needed
        break;
      case ShareResultStatus.unavailable:
        _showErrorSnackBar(context, 'Sharing not available');
        break;
    }
  }

  void _cleanupTempFile(RenderBox? box, BuildContext context) async {
    // Delay cleanup to ensure share sheet has loaded the file
    await Future.delayed(const Duration(seconds: 5));
    try {
      final directory = await getTemporaryDirectory();
      // Only delete panchang files to avoid clearing other temp data
      final files = directory.listSync().where(
        (f) => f.path.contains('panchang_') && f.path.endsWith('.png'),
      );
      
      for (var file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Cleanup error: $e');
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin:const EdgeInsets.all(16),
        duration:const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin:const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: () => shareCustomDesign(context),
        ),
      ),
    );
  }
}