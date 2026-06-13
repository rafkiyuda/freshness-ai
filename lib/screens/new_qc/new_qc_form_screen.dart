import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../config/constants.dart';
import '../../utils/date_formatter.dart';

class NewQcFormScreen extends StatefulWidget {
  const NewQcFormScreen({Key? key}) : super(key: key);

  @override
  State<NewQcFormScreen> createState() => _NewQcFormScreenState();
}

class _NewQcFormScreenState extends State<NewQcFormScreen> {
  String? _selectedSkuId;
  String? _selectedSupplierId;
  final TextEditingController _notesController = TextEditingController();

  void _startCamera() {
    if (_selectedSkuId == null || _selectedSupplierId == null) return;

    final sku = Constants.skuOptions.firstWhere((s) => s['skuId'] == _selectedSkuId);
    final supplier = Constants.supplierOptions.firstWhere((s) => s['id'] == _selectedSupplierId);

    context.push(
      '/camera-check',
      extra: {
        'skuId': sku['skuId'],
        'skuName': sku['skuName'],
        'supplierId': supplier['id'],
        'supplierName': supplier['name'],
        'notes': _notesController.text,
      },
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = _selectedSkuId != null && _selectedSupplierId != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QC Session Baru'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SKU Dropdown
                    const Text('Produk / SKU', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(hintText: 'Pilih Produk'),
                      value: _selectedSkuId,
                      items: Constants.skuOptions.map((sku) {
                        return DropdownMenuItem(
                          value: sku['skuId'],
                          child: Text('${sku['skuId']} — ${sku['skuName']}'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSkuId = val),
                    ),
                    const SizedBox(height: 24),

                    // Supplier Dropdown
                    const Text('Supplier / Petani', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(hintText: 'Pilih Supplier'),
                      value: _selectedSupplierId,
                      items: Constants.supplierOptions.map((sup) {
                        return DropdownMenuItem(
                          value: sup['id'],
                          child: Text(sup['name']!),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedSupplierId = val),
                    ),
                    const SizedBox(height: 24),

                    // Notes
                    const Text('Catatan (Opsional)', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Tambahkan catatan jika perlu...',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Read-only fields
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgMain,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tanggal', style: TextStyle(color: AppColors.textSecondary)),
                              Text(DateFormatter.formatIndonesian(now), style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const Divider(height: 16),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Diperiksa oleh', style: TextStyle(color: AppColors.textSecondary)),
                              Text('Staff Gudang', style: TextStyle(fontWeight: FontWeight.w500)), // Hardcoded for PoC
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // CTA
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isValid 
                    ? [AppColors.brandPrimary, AppColors.accentPrimary]
                    : [AppColors.borderColor, AppColors.borderColor],
                ),
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: ElevatedButton(
                onPressed: isValid ? _startCamera : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  disabledForegroundColor: AppColors.textMuted,
                ),
                child: const Text('Start Camera Check'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
