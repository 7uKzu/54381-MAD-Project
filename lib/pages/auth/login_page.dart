import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';
import 'package:bloodconnect/widgets/atoms/app_text_field.dart';
import 'package:bloodconnect/widgets/atoms/primary_button.dart';
import 'package:bloodconnect/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AppShell(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Welcome back',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              AppTextField(
                controller: _email,
                hint: 'Email',
                keyboard: TextInputType.emailAddress,
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _password,
                hint: 'Password',
                obscure: true,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Minimum 6 characters',
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Login',
                loading: auth.isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final ok = await context
                      .read<AuthProvider>()
                      .login(_email.text.trim(), _password.text);
                  if (!mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login failed')));
                  }
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
