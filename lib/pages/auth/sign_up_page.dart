import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:reco_app/controller/auth_controller.dart';
import 'package:reco_app/pages/auth/sign_in_page.dart';

import '../../widgets/custom/custom_button.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  bool passenable = true;
  final _formKey = GlobalKey<FormState>();
  FocusNode _focusName = FocusNode();
  FocusNode _focusEmail = FocusNode();
  FocusNode _focusPassword = FocusNode();

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusName = FocusNode();
    _focusEmail = FocusNode();
    _focusPassword = FocusNode();
  }

  @override
  void dispose() {
    _focusName.dispose();
    _focusEmail.dispose();
    _focusPassword.dispose();
    email.dispose();
    name.dispose();
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Login here',
                        style: TextStyle(
                          color: HexColor('4DC667'),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const SignInPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                _buildSignUpForm(context),
                const SizedBox(height: 24.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signUp(context, name.text, email.text,
                                    password.text);
                          } on FirebaseAuthException catch (e) {
                            Logger().i(e);
                          }
                        }
                      },
                      label: 'Sign Up',
                      backgroundColor: '4DC667',
                      textColor: Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildSignUpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: name,
            focusNode: _focusName,
            cursorColor: HexColor('4DC667'),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Name',
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
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_focusEmail);
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: email,
            focusNode: _focusEmail,
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
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_focusPassword);
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: password,
            focusNode: _focusPassword,
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
                      if (passenable) {
                        passenable = false;
                      } else {
                        passenable = true;
                      }
                    });
                  },
                  icon: Icon(passenable == true
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded),
                )),
          ),
        ],
      ),
    );
  }
}
