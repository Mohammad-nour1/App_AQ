import 'package:app_aq_2/core/constants/app_colors.dart';
import 'package:app_aq_2/core/constants/app_radius.dart';
import 'package:app_aq_2/core/constants/app_spacing.dart';
import 'package:app_aq_2/core/constants/app_text_styles.dart';
import 'package:app_aq_2/core/router/route_paths.dart';
import 'package:app_aq_2/core/widgets/glass_container.dart';
import 'package:app_aq_2/core/widgets/primary_button.dart';
import 'package:app_aq_2/core/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();

}
class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _controller =
      PageController();
  int currentPage = 0;



  final List<Map<String,String>> pages = [


    {
      "image": "assets/images/umayyad_mosque.jpg",
      "title": "Discover Syria",
      "description":
      "Explore the most beautiful places and hidden gems in Syria",
    },


    {
      "image": "assets/images/syria_place2.jpg",
      "title": "Plan Your Trip",
      "description":
      "Organize your trips easily and enjoy unforgettable experiences",
    },


    {
      "image": "assets/images/syria_place3.jpg",
      "title": "Start Your Journey",
      "description":
      "Find places, hotels and adventures around you",
    },


  ];
  @override
  void dispose() {

    _controller.dispose();

    super.dispose();

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(

      backgroundColor:
      AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index){
              setState(() {
                currentPage = index;
              });

            },

            itemBuilder: (context,index){
              return Stack(
                fit: StackFit.expand,
                children: [

                  Image.asset(
                    pages[index]["image"]!,
                    fit: BoxFit.cover,
                  ),
                  Container(

                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin:
                        Alignment.topCenter,
                        end:
                        Alignment.bottomCenter,

                        colors: [
                          Colors.transparent,
                          AppColors.background
                              .withOpacity(0.95),
                        ],
                      ), ), ),
                ]
              );

            },

          ),
          Positioned(

            left: AppSpacing.lg,

            right: AppSpacing.lg,

            bottom: AppSpacing.lg,

            child: SafeArea(
              child: GlassContainer(
                borderRadius:
                AppRadius.xl,
                padding:
                const EdgeInsets.all(
                  AppSpacing.lg,
                ),

                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(

                      pages[currentPage]["title"]!,

                      style:
                      AppTextStyles.displaySmall,

                    ),
                    const SizedBox(

                      height:
                      AppSpacing.sm,

                    ),
                    Text(

                      pages[currentPage]
                      ["description"]!,

                      style:
                      AppTextStyles.bodyMedium
                          .copyWith(

                        color:
                        AppColors.textSecondary,

                      ),


                    ),
                    const SizedBox(

                      height:
                      AppSpacing.md,

                    ),
                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children:

                      List.generate(

                        pages.length,

                            (index){


                          return AnimatedContainer(

                            duration:
                            const Duration(
                              milliseconds: 300,
                            ),

                            margin:
                            const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),

                            width:

                            currentPage == index
                                ? 25
                                : 8,

                            height: 6,

                            decoration:
                            BoxDecoration(

                              color:

                              currentPage == index

                                  ?

                              AppColors.accent

                                  :

                              AppColors.white
                                  .withOpacity(0.4),

                              borderRadius:
                              BorderRadius.circular(
                                AppRadius.full,
                              ),


                            ),


                          );


                        },


                      ),


                    ),

                    const SizedBox(

                      height:
                      AppSpacing.md,

                    ),
                    if(currentPage ==
                        pages.length -1)
                      Column(children: [
                          PrimaryButton(

                            label:
                            "Create Account",
                            onPressed: (){
                              context.go(
                                RoutePaths.register,
                              );
                            },
                          ),
                          const SizedBox(

                            height:
                            AppSpacing.sm,

                          ),
                          SecondaryButton(
                            label:
                            "Login",
                            onPressed: (){
                              context.go(
                                RoutePaths.login,
                              );


                            },
                          ),
                        ],

                      )
                    else
                      PrimaryButton(
                        label:
                        "Next",
                        onPressed: (){
                          _controller.nextPage(
                            duration:
                            const Duration(
                              milliseconds:300,
                            ),
                            curve:
                            Curves.easeInOut,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

          ),
        ],
      ),


    );


  }

}