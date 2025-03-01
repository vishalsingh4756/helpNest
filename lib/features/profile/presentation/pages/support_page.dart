import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final List<Map<String, String>> faqs = [
    {
      "question": "How do I search for a service provider?",
      "answer":
          "Use the search bar on the home screen to find service providers by profession (e.g., electrician, plumber) or location. You can also use filters to refine your search."
    },
    {
      "question": "How can I verify the credentials of a service provider?",
      "answer":
          "All service providers on HelpNest are verified. You can view their profile details, ratings, reviews, and certifications."
    },
    {
      "question": "What payment methods are supported?",
      "answer":
          "We support secure payments via credit/debit cards, UPI, net banking, and digital wallets."
    },
    {
      "question": "Can I schedule a service for a later date?",
      "answer":
          "Yes, you can select your preferred date and time while booking a service."
    },
    {
      "question": "What happens if the service provider doesn’t show up?",
      "answer":
          "In case of a no-show, you can report the issue through the app, and we’ll help you reschedule or connect with another provider."
    },
    {
      "question": "Are the service providers background-checked?",
      "answer":
          "Yes, all service providers undergo a background verification process to ensure safety and reliability."
    },
    {
      "question": "What if I’m unsatisfied with the service?",
      "answer":
          "You can rate the service and leave feedback. If there are issues, you can file a complaint through the app, and we’ll address it promptly."
    },
    {
      "question": "How can I contact the service provider?",
      "answer":
          "Once a booking is confirmed, you can use the in-app chat or call feature to communicate directly with the provider."
    },
    {
      "question": "Is there a cancellation policy?",
      "answer":
          "Yes, you can cancel bookings within the stipulated time. Check the cancellation policy on the booking details page for more information."
    },
    {
      "question": "Can I book multiple services at once?",
      "answer":
          "Yes, you can add multiple services to your booking and schedule them as needed."
    },
    {
      "question": "Are there any discounts or offers available?",
      "answer":
          "Keep an eye on the Offers section for discounts and promotional deals."
    },
    {
      "question": "How do I update my profile details?",
      "answer":
          "Go to the “My Account” section to edit your personal information, address, and payment methods."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support & FAQ",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Column(
              children: [
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  expandedAlignment: Alignment.centerLeft,
                  shape: const OutlineInputBorder(borderSide: BorderSide.none),
                  title: Text(
                    faq["question"]!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  children: [
                    Text(
                      faq["answer"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            );
          },
        ),
      ),
    );
  }
}
