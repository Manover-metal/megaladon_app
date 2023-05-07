import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  _changeLocalization(Locale? newValue) {
    if(newValue != null) {
      context.setLocale(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(context.supportedLocales.map((e) => e.languageCode));
    print(context.locale.languageCode);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                 HeaderAppBar(
                  isMenu: true,
                  title: 'Settings'.tr(),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: const [
                //     Text('Push-уведомления'),
                //     SwitchExample(),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Expanded(
                        child: Text('Language'.tr())
                    ),
                    Expanded(
                      child: DropdownButton<Locale>(
                        isExpanded: true,
                        value: context.locale,
                        items: context.supportedLocales.map((Locale locale) {
                          return DropdownMenuItem(
                            value: locale,
                            child: Text(locale.languageCode.tr()),
                          );
                        }).toList(),
                        onChanged: _changeLocalization
                      ),
                    ),

                  ],
                ),
                // OutlinedButtonApp(
                //   text: 'ЧАВО',
                //   onPressed: () {},
                // ),
                OutlinedButtonApp(
                  text: 'About_the_application'.tr(),
                  onPressed: () {},
                ),
                // OutlinedButtonApp(
                //   text: 'Сменить номер телефона',
                //   onPressed: () {},
                // ),
                const SizedBox(
                  height: 50,
                ),
                // OutlinedButtonApp(
                //   text: 'Сканировать QR код',
                //   onPressed: () {},
                // ),
                // Text(
                //   'Сканируйте QR код для\nавторизации в Web-версии приложения ',
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context).textTheme.labelMedium?.copyWith(
                //     color: Theme.of(context).colorScheme.secondary
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}
