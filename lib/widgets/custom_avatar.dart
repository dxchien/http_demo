import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http_demo/utils/constant.dart';

class CustomAvatar extends StatefulWidget {
  final double size;
  final String? url;

  const CustomAvatar({
    Key? key,
    this.size = 48,
    this.url,
  }) : super(key: key);

  @override
  _CustomAvatarState createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  @override
  Widget build(BuildContext context) {
    var url = widget.url!.isEmpty ? defaultAvatar : baseUrl + widget.url!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Container(
        width: widget.size,
        height: widget.size,
        child: Image(image: CachedNetworkImageProvider(url), fit: BoxFit.cover),
      ),
    );
  }
}
