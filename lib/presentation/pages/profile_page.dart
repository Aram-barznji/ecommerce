import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../widgets/app_navigation.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        state.userName.isNotEmpty ? state.userName[0].toUpperCase() : 'U',
                        style: const TextStyle(fontSize: 32, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(state.userName, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            return AppUtils.buildLoadingWidget();
          },
        ),
      ),
      bottomNavigationBar: AppNavigation(),
    );
  }
}