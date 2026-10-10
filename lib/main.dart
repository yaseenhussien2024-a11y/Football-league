
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const FootballLeagueApp());
}

class FootballLeagueApp extends StatelessWidget {
  const FootballLeagueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football League',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF071C15),
              Color(0xFF123D29),
              Color(0xFF071C15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.sports_soccer,
                    size: 105,
                    color: Color(0xFF69F0AE),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'FOOTBALL',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const Text(
                    'LEAGUE',
                    style: TextStyle(
                      color: Color(0xFF69F0AE),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'عيش أجواء كرة القدم!',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 40),
                  _menuButton(
                    context,
                    'ابدأ المباراة',
                    Icons.play_arrow_rounded,
                    const Color(0xFF00C853),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MatchPage(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _menuButton(
                    context,
                    'طريقة اللعب',
                    Icons.sports_esports,
                    const Color(0xFF263F35),
                    () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('طريقة اللعب'),
                        content: const Text(
                          '1- المس الملعب لتحريك اللاعب.\n'
                          '2- اقترب من الكرة لتستحوذ عليها.\n'
                          '3- اضغط زر تسديد لتسديد الكرة.\n'
                          '4- سجل أهدافًا قبل انتهاء الوقت!',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('تمام'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 42),
                  const Text(
                    'FOOTBALL LEAGUE • 2026',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final Stopwatch _clock = Stopwatch();
  Timer? _timer;

  int homeScore = 0;
  int awayScore = 0;
  int secondsLeft = 90;

  // مواقع اللاعبين والكرة بنسب من مساحة الملعب.
  Offset player = const Offset(.30, .50);
  Offset opponent = const Offset(.70, .50);
  Offset ball = const Offset(.36, .50);

  bool hasBall = false;
  bool finished = false;
  bool shooting = false;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _clock.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || finished) return;

      setState(() {
        secondsLeft--;
        if (secondsLeft <= 0) {
          secondsLeft = 0;
          finished = true;
          _timer?.cancel();
          _clock.stop();
        }
      });
    });
  }

  void _movePlayer(Offset target) {
    if (finished) return;

    setState(() {
      player = Offset(
        target.dx.clamp(.08, .92).toDouble(),
        target.dy.clamp(.10, .90).toDouble(),
      );

      final distance = (player - ball).distance;

      if (distance < .15) {
        hasBall = true;
        ball = Offset(
          player.dx + .045,
          player.dy,
        );
      } else {
        hasBall = false;
      }
    });
  }

  void _shoot() {
    if (finished || shooting) return;

    if (!hasBall && (player - ball).distance > .19) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اقترب من الكرة أولًا!'),
          duration: Duration(milliseconds: 800),
        ),
      );
      return;
    }

    setState(() {
      shooting = true;
      hasBall = false;
      ball = Offset(.98, player.dy);
    });

    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;

      setState(() {
        if (player.dx > .48) {
          homeScore++;
        }

        ball = const Offset(.50, .50);
        player = const Offset(.30, .50);
        opponent = const Offset(.70, .50);
        hasBall = false;
        shooting = false;
      });
    });
  }

  void _resetMatch() {
    _timer?.cancel();
    _clock
      ..reset()
      ..start();

    setState(() {
      homeScore = 0;
      awayScore = 0;
      secondsLeft = 90;
      player = const Offset(.30, .50);
      opponent = const Offset(.70, .50);
      ball = const Offset(.36, .50);
      hasBall = false;
      finished = false;
      shooting = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || finished) return;
      setState(() {
        secondsLeft--;
        if (secondsLeft <= 0) {
          secondsLeft = 0;
          finished = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _clock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsLeft % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FOOTBALL LEAGUE',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: const Color(0xFF09271A),
        actions: [
          IconButton(
            onPressed: _resetMatch,
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة المباراة',
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF071C15),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _teamInfo('فريقك', Colors.blue),
                  Column(
                    children: [
                      Text(
                        '$homeScore  -  $awayScore',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$minutes:$seconds',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF69F0AE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _teamInfo('الخصم', Colors.red),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final size = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );

                      return GestureDetector(
                        onTapDown: (details) {
                          final local = details.localPosition;
                          _movePlayer(
                            Offset(
                              local.dx / size.width,
                              local.dy / size.height,
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: FieldPainter(),
                              ),
                            ),
                            _playerWidget(
                              size,
                              player,
                              Colors.blue,
                              Icons.person,
                            ),
                            _playerWidget(
                              size,
                              opponent,
                              Colors.red,
                              Icons.person,
                            ),
                            Positioned(
                              left: ball.dx * size.width - 13,
                              top: ball.dy * size.height - 13,
                              child: const Icon(
                                Icons.sports_soccer,
                                size: 26,
                                color: Colors.white,
                              ),
                            ),
                            if (finished)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black87,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'انتهت المباراة!',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          homeScore > awayScore
                                              ? 'مبروك! أنت الفائز 🏆'
                                              : homeScore == awayScore
                                                  ? 'تعادل!'
                                                  : 'حاول مرة أخرى!',
                                          style: const TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: _resetMatch,
                                          child: const Text('العب مرة أخرى'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'المس المكان الذي تريد تحريك لاعبك إليه',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _shoot,
                        icon: const Icon(Icons.sports_soccer),
                        label: const Text(
                          'تسديد',
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00C853),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetMatch,
                        icon: const Icon(Icons.replay),
                        label: const Text(
                          'إعادة اللعب',
                          style: TextStyle(fontSize: 17),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _teamInfo(String name, Color color) {
    return Column(
      children: [
        Icon(Icons.shield, color: color, size: 32),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _playerWidget(
    Size size,
    Offset position,
    Color color,
    IconData icon,
  ) {
    return Positioned(
      left: position.dx * size.width - 16,
      top: position.dy * size.height - 20,
      child: Icon(icon, color: color, size: 40),
    );
  }
}

class FieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      paint.color = i.isEven
          ? const Color(0xFF168044)
          : const Color(0xFF126B38);

      canvas.drawRect(
        Rect.fromLTWH(
          i * size.width / 8,
          0,
          size.width / 8 + 1,
          size.height,
        ),
        paint,
      );
    }

    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(8, 8, size.width - 16, size.height - 16),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 8),
      Offset(size.width / 2, size.height - 8),
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      math.min(size.width, size.height) * .13,
      paint,
    );

    final goalHeight = size.height * .25;
    final goalTop = (size.height - goalHeight) / 2;

    canvas.drawRect(
      Rect.fromLTWH(8, goalTop, size.width * .10, goalHeight),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * .90,
        goalTop,
        size.width * .10 - 8,
        goalHeight,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
