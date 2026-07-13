import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_paths.dart';

class MyPlacesScreen extends StatelessWidget {
  const MyPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> myPlaces = [
      {
        'name': 'قلعة حلب',
        'location': 'حلب - سوريا',
        'address': 'القلعة، حلب القديمة',
        'distance': '310km',
        'price': '2,000',
        'rating': 5,
        'emoji': '🏰',
        'addedDate': '2025-01-15',
      },
      {
        'name': 'سد الفرات',
        'location': 'الرقة - سوريا',
        'address': 'نهر الفرات، شرق سوريا',
        'distance': '450km',
        'price': 'مجاني',
        'rating': 4.5,
        'emoji': '🌊',
        'addedDate': '2025-01-20',
      },
      {
        'name': 'تدمر (بالميرا)',
        'location': 'حمص - سوريا',
        'address': 'بادية الشام، وسط سوريا',
        'distance': '240km',
        'price': '5,000',
        'rating': 5,
        'emoji': '🏛️',
        'addedDate': '2025-01-25',
      },
      {
        'name': 'الجامع الأموي',
        'location': 'دمشق - سوريا',
        'address': 'سوق الحميدية، دمشق القديمة',
        'distance': '320km',
        'price': 'مجاني',
        'rating': 4.5,
        'emoji': '🕌',
        'addedDate': '2025-02-01',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('أماكني', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () {
              context.go(RoutePaths.addPlace);
            },
          ),
        ],
      ),
      body: myPlaces.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_location_alt, size: 80, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('لم تقم بإضافة أي مكان بعد', style: TextStyle(color: AppColors.textSecondary)),
                  SizedBox(height: 8),
                  Text('اضغط على زر الإضافة لبدء رحلتك', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myPlaces.length,
              itemBuilder: (context, index) {
                final place = myPlaces[index];
                return GlassContainer(
                  blur: 15.0,
                  opacity: 0.12,
                  borderRadius: 20.0,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [AppColors.primary.withOpacity(0.5), AppColors.primary.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(child: Text(place['emoji'] ?? '📍', style: const TextStyle(fontSize: 56))),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GlassContainer(
                                blur: 5.0,
                                opacity: 0.2,
                                borderRadius: 12.0,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                child: Text(
                                  'أضيف: ${place['addedDate'] ?? ''}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    place['name'] ?? '',
                                    style: AppTextStyles.headlineSmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(
                                      (place['rating'] ?? 5).floor(),
                                      (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                                    ),
                                    if ((place['rating'] ?? 5) % 1 != 0)
                                      const Icon(Icons.star_half, color: Colors.amber, size: 16),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_pin, color: AppColors.primary, size: 18),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    place['location'] ?? '',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.near_me, color: AppColors.textSecondary, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${place['distance'] ?? ''} ${place['address'] ?? ''}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    if (place['price'] != 'مجاني') ...[
                                      const Icon(Icons.attach_money, color: AppColors.accent, size: 20),
                                      Text(
                                        place['price'] ?? '0',
                                        style: AppTextStyles.headlineMedium.copyWith(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '/ الليلة',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'مجاني',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Row(
                                  children: [
                                    GlassContainer(
                                      blur: 5.0,
                                      opacity: 0.15,
                                      borderRadius: 50.0,
                                      padding: const EdgeInsets.all(4),
                                      child: IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                        onPressed: () {
                                          // فتح شاشة التعديل
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('سيتم فتح شاشة التعديل قريباً')),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GlassContainer(
                                      blur: 5.0,
                                      opacity: 0.15,
                                      borderRadius: 50.0,
                                      padding: const EdgeInsets.all(4),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () {
                                          _showDeleteDialog(context, place['name'] ?? '');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, String placeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('حذف المكان', style: TextStyle(color: AppColors.textPrimary)),
          content: Text(
            'هل أنت متأكد من حذف "$placeName"؟',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف "$placeName" بنجاح'), backgroundColor: Colors.orange),
                );
              },
              child: Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
