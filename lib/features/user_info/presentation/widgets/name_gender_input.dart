import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/validators/user_info_validators.dart';
import '../providers/user_info_provider.dart';

class NameGenderInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final void Function(String) onGenderChanged;
  final void Function(XFile) onImageSelected;

  const NameGenderInput({
    super.key,
    required this.formKey,
    required this.onGenderChanged,
    required this.onImageSelected,
  });

  @override
  _NameGenderInputState createState() => _NameGenderInputState();
}

class _NameGenderInputState extends ConsumerState<NameGenderInput> {
  String? gender;
  XFile? _image;
  String? _genderError;
  bool _isUploading = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoControllerProvider);
    gender = userInfo.value?.gender.isNotEmpty ?? false
        ? userInfo.value!.gender
        : null;
    _nameController = TextEditingController(text: userInfo.value?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isUploading) return;
    setState(() {
      _isUploading = true;
    });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      widget.onImageSelected(pickedFile);
    }
    setState(() {
      _isUploading = false;
    });
  }

  Widget _buildGenderOption(String genderType, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderType;
          _genderError = null;
        });
        widget.onGenderChanged(genderType);
      },
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: gender == genderType ? color : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 40.sp,
            color: gender == genderType ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final controller = ref.read(userInfoControllerProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Upload a profile picture",
              style: GoogleFonts.aBeeZee(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image != null
                          ? FileImage(File(_image!.path))
                          : userInfo.value?.profileImageUrl != null
                          ? NetworkImage(userInfo.value!.profileImageUrl!)
                          : null,
                      child:
                          _image == null &&
                              userInfo.value?.profileImageUrl == null
                          ? Icon(
                              Icons.add_a_photo,
                              size: 35.sp,
                              color: Colors.grey[600],
                            )
                          : null,
                    ),
                  ),
                  if (_isUploading)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "What is your name?",
              style: GoogleFonts.aBeeZee(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              validator: UserInfoValidators.validateName,
              onSaved: (value) {
                if (value != null) {
                  controller.setFormValue('name', value.trim());
                }
              },
            ),
            SizedBox(height: 20.h),
            Text(
              "Select your gender",
              style: GoogleFonts.aBeeZee(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: _buildGenderOption(
                      "Male",
                      Icons.male,
                      const Color(0xFF040B90),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: _buildGenderOption(
                      "Female",
                      Icons.female,
                      const Color.fromARGB(255, 255, 0, 234),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0,
              child: TextFormField(
                enabled: false,
                initialValue: gender ?? userInfo.value?.gender ?? '',
                validator: (value) {
                  final error = UserInfoValidators.validateGender(
                    gender ?? userInfo.value?.gender,
                  );
                  setState(() {
                    _genderError = error;
                  });
                  return error;
                },
                onSaved: (value) {
                  if (gender != null) {
                    controller.setFormValue('gender', gender);
                  }
                },
              ),
            ),
            if (_genderError != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  _genderError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
