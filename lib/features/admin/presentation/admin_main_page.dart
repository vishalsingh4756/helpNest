import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/features/admin/presentation/add_service_page.dart';
import 'package:iconsax/iconsax.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
            shrinkWrap: true,
            crossAxisCount: 5,
            children: [
              _buildServiceItem(
                  title: "Services",
                  icon: Iconsax.briefcase,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddServicePage()));
                  })
            ],
          )
        ],
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Admin Panel ( Temperory )",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Builds an individual service item for the grid.
  Widget _buildServiceItem(
      {required String title,
      required IconData icon,
      required void Function() onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        children: [
          Icon(icon),
          SizedBox(height: 10.h),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
