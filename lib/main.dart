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
          final img.Image? redImg = red != null
              ? img.decodeImage(File(red!.path).readAsBytesSync())
              : null;
          final img.Image? greenImg = green != null
              ? img.decodeImage(File(green!.path).readAsBytesSync())
              : null;
          final img.Image? blueImg = blue != null
              ? img.decodeImage(File(blue!.path).readAsBytesSync())
              : null;
          final img.Image? alphaImg = alpha != null
              ? img.decodeImage(File(alpha!.path).readAsBytesSync())
              : null;
          final img.Image image = img.Image(
              width: redImg?.width ??
                  greenImg?.width ??
                  blueImg?.width ??
                  alphaImg?.width ??
                  1024,
              height: redImg?.height ??
                  greenImg?.height ??
                  blueImg?.height ??
                  alphaImg?.height ??
                  1024);
          for (img.Pixel pixel in image) {
            final redData = redImg?.getPixel(pixel.x, pixel.y);
            final greenData = greenImg?.getPixel(pixel.x, pixel.y);
            final blueData = blueImg?.getPixel(pixel.x, pixel.y);
            final alphaData = alphaImg?.getPixel(pixel.x, pixel.y);
            int division = 0;
            division = redData != null ? division + 1 : division;
            division = greenData != null ? division + 1 : division;
            division = blueData != null ? division + 1 : division;
            pixel.r =
                ((redData?.r ?? 0) + (redData?.g ?? 0) + (redData?.b ?? 0)) /
                    division;
            pixel.g = ((greenData?.r ?? 0) +
                    (greenData?.g ?? 0) +
                    (greenData?.b ?? 0)) /
                division;
            pixel.b =
                ((blueData?.r ?? 0) + (blueData?.g ?? 0) + (blueData?.b ?? 0)) /
                    division;
            pixel.a = alphaData == null
                ? 255
                : (alphaData.r + alphaData.g + alphaData.b) / 3;
          }
          final bytes = img.encodePng(image, level: 9);
          await File('output.png').writeAsBytes(bytes);
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
                              : Stack(children: [
                                  Image.file(File(red!.path),
                                      width: 100, height: 100),
                                  IconButton(
                                      onPressed: () =>
                                          setState(() => red = null),
                                      icon: const Icon(Icons.close))
                                ]),
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
                              : Stack(children: [
                                  Image.file(File(green!.path),
                                      width: 100, height: 100),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => green = null),
                                    icon: const Icon(Icons.close),
                                  )
                                ]),
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
                              : Stack(children: [
                                  Image.file(File(blue!.path),
                                      width: 100, height: 100),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => blue = null),
                                    icon: const Icon(Icons.close),
                                  )
                                ]),
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
                              : Stack(children: [
                                  Image.file(File(alpha!.path),
                                      width: 100, height: 100),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => alpha = null),
                                    icon: const Icon(Icons.close),
                                  )
                                ]),
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
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(files[index].path),
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            files.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.close)),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          files[index].name,
                                          style: const TextStyle(shadows: [
                                            Shadow(blurRadius: 1),
                                            Shadow(blurRadius: 5),
                                            Shadow(blurRadius: 8),
                                          ]),
                                        ))
                                  ],
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
