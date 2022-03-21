import 'package:cached_network_image/cached_network_image.dart';
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
        height: 68,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              ClipOval(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                    radius: 25, child: CachedNetworkImage(imageUrl: urlAvatar!, errorWidget: (context, object, stackTrace) {
                  return const Icon(
                    Icons.account_circle,
                    size: 40.0,
                    color: Colors.grey,
                  );
                },)),
              ),
              const SizedBox(width: 15),
              Text(
                name!,
                style: const TextStyle(
                  fontSize: 20,
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
