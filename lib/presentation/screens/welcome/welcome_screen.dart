import 'package:flutter/material.dart';
import 'package:voz_popular/routes/app_routes.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //stack = fundo atrás do conteúdo
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const WaveBackground(),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: const Color.fromARGB(255, 39, 39, 39),
                      ),
                      onSelected: (value) {
                        if (value == 'server') {
                          print('Mudar para modo Servidor selecionado');
                          //troca de modo
                        } else if (value == 'help') {
                          print('Ajuda selecionada');
                          //url no futuro
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'server',
                              child: ListTile(
                                leading: Icon(
                                  Icons.admin_panel_settings_outlined,
                                ),
                                title: Text('Mudar para Servidor'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'help',
                              child: ListTile(
                                leading: Icon(Icons.help_outline),
                                title: Text('Ajuda'),
                              ),
                            ),
                          ],
                    ),
                  ),

                  const Spacer(flex: 3),
                  Text(
                    'Voz Popular',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SpoofTrial',
                      fontSize: 52,
                      fontWeight: FontWeight.bold, 
                      color: const Color.fromARGB(255, 45, 44, 45),
                    ),
                  ),
                  const Spacer(flex: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: const Color.fromARGB(255, 73, 73, 73),
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontFamily: 'SpoofTrial',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // side: BorderSide(
                          //   color: const Color.fromARGB(255, 62, 62, 62),
                          //   width: 2,
                          // ),
                          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                          padding: const EdgeInsets.symmetric(vertical: 26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontFamily: 'SpoofTrial',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final waveAreaHeight = size.height * 0.55;

    return SizedBox(
      height: waveAreaHeight,
      width: size.width,
      child: Stack(
        children: [
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
