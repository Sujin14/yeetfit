import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:yeetfit/core/theme/app_colors.dart';

/// Markdown rendered at the same size and colour as plain bubble text, so
/// stray `*`, `**` or `#` from the model never show as raw symbols.
class ChatMarkdownText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const ChatMarkdownText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final heading = style.copyWith(fontWeight: FontWeight.w700);

    return MarkdownBody(
      data: text,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: style,
        strong: const TextStyle(fontWeight: FontWeight.w700),
        em: const TextStyle(fontStyle: FontStyle.italic),
        a: style.copyWith(decoration: TextDecoration.underline),
        h1: heading,
        h2: heading,
        h3: heading,
        h4: heading,
        h5: heading,
        h6: heading,
        listBullet: style,
        blockquote: style,
        tableHead: heading,
        tableBody: style,
        code: style.copyWith(backgroundColor: Colors.transparent),
        codeblockDecoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        blockquoteDecoration: BoxDecoration(
          border: Border(left: BorderSide(color: colors.textMuted, width: 3)),
        ),
      ),
    );
  }
}
