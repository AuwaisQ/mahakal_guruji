import 'dart:convert';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_constants.dart';

class DevoteeAvatarStack extends StatefulWidget {
  const DevoteeAvatarStack({super.key});

  @override
  State<DevoteeAvatarStack> createState() => _DevoteeAvatarStackState();
}

class _DevoteeAvatarStackState extends State<DevoteeAvatarStack> {
  /// ---- CONFIG (change once, works everywhere) ----
  final String apiUrl = '${AppConstants.baseUrl}/api/v1/pooja/puja-devotee';
  final String responseKey = 'images';

  final double width = 300;
  final double height = 30;
  final int maxAvatars = 10;

  /// ---- STATE ----
  List<String> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  /// ---- API CALL ----
  Future<void> _loadImages() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        images = List<String>.from(data[responseKey] ?? []);
      }
    } catch (e) {
      debugPrint('DevoteeAvatarStack error: $e');
    }

    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || images.isEmpty) {
      return const SizedBox.shrink();
    }

    return AvatarStack(
      width: width,
      height: height,
      borderWidth: 1.5,
      borderColor: Colors.black,
      avatars: images
          .take(maxAvatars)
          .map((url) => NetworkImage(url))
          .toList(),
      infoWidgetBuilder: (remaining) {
        return Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.shade600,
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '+$remaining',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
