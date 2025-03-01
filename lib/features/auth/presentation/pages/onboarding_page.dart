import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/config/routes.dart';
import 'package:helpnest/features/auth/presentation/cubit/auth_state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<List<String>> onboarding = [
    [
      "Find Services\nwith Ease",
      "Browse and connect with trusted service providers tailored to your needs."
    ],
    [
      "Seamless\nCommunication",
      "Chat directly with service providers to discuss and finalize your requirements."
    ],
    [
      "Quality\nYou Can Trust",
      "Experience verified professionals delivering top-notch service, every time."
    ]
  ];
  bool skipped = false;
  int headingIndex = 0;
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == StateStatus.failure) {
          log(state.error.consoleMessage);
        } else if (state.status == StateStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 0.h),
                Center(
                  child: Text(
                    "helpNest",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 100.h,
                  child: AnimatedTextKit(
                    pause: Duration.zero,
                    animatedTexts: [
                      FadeAnimatedText(onboarding[0][0],
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          duration: const Duration(milliseconds: 3000)),
                      FadeAnimatedText(
                        onboarding[1][0],
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        duration: const Duration(milliseconds: 3000),
                        textAlign: TextAlign.center,
                      ),
                      FadeAnimatedText(
                        onboarding[2][0],
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        duration: const Duration(milliseconds: 3000),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    onNext: (i, b) => setState(() => headingIndex = i),
                    repeatForever: true,
                  ),
                ),
                SizedBox(
                  height: 450.h,
                  width: double.infinity,
                  child: CarouselSlider(
                    items: List.generate(
                        6,
                        (index) =>
                            Image.asset("assets/auth/onb${index + 1}.png")),
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 2),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    onboarding[headingIndex][1],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(330.r, 55.r),
                  ),
                  onPressed: state.status == StateStatus.loading
                      ? () => setState(() => skipped = true)
                      : _signIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue with Google",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      if (state.status == StateStatus.loading) ...[
                        SizedBox(width: 30.w),
                        SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 70.h),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar();
  }

  void _signIn() async {
    context.read<AuthCubit>().signInWithGoogle();
  }
}
