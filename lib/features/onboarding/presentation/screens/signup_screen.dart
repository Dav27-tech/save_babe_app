import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';
import '../../../../core/widgets/sb_header.dart';
import '../../../../core/widgets/sb_private_badge.dart';
import '../../../../core/widgets/sb_steps.dart';
import '../../../../core/widgets/sb_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late final TextEditingController _passwordController;
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    _nameController = TextEditingController(text: user.name);
    _contactController = TextEditingController(text: user.contact);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _contactController.text.trim().isNotEmpty &&
      _passwordController.text.length >= 6 &&
      _acceptedTerms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SbHeader(
                title: 'Créer votre compte',
                onBack: () => context.pop(),
              ),
              const SbSteps(currentStep: 1),
              SbTextField(
                label: 'Prénom',
                controller: _nameController,
                placeholder: 'Grâce',
                onChanged: (_) => setState(() {}),
              ),
              SbTextField(
                label: 'Adresse e-mail ou numéro de téléphone',
                controller: _contactController,
                placeholder: '+225 07 00 00 00',
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              SbTextField(
                label: 'Créer un mot de passe',
                controller: _passwordController,
                placeholder: '6 caractères minimum',
                obscureText: true,
                onChanged: (_) => setState(() {}),
              ),
              GestureDetector(
                onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _acceptedTerms,
                          activeColor: isDark ? AppColors.darkPrimary : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.bodyM.copyWith(
                              color: isDark ? AppColors.darkCardForeground : AppColors.cardForeground,
                            ),
                            children: const [
                              TextSpan(text: 'J\'accepte les '),
                              TextSpan(
                                text: 'conditions de confidentialité',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SbButton(
                text: 'Continuer',
                onPressed: _isValid
                    ? () {
                        ref.read(appUserStateNotifierProvider.notifier).update(
                              (s) => s.copyWith(
                                name: _nameController.text.trim(),
                                contact: _contactController.text.trim(),
                              ),
                            );
                        context.push('/onboarding/pregnancy');
                      }
                    : null,
              ),
              const SbPrivateBadge(text: 'Vos informations sont chiffrées'),
            ],
          ),
        ),
      ),
    );
  }
}
