import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_paths.dart';
import '../../../core/widgets/glass_container.dart';

class AddPlaceCubit extends Cubit<AddPlaceState> {
  AddPlaceCubit() : super(AddPlaceInitial());

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      selectedImages = images;
      emit(AddPlaceImagesPicked(images));
    }
  }

  Future<void> submitPlace({
    required String name,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
  }) async {
    if (name.isEmpty || description.isEmpty || category.isEmpty) {
      emit(AddPlaceError('الرجاء تعبئة جميع الحقول'));
      return;
    }
    if (selectedImages.isEmpty) {
      emit(AddPlaceError('الرجاء اختيار صورة على الأقل'));
      return;
    }

    emit(AddPlaceLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AddPlaceSuccess());
  }

  void resetState() {
    selectedImages.clear();
    emit(AddPlaceInitial());
  }
}

abstract class AddPlaceState {}

class AddPlaceInitial extends AddPlaceState {}

class AddPlaceImagesPicked extends AddPlaceState {
  final List<XFile> images;
  AddPlaceImagesPicked(this.images);
}

class AddPlaceLoading extends AddPlaceState {}

class AddPlaceSuccess extends AddPlaceState {}

class AddPlaceError extends AddPlaceState {
  final String message;
  AddPlaceError(this.message);
}

class AddPlaceScreen extends StatelessWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إضافة مكان جديد', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocProvider(create: (context) => AddPlaceCubit(), child: const AddPlaceView()),
    );
  }
}

class AddPlaceView extends StatefulWidget {
  const AddPlaceView({super.key});

  @override
  State<AddPlaceView> createState() => _AddPlaceViewState();
}

class _AddPlaceViewState extends State<AddPlaceView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  final List<String> _categories = [
    'مطل',
    'طبيعي',
    'أثري',
    'شلال',
    'مطعم',
    'مكان سياحي',
    'مناسب للتصوير',
    'أخرى',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPlaceCubit, AddPlaceState>(
      listener: (context, state) {
        if (state is AddPlaceSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('تم إضافة المكان بنجاح! 🎉'), backgroundColor: AppColors.success),
          );
          context.read<AddPlaceCubit>().resetState();
          context.go(RoutePaths.home);
        } else if (state is AddPlaceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: GlassContainer(
            blur: 15.0,
            opacity: 0.15,
            borderRadius: 24.0,
            borderColor: AppColors.surface.withOpacity(0.1),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassContainer(
                    blur: 5.0,
                    opacity: 0.1,
                    borderRadius: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'اسم المكان *',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                        hintText: 'أدخل اسم المكان',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.place, color: AppColors.textSecondary),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال اسم المكان' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  GlassContainer(
                    blur: 5.0,
                    opacity: 0.1,
                    borderRadius: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'الوصف *',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                        hintText: 'أدخل وصفاً للمكان',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.description, color: AppColors.textSecondary),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال وصف للمكان' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  GlassContainer(
                    blur: 5.0,
                    opacity: 0.1,
                    borderRadius: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'التصنيف *',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                        border: InputBorder.none,
                        icon: Icon(Icons.category, color: AppColors.textSecondary),
                      ),
                      value: _selectedCategory,
                      items: _categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category, style: TextStyle(color: AppColors.textPrimary)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) => value == null ? 'الرجاء اختيار تصنيف للمكان' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  GlassContainer(
                    blur: 5.0,
                    opacity: 0.1,
                    borderRadius: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'خط الطول (Latitude)',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                        hintText: 'مثال: 36.2153',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.pin_drop, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  GlassContainer(
                    blur: 5.0,
                    opacity: 0.1,
                    borderRadius: 50.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'خط العرض (Longitude)',
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                        floatingLabelStyle: TextStyle(color: AppColors.textPrimary),
                        hintText: 'مثال: 37.1653',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        icon: Icon(Icons.pin_drop_outlined, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  BlocBuilder<AddPlaceCubit, AddPlaceState>(
                    builder: (context, state) {
                      final cubit = context.read<AddPlaceCubit>();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GlassContainer(
                            blur: 10.0,
                            opacity: 0.2,
                            borderRadius: 12.0,
                            borderColor: AppColors.primary.withOpacity(0.3),
                            padding: EdgeInsets.zero,
                            child: MaterialButton(
                              onPressed: state is AddPlaceLoading ? null : () => cubit.pickImages(),
                              height: 50,
                              minWidth: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library, color: AppColors.textPrimary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'اختر صوراً من المعرض',
                                    style: TextStyle(color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (state is AddPlaceImagesPicked) ...[
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(state.images[index].path),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'تم اختيار ${state.images.length} صورة',
                                style: TextStyle(color: AppColors.success, fontSize: 14),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  if (state is AddPlaceLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  else
                    GlassContainer(
                      blur: 10.0,
                      opacity: 0.25,
                      borderRadius: 12.0,
                      borderColor: AppColors.primary.withOpacity(0.5),
                      padding: EdgeInsets.zero,
                      child: MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final lat = double.tryParse(_latitudeController.text) ?? 0.0;
                            final lng = double.tryParse(_longitudeController.text) ?? 0.0;

                            context.read<AddPlaceCubit>().submitPlace(
                              name: _nameController.text,
                              description: _descriptionController.text,
                              category: _selectedCategory!,
                              latitude: lat,
                              longitude: lng,
                            );
                          }
                        },
                        height: 56,
                        minWidth: double.infinity,
                        child: Text(
                          'إضافة المكان',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
