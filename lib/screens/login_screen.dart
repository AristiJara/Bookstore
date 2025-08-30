import 'package:bookshop/core/utils/secure_storage.dart';
import 'package:bookshop/providers/token_provider.dart';
import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookshop/services/auth_services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onRegisterPressed;
  const LoginScreen({super.key, required this.onRegisterPressed});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  final AuthServices _authService = AuthServices();

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

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
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      await SecureStorage.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await SecureStorage.saveUser(authResponse.user);

      ref.read(userProvider.notifier).setUser(authResponse.user);
      ref.read(tokenProvider.notifier).state = authResponse.accessToken;

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Sesión iniciada correctamente')),
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
        title: 'Log In',
        actionText: 'Log In',
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        emailController: _emailController,
        passwordController: _passwordController,
        emailError: _emailError,
        passwordError: _passwordError,
        onSubmit: _login,
        toggleAuthMode: widget.onRegisterPressed,
        isLoginMode: true,
      ),
    );
  }
}
