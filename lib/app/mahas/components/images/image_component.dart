import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageComponent extends StatefulWidget {
  final String? svgUrl;
  final String? networkUrl;
  final String? localUrl;
  final double height;
  final double width;
  final String errorImage;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool zoomable;
  final BoxFit boxFit;
  final String ? imageFromFile;
  const ImageComponent(
      {super.key,
      this.localUrl,
      this.networkUrl,
      this.svgUrl,
      this.height = 250,
      this.width = 250,
      this.imageFromFile,
      this.boxFit = BoxFit.none,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.all(0),
      this.errorImage = "assets/images/error_image.png",
      this.zoomable = false});

  @override
  State<ImageComponent> createState() => _ImageComponentState();
}

class _ImageComponentState extends State<ImageComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: widget.networkUrl != null
          ? widget.zoomable
              ? InteractiveViewer(
                  panEnabled: false,
                  maxScale: 2.5,
                  child: Image(
                    image: AssetImage(widget.networkUrl!),
                    height: widget.height,
                    width: widget.width,
                    errorBuilder: (context, _, __) {
                      return Image(
                        image: AssetImage(widget.errorImage),
                        width: widget.width,
                        height: widget.height,
                      );
                    },
                  ),
                )
              : Image(
                  image: AssetImage(widget.networkUrl!),
                  height: widget.height,
                  width: widget.width,
                  errorBuilder: (context, _, __) {
                    return Image(
                      image: AssetImage(widget.errorImage),
                      width: widget.width,
                      height: widget.height,
                    );
                  },
                )
          : widget.svgUrl != null
              ? widget.zoomable
                  ? InteractiveViewer(
                      panEnabled: false,
                      maxScale: 2.5,
                      child: SvgPicture.asset(
                        widget.svgUrl!,
                        width: widget.width,
                      ),
                    )
                  : SvgPicture.asset(
                      widget.svgUrl!,
                      width: widget.width,
                      fit: widget.boxFit,
                    )
          : widget.imageFromFile != null 
              ? Image.file(File(widget.imageFromFile!), width: widget.width, height: widget.height,)
              : widget.zoomable
                  ? InteractiveViewer(
                      panEnabled: false,
                      maxScale: 2.5,
                      child: Image(
                        image: AssetImage(widget.localUrl!),
                        height: widget.height,
                        width: widget.width,
                        errorBuilder: (context, _, __) {
                          return Image(
                            image: AssetImage(widget.errorImage),
                            width: widget.width,
                            height: widget.height,
                          );
                        },
                      ),
                    )
                  : Image(
                      image: AssetImage(widget.localUrl!),
                      height: widget.height,
                      width: widget.width,
                      errorBuilder: (context, _, __) {
                        return Image(
                          image: AssetImage(widget.errorImage),
                          width: widget.width,
                          height: widget.height,
                        );
                      },
                    ),
    );
  }
}
