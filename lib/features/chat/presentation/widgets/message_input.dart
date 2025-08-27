import 'package:flutter/material.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';
import '../controllers/chat_controller.dart';

class MessageInput extends StatelessWidget {
  final ChatController controller;

  const MessageInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: FixedSizes.box16(context),
        vertical: FixedSizes.box8(context),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              onChanged: controller.updateMessage,
              style: AppTheme.textStyles['bodyMedium']?.copyWith(
                color: AppTheme.colors['onSurface'],
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTheme.textStyles['bodyMedium']?.copyWith(
                  color: AppTheme.colors['secondaryText'],
                ),
                fillColor: AppTheme.colors['primaryAccent']!.withOpacity(0.2),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: FixedSizes.box16(context),
                  vertical: FixedSizes.box12(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius24(context)),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius24(context)),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientStart']!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius24(context)),
                  borderSide: BorderSide(
                    color: AppTheme.colors['borderGradientEnd']!,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: FixedSizes.box8(context)),
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: AppTheme.colors['navBarActive'],
              size: FixedSizes.iconSize(context),
            ),
            onPressed: () => controller.sendMessages(context),
          ),
        ],
      ),
    );
  }
}
