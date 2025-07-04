import 'package:flutter/material.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Define a altura total da área onde as ondas vão aparecer
    final waveAreaHeight = size.height * 0.55;

    return SizedBox(
      height: waveAreaHeight,
      width: size.width,
      child: Stack(
        children: [
          // Cada onda é um Positioned para controlar sua altura a partir do fundo.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: waveAreaHeight * 1.3,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: const Color(0xffAAB9FF).withOpacity(0.3)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: waveAreaHeight * 1.2,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: const Color(0xff9E8DFF).withOpacity(0.4)),
            ),
          ),
           Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: waveAreaHeight * 1.1,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: const Color(0xff7F7FD5).withOpacity(0.5)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: waveAreaHeight * 1,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: const Color.fromARGB(255, 43, 43, 43)),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  WaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.4); 

    path.quadraticBezierTo(
      size.width * 0.25, 
      size.height * 0.3,
      size.width * 0.5, 
      size.height * 0.4
    );

    path.quadraticBezierTo(
      size.width * 0.75, 
      size.height * 0.5,
      size.width, 
      size.height * 0.4
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height); 
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
