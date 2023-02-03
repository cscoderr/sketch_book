import 'package:flutter/material.dart';
import 'package:sketch_book/presentation/home/models/sketch_book.dart';
import 'package:sketch_book/presentation/home/models/sketch_book_type.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<SketchBook> sketches;
  late Color selectedColor;
  int selectedColorIndex = 0;
  SketchBook? selectedSketch;
  late SketchBookType sketchType;
  late double strokeWidth;

  @override
  void initState() {
    super.initState();
    sketches = [];
    sketchType = SketchBookType.pencil;
    selectedColor = Colors.primaries[0];
    strokeWidth = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Sketch Book',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ClipRect(
                  child: GestureDetector(
                    onPanStart: (details) {
                      setState(
                        () {
                          selectedSketch = SketchBook(
                            id: const Uuid().v4(),
                            color: selectedColor,
                            offsets: [details.localPosition],
                            strokeWidth: strokeWidth,
                            sketchType: sketchType,
                          );
                          sketches.add(selectedSketch!);
                        },
                      );
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        selectedSketch?.offsets.add(details.localPosition);
                        final sketch = sketches.firstWhere(
                            (element) => element.id == selectedSketch?.id);
                        sketches[sketches.indexOf(sketch)] =
                            sketch.copyWith(offsets: selectedSketch!.offsets);
                      });
                    },
                    onPanEnd: (details) {
                      setState(() {
                        selectedSketch = null;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/sketchbook_bg.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        // Positioned(
                        //   top: 0,
                        //   right: 20,
                        //   left: 20,
                        //   bottom: 0,
                        //   child: Image.network(
                        //     'https://img.freepik.com/premium-vector/hand-painted-background-violet-orange-colours_23-2148427578.jpg',
                        //     fit: BoxFit.scaleDown,
                        //   ),
                        // ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: SketchBookPainter(
                              sketches: sketches,
                            ),
                            child: Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkResponse(
                          onTap: () {
                            setState(() {
                              selectedColorIndex = index;
                              selectedColor = Colors.primaries[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: selectedColorIndex == index ? 60 : 45,
                            width: selectedColorIndex == index ? 60 : 45,
                            decoration: BoxDecoration(
                              color: Colors.primaries[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: selectedColorIndex == index ? 4 : 2,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                      itemCount: Colors.primaries.length,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.redo,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.undo,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            sketchType = SketchBookType.pencil;
                            strokeWidth = 20;
                            selectedColor =
                                Colors.primaries[selectedColorIndex];
                          });
                        },
                        icon: const Icon(
                          Icons.brush,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            sketchType = SketchBookType.pencil;
                            selectedColor = Colors.white;
                          });
                        },
                        icon: const Icon(
                          Icons.clean_hands,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: PopupMenuButton(
                          onSelected: (value) {
                            setState(() {
                              strokeWidth = value.toDouble();
                            });
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 10,
                                child: Text('10'),
                              ),
                              const PopupMenuItem(
                                value: 20,
                                child: Text('20'),
                              ),
                              const PopupMenuItem(
                                value: 30,
                                child: Text('30'),
                              ),
                              const PopupMenuItem(
                                value: 40,
                                child: Text('40'),
                              ),
                              const PopupMenuItem(
                                value: 50,
                                child: Text('50'),
                              ),
                            ];
                          },
                          child: const Icon(
                            Icons.list,
                            size: 30,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.save,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SketchBookPainter extends CustomPainter {
  SketchBookPainter({
    required this.sketches,
  });
  final List<SketchBook> sketches;
  @override
  void paint(Canvas canvas, Size size) {
    for (var sketch in sketches) {
      final paint = Paint()
        ..color = sketch.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(colors: Colors.primaries)
            .createShader(Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ))
        ..strokeWidth = sketch.strokeWidth;
      final path = Path();
      path.moveTo(sketch.offsets[0].dx, sketch.offsets[0].dy);
      for (var i = 0; i < sketch.offsets.length; i++) {
        if (i + 1 < sketch.offsets.length) {
          final offset1 = sketch.offsets[i];
          final offset2 = sketch.offsets[i + 1];
          path.quadraticBezierTo(
            offset1.dx,
            offset1.dy,
            offset2.dx,
            offset2.dy,
          );
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SketchBookPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(SketchBookPainter oldDelegate) => false;
}
