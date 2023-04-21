import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;
  final bool obscureText;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;

  const CustomTextFormField(
      {Key? key,
        this.textEditingController,
        this.keyboardType,
        this.textInputAction,
        this.validator,
        required this.label,
        required this.hintText,
        this.obscureText = false,
        this.onFieldSubmitted,
        this.enabled = true})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  FocusNode? _focusNode;
  Color _borderColor = Colors.transparent;

  late final double _borderRadius;

  @override
  void initState() {
    super.initState();
    _borderColor = Colors.transparent;
    _borderRadius = 16.r;

    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      setState(() {
        _borderColor =
        _focusNode!.hasFocus ? Colors.deepOrange : Colors.transparent;
      });
    });
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Material(
        elevation: 3.0,
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            border: Border.all(color: _borderColor, width: 2),
          ),
          child: TextFormField(
            controller: widget.textEditingController,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              label: Text(widget.label),
              hintText: widget.hintText,
            ),
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            obscureText: widget.obscureText,
            onFieldSubmitted: widget.onFieldSubmitted,
            enabled: widget.enabled,
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String hintText;
  final Color borderColor;
  final bool obscureText;

  const SearchField(
      {Key? key,
        this.textEditingController,
        this.focusNode,
        this.keyboardType,
        this.textInputAction,
        this.validator,
        required this.hintText,
        this.borderColor = Colors.transparent,
        this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        color: const Color(0xFFF0F1F5),
      ),
      child: TextFormField(
        controller: textEditingController,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 14.h),
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: const Color(0xFFC4C6CC),
          fillColor: const Color(0xFFF0F1F5),
          filled: true,
        ),
        textInputAction: textInputAction,
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}
