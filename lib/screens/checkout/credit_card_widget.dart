import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/card_back.dart';
import 'package:loja_virtual/screens/checkout/card_front.dart';

class CreditCardWidget extends StatelessWidget {

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16,16,16,8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            front: CardFront(),
            back: CardBack(),
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            flipOnTouch: false,
          ),
          FlatButton(
            child: Text('反対面'),
            textColor: Colors.white,
            padding: EdgeInsets.zero,
            onPressed: (){
              cardKey.currentState.toggleCard();/*回転実行*/
            },
          ),
        ],
      ),
    );
  }
}
