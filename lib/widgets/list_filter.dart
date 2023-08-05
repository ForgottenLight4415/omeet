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
              widget.buttonLabel,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        children: [
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  widget.options.length,
                  (index) => ListTile(
                    title: Text(widget.options[index]),
                    onTap: () {
                      widget.onChanged(widget.options[index]);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
