import 'package:flutter/material.dart';
import 'package:kort_jomnorng_dai_app/widget/color.dart';

import '../widget/background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const DrawerButton(
              color: Colors.white,
            )),
        drawer: buildDrawer(context),
        body: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: <Widget>[
                // Stroke text
                Text(
                  'សសសសស',
                  style: TextStyle(
                    fontFamily: 'KhmerHeader',
                    fontSize: 24,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
                // Solid text as fill
                Text(
                  'សសសសស',
                  style: TextStyle(
                    fontFamily: 'KhmerHeader',
                    fontSize: 24,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
