import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> places = [
      {
        'name': 'قلعة حلب',
        'location': 'حلب - سوريا',
        'address': 'القلعة، حلب القديمة',
        'distance': '310km',
        'price': '2,000',
        'rating': 5,
        'emoji': '🏰',
      },
      {
        'name': 'سد الفرات',
        'location': 'الرقة - سوريا',
        'address': 'نهر الفرات، شرق سوريا',
        'distance': '450km',
        'price': 'مجاني',
        'rating': 4,
        'emoji': '🌊',
      },
      {
        'name': 'تدمر (بالميرا)',
        'location': 'حمص - سوريا',
        'address': 'بادية الشام، وسط سوريا',
        'distance': '240km',
        'price': '5,000',
        'rating': 5,
        'emoji': '🏛️',
      },
      {
        'name': 'قلعة الحصن (كراك دي شوفالييه)',
        'location': 'حمص - سوريا',
        'address': 'وادي النضارين، غرب حمص',
        'distance': '280km',
        'price': '3,000',
        'rating': 5,
        'emoji': '⚔️',
      },
      {
        'name': 'الجامع الأموي',
        'location': 'دمشق - سوريا',
        'address': 'سوق الحميدية، دمشق القديمة',
        'distance': '320km',
        'price': 'مجاني',
        'rating': 4,
        'emoji': '🕌',
      },
      {
        'name': 'سوق الحميدية',
        'location': 'دمشق - سوريا',
        'address': 'دمشق القديمة، بجوار الجامع الأموي',
        'distance': '320km',
        'price': 'مجاني',
        'rating': 4,
        'emoji': '🛍️',
      },
      {
        'name': 'مدرج بصرى',
        'location': 'بصرى الشام - درعا - سوريا',
        'address': 'درعا، جنوب سوريا',
        'distance': '380km',
        'price': '2,000',
        'rating': 4,
        'emoji': '🎭',
      },
      {
        'name': 'جبال الساحل السوري',
        'location': 'اللاذقية - سوريا',
        'address': 'الساحل السوري، غرب سوريا',
        'distance': '350km',
        'price': 'مجاني',
        'rating': 4,
        'emoji': '🏔️',
      },
      {
        'name': 'قلعة شيزر',
        'location': 'حماة - سوريا',
        'address': 'مدينة شيزر الأثرية، شمال حماة',
        'distance': '330km',
        'price': '1,500',
        'rating': 4,
        'emoji': '🏰',
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('المفضلة', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: places.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('لا توجد مفضلات بعد', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
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
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [AppColors.primary.withOpacity(0.4), AppColors.primary.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(place['emoji'] ?? '📍', style: const TextStyle(fontSize: 64)),
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
                                  children: List.generate(
                                    place['rating'] ?? 5,
                                    (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                                  ),
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
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                GlassContainer(
                                  blur: 5.0,
                                  opacity: 0.15,
                                  borderRadius: 50.0,
                                  padding: const EdgeInsets.all(4),
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                                    onPressed: () {},
                                  ),
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
}
