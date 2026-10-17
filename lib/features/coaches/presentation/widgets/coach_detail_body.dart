import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/shared/widgets/glass_sliver_app_bar.dart';
import '../../domain/entities/coach.dart';
import 'coach_certification_list.dart';
import 'coach_detail_section.dart';
import 'coach_profile_card.dart';
import 'coach_specialization_chips.dart';
import 'coach_rating_card.dart';
import 'request_coach_button.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import '../providers/coach_provider.dart';
import 'training_schedule_card.dart';

class CoachDetailBody extends ConsumerWidget {
  final Coach coach;
  final String clientUid;
  final AsyncValue<String?> currentCoachId;

  const CoachDetailBody({
    super.key,
    required this.coach,
    required this.clientUid,
    required this.currentCoachId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final clientData = ref
        .watch(clientProfileProvider(clientUid))
        .asData
        ?.value;
    return CustomScrollView(
      slivers: [
        const GlassSliverAppBar(title: 'Coach Profile'),
        SliverToBoxAdapter(child: CoachProfileCard(coach: coach)),
        if (clientData != null && clientData.currentCoachId == coach.uid) ...[
          SliverToBoxAdapter(
            child: TrainingScheduleCard(
              trainingDays: clientData.trainingDays,
              coachId: coach.uid,
            ),
          ),
          SliverToBoxAdapter(
            child: CoachRatingCard(coachUid: coach.uid, clientUid: clientUid),
          ),
        ],
        SliverToBoxAdapter(
          child: CoachDetailSection(
            title: 'Specializations',
            child: coach.specializations.isEmpty
                ? Text(
                    'No specializations listed',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: colors.textMuted),
                  )
                : CoachSpecializationChips(
                    specializations: coach.specializations,
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: CoachDetailSection(
            title: 'Certifications',
            child: CoachCertificationList(certifications: coach.certifications),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenEdge,
              AppSpacing.md,
              AppSpacing.screenEdge,
              AppSpacing.xl,
            ),
            child: RequestCoachButton(
              coach: coach,
              clientUid: clientUid,
              currentCoachId: currentCoachId,
              width: double.infinity,
              height: 52,
            ),
          ),
        ),
      ],
    );
  }
}
