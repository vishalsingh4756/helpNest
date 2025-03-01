import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionText(
                title: null,
                content:
                    "HelpNest is committed to protecting the privacy of our users, including unorganized sector workers and consumers. This privacy policy explains how we collect, use, and protect personal information through our app.",
              ),
              const SectionText(
                title: "Personal Information We Collect",
                content:
                    "We collect personal information from workers and consumers, including:\n\n"
                    "1. Contact information (name, email, phone number, address)\n"
                    "2. Profile information (work experience, skills, education)\n"
                    "3. Location information (GPS coordinates)\n"
                    "4. Job search preferences\n"
                    "5. Communication history (messages, calls).",
              ),
              const SectionText(
                title: "How We Use Personal Information",
                content: "We use personal information to:\n\n"
                    "1. Connect workers with consumers for job opportunities\n"
                    "2. Provide services and support to workers and consumers\n"
                    "3. Improve our app's functionality and user experience\n"
                    "4. Conduct research and analysis to enhance our services.",
              ),
              const SectionText(
                title: "Sharing Personal Information",
                content: "We may share personal information with:\n\n"
                    "1. Consumers seeking workers for job opportunities\n"
                    "2. Third-party service providers (e.g., payment processors)\n"
                    "3. Law enforcement agencies (as required by law).",
              ),
              const SectionText(
                title: "Data Security",
                content:
                    "We implement reasonable security measures to protect personal information from unauthorized access, disclosure, or destruction.",
              ),
              const SectionText(
                title: "User Rights",
                content: "Users have the right to:\n\n"
                    "1. Access and update their personal information\n"
                    "2. Delete their account and personal information\n"
                    "3. Opt-out of promotional communications.",
              ),
              const SectionText(
                title: "Changes to Privacy Policy",
                content:
                    "We reserve the right to update this privacy policy. Changes will be effective upon posting.",
              ),
              const SectionText(
                title: "Contact Us",
                content:
                    "For questions or concerns, please contact us at harshsharma55115@gmail.com.",
              ),
              const SectionText(
                title: "Acknowledgement",
                content:
                    "By using our app, you acknowledge that you have read, understood, and agreed to this privacy policy.",
              ),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String? title;
  final String content;

  const SectionText({this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        if (title != null) SizedBox(height: 20.h),
        Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
