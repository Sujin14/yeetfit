import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/theme/theme.dart';
import '../controllers/chat_controller.dart';

class MessageInput extends StatelessWidget {
  final ChatController controller;

  const MessageInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              onChanged: controller.updateMessage,
              style: AppTheme.textStyles['bodyMedium']?.copyWith(
                color: AppTheme.colors['onSurface'] ?? Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTheme.textStyles['bodyMedium']?.copyWith(
                  color: AppTheme.colors['secondaryText'] ?? Colors.black,
                ),
                fillColor: (AppTheme.colors['primaryAccent'] ?? Colors.blue)
                    .withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color:
                        AppTheme.colors['borderGradientStart'] ?? Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color:
                        AppTheme.colors['borderGradientStart'] ?? Colors.blue,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientEnd'] ?? Colors.blue,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: AppTheme.colors['navBarActive'] ?? Colors.blue,
              size: 45.sp,
            ),
            onPressed: () => controller.sendMessages(context),
          ),
        ],
      ),
    );
  }
}