import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_layout.dart';
import '../../../localizations/app_localizations.dart';
import 'models/onboarding_page_data.dart';
import 'widgets/onboarding_continue_button.dart';
import 'widgets/onboarding_page_content.dart';
import 'widgets/onboarding_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  static const int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    if (_currentPageIndex == _totalPages - 1) {
      widget.onFinished();
      return;
    }

    final nextPage = _currentPageIndex + 1;
    await _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final pages = OnboardingPageData.items(localizations);
    final screenPadding = AppLayout.screenPadding(context);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: _currentPageIndex.isOdd ? AppColors.purple : AppColors.gray,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenPadding),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return OnboardingPageContent(
                        text: page.text,
                        imagePath: page.imagePath,
                      );
                    },
                  ),
                ),
                OnboardingPageIndicator(
                  totalPages: _totalPages,
                  currentPageIndex: _currentPageIndex,
                ),
                const SizedBox(height: 12),
                OnboardingContinueButton(
                  label: localizations.t('continue'),
                  onPressed: _onContinuePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
