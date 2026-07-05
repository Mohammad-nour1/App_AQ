import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TripSuggestionScreen extends StatelessWidget {
  const TripSuggestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip Suggestions'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Trip Suggestion Screen'),
      ),
    );
  }
}
