import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:r_g_b_to_image/drop_zone.dart';

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
  void setFiles(details) {
    details.files.retainWhere(
      (e) => ['jpg', 'png', 'webp', 'jpeg']
          .contains(e.name.split('.').last.toLowerCase()),
    );

    setState(() {
      files.addAll(details.files);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final img.Image redImg =
              img.decodeImage(File(red!.path).readAsBytesSync())!;
          final img.Image greenImg =
              img.decodeImage(File(green!.path).readAsBytesSync())!;
          final img.Image blueImg =
              img.decodeImage(File(blue!.path).readAsBytesSync())!;
          final img.Image alphaImg =
              img.decodeImage(File(alpha!.path).readAsBytesSync())!;
          final img.Image image =
              img.Image(width: redImg.width, height: redImg.height);

          img.copyImageChannels(image,
              from: redImg, scaled: true, red: img.Channel.red);
        },
        child: const Icon(Icons.output),
      ),
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
                          const Text("Red"),
                          Text(red?.name ?? ""),
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
                          const Text("Green"),
                          Text(green?.name ?? ""),
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
                          const Text("Blue"),
                          Text(blue?.name ?? ""),
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
                          const Text("Alpha"),
                          Text(alpha?.name ?? ""),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            files.isEmpty
                ? Expanded(flex: 8, child: DropArea(setFiles))
                : Flexible(
                    flex: 4,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        if (index > files.length) return null;
                        if (index == files.length) {
                          return DropArea(setFiles);
                        }

                        return Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
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
