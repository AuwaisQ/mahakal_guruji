import 'package:flutter/material.dart';

class MahakalLoadingData extends StatefulWidget {
  final VoidCallback? onReload;
  const MahakalLoadingData({super.key, required this.onReload});
  @override
  _MahakalLoadingDataState createState() => _MahakalLoadingDataState();
}

class _MahakalLoadingDataState extends State<MahakalLoadingData>
    with SingleTickerProviderStateMixin {
  bool _showReloadButton = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showReloadButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.deepOrange,
      )),
    );
  }
}
//
// class MahakalLoadingData extends StatefulWidget {
//   final Color outerColor;
//   final Color innerColor;
//   final double size;
//   final Duration duration;
//   final double strokeWidth;
//   final VoidCallback? onReload;
//
//   const MahakalLoadingData({
//     Key? key,
//     this.outerColor = Colors.blue,
//     this.innerColor = Colors.lightBlue,
//     this.size = 50.0,
//     this.duration = const Duration(milliseconds: 1500),
//     this.strokeWidth = 4.0, this.onReload,
//   }) : super(key: key);
//
//   @override
//   _MahakalLoadingDataState createState() => _MahakalLoadingDataState();
// }
//
// class _MahakalLoadingDataState extends State<MahakalLoadingData>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _outerAnimation;
//   late Animation<double> _innerAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.duration,
//     )..repeat();
//
//     _outerAnimation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
//       ),
//     );
//
//     _innerAnimation = Tween(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: widget.size,
//         height: widget.size,
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Outer circle
//                 CircularProgressIndicator(
//                   value: _outerAnimation.value,
//                   strokeWidth: widget.strokeWidth,
//                   valueColor: AlwaysStoppedAnimation<Color>(widget.outerColor),
//                 ),
//
//                 // Inner circle (rotates in opposite direction)
//                 Transform.scale(
//                   scale: 0.6,
//                   child: Transform.rotate(
//                     angle: -_controller.value * 2 * pi,
//                     child: CircularProgressIndicator(
//                       value: _innerAnimation.value,
//                       strokeWidth: widget.strokeWidth * 0.8,
//                       valueColor: AlwaysStoppedAnimation<Color>(widget.innerColor),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
