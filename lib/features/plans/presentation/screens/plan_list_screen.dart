import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/theme.dart';
import '../../data/models/plan_model.dart';
import '../widgets/plan_list_item.dart';

class PlanListScreen extends StatelessWidget {
  final String category;

  const PlanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Error',
            style: GoogleFonts.roboto(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.colors['teal'],
            ),
          ),
        ),
        body: Center(
          child: Text(
            'User not logged in',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              color: AppTheme.colors['error'],
            ),
          ),
        ),
      );
    }

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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection(category == 'diet' ? 'diets' : 'workouts')
              .orderBy('createdAt', descending: true)
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
                  'No ${category == 'diet' ? 'diet' : 'workout'} plans available',
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
                debugPrint('PlanListScreen: Navigating to plan - id=${plan.id}, type=${plan.type}, category=$category');
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: PlanListItem(
                    plan: plan,
                    onTap: () {
                      context.push(
                        '/plans/$category/${plan.id}',
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
    );
  }
}