import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class OtpField extends StatefulWidget {
  const OtpField({Key? key, this.first, this.last,required this.controller}) : super(key: key);
  final bool? first;
  final dynamic last;
  final TextEditingController controller;

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: SizeConfig.heightMultiplier * 8,
          width: SizeConfig.widthMultiplier * 17,
           decoration:BoxDecoration(
             color:widget.controller.text.isNotEmpty? kPrimaryColor:Colors.transparent,
             borderRadius: BorderRadius.circular(15)
          ),
        ),
        SizedBox(
          height: SizeConfig.heightMultiplier * 9,
          width: SizeConfig.widthMultiplier * 17,
         
         
          child: AspectRatio(
            aspectRatio: 1.0,
            child: TextField(
              controller: widget.controller,
              autofocus: true,
              onChanged: (value) {
                if (value.length == 1 && widget.last == false) {
                  FocusScope.of(context).nextFocus();
                }
                if (value.length == 0 && widget.first == false) {
                  FocusScope.of(context).previousFocus();
                }
                setState(() {
                  
                });
              },
              showCursor: false,
              readOnly: false,
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: widget.controller.text.isNotEmpty?Colors.white:Colors.black,
                fontSize: SizeConfig.textMultiplier*3.6, fontWeight: FontWeight.bold),
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counter: const Offstage(),
                enabledBorder:widget.controller.text.isEmpty? OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: Color(0xffE8E6EA)),
                    borderRadius: BorderRadius.circular(15)):InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
