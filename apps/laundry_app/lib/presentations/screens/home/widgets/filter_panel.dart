import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/order_model.dart';

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

  /// Current status filter (`null` = any status). Owned by the parent, same
  /// as [sort]; the panel renders the dropdown and writes the choice back.
  final ValueNotifier<OrderStatus?> statusFilter;

  const FilterPanel({
    super.key,
    required this.isOpen,
    required this.orderNumberController,
    required this.clientController,
    required this.sort,
    required this.statusFilter,
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

  /// Italian label for each sort key, shown in the dropdown.
  static const Map<SortKey, String> _sortLabels = {
    SortKey.createdAt: "Data creazione",
    SortKey.deliveryDate: "Data consegna",
    SortKey.orderNumber: "Numero d'ordine",
    SortKey.clientName: "Cliente",
  };

  /// Italian label for each status filter option; `null` means "any status".
  static const Map<OrderStatus?, String> _statusLabels = {
    null: "Tutti",
    OrderStatus.doing: "In corso",
    OrderStatus.completed: "Completati",
  };

  /// The status filter dropdown, styled like the sort field's dropdown.
  Widget _statusControl(OrderStatus? status) {
    return DropdownButtonFormField<OrderStatus?>(
      initialValue: status,
      isExpanded: true,
      icon: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowDown01,
        color: AppTheme.primaryColorTone1,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppTheme.primaryColorTone1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppTheme.primaryColorTone1),
        ),
        filled: true,
        fillColor: const Color.fromRGBO(243, 244, 245, 100),
      ),
      style: TextStyle(
        color: AppTheme.primaryColorTone1,
        fontSize: 18,
      ),
      dropdownColor: AppTheme.primaryBackgroundColorShade2,
      borderRadius: BorderRadius.circular(20),
      items: _statusLabels.entries
          .map(
            (entry) => DropdownMenuItem<OrderStatus?>(
              value: entry.key,
              child: Text(entry.value),
            ),
          )
          .toList(),
      onChanged: (status) => widget.statusFilter.value = status,
    );
  }

  /// The sort controls as a single row: a dropdown picking the field on the
  /// left, and a rounded button toggling the direction on the right. Selecting
  /// a new field resets to its natural direction (via [OrderSort.withKey]);
  /// the button flips the current direction (via [OrderSort.toggled]).
  Widget _sortControls(OrderSort sort) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<SortKey>(
            initialValue: sort.key,
            isExpanded: true,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: AppTheme.primaryColorTone1,
            ),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppTheme.primaryColorTone1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppTheme.primaryColorTone1),
              ),
              filled: true,
              fillColor: const Color.fromRGBO(243, 244, 245, 100),
            ),
            style: TextStyle(
              color: AppTheme.primaryColorTone1,
              fontSize: 18,
            ),
            dropdownColor: AppTheme.primaryBackgroundColorShade2,
            borderRadius: BorderRadius.circular(20),
            items: SortKey.values
                .map(
                  (key) => DropdownMenuItem<SortKey>(
                    value: key,
                    child: Text(_sortLabels[key]!),
                  ),
                )
                .toList(),
            onChanged: (key) {
              if (key != null) widget.sort.value = widget.sort.value.withKey(key);
            },
          ),
        ),
        const SizedBox(width: 10),
        // Rounded direction toggle: up = ascending, down = descending.
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.sort.value = widget.sort.value.toggled(),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(243, 244, 245, 100),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primaryColorTone1),
            ),
            child: Center(
              child: HugeIcon(
                icon: sort.ascending
                    ? HugeIcons.strokeRoundedArrowUp01
                    : HugeIcons.strokeRoundedArrowDown01,
                color: AppTheme.primaryColorTone1,
              ),
            ),
          ),
        ),
      ],
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
                Text("Stato"),
                // Rebuild only the status control when the selection changes.
                ValueListenableBuilder<OrderStatus?>(
                  valueListenable: widget.statusFilter,
                  builder: (context, status, _) => _statusControl(status),
                ),
                Text("Ordina per"),
                // Rebuild only the sort controls when the selection changes, so
                // picking a field / flipping direction doesn't touch the fields.
                ValueListenableBuilder<OrderSort>(
                  valueListenable: widget.sort,
                  builder: (context, sort, _) => _sortControls(sort),
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
                      widget.statusFilter.value = OrderStatus.doing;
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
