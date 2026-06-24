import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';

/// The home-screen filter panel that slides down from the top.
///
/// Visibility is driven by [isOpen]: flipping it to `true` runs the
/// slide + fade forward, `false` reverses it. The panel owns its own
/// [AnimationController] (the ticker), so the parent stays stateless.
class FilterPanel extends StatefulWidget {
  final ValueNotifier<bool> isOpen;

  const FilterPanel({super.key, required this.isOpen});

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Seed the controller to match the current open state.
    _controller.value = widget.isOpen.value ? 1 : 0;
    widget.isOpen.addListener(_handleToggle);
  }

  void _handleToggle() {
    if (widget.isOpen.value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.isOpen.removeListener(_handleToggle);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      // The card subtree is static, so build it once and pass it as `child`.
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          margin: EdgeInsets.zero,
          color: AppTheme.primaryBackgroundColorShade2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text("Numero d'ordine"),
                TextFormField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "#98",
                    hintStyle: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(243, 244, 245, 100),
                  ),
                  style: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context, child) {
        // When fully closed, let taps fall through to the list underneath.
        return IgnorePointer(
          ignoring: _controller.isDismissed,
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
