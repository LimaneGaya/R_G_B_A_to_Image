import 'dart:io';

import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart' as desktop_drop;
import 'package:cross_file/cross_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB to Image',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const RGBtoImage(),
    );
  }
}

class RGBtoImage extends StatefulWidget {
  const RGBtoImage({super.key});

  @override
  State<RGBtoImage> createState() => _RGBtoImageState();
}

class _RGBtoImageState extends State<RGBtoImage> {
  List<XFile> files = [];
  XFile? red;
  XFile? blue;
  XFile? green;
  XFile? alpha;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DragTarget<XFile>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        red = details.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          red == null
                              ? Container(
                                  width: 100, height: 100, color: Colors.red)
                              : Image.file(File(red!.path),
                                  width: 100, height: 100),
                          Text("Red"),
                        ],
                      );
                    },
                  ),
                  DragTarget<XFile>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        green = details.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          green == null
                              ? Container(
                                  width: 100, height: 100, color: Colors.green)
                              : Image.file(File(green!.path),
                                  width: 100, height: 100),
                          Text("Green"),
                        ],
                      );
                    },
                  ),
                  DragTarget<XFile>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        blue = details.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          blue == null
                              ? Container(
                                  width: 100, height: 100, color: Colors.blue)
                              : Image.file(File(blue!.path),
                                  width: 100, height: 100),
                          Text("Blue"),
                        ],
                      );
                    },
                  ),
                  DragTarget<XFile>(
                    onAcceptWithDetails: (details) {
                      setState(() {
                        alpha = details.data;
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          alpha == null
                              ? Container(
                                  width: 100, height: 100, color: Colors.white)
                              : Image.file(File(alpha!.path),
                                  width: 100, height: 100),
                          Text("Alpha"),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            files.isEmpty
                ? desktop_drop.DropTarget(
                    child: Flexible(
                      flex: 6,
                      child: Container(color: Colors.blue),
                    ),
                    onDragDone: (details) {
                      details.files.retainWhere(
                        (e) => ['jpg', 'png', 'webp', 'jpeg']
                            .contains(e.name.split('.').last.toLowerCase()),
                      );

                      setState(() {
                        files.addAll(details.files);
                      });
                    },
                  )
                : Flexible(
                    flex: 4,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 300,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        if (index > files.length) return null;
                        if (index == files.length) {
                          return desktop_drop.DropTarget(
                            child: Flexible(
                              flex: 6,
                              child: Container(
                                child: Center(
                                  child: Icon(Icons.add, size: 50),
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            onDragDone: (details) {
                              details.files.retainWhere(
                                (e) => ['jpg', 'png', 'webp', 'jpeg'].contains(
                                    e.name.split('.').last.toLowerCase()),
                              );

                              setState(() {
                                files.addAll(details.files);
                              });
                            },
                          );
                        }

                        return Container(
                            child: LongPressDraggable<XFile>(
                                data: files[index],
                                feedback: Image.file(
                                  File(files[index].path),
                                  width: 200,
                                  height: 200,
                                ),
                                child: Image.file(
                                  File(files[index].path),
                                  width: 200,
                                  height: 200,
                                )));
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
