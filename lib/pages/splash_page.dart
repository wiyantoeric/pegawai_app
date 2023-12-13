import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    Timer(const Duration(milliseconds: 1500), () {
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            left: -150,
            top: -100,
            child: Container(
              child: Image.asset(
                'assets/images/orange-circle.png',
                width: 450,
                height: 450,
              ),
            ),
          ),
          Positioned(
            right: -300,
            bottom: -100,
            child: Container(
              child: Image.asset(
                'assets/images/blue-circle.png',
                width: 600,
                height: 600,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pegawai App',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.tertiary),
                        value: _progressAnimation.value,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
