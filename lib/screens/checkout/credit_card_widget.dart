import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/card_back.dart';
import 'package:loja_virtual/screens/checkout/card_front.dart';

class CreditCardWidget extends StatelessWidget {

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16,16,16,8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            front: CardFront(
              numberFocus: numberFocus,
              dateFocus: dateFocus,
              nameFocus: nameFocus,
              finished: (){/*front書き終えたら自動的に裏面へ*/
                cardKey.currentState.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              cvvFocus: cvvFocus,
            ),
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
