import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListFilterElement extends StatefulWidget {
  final String buttonLabel;
  final List<String> options;
  final Function(String) onChanged;

  const ListFilterElement({
    Key? key,
    required this.buttonLabel,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ListFilterElement> createState() => _ListFilterElementState();
}

class _ListFilterElementState extends State<ListFilterElement> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.options[0];
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showMenu(context),
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
      ),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        constraints: BoxConstraints(
          minHeight: 40.h,
          minWidth: 100.w,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(50.0))
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              "${widget.buttonLabel}: $_selected",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(widget.buttonLabel),
        insetPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        children: widget.options.map((e) => ListTile(
            title: Text(e),
            onTap: () {
              setState(() {
                _selected = e;
              });
              widget.onChanged(e);
              Navigator.pop(context);
            },
        )).toList(),
      ),
    );
  }
}
