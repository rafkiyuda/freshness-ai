import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Pusat Bantuan', style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
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
          // Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.brandPrimary, AppColors.accentPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brandPrimary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bagaimana kami bisa\nmembantu Anda?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          Text(
            'FAQ (Pertanyaan Umum)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFaqItem(
            context,
            'Bagaimana cara menggunakan AI untuk Inspeksi?',
            'Buka menu Utama, tekan "Mulai Inspeksi Baru", ambil foto produk yang ingin diperiksa, dan AI akan otomatis menghitung tingkat kesegaran serta kepercayaannya secara offline.',
          ),
          _buildFaqItem(
            context,
            'Apakah aplikasi ini butuh internet?',
            'Tidak untuk proses inspeksi AI. AI berjalan sepenuhnya secara offline di dalam HP Anda. Internet hanya dibutuhkan saat Anda melakukan "Sync" ke server dan mengambil notifikasi terbaru.',
          ),
          _buildFaqItem(
            context,
            'Bagaimana cara mengganti kata sandi?',
            'Anda dapat mengganti kata sandi di menu Profil > Pengaturan Akun > Keamanan > Ubah Kata Sandi.',
          ),
          _buildFaqItem(
            context,
            'Kenapa Sinkronisasi (Sync) gagal?',
            'Pastikan HP Anda terhubung ke koneksi internet (WiFi atau Data Seluler) yang stabil, dan server KongsiLogi sedang online.',
          ),

          const SizedBox(height: 32),
          Text(
            'Butuh bantuan lebih lanjut?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.freshGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble_outline, color: AppColors.freshGreen),
              ),
              title: Text('Hubungi Support IT', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
              subtitle: Text('Live chat via WhatsApp', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
              trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
              onTap: () async {
                final Uri waUrl = Uri.parse('https://wa.me/6285283971917');
                if (!await launchUrl(waUrl, mode: LaunchMode.externalApplication)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal membuka WhatsApp')),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Freshness AI App v1.0.0\n© 2026 KongsiLogi',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        iconColor: AppColors.brandPrimary,
        collapsedIconColor: Theme.of(context).iconTheme.color?.withOpacity(0.5),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer,
            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
