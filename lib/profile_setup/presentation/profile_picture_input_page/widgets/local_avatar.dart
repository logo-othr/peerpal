import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peerpal/profile_setup/presentation/profile_picture_input_page/widgets/custom_circle_avatar.dart';

Widget LocalAvatar(String path) {
  return CustomCircleAvatar(image: FileImage(File(path)));
}
