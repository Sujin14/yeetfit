import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/sleep_provider.dart';
import '../../../../shared/widgets/glassmorphic_container.dart';

class SleepGoalDialog extends ConsumerStatefulWidget {
  final String userId;

  const SleepGoalDialog({super.key, required this.userId});

  @override
  ConsumerState<SleepGoalDialog> createState() => _SleepGoalDialogState();
}

class _SleepGoalDialogState extends ConsumerState<SleepGoalDialog> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final goalHours = ref.read(sleepGoalProvider(widget.userId)).value ?? 8.0;
    controller.text = goalHours.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      color: const Color(0xFF3F51B5),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Set Sleep Goal (hours)',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter hours (e.g., 7.5)',
            hintStyle: GoogleFonts.roboto(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.roboto(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = double.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                ref.read(sleepGoalProvider(widget.userId).notifier).setGoal(newGoal);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid number')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26A69A).withOpacity(0.3),
            ),
            child: Text('Save', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}