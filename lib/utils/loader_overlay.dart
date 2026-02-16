import 'package:flutter/material.dart';

// class LoaderOverlay {
//   static OverlayEntry? _overlayEntry;

//   static void show(BuildContext context) {
//     if (_overlayEntry != null) return;

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           ModalBarrier(
//             dismissible: false,
//             color: Colors.black.withOpacity(0.5),
//           ),
//           const Center(
//             child: CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );

//     Overlay.of(context).insert(_overlayEntry!);
//   }
//   static void hide() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
// }
class LoaderOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (_) => Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );

    // Only insert if mounted
    final overlay = Overlay.of(context);
    if (overlay != null) overlay.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}