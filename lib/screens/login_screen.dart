import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app/theme/kurie_colors.dart';
import '../data/services/auth_service.dart';

/// Login screen — two-step: Email entry then Password entry.
/// Matches Stitch "Login: Email Step" and "Login: Password Step" designs.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordStep = false;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onContinueEmail() {
    if (_emailController.text.trim().isNotEmpty) {
      setState(() => _isPasswordStep = true);
    }
  }

  Future<void> _onLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final userCredential = await AuthService().signInWithEmailAndPassword(
        email,
        password,
      );
      if (mounted) {
        setState(() => _isLoading = false);
        if (userCredential != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        String message = 'Login failed';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = e.message ?? message;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      }
    }
  }

  void _onBackToEmail() {
    setState(() => _isPasswordStep = false);
  }

  Future<void> _onGoogleSignIn() async {
    setState(() => _isLoading = true);
    final userCredential = await AuthService().signInWithGoogle();

    if (mounted) {
      setState(() => _isLoading = false);
      if (userCredential != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google sign-in failed or was canceled.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KurieColors.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _isPasswordStep ? _buildPasswordStep() : _buildEmailStep(),
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return SingleChildScrollView(
      key: const ValueKey('email'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          // Header
          const Text(
            'Log in',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.64,
              color: KurieColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your email to log in and access your meter data.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: KurieColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          // Email field
          const Text(
            'EMAIL',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: KurieColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'you@example.com'),
            onSubmitted: (_) => _onContinueEmail(),
          ),
          const SizedBox(height: 24),
          // Continue button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onContinueEmail,
              child: const Text('Continue'),
            ),
          ),
          const SizedBox(height: 24),
          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'or',
                  style: TextStyle(
                    fontSize: 14,
                    color: KurieColors.onSurfaceVariant,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          // Social login
          SizedBox(
            width: double.infinity,
            height: 48,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: KurieColors.secondary,
                    ),
                  )
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: KurieColors.primary,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: KurieColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    onPressed: _onGoogleSignIn,
                    icon: Image.asset(
                      'lib/app/assets/google-icon.webp',
                      width: 24,
                      height: 24,
                    ),
                    label: const Text('Continue with Google'),
                  ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: const Text(
                'Don\'t have an account? Tap here.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: KurieColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStep() {
    return SingleChildScrollView(
      key: const ValueKey('password'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _onBackToEmail,
            style: IconButton.styleFrom(
              backgroundColor: KurieColors.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Header
          const Text(
            'Enter your password',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              color: KurieColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign-in with ${_emailController.text.trim()}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: KurieColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          // Password field
          const Text(
            'PASSWORD',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: KurieColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: '••••••••',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: KurieColors.onSurfaceVariant,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            onSubmitted: (_) => _onLogin(),
          ),
          const SizedBox(height: 16),
          // Login button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _onLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}
