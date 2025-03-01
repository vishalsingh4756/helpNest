// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/admin/data/add_service.dart';
import 'package:helpnest/features/service/data/models/service_model.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  bool loading = false;
  File? _logo;
  File? _slide1;
  File? _slide2;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            CustomTextFormField(
              labelText: "Service Name",
              controller: _name,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20.h),
            CustomTextFormField(
              labelText: "Service Description",
              controller: _description,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20.h),
            Text("Service Logo",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            CustomImageUploader(
              onSelected: (File file) => setState(() => _logo = file),
              image: _logo,
              onCancel: () => setState(() => _logo = null),
              height: 150.h,
              width: 150.h,
            ),
            SizedBox(height: 20.h),
            Text("Service Slide 1",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            CustomImageUploader(
              onSelected: (File file) => setState(() => _slide1 = file),
              image: _slide1,
              onCancel: () => setState(() => _slide1 = null),
            ),
            SizedBox(height: 20.h),
            Text("Service Slide 2",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            CustomImageUploader(
              onSelected: (File file) => setState(() => _slide2 = file),
              image: _slide2,
              onCancel: () => setState(() => _slide2 = null),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Add Service",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: _addService,
            icon: loading
                ? SizedBox(
                    height: 16.r,
                    width: 16.r,
                    child: const CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check)),
        SizedBox(width: 15.w)
      ],
    );
  }

  void _addService() async {
    final td = Timestamp.now();
    setState(() => loading = true);
    await AdminDs()
        .addService(
            service: ServiceModel(
                id: td.millisecondsSinceEpoch.toString(),
                name: _name.text,
                logo: "",
                description: _description.text,
                creationTD: td,
                createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
                deactivate: false,
                avgCharge: 200,
                avgTime: "2",
                slides: []),
            logo: _logo!,
            slide1: _slide1!,
            slide2: _slide2!)
        .whenComplete(() {
      setState(() => loading = false);
    });
  }
}
