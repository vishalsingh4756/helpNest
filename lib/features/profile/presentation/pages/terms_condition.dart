import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
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
              Text(
                "Welcome to HelpNest, a platform connecting unorganized sector workers with consumers. By using our app, you agree to these Terms and Conditions.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20.h),
              Text(
                "Definitions",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Text(
                "1. \"App\" refers to the HelpNest mobile application.\n"
                "2. \"User\" refers to workers, consumers, and any other individuals using the app.\n"
                "3. \"Services\" refers to the platform's features and functionality.",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20.h),
              _buildSectionTitle(context, "User Agreement"),
              _buildSectionContent(
                  context,
                  "1. You must be at least 18 years old or act on behalf of someone who will take responsibility.\n"
                  "2. You agree to provide accurate, authentic, and complete information during registration.\n"
                  "3. You are responsible for maintaining the confidentiality of your account credentials."),
              _buildSectionTitle(context, "Worker Terms"),
              _buildSectionContent(
                  context,
                  "1. Workers must provide accurate and complete profile information.\n"
                  "2. Workers are responsible for their own work quality and reliability.\n"
                  "3. Workers must comply with consumer requests and job requirements."),
              _buildSectionTitle(context, "Consumer Terms"),
              _buildSectionContent(
                  context,
                  "1. Consumers must provide accurate and complete job requirements.\n"
                  "2. Consumers are responsible for their own decisions regarding worker selection.\n"
                  "3. Consumers must treat workers with respect and professionalism."),
              _buildSectionTitle(context, "Prohibited Activities"),
              _buildSectionContent(
                  context,
                  "1. Spamming or soliciting other users.\n"
                  "2. Posting false or misleading information.\n"
                  "3. Engaging in harassment or abusive behavior.\n"
                  "4. Violating intellectual property rights."),
              _buildSectionTitle(context, "Payment Terms"),
              _buildSectionContent(
                  context,
                  "1. Payment processing fees may apply.\n"
                  "2. Workers are responsible for their own payment processing.\n"
                  "3. Consumers must pay workers according to specified terms."),
              _buildSectionTitle(context, "Intellectual Property"),
              _buildSectionContent(
                  context,
                  "1. HelpNest retains all intellectual property rights.\n"
                  "2. Users may not reproduce or distribute app content."),
              _buildSectionTitle(context, "Disclaimers"),
              _buildSectionContent(
                  context,
                  "1. HelpNest is not responsible for user interactions or disputes.\n"
                  "2. HelpNest is not liable for damages or losses resulting from app use."),
              _buildSectionTitle(context, "Termination"),
              _buildSectionContent(
                  context,
                  "1. HelpNest may terminate user accounts for violating Terms and Conditions.\n"
                  "2. Users may terminate their accounts at any time."),
              _buildSectionTitle(context, "Governing Law"),
              _buildSectionContent(context,
                  "These Terms and Conditions are governed by laws of the land."),
              _buildSectionTitle(context, "Changes"),
              _buildSectionContent(
                  context,
                  "1. HelpNest reserves the right to update these Terms and Conditions.\n"
                  "2. Changes will be effective upon posting."),
              _buildSectionTitle(context, "Contact"),
              _buildSectionContent(context,
                  "For questions or concerns, please contact us at mailto:harshsharma55115@gmail.com."),
              _buildSectionTitle(context, "Effective Date"),
              _buildSectionContent(context, "01 Feb, 2025"),
              _buildSectionTitle(context, "Acknowledgement"),
              _buildSectionContent(context,
                  "By using our app, you acknowledge that you have read, understood, and agreed to these Terms and Conditions."),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSectionContent(BuildContext context, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
