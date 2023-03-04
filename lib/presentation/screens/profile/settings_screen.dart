// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../../widgets/buttons/outlined_button.dart';
import '../../widgets/navigate/header.dart';

class SettingsScreen extends StatefulWidget {
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HeaderAppBar(
                  isMenu: true,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Push-уведомления'),
                            SwitchExample(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Язык'),
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
                        SizedBox(
                          height: 50,
                        ),
                        OutlinedButtonApp(
                          text: 'Сканировать QR код',
                          onPressed: () {},
                        ),
                        Container(
                          width: 290,
                          child: Text(
                            'Сканируйте QR код для авторизации в Web-версии приложения ',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
