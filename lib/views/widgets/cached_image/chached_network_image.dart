import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChachedImage extends StatelessWidget {
  final String url;
  const ChachedImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (c, d, e) => Center(
        child: Text("Hata " + e.toString()),
      ),
      progressIndicatorBuilder: (c, url, progress) {
        return Center(
          child: CircularProgressIndicator.adaptive(
            value: progress.downloaded / progress.totalSize,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade300),
          ),
        );
      },
      imageBuilder: (c, image) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
