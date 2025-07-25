import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/models/plan_model.dart';
import '../widgets/plan_list_item.dart';

class PlanListScreen extends StatelessWidget {
  final String category;

  const PlanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          category == 'diet' ? 'Diet Plans' : 'Workout Plans',
          style: GoogleFonts.roboto(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.colors['teal'],
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.colors['onSurfaceDark']),
      ),
      body: SafeArea(
        child: GlassmorphicContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
          blur: 20,
          alignment: Alignment.center,
          border: 0,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.colors['navigationAccent']!,
              AppTheme.colors['navigationAccent']!.withOpacity(0.8),
            ],
          ),
          borderGradient: LinearGradient(
            colors: [
              AppTheme.colors['borderGradientStart']!,
              AppTheme.colors['borderGradientEnd']!,
            ],
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(category == 'diet' ? 'diets' : 'workouts')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: AppTheme.colors['error'],
                    ),
                  ),
                );
              }
              final plans = snapshot.data!.docs
                  .map((doc) => PlanModel.fromFirestore(doc))
                  .toList();
              if (plans.isEmpty) {
                return Center(
                  child: Text(
                    'No $category plans available',
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: AppTheme.colors['onSurfaceDark']!.withOpacity(0.8),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: PlanListItem(
                      plan: plan,
                      onTap: () {
                        context.push(
                          '/plans/${plan.id}',
                          extra: {'plan': plan, 'category': category},
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
