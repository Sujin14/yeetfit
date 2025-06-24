import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/controllers/admin_auth_controller.dart';

class AdminLoginForm extends ConsumerStatefulWidget {
  const AdminLoginForm({super.key});

  @override
  ConsumerState<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends ConsumerState<AdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref
          .read(adminAuthControllerProvider.notifier)
          .loginAsAdmin(
            username: _username.trim(),
            password: _password.trim(),
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(adminAuthControllerProvider);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (val) =>
                val != null && val.isNotEmpty ? null : 'Enter your username',
            onSaved: (val) => _username = val ?? '',
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (val) =>
                val != null && val.length >= 6 ? null : 'Minimum 6 characters',
            onSaved: (val) => _password = val ?? '',
          ),
          const SizedBox(height: 24),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => _submit(context),
                  child: const Text("Login as Admin"),
                ),
        ],
      ),
    );
  }
}
