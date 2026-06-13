
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Force portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: MobileLayout(),
        ),
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(color: const Color(0xFFD2E9F7)),
        // Grid Overlay
        const Positioned.fill(child: GridOverlay()),
        
        // Green Hill
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipPath(
            clipper: HillClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: const Color(0xFF76BA53),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: Column(
            children: [
              const FakeStatusBar(),
              const SizedBox(height: 10),
              // Logo and Title
              const LogoAndTitle(),
              const SizedBox(height: 8),
              Text(
                "Capture cities. Solve clues. Build your word empire.",
                style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: const Color(0xFF232D3F),
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              // Chibi Soldiers
              const ChibiSoldierRow(),
              const Spacer(),
              // Buttons and Nav
              const BottomControls(),
              const SizedBox(height: 10),
              // Version
              const Text(
                "v1.0.0",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class FakeStatusBar extends StatelessWidget {
  const FakeStatusBar({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("12:34", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: Colors.black54, size: 14),
              SizedBox(width: 4),
              Icon(Icons.wifi, color: Colors.black54, size: 14),
              SizedBox(width: 4),
              Icon(Icons.battery_full, color: Colors.black54, size: 14),
            ],
          )
        ],
      ),
    );
  }
}

class GridOverlay extends StatelessWidget {
  const GridOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    // Draw horizontal lines
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


class HillClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(
        size.width / 2, -size.height * 0.1, 0, size.height * 0.2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LogoAndTitle extends StatelessWidget {
  const LogoAndTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFFFABC41),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Text(
              'W',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Stack(
          children: [
            // Outline
            Text(
              'WORD WARS',
              style: GoogleFonts.bangers(
                fontSize: 48,
                letterSpacing: 3,
                fontStyle: FontStyle.italic,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = const Color(0xFF232D3F),
              ),
            ),
            // Fill
            Text(
              'WORD WARS',
              style: GoogleFonts.bangers(
                fontSize: 48,
                letterSpacing: 3,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFF9A825),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class ChibiSoldierRow extends StatelessWidget {
  const ChibiSoldierRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChibiSoldier(
          letter: 'W',
          color: Color(0xFF4CAF50),
          helmetType: HelmetType.camo,
          weapon: Weapon.sword,
        ),
        ChibiSoldier(
          letter: 'A',
          color: Color(0xFFFFC107),
          helmetType: HelmetType.beret,
          weapon: Weapon.dagger,
        ),
        ChibiSoldier(
          letter: 'R',
          color: Color(0xFFF44336),
          helmetType: HelmetType.riot,
          weapon: Weapon.shield,
          showCharge: true,
        ),
        ChibiSoldier(
          letter: 'S',
          color: Color(0xFF009688),
          helmetType: HelmetType.army,
          weapon: Weapon.rifle,
        ),
      ],
    );
  }
}

enum HelmetType { camo, beret, riot, army }
enum Weapon { sword, dagger, shield, rifle }

class ChibiSoldier extends StatelessWidget {
  final String letter;
  final Color color;
  final HelmetType helmetType;
  final Weapon weapon;
  final bool showCharge;

  const ChibiSoldier({
    super.key,
    required this.letter,
    required this.color,
    required this.helmetType,
    required this.weapon,
    this.showCharge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Body
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            // Boots
            Row(
              children: [
                Container(width: 20, height: 10, color: Colors.black),
                const SizedBox(width: 5),
                Container(width: 20, height: 10, color: Colors.black),
              ],
            )
          ],
        ),
        // Helmet
        Positioned(
          top: -25,
          child: Helmet(type: helmetType),
        ),
        // Eyes and Cheeks
        Positioned(
          top: 20,
          child: Row(
            children: [
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
              const SizedBox(width: 15),
              Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
            ],
          ),
        ),
        Positioned(
          top: 28,
          child: Row(
            children: [
              Container(width: 8, height: 4, decoration: BoxDecoration(color: Colors.pink.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 25),
              Container(width: 8, height: 4, decoration: BoxDecoration(color: Colors.pink.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
            ],
          ),
        ),
        // Weapon
        Positioned(
          right: weapon == Weapon.rifle ? -40 : -20,
          top: 20,
          child: SoldierWeapon(weapon: weapon),
        ),

        // Charge bubble
        if(showCharge)
        Positioned(
          top: -55,
          right: -30,
          child: ChargeBubble(),
        )
      ],
    );
  }
}


class Helmet extends StatelessWidget {
  final HelmetType type;
  const Helmet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HelmetType.camo:
        return const Icon(Icons.military_tech, color: Color(0xFF388E3C), size: 40);
      case HelmetType.beret:
        return Transform.rotate(
          angle: -0.3,
          child: Stack(
            children: [
              const Icon(Icons.style, color: Color(0xFF37474F), size: 35),
              Positioned(
                right: 2, top: 4,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle))
              )
            ],
          ),
        );
      case HelmetType.riot:
        return const Icon(Icons.sports_motorsports, color: Color(0xFF263238), size: 40);
      case HelmetType.army:
        return const Icon(Icons.admin_panel_settings, color: Color(0xFF455A64), size: 40);
    }
  }
}

class SoldierWeapon extends StatelessWidget {
  final Weapon weapon;
  const SoldierWeapon({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    switch (weapon) {
      case Weapon.sword:
        return const Icon(Icons.gavel, color: Colors.grey, size: 30); // Placeholder
      case Weapon.dagger:
        return const Icon(Icons.colorize, color: Colors.grey, size: 25); // Placeholder
      case Weapon.shield:
       return Transform.translate(offset: const Offset(-80, 0), child: const Icon(Icons.shield, color: Colors.blueGrey, size: 35));
      case Weapon.rifle:
        return const Icon(Icons.precision_manufacturing_rounded, color: Colors.black, size: 40); // Placeholder
    }
  }
}

class ChargeBubble extends StatelessWidget {
  const ChargeBubble({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChargeBubblePainter(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text("CHARGE!", style: GoogleFonts.bangers(fontSize: 14, color: Colors.black)),
      ),
    );
  }
}

class ChargeBubblePainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;
        
        final path = Path();
        path.moveTo(size.width * 0.2, 0);
        path.lineTo(size.width * 0.8, 0);
        path.quadraticBezierTo(size.width, 0, size.width, size.height * 0.2);
        path.lineTo(size.width, size.height * 0.8);
        path.quadraticBezierTo(size.width, size.height, size.width * 0.8, size.height);
        path.lineTo(size.width * 0.3, size.height);
        path.lineTo(size.width * 0.1, size.height * 1.3);
        path.lineTo(size.width * 0.2, size.height);
        path.lineTo(size.width * 0.2, size.height);
        path.quadraticBezierTo(0, size.height, 0, size.height * 0.8);
        path.lineTo(0, size.height * 0.2);
        path.quadraticBezierTo(0, 0, size.width * 0.2, 0);
        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFABC41),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            side: const BorderSide(width: 3, color: const Color(0xFF232D3F)),
          ),
          child: Stack(
            children: [
              // Outline
              Text(
                'PLAY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = const Color(0xFF232D3F),
                ),
              ),
              // Fill
              const Text(
                'PLAY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCircleButton(Icons.map),
            const SizedBox(width: 20),
            buildCircleButton(Icons.emoji_events),
            const SizedBox(width: 20),
            buildCircleButton(Icons.settings),
          ],
        )
      ],
    );
  }

  Widget buildCircleButton(IconData icon) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 2), blurRadius: 4.0)
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF232D3F)),
        onPressed: () {},
      ),
    );
  }
}
