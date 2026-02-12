import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants.dart';
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
            final userName =
                (state is AuthAuthenticated) ? state.userName : 'User';

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Avatar & Name
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Premium Member',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Settings list
                    _buildSection(context, 'Account', [
                      _SettingsTile(
                        icon: Icons.receipt_long_outlined,
                        title: 'My Orders',
                        subtitle: 'View order history',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'Orders page coming soon'),
                      ),
                      _SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Shipping Address',
                        subtitle: 'Manage addresses',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'Addresses page coming soon'),
                      ),
                      _SettingsTile(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Manage your cards',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'Payment page coming soon'),
                      ),
                    ]),

                    _buildSection(context, 'Preferences', [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage notification preferences',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'Notification settings coming soon'),
                      ),
                      _SettingsTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        subtitle: 'FAQs, contact us',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'Help page coming soon'),
                      ),
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        subtitle: 'App version 1.0.0',
                        onTap: () => AppUtils.showSnackBar(
                            context, 'ShopVibe v1.0.0'),
                      ),
                    ]),

                    // Logout
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final confirm = await AppUtils.showConfirmDialog(
                              context,
                              'Logout',
                              'Are you sure you want to sign out?',
                            );
                            if (confirm) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthLogoutRequested());
                            }
                          },
                          icon: const Icon(Icons.logout_rounded,
                              color: AppTheme.errorColor),
                          label: const Text(
                            'Sign Out',
                            style: TextStyle(color: AppTheme.errorColor),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.errorColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppNavigation(initialIndex: 3),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<_SettingsTile> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: tiles.asMap().entries.map((entry) {
              final isLast = entry.key == tiles.length - 1;
              final tile = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(tile.icon,
                          color: AppTheme.primaryColor, size: 20),
                    ),
                    title: Text(
                      tile.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      tile.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.textHint),
                    onTap: tile.onTap,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: Colors.grey.shade100,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}