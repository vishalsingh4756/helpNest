import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:helpnest/core/config/error.dart';
import 'package:helpnest/core/utils/common_methods.dart';
import 'package:helpnest/core/utils/common_widgets.dart';
import 'package:helpnest/features/profile/presentation/cubit/profile_state.dart';
import 'package:iconsax/iconsax.dart';

class EditProPage extends StatefulWidget {
  const EditProPage({super.key});

  @override
  State<EditProPage> createState() => _EditProPageState();
}

class _EditProPageState extends State<EditProPage> {
  File? _avatar;
  String? _imageUrl;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _gender = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.user.isNotEmpty) {
          _imageUrl = state.user.first.image;
          _name.text = state.user.first.name;
          _phoneNumber.text = state.user.first.phoneNumber;
          _gender.text = state.user.first.gender;
        }
        return Scaffold(
          appBar: _appBar(context: context, state: state),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                CustomImageUploader(
                  height: 130.h,
                  width: 130.h,
                  imageUrl: _imageUrl,
                  onSelected: (File file) => setState(() {
                    _avatar = file;
                  }),
                  image: _avatar,
                  onCancel: () => setState(() {
                    _avatar = null;
                  }),
                  circularMode: true,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  labelText: "Name",
                  controller: _name,
                  underlineBorderedTextField: true,
                ),
                
                SizedBox(height: 20.h),
                CustomTextFormField(
                  labelText: "Email Address",
                  controller: TextEditingController(
                      text: FirebaseAuth.instance.currentUser?.email ?? ""),
                  isEnabled: false,
                  underlineBorderedTextField: true,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  labelText: "Gender",
                  controller: _gender,
                  onTap: () => commonBottomSheet(
                      context: context,
                      title: 'Select an option',
                      options: ["Male", "Female"],
                      onSelected: (String value) {
                        _gender.text = value;
                      }),
                  suffixIcon: Iconsax.arrow_down_1,
                  keyboardType: TextInputType.text,
                  underlineBorderedTextField: true,
                ),
                SizedBox(height: 20.h),
                CustomTextFormField(
                  labelText: "Phone Number",
                  controller: _phoneNumber,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  underlineBorderedTextField: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar({required BuildContext context, required ProfileState state}) {
    return AppBar(
      title: Text(
        "Edit Profile",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: state.updateUserStatus == StateStatus.loading
              ? () {}
              : () {
                  if (state.user.isNotEmpty) {
                    final oldUserData = state.user.first;
                    if (oldUserData.name != _name.text ||
                        oldUserData.phoneNumber != _phoneNumber.text ||
                        oldUserData.gender != _gender.text ||
                        _avatar != null) {
                      context.read<ProfileCubit>().updateUser(
                          oldUserData.copyWith(
                              name: _name.text,
                              image: _imageUrl,
                              phoneNumber: _phoneNumber.text,
                              gender: _gender.text),
                          _avatar);
                    }
                  }
                },
          icon: state.updateUserStatus == StateStatus.loading
              ? SizedBox(
                  height: 20.r,
                  width: 20.r,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 2.r,
                  ),
                )
              : Icon(
                  Icons.check,
                  color: state.updateUserStatus == StateStatus.success
                      ? Theme.of(context).primaryColor
                      : null,
                ),
        ),
        SizedBox(width: 10.w)
      ],
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _phoneNumber.dispose();
    _gender.dispose();
    super.dispose();
  }
}
