import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final bool notificationExists;

  const NotificationIcon(
      {Key key, this.iconData, this.color, this.onTap, this.notificationExists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: color,
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: notificationExists
                  ? Padding(
                      padding: EdgeInsets.only(right: 8, top: 0),
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.redAccent),
                        alignment: Alignment.center,
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
