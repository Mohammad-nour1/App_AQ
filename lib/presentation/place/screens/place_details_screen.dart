import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({
    required this.placeId,
    super.key,
  });

  final String placeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Place Details'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Center(
        child: Text('Place: $placeId'),
      ),
    );
  }
}
