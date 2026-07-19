import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/router/route_paths.dart';
import '../../core/services/auth_service.dart';

import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/loading_indicator.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';



class RegisterCubit extends Cubit<String?> {

  RegisterCubit() : super(null);


  static const loadingState = '__loading__';



  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {


    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {


      emit('Please fill in all fields');

      return;

    }



    if (password != confirmPassword) {

      emit('Passwords do not match');

      return;

    }



    if (password.length < 6) {

      emit('Password must be at least 6 characters');

      return;

    }



    emit(loadingState);



    final success = await AuthService.register(

      name: name,

      email: email,

      password: password,

    );



    if (success) {

      emit('success');

    } else {

      emit('Registration failed. Please try again.');

    }


  }





  void resetState() {

    emit(null);

  }


}






class RegisterScreen extends StatelessWidget {

  const RegisterScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: Stack(

        fit: StackFit.expand,


        children: [



          Image.asset(

            'assets/images/splash.jpg',

            fit: BoxFit.cover,

          ),




          Container(

            color:
            AppColors.overlayDark.withValues(

              alpha: AppOpacity.high,

            ),

          ),





          BackdropFilter(

            filter: ImageFilter.blur(

              sigmaX: 3,

              sigmaY: 3,

            ),


            child: Container(

              color:
              AppColors.transparent,

            ),

          ),





          SafeArea(

            child: BlocProvider(

              create: (_) => RegisterCubit(),


              child:
              const RegisterView(),

            ),

          ),



        ],


      ),

    );

  }


}








class RegisterView extends StatefulWidget {


  const RegisterView({

    super.key,

  });




  @override
  State<RegisterView> createState() =>

      _RegisterViewState();


}






class _RegisterViewState
    extends State<RegisterView> {


  final nameController =
      TextEditingController();



  final emailController =
      TextEditingController();



  final passwordController =
      TextEditingController();



  final confirmPasswordController =
      TextEditingController();




  final formKey =
      GlobalKey<FormState>();




  bool showPassword = false;






  @override
  void dispose() {


    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();


    super.dispose();

  }






  bool validateEmail(String email) {


    return email.contains('@') &&

        email.contains('.');


  }  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RegisterCubit, String?>(

      listener: (context, state) {


        if (state == 'success') {

          context.go(RoutePaths.home);

        }



        else if (state != null &&
            state != RegisterCubit.loadingState) {


          ScaffoldMessenger.of(context)
              .showSnackBar(

            SnackBar(

              content: Text(state),

              backgroundColor:
              AppColors.error,

            ),

          );


        }


      },



      builder: (context, state) {


        final isLoading =
            state == RegisterCubit.loadingState;



        return SingleChildScrollView(

          padding:
          const EdgeInsets.all(
            AppSpacing.lg,
          ),


          child: Center(

            child: Column(

              children: [



                const SizedBox(
                  height: AppSpacing.lg,
                ),





                Container(

                  height: 90,

                  width: 90,


                  decoration: BoxDecoration(

                    shape:
                    BoxShape.circle,


                    gradient:
                    const LinearGradient(

                      colors: [

                        AppColors.accentDeep,

                        AppColors.accent,

                      ],

                    ),


                    boxShadow: [

                      BoxShadow(

                        color:
                        AppColors.accent
                            .withValues(
                          alpha: 0.25,
                        ),

                        blurRadius: 25,

                        offset:
                        const Offset(
                          0,
                          12,
                        ),

                      ),

                    ],


                  ),



                  child:
                  const Icon(

                    Icons.person_add_alt_1,

                    size: 42,

                    color:
                    AppColors.black,

                  ),


                ),





                const SizedBox(
                  height: AppSpacing.lg,
                ),




                Text(

                  'Create Account',

                  style:
                  AppTextStyles.displayMedium,

                  textAlign:
                  TextAlign.center,

                ),





                const SizedBox(
                  height: AppSpacing.xs,
                ),




                Text(

                  'Create your account and start discovering amazing places.',

                  style:
                  AppTextStyles.bodyMedium
                      .copyWith(

                    color:
                    AppColors.textSecondary,

                  ),

                  textAlign:
                  TextAlign.center,

                ),





                const SizedBox(
                  height:
                  AppSpacing.xxl,
                ),






                GlassCard(

                  borderRadius:
                  AppRadius.lg,


                  padding:
                  const EdgeInsets.all(
                    AppSpacing.lg,
                  ),



                  child:
                  Form(

                    key:
                    formKey,



                    child:
                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.stretch,


                      children: [





                        AppTextField(

                          controller:
                          nameController,


                          hint:
                          'Full Name',


                          prefixIcon:
                          const Icon(

                            Icons.person_outline,

                            color:
                            AppColors.accent,

                          ),



                          textInputAction:
                          TextInputAction.next,



                          onChanged: (_) {

                            context
                                .read<RegisterCubit>()
                                .resetState();

                          },



                          validator: (value) {


                            if (value == null ||
                                value.trim().isEmpty) {


                              return
                                'Please enter your name';


                            }


                            return null;


                          },


                        ),





                        const SizedBox(

                          height:
                          AppSpacing.md,

                        ),





                        AppTextField(

                          controller:
                          emailController,


                          hint:
                          'Email',



                          prefixIcon:
                          const Icon(

                            Icons.email_outlined,

                            color:
                            AppColors.accent,

                          ),



                          keyboardType:
                          TextInputType.emailAddress,



                          textInputAction:
                          TextInputAction.next,



                          onChanged: (_) {

                            context
                                .read<RegisterCubit>()
                                .resetState();

                          },



                          validator: (value) {


                            if (value == null ||
                                value.trim().isEmpty) {


                              return
                                'Please enter your email';


                            }



                            if (!validateEmail(
                                value.trim()
                            )) {


                              return
                                'Invalid email';


                            }



                            return null;


                          },


                        ),





                        const SizedBox(

                          height:
                          AppSpacing.md,

                        ),






                        AppTextField(

                          controller:
                          passwordController,


                          hint:
                          'Password',



                          obscureText:
                          !showPassword,



                          prefixIcon:
                          const Icon(

                            Icons.lock_outline,

                            color:
                            AppColors.accent,

                          ),




                          suffixIcon:
                          IconButton(


                            onPressed: () {


                              setState(() {


                                showPassword =
                                    !showPassword;


                              });


                            },


                            icon:
                            Icon(


                              showPassword

                                  ?

                              Icons.visibility_off

                                  :

                              Icons.visibility,


                              color:
                              AppColors.textSecondary,


                            ),


                          ),





                          onChanged: (_) {

                            context
                                .read<RegisterCubit>()
                                .resetState();

                          },



                          validator: (value) {



                            if (value == null ||
                                value.isEmpty) {


                              return
                                'Please enter password';


                            }



                            if (value.length < 6) {


                              return
                                'Minimum 6 characters';


                            }



                            return null;


                          },


                        ),





                        const SizedBox(

                          height:
                          AppSpacing.md,

                        ),






                        AppTextField(

                          controller:
                          confirmPasswordController,


                          hint:
                          'Confirm Password',



                          obscureText:
                          !showPassword,



                          prefixIcon:
                          const Icon(

                            Icons.lock_reset,

                            color:
                            AppColors.accent,

                          ),




                          textInputAction:
                          TextInputAction.done,



                          onChanged: (_) {


                            context
                                .read<RegisterCubit>()
                                .resetState();


                          },



                          validator: (value) {


                            if (value == null ||
                                value.isEmpty) {


                              return
                                'Confirm password';


                            }




                            if (value !=
                                passwordController.text) {


                              return
                                'Passwords do not match';


                            }



                            return null;


                          },


                        ),





                        const SizedBox(

                          height:
                          AppSpacing.lg,

                        ),





                        if (isLoading)

                          const LoadingIndicator()



                        else


                          PrimaryButton(

                            label:
                            'Create Account',



                            onPressed: () {


                              if (formKey.currentState!
                                  .validate()) {


                                context
                                    .read<RegisterCubit>()
                                    .register(

                                  nameController.text
                                      .trim(),


                                  emailController.text
                                      .trim(),


                                  passwordController.text
                                      .trim(),


                                  confirmPasswordController.text
                                      .trim(),


                                );


                              }


                            },


                          ),





                        const SizedBox(

                          height:
                          AppSpacing.md,

                        ),





                        SecondaryButton(

                          label:
                          'Already have account? Sign In',



                          onPressed: () {


                            context.go(
                              RoutePaths.login,
                            );


                          },


                        ),



                      ],

                    ),

                  ),

                ),



              ],

            ),

          ),

        );

      },

    );

  }

}