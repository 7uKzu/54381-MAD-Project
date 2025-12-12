import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bloodconnect/widgets/organisms/app_shell.dart';
import 'package:bloodconnect/widgets/atoms/app_text_field.dart';
import 'package:bloodconnect/widgets/atoms/primary_button.dart';
import 'package:bloodconnect/providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  String _role = 'Donor';
  PlatformFile? _avatar;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return AppShell(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Create account',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              AppTextField(
                  controller: _name,
                  hint: 'Full name',
                  validator: (v) => (v != null && v.trim().isNotEmpty)
                      ? null
                      : 'Name required'),
              const SizedBox(height: 12),
              AppTextField(
                  controller: _email,
                  hint: 'Email',
                  keyboard: TextInputType.emailAddress,
                  validator: (v) => v != null && v.contains('@')
                      ? null
                      : 'Valid email required'),
              const SizedBox(height: 12),
              AppTextField(
                  controller: _password,
                  hint: 'Password',
                  obscure: true,
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : 'Minimum 6 characters'),
              const SizedBox(height: 12),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _roles
                      .map((r) => ChoiceChip(
                            label: Text(r),
                            selected: _role == r,
                            onSelected: (_) => setState(() => _role = r),
                            labelStyle: Theme.of(context).textTheme.labelLarge,
                          ))
                      .toList()),
              const SizedBox(height: 12),
              Row(children: [
                OutlinedButton.icon(
                    onPressed: _pickAvatar,
                    icon: const Icon(Icons.image),
                    label: const Text('Avatar (optional)')),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(_avatar?.name ?? 'No file selected',
                        overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Register',
                loading: auth.isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final ok = await context.read<AuthProvider>().register(
                      _email.text.trim(),
                      _password.text,
                      _name.text.trim(),
                      _role);
                  if (!mounted) return;
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration failed')));
                  }
                },
              )
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> _pickAvatar() async {
    try {
      final res = await FilePicker.platform
          .pickFiles(type: FileType.image, withReadStream: false);
      if (res != null && res.files.isNotEmpty) {
        setState(() => _avatar = res.files.first);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('File pick failed')));
    }
  }

  List<String> get _roles => const [
        'Donor',
        'Recipient',
        'Technician',
        'Staff',
        'BloodBankManager',
        'Admin',
        'MedicalStaff'
      ];
}
