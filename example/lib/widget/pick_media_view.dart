import 'package:flutter/material.dart';

class PickMediaView extends StatefulWidget {
  const PickMediaView({Key? key}) : super(key: key);

  @override
  State<PickMediaView> createState() => _PickMediaViewState();
}

class _PickMediaViewState extends State<PickMediaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Media'),
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
