import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 400,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.network(
                    fullLogoImageUrl,
                    width: 400,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Welcome to ICOC app admin panel!',
                    style: TextStyle(fontSize: 24),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyTexField(
                            controller: _emailController,
                            hint: 'Email',
                            validator: _validateEmail,
                            maxLength: 30,
                          ),
                          MyTexField(
                            controller: _passwordController,
                            obscureText: true,
                            hint: 'Password',
                            validator: _validatePassword,
                            maxLength: 16,
                            onFieldSubmitted: () {
                              _login(context);
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextButton(
                            onPressed: () {
                              _login(context);
                            },
                            label: 'Login',
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text('Do not have an account? Email me:'),
                          TextButton(
                            onPressed: () async {
                              final Uri emailLaunchUri = Uri(
                                scheme: 'mailto',
                                path: email,
                                query: encodeQueryParameters(<String, String>{
                                  'subject':
                                      'Access to ICOC app admin panel request',
                                  'body':
                                      'Hello, I woud like to request access to the ICOC app admin panel. Please send login credentials.'
                                }),
                              );
                              if (await canLaunchUrl(emailLaunchUri)) {
                                await launchUrl(emailLaunchUri);
                              } else {
                                throw 'Could not launch $emailLaunchUri';
                              }
                            },
                            child: const Text(email),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              state.whenOrNull(
                error: (message) {
                  showAlertDialog(context, message);
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  orElse: () => const SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEvent.logIn(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }
}
