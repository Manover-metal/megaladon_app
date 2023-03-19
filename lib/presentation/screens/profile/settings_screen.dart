import 'package:flutter/material.dart';
import 'package:megaladon/presentation/widgets/buttons/outlined_button.dart';
import 'package:megaladon/presentation/widgets/navigate/header.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List <String> items = <String>['Ru', 'Kz', 'Eng'];

  String dropdownvalue = 'Ru';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const HeaderAppBar(
                  isMenu: true,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Push-уведомления'),
                    SwitchExample(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Язык'),
                    DropdownButton<String>(
                      value: dropdownvalue,
                      items: items.map((String listLang) {
                        return DropdownMenuItem(
                          value: listLang,
                          child: Text(listLang),
                        );
                      }).toList(),
                       onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),

                  ],
                ),
                OutlinedButtonApp(
                  text: 'ЧАВО',
                  onPressed: () {},
                ),
                OutlinedButtonApp(
                  text: 'О приложении',
                  onPressed: () {},
                ),
                OutlinedButtonApp(
                  text: 'Сменить номер телефона',
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 50,
                ),
                OutlinedButtonApp(
                  text: 'Сканировать QR код',
                  onPressed: () {},
                ),
                Text(
                  'Сканируйте QR код для\nавторизации в Web-версии приложения ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
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
