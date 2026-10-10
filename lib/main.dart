
import 'package:flutter/material.dart';

void main() {
  runApp(const FootballApp());
}

class FootballApp extends StatelessWidget {
  const FootballApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football League',
      theme: ThemeData.dark(),
      home: const FootballHome(),
    );
  }
}

class FootballHome extends StatefulWidget {
  const FootballHome({super.key});

  @override
  State<FootballHome> createState() => _FootballHomeState();
}

class _FootballHomeState extends State<FootballHome> {
  int goals = 0;
  double playerX = 0.5;
  double playerY = 0.7;
  bool started = false;

  void startGame() {
    setState(() {
      goals = 0;
      playerX = 0.5;
      playerY = 0.7;
      started = true;
    });
  }

  void shoot() {
    if (!started) return;

    setState(() {
      goals++;
      playerX = 0.5;
      playerY = 0.7;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: const Text('Football League ⚽'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              'Goals: $goals',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (details) {
                      if (!started) return;

                      setState(() {
                        playerX = (details.localPosition.dx /
                                constraints.maxWidth)
                            .clamp(0.08, 0.92)
                            .toDouble();

                        playerY = (details.localPosition.dy /
                                constraints.maxHeight)
                            .clamp(0.25, 0.85)
                            .toDouble();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: FootballFieldPainter(),
                            ),
                          ),
                          const Positioned(
                            top: 5,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                '🥅',
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.5 - 17,
                            top: constraints.maxHeight * 0.42,
                            child: const Text(
                              '⚽',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                          Positioned(
                            left: constraints.maxWidth * playerX - 20,
                            top: constraints.maxHeight * playerY,
                            child: const Column(
                              children: [
                                Text(
                                  '🔵',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  'PLAYER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!started)
                            Center(
                              child: ElevatedButton(
                                onPressed: startGame,
                                child: const Text(
                                  'START GAME',
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: shoot,
                  icon: const Icon(Icons.sports_soccer),
                  label: const Text(
                    'SHOOT',
                    style: TextStyle(fontSize: 22),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FootballFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.25,
        0,
        size.width * 0.5,
        size.height * 0.18,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}