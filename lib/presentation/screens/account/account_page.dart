import 'package:flutter/material.dart';
import 'package:hopaut/config/constants/theme.dart';
import 'package:hopaut/controllers/providers/account_provider.dart';
import 'package:hopaut/presentation/screens/account/account_widgets.dart';
import 'package:hopaut/presentation/widgets/profile_picture.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountProvider _accountProvider;

  @override
  void initState() {
    _accountProvider = Provider.of<AccountProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            width: _size.width,
            height: _size.height,
            decoration: HATheme.GRADIENT_DECORATION,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 96, bottom: 32),
                width: _size.width,
                height: _size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        spreadRadius: 3)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    userFullName(accountProvider: _accountProvider),
                    SizedBox(
                      height: 16,
                    ),
                    userDescription(accountProvider: _accountProvider),
                    accountInformation(accountProvider: _accountProvider),
                    Divider(
                      indent: _size.width * 0.2,
                      endIndent: _size.width * 0.2,
                    ),
                    accountMenu(context: context),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              heightFactor: 2,
              child: ProfilePicture(),
            ),
          )
        ]),
      ),
    );
  }
}
