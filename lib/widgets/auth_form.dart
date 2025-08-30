import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final String title;
  final String actionText;
  final String? errorMessage;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? nameController;
  final VoidCallback onSubmit;
  final VoidCallback toggleAuthMode;
  final bool isLoginMode;
  final String? nameError;
  final String? emailError;
  final String? passwordError;

  const AuthForm({
    super.key,
    required this.title,
    required this.actionText,
    required this.errorMessage,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    this.nameController,
    required this.onSubmit,
    required this.toggleAuthMode,
    required this.isLoginMode,
    this.nameError,
    this.emailError,
    this.passwordError,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF382110),
              child: Icon(
                widget.isLoginMode ? Icons.person : Icons.person_add,
                size: 90,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF382110),
              ),
            ),
            const SizedBox(height: 30),

            // Nombre (solo signup)
            if (!widget.isLoginMode && widget.nameController != null)
              Column(
                children: [
                  TextField(
                    controller: widget.nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      errorText: widget.nameError,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),

            // Email
            TextField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.email),
                errorText: widget.emailError,
              ),
            ),
            const SizedBox(height: 20),

            // Password
            TextField(
              controller: widget.passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                errorText: widget.passwordError,
              ),
            ),
            const SizedBox(height: 20),

            if (widget.errorMessage != null)
              Text(
                widget.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),

            widget.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: widget.onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(235, 226, 215, 1.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.actionText,
                      style: const TextStyle(fontSize: 16, color: Color(0xFF382110)),
                    ),
                  ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.toggleAuthMode,
              child: Text(
                widget.isLoginMode
                    ? "Don't have an account? Sign up"
                    : "Already have an account? Log in",
                style: const TextStyle(
                  color: Color(0xFF382110),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
