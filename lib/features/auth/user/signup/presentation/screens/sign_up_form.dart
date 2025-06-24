import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../login/application/controllers/email_auth_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final success = await ref
          .read(emailAuthControllerProvider.notifier)
          .signUp(_email.trim(), _password.trim(), context);

      final msg = success ? 'Signup successful' : 'Signup failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(emailAuthControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (val) =>
                val != null && val.contains('@') ? null : 'Enter a valid email',
            onSaved: (val) => _email = val ?? '',
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (val) => val != null && val.length >= 6
                ? null
                : 'Min 6 characters required',
            onSaved: (val) => _password = val ?? '',
          ),
          const SizedBox(height: 24),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _submit(context),
                  child: const Text("Sign Up"),
                ),
        ],
      ),
    );
  }
}
