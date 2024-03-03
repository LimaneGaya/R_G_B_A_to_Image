import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class DropArea extends StatelessWidget {
  final Function(DropDoneDetails) onDragDone;
  const DropArea(this.onDragDone, {super.key});

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: onDragDone,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onTertiary,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 50),
              Text("Drop images here"),
            ],
          ),
        ),
      ),
    );
  }
}
