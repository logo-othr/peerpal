import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/widgets/custom_circle_avatar.dart';

enum AvatarType { local, network, loading, empty }

class Avatar extends StatelessWidget {
  final AvatarType avatarType;
  final String uri;

  const Avatar({Key? key, required this.avatarType, required this.uri})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (avatarType) {
      case AvatarType.network:
        return _NetworkAvatar(uri);
      case AvatarType.local:
        return _LocalAvatar(uri);
      case AvatarType.loading:
        return _LoadingAvatar();
      case AvatarType.empty:
        return _EmptyAvatar(
            icon: Icon(
          Icons.camera_alt_outlined,
          size: 110,
          color: PeerPALAppColor.primaryColor,
        ));
    }
  }

  Widget _LocalAvatar(String path) {
    return CustomCircleAvatar(image: FileImage(File(path)));
  }

  Widget _NetworkAvatar(String imageURL) {
    if (_imageLinkExists(imageURL)) {
      return CustomCircleAvatar(image: CachedNetworkImageProvider(imageURL));
    } else {
      return _EmptyAvatar(
          icon: Icon(
        Icons.account_circle,
        size: 140,
        color: Colors.grey,
      ));
    }
  }

  bool _imageLinkExists(String? imageURL) =>
      imageURL != null && imageURL.isNotEmpty && imageURL != '';
}

class _EmptyAvatar extends StatelessWidget {
  final Icon icon;

  const _EmptyAvatar({
    Key? key,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: PeerPALAppColor.primaryColor,
            width: 4.0,
          ),
        ),
        child: Icon(
          Icons.camera_alt_outlined,
          size: 110,
          color: PeerPALAppColor.primaryColor,
        ));
  }
}

class _LoadingAvatar extends StatelessWidget {
  const _LoadingAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: PeerPALAppColor.primaryColor,
          width: 4.0,
        ),
      ),
      child: const CircularProgressIndicator(),
    );
  }
}
