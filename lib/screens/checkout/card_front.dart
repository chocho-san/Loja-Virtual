import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/checkout/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {

  final VoidCallback finished;
  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
/**/
  CardFront({
    this.numberFocus,
    this.dateFocus,
    this.nameFocus,
    this.finished,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      /*これないと下のshape反映されない*/
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 16,
      child: Container(
        height: 200,
        color: Color(0xFF1B4B52),
        padding: EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CardTextField(
                    title: 'カード番号',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatter: [
                      MaskTextInputFormatter(
                        mask: '#### #### #### ####',
                        filter: {"#": RegExp(r'[0-9]')},
                      ),
                    ],
                    validator: (number) {
                      if (number != 19)
                        return '無効です';
                      else if (detectCCType(number) == CreditCardType.unknown)
                        return '無効です';
                      return null;
                    },
                    onSubmitted: (_){
                      dateFocus.requestFocus();/*次のfocus*/
                    },
                    focusNode: numberFocus,
                  ),
                  CardTextField(
                    title: '有効期限 MONTH/YEAR',
                    hint: '11/20',
                    textInputType: TextInputType.number,
                    inputFormatter: [
                      MaskTextInputFormatter(
                        mask: '!#/##',
                        filter: {"#": RegExp(r'[0-9]'), '!': RegExp('[0-1]')},
                      ),
                    ],
                    validator: (date) {
                      if (date.length != 5) return '無効です';
                      return null;
                    },
                    onSubmitted: (_){
                      nameFocus.requestFocus();/*次のfocus*/
                    },
                    focusNode: dateFocus,
                  ),
                  CardTextField(
                    title: '名前',
                    hint: 'BOKUNO NAMAE',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (name) {
                      if (name.isEmpty) return '無効です';
                      return null;
                    },
                    onSubmitted: (_){
                      finished();
                    },
                    focusNode: nameFocus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
