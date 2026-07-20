import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';


class AppTextField extends StatelessWidget {

  const AppTextField({

    super.key,

    this.controller,

    this.label,

    this.hint,

    this.errorText,

    this.prefixIcon,

    this.suffixIcon,

    this.onChanged,

    this.onSubmitted,

    this.validator,

    this.obscureText = false,

    this.enabled = true,

    this.maxLines = 1,

    this.keyboardType,

    this.textInputAction,

  });



  final TextEditingController? controller;

  final String? label;

  final String? hint;

  final String? errorText;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final String? Function(String?)? validator;

  final bool obscureText;

  final bool enabled;

  final int maxLines;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;



  @override
  Widget build(BuildContext context) {


    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      mainAxisSize:
      MainAxisSize.min,


      children: [



        if(label != null)...[


          Text(

            label!,

            style:
            AppTextStyles.labelMedium,

          ),



          const SizedBox(

            height:
            AppSpacing.xs,

          ),


        ],




        TextFormField(

          controller:
          controller,


          validator:
          validator,


          onChanged:
          onChanged,


          onFieldSubmitted:
          onSubmitted,


          obscureText:
          obscureText,


          enabled:
          enabled,


          maxLines:
          maxLines,


          keyboardType:
          keyboardType,


          textInputAction:
          textInputAction,



          style:
          AppTextStyles.bodyMedium,



          decoration:
          InputDecoration(

            hintText:
            hint,


            hintStyle:
            AppTextStyles.bodyMedium
                .copyWith(

              color:
              AppColors.textSecondary,

            ),



            errorText:
            errorText,



            prefixIcon:
            prefixIcon,



            suffixIcon:
            suffixIcon,



            filled:
            true,



            fillColor:
            AppColors.surface
                .withValues(
              alpha: 0.24,
            ),



            contentPadding:
            const EdgeInsets.symmetric(

              vertical: 18,

              horizontal: 16,

            ),




            border:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                AppRadius.input,
              ),


              borderSide:
              BorderSide(

                color:
                AppColors.border
                    .withValues(
                  alpha:0.35,
                ),

              ),

            ),




            enabledBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                AppRadius.input,
              ),


              borderSide:
              BorderSide(

                color:
                AppColors.border
                    .withValues(
                  alpha:0.25,
                ),

              ),

            ),




            focusedBorder:
            OutlineInputBorder(

              borderRadius:
              BorderRadius.circular(
                AppRadius.input,
              ),


              borderSide:
              const BorderSide(

                color:
                AppColors.accent,

                width:
                1.5,

              ),

            ),



          ),

        ),


      ],

    );

  }

}