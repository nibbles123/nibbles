import 'package:flutter/material.dart';
import 'package:nibbles/constants/colors.dart';
import 'package:nibbles/utils/size_config.dart';

class SelectedOptionList extends StatefulWidget {
  SelectedOptionList({
    Key? key,
    required this.list,
    required this.isGrey,
  }) : super(key: key);

  final List list;
  final bool isGrey;
  @override
  State<SelectedOptionList> createState() => _SelectedOptionListState();
}

class _SelectedOptionListState extends State<SelectedOptionList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
              widget.list.length,
              (index) => Container(
                    height: SizeConfig.heightMultiplier * 5,
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.heightMultiplier * 3,
                      top: SizeConfig.heightMultiplier * 1,
                      left: index == 0
                          ? SizeConfig.widthMultiplier * 8
                          : SizeConfig.widthMultiplier * 3,
                    ),
                    decoration: BoxDecoration(
                        color: widget.isGrey
                            ? Colors.grey.shade300
                            : selectedTileColor,
                        boxShadow: widget.isGrey
                            ? null
                            : [
                                BoxShadow(
                                    color: selectedTileColor.withOpacity(0.6),
                                    blurRadius: 15,
                                    offset: const Offset(5, 8))
                              ],
                        borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 2,
                        left: SizeConfig.widthMultiplier * 3),
                    child: Row(children: [
                      Text(
                        widget.list[index].toUpperCase(),
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.4,
                            fontWeight: FontWeight.w500),
                      ),
                      // const Spacer(),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 5,
                      ),
                      InkWell(
                        onTap: () {
                          if (!widget.isGrey) {
                            widget.list.removeAt(index);
                            setState(() {});
                          }
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.grey.shade600,
                          size: 17,
                        ),
                      ),
                    ]),
                  ))
        ],
      ),
    );
  }
}
