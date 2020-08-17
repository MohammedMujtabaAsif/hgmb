import 'package:flutter/material.dart';
import 'customCard.dart';

class CustomCardList extends StatefulWidget {
  final CustomCard title;
  final List<CustomCard> cards;
  final ScrollController controller;

  const CustomCardList({this.controller, this.title, this.cards});

  @override
  State createState() => CustomCardListState();
}

class CustomCardListState extends State<CustomCardList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          widget.title,
          Divider(
            thickness: 1,
          ),
          ListView.builder(
            controller: widget.controller,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.cards.length,
            itemBuilder: (BuildContext context, int index) {
              return widget.cards[index];
            },
          ),
        ],
      ),
    );
  }
}
