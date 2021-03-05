import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  final String title;
  final bool bold;

  /*入力されたかどうか*/
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatter;
  final FormFieldValidator<String> validator;

  CardTextField(
      {this.title,
      this.bold = false,
      this.hint,
      this.textInputType,
      this.inputFormatter,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '', /*null回避用*/
      validator: validator,
      builder: (state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  if (state.hasError)
                    Text(
                      '    無効です',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                ),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 2)),
                keyboardType: textInputType,
                inputFormatters: inputFormatter,
                onChanged: (text) {
                  state.didChange(text);/*入力保存*/
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
