import 'package:flutter/material.dart';
import '../widgets/show_multiple_select_widget.dart';

void showMultiSelcedBadges(
    BuildContext context, List<Map> myBdges, int selectedCounter) async {
  final List<String>? result = await showDialog(
    context: context,
    builder: (context) {
      return MultiSelectedBadgeWidget(
        myBadges: myBdges,
        selectedCounter: selectedCounter,
      );
    },
  );
}
