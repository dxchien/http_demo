import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http_demo/utils/constant.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatefulWidget {
  final String path;
  final Function()? action;
  final String? actionLabel;

  const PhotoScreen({
    Key? key,
    required this.path,
    this.action,
    this.actionLabel,
  }) : super(key: key);

  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (widget.path.startsWith("http")) {
      imageProvider = CachedNetworkImageProvider(widget.path);
    } else if (widget.path.startsWith("/uploads/")) {
      imageProvider = CachedNetworkImageProvider(baseUrl + widget.path);
    } else {
      imageProvider = FileImage(File(widget.path));
    }

    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            Positioned(
              child: PhotoView(
                backgroundDecoration: BoxDecoration(
                  color: Colors.black,
                ),
                imageProvider: imageProvider,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(
                    Icons.close_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (widget.actionLabel != null) ...[
              Positioned(
                top: 8,
                right: 8,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(widget.actionLabel ?? ""),
                  onPressed: widget.action,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
