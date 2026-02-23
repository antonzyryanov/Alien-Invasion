import 'package:flutter/material.dart';

import '../models/menu_action_item.dart';
import 'menu_action_button.dart';

class MenuActionsList extends StatelessWidget {
  const MenuActionsList({
    required this.items,
    required this.listGap,
    super.key,
  });

  final List<MenuActionItem> items;
  final double listGap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => SizedBox(height: listGap),
      itemBuilder: (context, index) {
        final item = items[index];
        return MenuActionButton(
          label: item.label,
          onPressed: item.onTap,
          animationIndex: index,
        );
      },
    );
  }
}
