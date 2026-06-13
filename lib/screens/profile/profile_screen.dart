import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.userData;
    
    // Determine avatar
    final isGudang = user?['email'] == 'gudang@kongsil.co';
    final avatarPath = isGudang ? 'assets/images/avatar_female.png' : 'assets/images/avatar_male.png';

    return Scaffold(
      backgroundColor: AppColors.brandPrimary,
      body: Column(
        children: [
          // Header
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
              child: Row(
                children: const [
                  Text(
                    'Profil Saya',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  // Profile Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
                    child: Column(
                      children: [
                        Text(
                          user?['name'] ?? 'Staf',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?['email'] ?? '-',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brandPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getRoleLabel(user?['role'] as String?),
                            style: const TextStyle(
                              color: AppColors.brandPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Menu List
                        _buildMenuCard(
                          context: context,
                          icon: Icons.business,
                          title: 'Koperasi Melati Jaya',
                          subtitle: 'Pusat Distribusi Utama',
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          context: context,
                          icon: Icons.settings_outlined,
                          title: 'Pengaturan Akun',
                          onTap: () {
                            context.push('/settings');
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          context: context,
                          icon: Icons.help_outline,
                          title: 'Pusat Bantuan',
                          onTap: () {
                            context.push('/help');
                          },
                        ),
                        
                        const Spacer(),
                        
                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => ref.read(authProvider.notifier).logout(),
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text(
                              'Keluar',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.freshRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  
                  // Floating Avatar
                  Positioned(
                    top: -50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(avatarPath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({required BuildContext context, required IconData icon, required String title, String? subtitle, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.brandPrimary, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))) : null,
        trailing: onTap != null ? Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).iconTheme.color?.withOpacity(0.3)) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'ADMIN':
        return 'Admin';
      case 'WAREHOUSE_STAFF':
        return 'Staf Gudang';
      case 'CASHIER':
        return 'Kasir';
      default:
        return 'Staf';
    }
  }
}
