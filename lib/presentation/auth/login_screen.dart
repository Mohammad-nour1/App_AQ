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


class LoginCubit extends Cubit<String?> {
  LoginCubit() : super(null);

  static const loadingState = '__loading__';

  Future<void> login(
    String email,
    String password,
  ) async {

    if (email.isEmpty || password.isEmpty) {
      emit('Please fill in all fields');
      return;
    }

    emit(loadingState);


    final success = await AuthService.login(
      email,
      password,
    );


    if (success) {

      emit('success');

    } else {

      emit('Invalid email or password');

    }

  }


  void resetState() {
    emit(null);
  }

}





class LoginScreen extends StatelessWidget {

  const LoginScreen({
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

            filter:
            ImageFilter.blur(
              sigmaX: 3,
              sigmaY: 3,
            ),


            child:
            Container(
              color:
              AppColors.transparent,
            ),

          ),



          SafeArea(

            child:
            BlocProvider(

              create: (_) => LoginCubit(),

              child:
              const LoginView(),

            ),

          ),


        ],

      ),

    );

  }

}





class LoginView extends StatefulWidget {

  const LoginView({
    super.key,
  });


  @override
  State<LoginView> createState() =>
      _LoginViewState();

}





class _LoginViewState
    extends State<LoginView> {


  final emailController =
      TextEditingController();


  final passwordController =
      TextEditingController();


  final formKey =
      GlobalKey<FormState>();


  bool showPassword = false;




  @override
  void initState() {

    super.initState();


    AuthService.getSavedEmail()
        .then((email) {


      if(email != null && mounted){

        emailController.text =
            email;

      }

    });

  }





  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }





  bool validateEmail(String email){

    return email.contains('@') &&
        email.contains('.');

  }






  @override
  Widget build(BuildContext context) {


    return BlocConsumer<LoginCubit, String?>(


      listener: (context,state){


        if(state == 'success'){

          context.go(
            RoutePaths.home,
          );

        }



        if(state != null &&
            state != LoginCubit.loadingState){


          ScaffoldMessenger.of(context)
              .showSnackBar(

            SnackBar(

              content:
              Text(state),

              backgroundColor:
              AppColors.error,

            ),

          );

        }


      },




      builder:(context,state){


        final isLoading =
            state == LoginCubit.loadingState;



        return SingleChildScrollView(

          padding:
          const EdgeInsets.all(
            AppSpacing.lg,
          ),



          child: Center(


            child: Column(

              children: [



                const SizedBox(
                  height:
                  AppSpacing.xxl,
                ),





                Container(

                  width:90,

                  height:90,


                  decoration:
                  BoxDecoration(

                    shape:
                    BoxShape.circle,


                    gradient:
                    const LinearGradient(

                      colors:[

                        AppColors.accentDeep,

                        AppColors.accent,

                      ],

                    ),



                    boxShadow:[


                      BoxShadow(

                        color:
                        AppColors.accent
                            .withValues(
                          alpha:0.3,
                        ),


                        blurRadius:25,


                        offset:
                        const Offset(
                          0,
                          10,
                        ),

                      ),


                    ],


                  ),



                  child:
                  const Icon(

                    Icons.explore,

                    size:42,

                    color:
                    AppColors.black,

                  ),


                ),





                const SizedBox(
                  height:
                  AppSpacing.lg,
                ),




                Text(

                  'Welcome Back',

                  style:
                  AppTextStyles.displayMedium,

                  textAlign:
                  TextAlign.center,

                ),




                const SizedBox(
                  height:
                  AppSpacing.xs,
                ),




                Text(

                  'Sign in to continue exploring places around you',

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

                      children:[



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



                          onChanged:(_){

                            context
                                .read<LoginCubit>()
                                .resetState();

                          },



                          validator:(value){


                            if(value == null ||
                                value.trim().isEmpty){

                              return
                                'Enter email';

                            }



                            if(!validateEmail(
                                value.trim()
                            )){

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


                            onPressed:(){

                              setState((){

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




                          onChanged:(_){

                            context
                                .read<LoginCubit>()
                                .resetState();

                          },




                          validator:(value){


                            if(value == null ||
                                value.isEmpty){

                              return
                                'Enter password';

                            }



                            if(value.length < 6){

                              return
                                'Password minimum 6 characters';

                            }


                            return null;


                          },


                        ),





                        const SizedBox(
                          height:
                          AppSpacing.lg,
                        ),




                        if(isLoading)

                          const LoadingIndicator()


                        else

                          PrimaryButton(

                            label:
                            'Sign In',



                            onPressed:(){


                              if(formKey.currentState!
                                  .validate()){


                                context
                                    .read<LoginCubit>()
                                    .login(

                                  emailController.text
                                      .trim(),


                                  passwordController.text
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
                          'Create Account',



                          onPressed:(){

                            context.go(
                              RoutePaths.register,
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