import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_info_controller.dart';
import '../../domain/validators/user_info_validators.dart';
import 'dart:io';

class NameGenderInput extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  const NameGenderInput({super.key, required this.formKey});

  @override
  _NameGenderInputState createState() => _NameGenderInputState();
}

class _NameGenderInputState extends ConsumerState<NameGenderInput> {
  String? gender;
  XFile? _image;
  String? _genderError;

  @override
  void initState() {
    super.initState();
    // Initialize gender from userInfo to persist selection when navigating back
    final userInfo = ref.read(userInfoControllerProvider);
    gender = userInfo.gender.isNotEmpty ? userInfo.gender : null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      ref.read(userInfoControllerProvider.notifier).updateProfileImageUrl(
            pickedFile.path,
            context,
          );
    }
  }

  Widget _buildGenderOption(
    String genderType,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderType;
          _genderError = null;
        });
        ref.read(userInfoControllerProvider.notifier).updateGender(genderType, context);
      },
      child: Container(
        width: 80,
        height: 80,
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
            size: 40,
            color: gender == genderType ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoControllerProvider);
    final notifier = ref.read(userInfoControllerProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Upload a profile picture",
              style: GoogleFonts.aBeeZee(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
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
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _image != null ? FileImage(File(_image!.path)) : null,
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 35, color: Colors.grey[600])
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "What is your name?",
              style: GoogleFonts.aBeeZee(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: userInfo.name,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              validator: UserInfoValidators.validateName,
              onChanged: (val) => notifier.updateName(val.trim(), context),
            ),
            const SizedBox(height: 20),
            Text(
              "Select your gender",
              style: GoogleFonts.aBeeZee(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGenderOption(
                    "Male",
                    Icons.male,
                    const Color(0xFF040B90),
                  ),
                  _buildGenderOption(
                    "Female",
                    Icons.female,
                    const Color.fromARGB(255, 255, 0, 234),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0,
              child: TextFormField(
                enabled: false,
                initialValue: gender ?? userInfo.gender,
                decoration: const InputDecoration(
                ),
                validator: (value) {
                  final error = UserInfoValidators.validateGender(gender ?? userInfo.gender);
                  setState(() {
                    _genderError = error;
                  });
                  return error;
                },
              ),
            ),
            if (_genderError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _genderError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}