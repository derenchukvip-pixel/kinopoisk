import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
// ...existing code...

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _mapError(String error) {
    if (error.contains('Failed to get request token')) {
      return 'No connection to TMDB or invalid API key.';
    }
    if (error.contains('Invalid credentials')) {
      return 'Invalid username or password.';
    }
    if (error.contains('Failed to create session')) {
      return 'Failed to create TMDB session.';
    }
    if (error.contains('Failed to get account details')) {
      return 'Failed to fetch user profile.';
    }
    if (error.contains('SocketException')) {
      return 'No internet connection.';
    }
    return 'Unknown error: $error';
  }

    @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final error = state is AuthError ? _mapError(state.message) : null;
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginRequested(_emailController.text, _passwordController.text),
                          );
                        },
                        child: const Text('Login'),
                      ),
                      if (state is AuthLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: CircularProgressIndicator(),
                        ),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            error,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
