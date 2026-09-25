import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use mobile image for small screens.
    // Use desktop image for tablet/desktop screens.
    final bool isMobile = screenWidth < 600;

    final String backgroundImage = isMobile
        ? 'assets/images/hospital_welcome_image_mobile.png'
        : 'assets/images/hospital_welcome.png';

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.03),
                      Colors.black.withOpacity(0.30),
                    ],
                    stops: const [
                      0.0,
                      0.65,
                      1.0,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: isMobile ? 20 : 50,
              right: isMobile ? 20 : 50,
              bottom: isMobile ? 25 : 45,
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    width: isMobile
                        ? double.infinity
                        : 420,
                    height: isMobile ? 55 : 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offNamed('/roleselecting');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor:
                            const Color(0xFF2563EB)
                                .withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize:
                                  isMobile ? 17 : 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: isMobile ? 22 : 24,
                          ),
                        ],
                      ),
                    ),
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
