import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingPage extends ConsumerStatefulWidget {
  final Widget title;
  final Future<void> Function() resolve;

  const LoadingPage({
    super.key,
    required this.title,
    required this.resolve,
  });

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  void initState() {
    super.initState();
    widget.resolve();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}