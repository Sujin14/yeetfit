import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class WaterSuccessPage extends StatelessWidget {
  final int goal;
  const WaterSuccessPage({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors['background'],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/success.json',
            width: FixedSizes.box300(context),
            height: FixedSizes.box300(context),
            fit: BoxFit.contain,
            repeat: false,
          ),
          Text(
            'Congratulations! 🎉',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font28(context),
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['teal'],
            ),
          ),
          SizedBox(height: FixedSizes.box10(context)),
          Text(
            'You crushed your goal of $goal glasses today — let’s keep the streak alive! 💧🔥',
            style: GoogleFonts.roboto(
              fontSize: FixedSizes.font18(context),
              color: AppTheme.colors['primaryText'],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: FixedSizes.box30(context)),
          ElevatedButton(
            onPressed: () => context.go('/modal/water'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['navBarActive'],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FixedSizes.radius12(context))),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font16(context),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
