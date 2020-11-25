import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/generated/l10n.dart';
import 'package:lighthouse/res/colors.dart';
import 'package:lighthouse/res/gaps.dart';
import 'package:lighthouse/res/styles.dart';

class NormalTextField extends StatefulWidget {

  final String hint;
  final FocusNode focusNode;
  final Function() onTextChanged;
  final TextEditingController controller;

  NormalTextField({
    Key key,
    @required this.controller,
    this.hint,
    this.focusNode,
    this.onTextChanged,
  }) : super(key: key);

  @override
  _NormalTextFieldState createState() => _NormalTextFieldState();
}

class _NormalTextFieldState extends State<NormalTextField> {

  bool _isEmptyText() {
    return widget.controller.text == null || widget.controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 52.0,
        color: Colours.white,
        child: TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: TextStyles.textBlack14,
          keyboardType: TextInputType.text,
          maxLines: 1,
          maxLength: 12,
          decoration: InputDecoration(
            counterText: "",
            hintText: widget.hint,
            contentPadding: EdgeInsets.only(left: 16, right: 10),
            hintStyle: TextStyles.textGray400_w400_14,
            focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                borderSide:  BorderSide(color: Colours.white)
            ),
            enabledBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                borderSide:  BorderSide(color: Colours.white)
            ),
            suffixIcon: !_isEmptyText() ? IconButton(
              iconSize: 20.0,
              icon: Icon(Icons.close, color: Colours.text_black, size: 20),
              onPressed: () {
                setState(() {
                  widget.controller.text = "";
                  widget.onTextChanged();
                });
              },
            ) : Gaps.empty,
          ),
          onChanged: (text) {
            setState(() {
              widget.onTextChanged();
            });
          },
        )
    );
  }
}
