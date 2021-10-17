import 'package:flutter/material.dart';

class DropDownWidget<T> extends StatefulWidget {
  final T value;
  final ValueChanged<T> onChanged;
  final String hintText;
  final String labelText;
  final List<T> list;
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;
  final Widget prefixIcon;

  const DropDownWidget({
    Key key,
    this.value,
    @required this.onChanged,
    this.hintText,
    this.labelText,
    @required this.list,
    @required this.validator,
    @required this.onSaved,
    this.prefixIcon,
  }) : super(key: key);

  @override
  _DropDownWidgetState<T> createState() => _DropDownWidgetState<T>();
}

class _DropDownWidgetState<T> extends State<DropDownWidget<T>> {
  FocusNode _focus = new FocusNode();
  double width;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      margin: EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: DropdownButtonFormField<T>(
        value: widget.value,
        onChanged: widget.onChanged,
        // focusNode: _focus,
        validator: widget.validator,
        onSaved: widget.onSaved,
        items: widget.list
            ?.map((T e) => DropdownMenuItem<T>(value: e, child: Text('$e')))
            ?.toList(),
        decoration: InputDecoration(
          filled: _focus.hasFocus,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF2A2A2A),
          ),
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          border: InputBorder.none,
          fillColor: Color(0xFFF5F5F5).withOpacity(0.64),
          focusColor: Color(0xFFF5F5F5).withOpacity(0.64),
        ),
      ),
    );
  }
}
