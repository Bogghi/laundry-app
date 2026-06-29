import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/screens/home/widgets/order_sort.dart';

/// The home-screen filter panel that slides down from the top.
///
/// Visibility is driven by [isOpen]: flipping it to `true` runs the
/// slide + fade forward, `false` reverses it. The panel owns its own
/// [AnimationController] (the ticker), so the parent stays stateless.
class FilterPanel extends StatefulWidget {
  final ValueNotifier<bool> isOpen;

  /// Controller for the "Numero d'ordine" field. Owned by the parent so the
  /// home screen can read the query and filter its order list against it.
  final TextEditingController orderNumberController;

  /// Controller for the "Cliente" field. Owned by the parent so the home
  /// screen can read the query and filter its order list against it; the
  /// panel just binds the field to it.
  final TextEditingController clientController;

  /// Current sort selection. Owned by the parent (like the controllers above)
  /// so the home screen can read it to order its list; the panel renders the
  /// sort rows and writes the user's choice back into it.
  final ValueNotifier<OrderSort> sort;

  const FilterPanel({
    super.key,
    required this.isOpen,
    required this.orderNumberController,
    required this.clientController,
    required this.sort,
  });

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

  /// One tappable sort option. Tapping an inactive key selects it (with its
  /// natural default direction); tapping the active key flips the direction.
  /// The active row is accented and shows an up/down arrow.
  Widget _sortRow(OrderSort sort, SortKey key, String label) {
    final isActive = sort.key == key;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.sort.value = isActive
            ? widget.sort.value.toggled()
            : widget.sort.value.withKey(key);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(243, 244, 245, 100)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.primaryColorTone1,
                fontSize: 18,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isActive)
              HugeIcon(
                icon: sort.ascending
                    ? HugeIcons.strokeRoundedArrowUp01
                    : HugeIcons.strokeRoundedArrowDown01,
                color: AppTheme.primaryColorTone1,
              ),
          ],
        ),
      ),
    );
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
                  controller: widget.orderNumberController,
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
                Text("Cliente"),
                TextFormField(
                  controller: widget.clientController,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                Text("Ordina per"),
                // Rebuild only the sort rows when the selection changes, so
                // picking a key / flipping direction doesn't touch the fields.
                ValueListenableBuilder<OrderSort>(
                  valueListenable: widget.sort,
                  builder: (context, sort, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        _sortRow(sort, SortKey.createdAt, "Data creazione"),
                        _sortRow(sort, SortKey.deliveryDate, "Data consegna"),
                        _sortRow(sort, SortKey.orderNumber, "Numero d'ordine"),
                        _sortRow(sort, SortKey.clientName, "Cliente"),
                      ],
                    );
                  },
                ),
                // Clears both queries and resets the sort at once. The list and
                // the AppBar dot both derive from these, so they update for free.
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      widget.orderNumberController.clear();
                      widget.clientController.clear();
                      widget.sort.value = OrderSort.defaultSort;
                      // Drop focus so the keyboard retracts, then close the panel.
                      FocusManager.instance.primaryFocus?.unfocus();
                      widget.isOpen.value = false;
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColorTone1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Cancella filtri",
                      style: TextStyle(fontSize: 18),
                    ),
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
