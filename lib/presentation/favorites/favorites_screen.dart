import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للأماكن المفضلة (للتجربة)
    final List<Map<String, String>> favoritePlaces = [
      {
        'name': 'قلعة حلب',
        'location': 'حلب',
        'image': '🏰',
      },
      {
        'name': 'سد الفرات',
        'location': 'الرقة',
        'image': '🌊',
      },
      {
        'name': 'جبل العرب',
        'location': 'السويداء',
        'image': '⛰️',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('المفضلة'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: favoritePlaces.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد أماكن مفضلة بعد',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'أضف أماكن إلى مفضلتك لتظهر هنا',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          final place = favoritePlaces[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  place['image'] ?? '📍',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                place['name'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(place['location'] ?? ''),
              trailing: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  // هنا رح نضيف منطق الحذف من المفضلة لاحقاً
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تمت إزالة المكان من المفضلة'),
                    ),
                  );
                },
              ),
              onTap: () {
                // لاحقاً رح نفتح صفحة تفاصيل المكان
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('سيتم فتح تفاصيل ${place['name']}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}