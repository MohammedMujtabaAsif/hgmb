import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final double titleSize;

  final String subtitle;
  final double subtitleSize;

  final bool isTitle;
  const CustomCard(
      {this.title,
      this.titleSize,
      this.subtitle,
      this.subtitleSize,
      this.isTitle});

  @override
  State createState() => CustomCardState();
}

class CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Text(
          widget.title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: widget.titleSize != null
                  ? widget.titleSize
                  : widget.isTitle == true ? 20 : 18),
        ),
      ),
      subtitle: widget.subtitle == null
          ? null
          : Container(
              child: Text(
                widget.subtitle,
                style: TextStyle(
                    fontSize:
                        widget.subtitleSize == null ? 15 : widget.subtitleSize),
              ),
            ),
    );
  }
}
