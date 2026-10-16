import 'package:flutter/material.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

class MoodEmojiButton extends StatelessWidget {
  static const double size = 40;

  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const MoodEmojiButton({
    super.key,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    const duration = Duration(milliseconds: 180);

    return AnimatedScale(
      scale: isSelected ? 1.15 : 1,
      duration: duration,
      curve: Curves.easeOut,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: AnimatedContainer(
          duration: duration,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? colors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          // Emoji glyphs ignore text color, so selection is shown by opacity.
          child: AnimatedOpacity(
            opacity: isSelected ? 1 : 0.4,
            duration: duration,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
      ),
    );
  }
}
