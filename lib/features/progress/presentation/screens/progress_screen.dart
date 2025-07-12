import 'package:flutter/material.dart';

import '../widgets/progress_calendar.dart';
import '../widgets/progress_header.dart';


class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressHeader(),
              SizedBox(height: 16),
              const ProgressCalendar(),
            ],
          ),
        ),
      ),
    );
  }
}