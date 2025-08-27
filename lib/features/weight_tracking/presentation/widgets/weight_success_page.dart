import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../utils/fixed_sizes.dart';

class WeightSuccessPage extends StatelessWidget {
  final String goal;

  const WeightSuccessPage({super.key, required this.goal});

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: FixedSizes.box16(context)),
            child: Text(
              'You reached your goal weight of $goal kg — amazing work! 💪',
              style: GoogleFonts.roboto(
                fontSize: FixedSizes.font18(context),
                color: AppTheme.colors['primaryText'],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: FixedSizes.box30(context)),
          ElevatedButton(
            onPressed: () => context.go('/modal/weight'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.colors['navBarActive'],
              padding: EdgeInsets.symmetric(horizontal: FixedSizes.box24(context), vertical: FixedSizes.box12(context)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(FixedSizes.box12(context)),
              ),
            ),
            child: Text(
              'Done',
              style: GoogleFonts.roboto(fontSize: FixedSizes.font16(context), color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
