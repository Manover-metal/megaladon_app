import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/core/constants/legal_urls.dart';
import 'package:megaladon/generated/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Текст-дисклеймер под кнопкой регистрации со ссылкой на
/// пользовательское соглашение, по которой можно тапнуть.
class UserAgreementText extends StatefulWidget {
  const UserAgreementText({super.key});

  @override
  State<UserAgreementText> createState() => _UserAgreementTextState();
}

class _UserAgreementTextState extends State<UserAgreementText> {
  late final TapGestureRecognizer _agreementTap;

  @override
  void initState() {
    _agreementTap = TapGestureRecognizer()..onTap = _openAgreement;
    super.initState();
  }

  @override
  void dispose() {
    _agreementTap.dispose();
    super.dispose();
  }

  Future<void> _openAgreement() async {
    final uri = Uri.parse(userAgreementUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: l10n.by_clicking_on_the_Continue_button_you_accept),
          TextSpan(
            text: l10n.user_Agreement_Terms,
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: _agreementTap,
          ),
        ],
        style: Theme.of(context).textTheme.bodySmall,
      ),
      textAlign: TextAlign.center,
    );
  }
}
