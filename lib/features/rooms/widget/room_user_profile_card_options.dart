import 'package:flutter/material.dart';

class RooMUserProfileCardOptions extends StatelessWidget {
  const RooMUserProfileCardOptions({
    super.key,
    required this.onTap,
    required this.icon,
    required this.tilte,
    required this.iconColor,
    this.divider,
  });
  final void Function()? onTap;
  final IconData icon;
  final String tilte;
  final Color iconColor;
  final bool? divider;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: divider != null ? 0 : 18),
      child: Row(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 30,
                ),
              ),
              Text(
                tilte,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
          SizedBox(width: divider != null ? 0 : 24),
          divider == null
              ? SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    width: 20,
                    color: Colors.grey.shade300,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
