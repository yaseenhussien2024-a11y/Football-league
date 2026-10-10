
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const FootballLeague());
}

class FootballLeague extends StatelessWidget {
  const FootballLeague({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football League',
      theme: ThemeData.dark(),
      home: const FootballGame(),
    );
  }
}

class FootballGame extends StatefulWidget {
  const FootballGame({super.key});

  @override
  State<FootballGame> createState() => _FootballGameState();
}

class _FootballGameState extends State<FootballGame> {
  double playerX = 0.5;
  double playerY = 0.72;
  double ballX = 0.5;
  double ballY = 0.64;

  int score = 0;
  int seconds = 60;
  bool playing = false;
  Timer? timer;

  void startGame() {
    timer?.cancel();

    setState(() {
      playerX = 0.5;
      playerY = 0.72;
      ballX = 0.5;
      ballY = 0.64;
      score = 0;
      seconds = 60;
      playing = true;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;

      if (seconds <= 1) {
        t.cancel();
        setState(() {
          seconds = 0;
          playing = false;
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  void movePlayer(TapDownDetails details, Size size) {
    if (!playing) return;

    setState(() {
      playerX = (details.localPosition.dx / size.width)
          .clamp(0.08, 0.92)
          .toDouble();

      playerY = (details.localPosition.dy / size.height)
          .clamp(0.35, 0.88)
          .toDouble();
    });
  }

  void shootBall() {
    if (!playing) return;

    setState(() {
      final closeToBall =
          (playerX - ballX).abs() < 0.22 &&
          (playerY - ballY).abs() < 0.18;

      if (closeToBall) {
        score++;
        ballX = 0.5;
        ballY = 0.64;
        playerX = 0.5;
        playerY = 0.72;
      } else {
        ballY = (ballY - 0.08).clamp(0.15, 0.85).toDouble();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10251A),
      appBar: AppBar(
        title: const Text('Football League ⚽'),
        centerTitle: true,
        backgroundColor: Colors.green.shade800,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Goals: $score',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Time: $seconds',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return GestureDetector(
                    onTapDown: (details) =>
                        movePlayer(details, size),
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF168447),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: FieldPainter(),
                            ),
                          ),
                          Positioned(
                            left: ballX * size.width - 17,
                            top: ballY * size.height - 17,
                            child: const Text(
                              '⚽',
                              style: TextStyle(fontSize: 34),
                            ),
                          ),
                          Positioned(
                            left: playerX * size.width - 20,
                            top: playerY * size.height - 25,
                            child: const Column(
                              children: [
                                Text(
                                  '🔵',
                                  style: TextStyle(fontSize: 35),
                                ),
                                Text(
                                  'YOU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: size.width * 0.5 - 20,
                            top: size.height * 0.12,
                            child: const Text(
                              '🥅',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                          if (!playing)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      seconds == 0
                                          ? 'Game Over!'
                                          : 'Football Game',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Your goals: $score',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: startGame,
                                      child: Text(
                                        seconds == 0
                                            ? 'Play Again'
                                            : 'Start Game',
                                      ),
                                    ),
                                  ],
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
                  onPressed: shootBall,
                  icon: const Icon(Icons.sports_soccer),
                  label: const Text(
                    'SHOOT!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
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

class FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      linePaint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      linePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.14,
      linePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.25,
        0,
        size.width * 0.5,
        size.height * 0.18,
      ),
      linePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.35,
        0,
        size.width * 0.3,
        size.height * 0.08,
      ),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
