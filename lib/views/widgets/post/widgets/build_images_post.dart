import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_media_app/models/Post.dart';

class BuildImagesPost extends StatefulWidget {
  final Post post;
  BuildImagesPost({Key? key, required this.post}) : super(key: key);

  @override
  _BuildImagesPostState createState() => _BuildImagesPostState();
}

class _BuildImagesPostState extends State<BuildImagesPost> {
  PageController? _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 10 / 6,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.post.images!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          widget.post.images![index].downloadURL!,
                          errorListener: () {
                        print("resim yüklenirken hata oluştu");
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller!,
                count: widget.post.images!.length,
                effect: ScrollingDotsEffect(
                    activeDotScale: 1.3,
                    dotColor: Colors.white60,
                    radius: 5,
                    activeDotColor: Colors.white,
                    strokeWidth: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
