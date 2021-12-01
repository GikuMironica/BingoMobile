import 'package:flutter/material.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:provider/provider.dart';

class ConfirmMobile extends StatefulWidget {
  @override
  _ConfirmMobileState createState() => _ConfirmMobileState();
}

class _ConfirmMobileState extends State<ConfirmMobile> {
  AccountProvider _accountProvider;

  @override
  Widget build(BuildContext context) {
    _accountProvider = Provider.of<AccountProvider>(context, listen: true);
    return Container(child: Text(_accountProvider.number));
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.number = null;
  }
}
