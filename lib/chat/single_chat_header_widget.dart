import 'package:flutter/material.dart';

class SingleChatHeader extends StatelessWidget {
  final String? name;
  final String? urlAvatar;

  const SingleChatHeader({
    required this.name,
    required this.urlAvatar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 18, backgroundImage: NetworkImage(urlAvatar!)),
              const SizedBox(width: 15),
              Text(
                name!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
