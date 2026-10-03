import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  static const List<String> _fruits = [
    'graine de pavot',
    'graine de sésame',
    'lentille',
    'myrtille',
    'framboise',
    'olive',
    'prune',
    'citron vert',
    'citron',
    'pêche',
    'pomme',
    'avocat',
    'oignon',
    'patate douce',
    'mangue',
    'banane',
    'grenade',
    'papaye',
    'maïs',
    'aubergine',
    'chou-fleur',
    'noix de coco',
    'ananas',
    'melon',
    'pastèque',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final w = DateFormatter.weeksOf(user.lmp);
    final due = DateFormatter.dueDate(user.lmp);
    final fruitIndex = ((w - 4) / 1.5).floor().clamp(0, _fruits.length - 1);
    final fruit = _fruits[fruitIndex];
    final progress = (w / 40.0).clamp(0.0, 1.0);
    final trimester = DateFormatter.trimester(w);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Suivi de grossesse',
                subtitle: due.isNotEmpty ? 'Accouchement prévu le $due' : 'Accouchement prévu le 17/12/2026',
              ),
              // Big card with gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.darkCard, AppColors.darkPrimary.withValues(alpha: 0.3)]
                        : [AppColors.secondary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Semaine',
                      style: AppTypography.bodyS.copyWith(
                        color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$w',
                      style: AppTypography.displayXl.copyWith(
                        fontSize: 64,
                        color: isDark ? AppColors.darkPrimary : AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        style: AppTypography.bodyM.copyWith(
                          color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                        ),
                        children: [
                          const TextSpan(text: 'Bébé a la taille d\'une '),
                          TextSpan(
                            text: fruit,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        height: 12,
                        width: double.infinity,
                        color: isDark ? AppColors.darkCard : Colors.white,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.pink,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$w/40 semaines · Trimestre $trimester',
                      style: AppTypography.bodyS.copyWith(
                        color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Conseil de la semaine
              SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Conseil de la semaine',
                      style: AppTypography.labelM.copyWith(
                        color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Buvez au moins 1,5 L d\'eau potable par jour et dormez sous moustiquaire imprégnée. Continuez vos consultations prénatales.',
                      style: AppTypography.bodyM.copyWith(
                        color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Chronologie
              Text(
                'Chronologie',
                style: AppTypography.labelL.copyWith(
                  color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                ),
              ),
              const SizedBox(height: 10),
              ...[w - 1, w, w + 1].map((weekNum) {
                final isCurrent = weekNum == w;
                final isPast = weekNum < w;
                final statusText = isPast ? '✓ Terminée' : (isCurrent ? 'En cours' : 'À venir');

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SbCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    borderColor: isCurrent ? (isDark ? AppColors.darkPrimary : AppColors.primary) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Semaine $weekNum',
                          style: AppTypography.labelM.copyWith(
                            color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                          ),
                        ),
                        Text(
                          statusText,
                          style: AppTypography.bodyS.copyWith(
                            color: isCurrent
                                ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                                : (isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground),
                            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Mon dossier
              if (user.record.isNotEmpty) ...[
                const SizedBox(height: 16),
                SbCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mon dossier',
                        style: AppTypography.labelM.copyWith(
                          color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...user.record.map((r) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                r.label,
                                style: AppTypography.bodyS.copyWith(
                                  color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                                ),
                              ),
                              Text(
                                r.value,
                                style: AppTypography.bodyM.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              SbButton(
                text: 'Mes indicateurs de santé',
                onPressed: () => context.push('/app/tracking/metrics'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
