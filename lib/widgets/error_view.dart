import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;
  final LottieBuilder lottie;

  const ErrorView({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onPressed,
    required this.lottie,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lottie,
            //const SizedBox(height: 0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),),
            ),
          ],
        ),
      ),
    );
  }
}