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
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;/*TextFieldにフォーカスが当たっているかどうか判定*/
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;

  CardTextField({
    this.title,
    this.bold = false,
    this.hint,
    this.textInputType,
    this.inputFormatter,
    this.validator,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.onSubmitted,
  }) : textInputAction = onSubmitted == null
      ? TextInputAction.done
      : TextInputAction.next;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      /*null回避用*/
      validator: validator,
      builder: (state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (title != null)
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
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
                  color: title == null && state.hasError/*title==nullは裏面の話*/
                      ? Colors.red
                      : Colors.white,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: title == null && state.hasError
                        ? Colors.red.withAlpha(200)
                        : Colors.white.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 2),
                  counterText: '',
                ),
                keyboardType: textInputType,
                inputFormatters: inputFormatter,
                onChanged: (text) {
                  state.didChange(text); /*入力保存*/
                },
                maxLength: maxLength,
                textAlign: textAlign,
                focusNode: focusNode,
                onFieldSubmitted: onSubmitted,
                textInputAction: textInputAction,
              ),
            ],
          ),
        );
      },
    );
  }
}
