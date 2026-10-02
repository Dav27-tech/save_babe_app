import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/state/app_user_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_card.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_text_field.dart';

class MetricsScreen extends ConsumerStatefulWidget {
  const MetricsScreen({super.key});

  @override
  ConsumerState<MetricsScreen> createState() => _MetricsScreenState();
}

class _MetricsScreenState extends ConsumerState<MetricsScreen> {
  String _selectedKind = 'poids';
  final TextEditingController _valueController = TextEditingController();
  bool _showHistory = false;

  static const Map<String, Map<String, String>> _meta = {
    'poids': {'label': 'Poids', 'unit': 'kg', 'placeholder': '64'},
    'tension': {'label': 'Tension', 'unit': 'mmHg', 'placeholder': '120/80'},
    'glycemie': {'label': 'Glycémie', 'unit': 'g/L', 'placeholder': '0,9'},
  };

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _addMeasure() {
    final val = _valueController.text.trim();
    if (val.isEmpty) return;

    final newMeasure = Measure(
      id: const Uuid().v4(),
      kind: _selectedKind,
      value: val,
      date: DateFormatter.formatFR(DateTime.now()),
    );

    ref.read(appUserStateNotifierProvider.notifier).addMeasure(newMeasure);
    _valueController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesure ajoutée')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appUserStateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentMeta = _meta[_selectedKind]!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Mes indicateurs',
                subtitle: 'Aujourd\'hui',
                onBack: () => context.pop(),
              ),
              // 3 boutons indicateurs
              Row(
                children: _meta.keys.map((k) {
                  final m = _meta[k]!;
                  final isSelected = _selectedKind == k;
                  final matching = user.measures.where((x) => x.kind == k);
                  final lastVal = matching.isNotEmpty ? matching.first.value : null;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedKind = k),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppColors.darkPrimary.withValues(alpha: 0.2) : AppColors.secondary)
                                : (isDark ? AppColors.darkCard : AppColors.card),
                            borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
                            border: Border.all(
                              color: isSelected
                                  ? (isDark ? AppColors.darkPrimary : AppColors.primary)
                                  : (isDark ? AppColors.darkBorder : AppColors.border),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                m['label']!,
                                style: AppTypography.bodyS.copyWith(
                                  color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lastVal ?? '—',
                                style: AppTypography.displayM.copyWith(
                                  fontSize: 20,
                                  color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                                ),
                              ),
                              Text(
                                m['unit']!,
                                style: AppTypography.bodyS.copyWith(
                                  color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Formulaire d'ajout
              SbCard(
                child: Column(
                  children: [
                    SbTextField(
                      label: 'Nouvelle mesure — ${currentMeta['label']} (${currentMeta['unit']})',
                      controller: _valueController,
                      placeholder: currentMeta['placeholder'],
                      keyboardType: TextInputType.text,
                    ),
                    SbButton(
                      text: '+ Ajouter une mesure',
                      onPressed: _addMeasure,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: SbButton(
                  text: _showHistory ? 'Masquer l\'historique' : 'Voir l\'historique',
                  variant: SbButtonVariant.ghost,
                  onPressed: () => setState(() => _showHistory = !_showHistory),
                ),
              ),
              // Historique
              if (_showHistory) ...[
                const SizedBox(height: 12),
                if (user.measures.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Aucune mesure pour l\'instant',
                        style: AppTypography.bodyM.copyWith(
                          color: isDark ? AppColors.darkMutedForeground : AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  )
                else
                  ...user.measures.map((m) {
                    final meta = _meta[m.kind] ?? {'label': m.kind, 'unit': ''};
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SbCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${meta['label']} · ${m.date}',
                              style: AppTypography.bodyM.copyWith(
                                color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                              ),
                            ),
                            Text(
                              '${m.value} ${meta['unit']}',
                              style: AppTypography.labelM.copyWith(
                                color: isDark ? AppColors.darkPrimary : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
