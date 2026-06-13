import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/change_password_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Pengaturan Akun', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle('Notifikasi Push', context),
          _buildSwitchTile(
            context: context,
            title: 'Peringatan Stok Rendah',
            subtitle: 'Dapatkan info saat stok kritis',
            value: settings.notifLowStock,
            onChanged: (val) => settingsNotifier.updateSettings(notifLowStock: val),
          ),
          _buildSwitchTile(
            context: context,
            title: 'Peringatan Kadaluarsa',
            subtitle: 'Dapatkan info H-3 masa kadaluarsa',
            value: settings.notifExpiry,
            onChanged: (val) => settingsNotifier.updateSettings(notifExpiry: val),
          ),
          _buildSwitchTile(
            context: context,
            title: 'Pengingat Audit Reguler',
            subtitle: 'Notifikasi jadwal audit gudang',
            value: settings.notifAudit,
            onChanged: (val) => settingsNotifier.updateSettings(notifAudit: val),
          ),
          
          const SizedBox(height: 32),
          _buildSectionTitle('Keamanan', context),
          _buildListTile(
            context: context,
            title: 'Ubah Kata Sandi',
            subtitle: 'Perbarui kata sandi Anda',
            icon: Icons.lock_outline,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ChangePasswordDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
        subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.brandPrimary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.brandPrimary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.brandPrimary),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
        subtitle: Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13)),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).iconTheme.color?.withOpacity(0.3)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: onTap,
      ),
    );
  }
}
