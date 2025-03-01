import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart' as badge;

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final bool isEnabled;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool underlineBorderedTextField;

  const CustomTextFormField({
    required this.labelText,
    this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    super.key,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.underlineBorderedTextField = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          enabled: isEnabled && onTap == null,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            border: underlineBorderedTextField
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  )
                : OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            enabledBorder: underlineBorderedTextField
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  )
                : OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(.5),
              ),
            ),
            focusedBorder: underlineBorderedTextField
                ? UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  )
                : OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomImageUploader extends StatefulWidget {
  final double height;
  final double width;
  final Function(File) onSelected;
  final Function() onCancel;
  File? image;
  String? imageUrl;
  final bool readOnly;
  final bool circularMode;

  CustomImageUploader({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    required this.onSelected,
    required this.onCancel,
    this.image,
    this.imageUrl,
    this.readOnly = false,
    this.circularMode = false,
  });

  @override
  State<CustomImageUploader> createState() => _CustomImageUploaderState();
}

class _CustomImageUploaderState extends State<CustomImageUploader> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        widget.image = File(pickedFile.path);
      });
      widget.onSelected(widget.image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return badge.Badge(
      position: widget.circularMode
          ? badge.BadgePosition.bottomEnd(bottom: 15.h, end: 2.w)
          : badge.BadgePosition.topEnd(top: 20.h, end: 20.h),
      badgeContent: Icon(Icons.edit,
          color: widget.circularMode ? Colors.white : Colors.black, size: 17.r),
      badgeStyle: badge.BadgeStyle(
          badgeColor: widget.circularMode
              ? Theme.of(context).primaryColor
              : Colors.white),
      showBadge: (widget.image != null || widget.imageUrl != null) &&
          (!widget.readOnly),
      onTap: widget.readOnly ? () {} : _pickImage,
      child: GestureDetector(
        onTap: widget.readOnly ? () {} : _pickImage,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.3)),
            borderRadius:
                widget.circularMode ? null : BorderRadius.circular(10),
            shape: widget.circularMode ? BoxShape.circle : BoxShape.rectangle,
            color: Colors.grey.withOpacity(.1),
          ),
          padding: widget.circularMode || widget.readOnly
              ? EdgeInsets.zero
              : EdgeInsets.all(
              widget.image != null || widget.imageUrl != null ? 10.w : 0),
          child: widget.image != null
              ? widget.circularMode
                  ? ClipOval(
                      child: Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    widget.image!,
                    fit: BoxFit.cover,
                  ),
                )
              : widget.imageUrl != null
                  ? widget.circularMode
                      ? ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            errorWidget: (c, u, e) {
                              log("CACHED_IMAGE_ERROR: $e");
                              return const Icon(Iconsax.gallery);
                            },
                            imageUrl: widget.imageUrl ?? "",
                          ),
                        )
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        errorWidget: (c, u, e) {
                          log("CACHED_IMAGE_ERROR: $e");
                          return const Icon(Iconsax.gallery);
                        },
                        imageUrl: widget.imageUrl ?? "",
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.gallery),
                        if (!widget.circularMode) ...[
                          SizedBox(height: 10.h),
                        Text(
                          "Upload an Image",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ],
                        
                      ],
                    ),
        ),
      ),
    );
  }
}
