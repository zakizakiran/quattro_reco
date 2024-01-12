import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:reco_app/widgets/custom/custom_button.dart';

class SuccessSentPage extends StatelessWidget {
  const SuccessSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Lottie.asset(
              'assets/img/checked.json',
              width: MediaQuery.sizeOf(context).width / 2,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "We've sent you link to reset your password through your email",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CustomButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: 'Back',
              backgroundColor: '4DC667',
              textColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
