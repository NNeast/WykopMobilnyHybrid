import 'package:flutter/material.dart';
import 'package:owmflutter/owm_glyphs.dart';

class CommentsButton extends StatelessWidget {
  final num count;
  final VoidCallback onClicked;

  CommentsButton({@required this.count, this.onClicked});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
          padding: EdgeInsets.only(left: 6.0, right: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 4.0, right: 4.0, top: 1.5),
                  child: Icon(OwmGlyphs.ic_buttontoolbar_comment,
                      size: 17.0,
                      color: Theme.of(context).textTheme.caption.color)),
              Text(
                count.toInt().toString(),
                style: TextStyle(
                    fontSize: 16.5,
                    color: Theme.of(context).textTheme.caption.color),
              ),
            ],
          )),
      onTap: this.onClicked,
    );
  }
}
