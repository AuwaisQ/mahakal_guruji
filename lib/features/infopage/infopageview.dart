import 'package:flutter/material.dart';

infoPopup(BuildContext context, String info) {
  showDialog(
    useSafeArea: false,
    barrierDismissible: true,
    traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        insetPadding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  info,
                  style: const TextStyle(fontSize: 20, letterSpacing: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 6), // Replacing VerticalSpace with SizedBox
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0)),
                child: const Center(
                    child: Text(
                  "Got it",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),
              ),
            )
            // punkGuideButton(context),
          ],
        ),
      );
    },
  );
}
