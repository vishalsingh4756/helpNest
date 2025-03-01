import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About HelpNest",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to HelpNest",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your one-stop solution for connecting households with skilled and reliable service providers. Our app is designed to simplify everyday tasks by bringing trusted electricians, plumbers, carpenters, and more to your fingertips.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                "What We Do",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "HelpNest bridges the gap between service seekers and providers by offering a secure, organized, and efficient platform. Whether you’re looking to book a service or showcase your skills, we’re here to make the process easy and seamless.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text(
                "Why Choose HelpNest?",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              SizedBox(height: 20.h),
              _buildFeature(
                icon: Iconsax.search_normal_1,
                title: "Simple and Fast Search",
                description:
                    "Find services based on your location, availability, and ratings.",
              ),
              _buildFeature(
                icon: Iconsax.cards,
                title: "Dual Functionality",
                description:
                    "Designed for both service providers and households, enabling smooth interactions.",
              ),
              _buildFeature(
                icon: Iconsax.security_card,
                title: "Verified Professionals",
                description:
                    "We ensure quality with trusted and verified service providers.",
              ),
              _buildFeature(
                icon: Iconsax.shield_tick,
                title: "Safe Transactions",
                description:
                    "Enjoy secure payments and real-time communication tools for a worry-free experience.",
              ),
              const SizedBox(height: 20),
              Text(
                "At HelpNest, we aim to empower skilled professionals and provide households with the services they need, creating a more connected and reliable community. Join us today and experience convenience like never before!",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
