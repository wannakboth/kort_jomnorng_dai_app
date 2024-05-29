import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (_, index) {
          return Text('data');
        });
  }
}
