import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utill/app_constants.dart';

class SharePachangController extends ChangeNotifier {
  final ScreenshotController screenshotController = ScreenshotController();

  void shareCustomDesign(BuildContext context) async {
    try {
      // Capture the widget as an image
      Uint8List? image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final path = '${directory.path}/panchang.png';
        final file = File(path)..writeAsBytesSync(image);

        String shareUrl = '';
        shareUrl = "${AppConstants.baseUrl}/download";

        // Share the image
        Share.shareXFiles([XFile(path)],
            text: "📜 **आज का पंचांग - दिव्य तिथि विवरण** ✨\n\n"
                "🔆 **शुभ तिथि और नक्षत्र जानें!**\n"
                "📅 **अपने दिन की शुरुआत करें शुभ समय के अनुसार।**\n\n"
                "अभी देखें Mahakal.com ऐप पर! 🔱💖\n"
                "📲 **डाउनलोड करें और पुण्य लाभ प्राप्त करें!** 🙏\n\n"
                "🔹Download App Now: $shareUrl");
      }
    } catch (error) {
      print("Error capturing or sharing image: $error");
    }

    notifyListeners();
  }
}
