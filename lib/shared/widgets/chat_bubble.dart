import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'chat_markdown_text.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';

/// Message bubble shared by coach chat and the AI coach. Own messages are
/// gradient on the right; received ones are translucent on the left.
/// Received bubbles skip the backdrop blur — blurring every row of a long
/// scrolling list is expensive and the flat 10% fill reads the same.
class ChatBubble extends StatelessWidget {
  static const double _radius = 18;
  static const double _tailRadius = 4;

  final String text;
  final bool isMine;
  final Widget? footer;
  final VoidCallback? onLongPress;

  /// For AI replies only; people's messages stay literal so a typed `*`
  /// isn't reinterpreted.
  final bool renderMarkdown;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMine,
    this.footer,
    this.onLongPress,
    this.renderMarkdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: isMine ? colors.onPrimary : colors.onBackground,
    );
    final maxWidth = MediaQuery.sizeOf(context).width * 0.7;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(_radius),
      topRight: const Radius.circular(_radius),
      bottomLeft: Radius.circular(isMine ? _radius : _tailRadius),
      bottomRight: Radius.circular(isMine ? _tailRadius : _radius),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: onLongPress,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: isMine
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colors.primary, colors.secondary],
                        )
                      : null,
                  color: isMine ? null : Colors.white.withValues(alpha: 0.1),
                  border: isMine
                      ? null
                      : Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.smd,
                  ),
                  child: renderMarkdown
                      ? ChatMarkdownText(text: text, style: textStyle)
                      : Text(text, style: textStyle),
                ),
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xs,
                left: AppSpacing.xs,
                right: AppSpacing.xs,
              ),
              child: footer,
            ),
        ],
      ),
    );
  }
}
