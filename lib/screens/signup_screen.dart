import 'package:bookshop/core/utils/secure_storage.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookshop/services/auth_services.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final VoidCallback onLoginPressed;
  const SignupScreen({super.key, required this.onLoginPressed});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _nameError;
  String? _emailError;
  String? _passwordError;

  final AuthServices _authService = AuthServices();

  Future<void> _signup() async {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _errorMessage = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

    if (name.isEmpty) {
      _nameError = "Name is required";
      hasError = true;
    }

    if (email.isEmpty || !email.contains('@')) {
      _emailError = "Valid email is required";
      hasError = true;
    }

    if (password.isEmpty || password.length < 6) {
      _passwordError = "Password must be at least 6 characters";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authService.signup(
        name: name,
        email: email,
        password: password,
      );

      await SecureStorage.saveUser(user);
      ref.read(userProvider.notifier).setUser(user);

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Account created successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(
        title: 'Sign Up',
        actionText: 'Create Account',
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        nameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        nameError: _nameError,
        emailError: _emailError,
        passwordError: _passwordError,
        onSubmit: _signup,
        toggleAuthMode: widget.onLoginPressed,
        isLoginMode: false,
      ),
    );
  }
}
