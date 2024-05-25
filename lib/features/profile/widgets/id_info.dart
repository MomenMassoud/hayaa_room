import 'package:flutter/material.dart';

class IdInfoo extends StatelessWidget {
  String id;
  String seen;
  IdInfoo(this.seen, this.id);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: const Icon(
            Icons.copy,
            color: Colors.white,
            size: 20,
          ),
        ),
        Text(
          id,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 15,
          width: 2,
          color: Colors.grey,
        ),
        const SizedBox(width: 2),
        const Text(
          "Country Name",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 15,
          width: 2,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 2,
        ),
        const Text(
          "Fans : 200",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 15,
          width: 2,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          seen,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
