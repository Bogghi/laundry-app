import 'package:flutter/material.dart';

class ItemsManagerAddDialog extends StatefulWidget {
  final Future<void> Function(String name) onSave;

  const ItemsManagerAddDialog({super.key, required this.onSave});

  @override
  State<ItemsManagerAddDialog> createState() => _ItemsManagerAddDialogState();
}

class _ItemsManagerAddDialogState extends State<ItemsManagerAddDialog> {
  late TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_controller.text.trim().isEmpty || _saving) return;

    setState(() => _saving = true);
    try {
      await widget.onSave(_controller.text);
    } catch (_) {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuovo capo"),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: "Nome capo"),
        textCapitalization: TextCapitalization.sentences,
        enabled: !_saving,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _handleSave(),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text("Annulla"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _saving || _controller.text.trim().isEmpty
              ? null
              : _handleSave,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  "Salva",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
        ),
      ],
    );
  }
}
