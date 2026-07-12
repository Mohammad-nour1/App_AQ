import 'dart:io'; // هذا السطر مهم جداً للتعامل مع الملفات

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/router/route_paths.dart';

// --- 1. AddPlaceCubit (مدير الحالة) ---
class AddPlaceCubit extends Cubit<AddPlaceState> {
  AddPlaceCubit() : super(AddPlaceInitial());

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  // دالة اختيار الصور
  Future<void> pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      selectedImages = images;
      emit(AddPlaceImagesPicked(images));
    }
  }

  // دالة رفع المكان (محاكاة)
  Future<void> submitPlace({
    required String name,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
  }) async {
    // تحقق من الحقول الأساسية
    if (name.isEmpty || description.isEmpty || category.isEmpty) {
      emit(AddPlaceError('الرجاء تعبئة جميع الحقول'));
      return;
    }
    if (selectedImages.isEmpty) {
      emit(AddPlaceError('الرجاء اختيار صورة على الأقل'));
      return;
    }

    emit(AddPlaceLoading());

    // محاكاة طلب الـ API (تأخير 2 ثانية)
    await Future.delayed(const Duration(seconds: 2));

    // محاكاة نجاح العملية
    emit(AddPlaceSuccess());
  }

  // دالة لإعادة ضبط الحالة (بعد النجاح)
  void resetState() {
    selectedImages.clear();
    emit(AddPlaceInitial());
  }
}

// --- 2. حالات (States) الـ Cubit ---
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

// --- 3. شاشة Add Place (UI) ---
class AddPlaceScreen extends StatelessWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إضافة مكان جديد'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocProvider(create: (context) => AddPlaceCubit(), child: const AddPlaceView()),
    );
  }
}

// --- 4. الـ View المنفصل (يحتوي على الحقول والأزرار) ---
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
          // عند النجاح، نظهر رسالة ونرجع للصفحة الرئيسية
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة المكان بنجاح! 🎉'), backgroundColor: Colors.green),
          );
          // نعيد ضبط الـ Cubit
          context.read<AddPlaceCubit>().resetState();
          // نرجع للـ Home
          context.go(RoutePaths.home);
        } else if (state is AddPlaceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // --- حقل الاسم ---
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المكان *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.place),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال اسم المكان' : null,
                ),
                const SizedBox(height: 16),

                // --- حقل الوصف ---
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'الوصف *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'الرجاء إدخال وصف للمكان' : null,
                ),
                const SizedBox(height: 16),

                // --- قائمة منسدلة (التصنيف) ---
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'التصنيف *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'الرجاء اختيار تصنيف للمكان' : null,
                ),
                const SizedBox(height: 16),

                // --- حقل خط الطول (Latitude) ---
                TextFormField(
                  controller: _latitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'خط الطول (Latitude)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pin_drop),
                  ),
                ),
                const SizedBox(height: 16),

                // --- حقل خط العرض (Longitude) ---
                TextFormField(
                  controller: _longitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'خط العرض (Longitude)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                  ),
                ),
                const SizedBox(height: 16),

                // --- زر اختيار الصور وعرضها ---
                BlocBuilder<AddPlaceCubit, AddPlaceState>(
                  builder: (context, state) {
                    final cubit = context.read<AddPlaceCubit>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: state is AddPlaceLoading ? null : () => cubit.pickImages(),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('اختر صوراً من المعرض'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        ),
                        const SizedBox(height: 8),
                        if (state is AddPlaceImagesPicked)
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                        if (state is AddPlaceImagesPicked)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'تم اختيار ${state.images.length} صورة',
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // --- زر الحفظ (Submit) ---
                if (state is AddPlaceLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('إضافة المكان', style: TextStyle(fontSize: 18)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
