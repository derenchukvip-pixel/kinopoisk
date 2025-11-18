import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: Text('Not logged in'));
        }
        final user = state.user;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                              ? NetworkImage(user.avatarUrl!)
                              : null,
                          child: user.avatarUrl == null || user.avatarUrl!.isEmpty
                              ? const Icon(Icons.person, size: 48)
                              : null,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.name?.isNotEmpty == true ? user.name! : 'No name',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.email,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              tooltip: 'Copy username',
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: user.email));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Username copied!')),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.favorite, color: Colors.red),
                              const SizedBox(width: 8),
                              Text('Last favorite movie: Coming soon'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('User ID: ${user.id}', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(LogoutRequested());
                              Navigator.of(context).pushReplacementNamed('/');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
