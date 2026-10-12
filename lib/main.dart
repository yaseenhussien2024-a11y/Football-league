
import 'package:flutter/material.dart';

void main() {
  runApp(const FootballGame());
}

class FootballGame extends StatelessWidget {
  const FootballGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'لعبة الكورة',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double playerX = 0.25;
  double playerY = 0.50;
  int score = 0;
  int shots = 0;
  String message = 'يلا نلعب!';

  void movePlayer(double dx, double dy) {
    setState(() {
      playerX = (playerX + dx).clamp(0.08, 0.78).toDouble();
      playerY = (playerY + dy).clamp(0.12, 0.88).toDouble();
      message = 'قرّب من المرمى وسدّد!';
    });
  }

  void shoot() {
    setState(() {
      shots++;
      if (playerX >= 0.58 &&
          playerY >= 0.38 &&
          playerY <= 0.62) {
        score++;
        message = 'جوووول! ⚽';
      } else {
        message = 'حاول تسدّد تاني!';
      }
    });
  }

  void resetGame() {
    setState(() {
      playerX = 0.25;
      playerY = 0.50;
      score = 0;
      shots = 0;
      message = 'يلا نلعب!';
    });
  }

  Widget controlButton(
    IconData icon,
    VoidCallback action,
  ) {
    return SizedBox(
      width: 58,
      height: 50,
      child: FilledButton(
        onPressed: action,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.green.shade800,
        ),
        child: Icon(icon, size: 28),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('⚽ تحدي كرة القدم'),
          centerTitle: true,
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'الأهداف: $score',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'التسديدات: $shots',
                    style: const TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: resetGame,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PitchPainter(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: h * 0.35,
                              width: 30,
                              height: h * 0.30,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: playerX * w - 18,
                              top: playerY * h - 25,
                              child: const Icon(
                                Icons.sports_soccer,
                                color: Colors.white,
                                size: 42,
                              ),
                            ),
                            Positioned(
                              left: playerX * w + 15,
                              top: playerY * h + 12,
                              child: const Text(
                                '⚽',
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              controlButton(
                Icons.keyboard_arrow_up,
                () => movePlayer(0, -0.07),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controlButton(
                    Icons.keyboard_arrow_right,
                    () => movePlayer(0.06, 0),
                  ),
                  const SizedBox(width: 8),
                  controlButton(
                    Icons.keyboard_arrow_down,
                    () => movePlayer(0, 0.07),
                  ),
                  const SizedBox(width: 8),
                  controlButton(
                    Icons.keyboard_arrow_left,
                    () => movePlayer(-0.06, 0),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 48,
                child: FilledButton.icon(
                  onPressed: shoot,
                  icon: const Icon(Icons.sports_soccer),
                  label: const Text('تسديد الكرة'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange.shade800,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grass = Paint();

    for (int i = 0; i < 8; i++) {
      grass.color = i.isEven
          ? const Color(0xFF388E3C)
          : const Color(0xFF43A047);

      canvas.drawRect(
        Rect.fromLTWH(
          i * size.width / 8,
          0,
          size.width / 8 + 1,
          size.height,
        ),
        grass,
      );
    }

    final line = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(
        8,
        8,
        size.width - 16,
        size.height - 16,
      ),
      line,
    );

    canvas.drawLine(
      Offset(size.width / 2, 8),
      Offset(size.width / 2, size.height - 8),
      line,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.13,
      line,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.78,
        size.height * 0.25,
        size.width * 0.18,
        size.height * 0.50,
      ),
      line,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.04,
        size.height * 0.25,
        size.width * 0.18,
        size.height * 0.50,
      ),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
