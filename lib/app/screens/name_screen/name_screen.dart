import 'package:alien_invasion/app_design/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../app_design/app_colors.dart';
import '../../../app_design/app_dimensions.dart';
import '../../../app_design/app_layout.dart';
import '../../../localizations/app_localizations.dart';
import 'widgets/name_input_field.dart';
import 'widgets/name_submit_button.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenPadding = AppLayout.screenPadding(context);
    return Scaffold(
      body: Container(
        color: AppColors.menuBackground,
        alignment: Alignment.center,
        padding: EdgeInsets.all(screenPadding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppLayout.contentMaxWidth(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.t('enterNameTitle'),
                style: AppTextStyles.title(context),
              ),
              SizedBox(height: AppDimensions.titleToFieldGap(context)),
              NameInputField(
                controller: _controller,
                hintText: localizations.t('enterNameHint'),
              ),
              SizedBox(height: AppDimensions.fieldToButtonGap(context)),
              NameSubmitButton(
                label: localizations.t('continue'),
                onPressed: () {
                  final value = _controller.text.trim();
                  if (value.isEmpty) {
                    return;
                  }
                  widget.onSubmit(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
