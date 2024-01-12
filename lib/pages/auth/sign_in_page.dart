// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/pages/auth/forget_password_page.dart';
import 'package:reco_app/pages/auth/sign_up_page.dart';
import 'package:reco_app/widgets/custom/custom_button.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  bool passenable = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text.rich(
                  TextSpan(
                    text: "If you don't have an account ",
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Register here',
                        style: TextStyle(
                          color: HexColor('4DC667'),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                _buildSignInForm(context),
                const SizedBox(height: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(authControllerProvider.notifier)
                              .emailPassSignIn(
                                  context, email.text, password.text);
                          if (!mounted) return;
                        }
                      },
                      label: 'Login',
                      backgroundColor: '4DC667',
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await ref
                              .read(authControllerProvider.notifier)
                              .signInWithGoogle(context);
                        } on FirebaseAuthException catch (e) {
                          print('Error signing in: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                      ),
                      icon: SvgPicture.asset('assets/img/icon_google.svg'),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildSignInForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              return null;
            }),
            cursorColor: HexColor('4DC667'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: HexColor('4DC667')),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: password,
            cursorColor: HexColor('4DC667'),
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Please fill password!';
              }
              return null;
            }),
            obscureText: passenable,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: HexColor('4DC667')),
              ),
              suffixIcon: IconButton(
                splashColor: Colors.transparent,
                color: HexColor('4DC667'),
                onPressed: () {
                  setState(() {
                    passenable = !passenable;
                  });
                },
                icon: Icon(passenable
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ForgetPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
