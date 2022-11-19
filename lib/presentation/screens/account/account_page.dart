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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Container(
              width: _size.width,
              height: _size.height,
              decoration: HATheme.GRADIENT_DECORATION,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(top: _size.height * 0.1),
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 96, bottom: 32),
                  width: _size.width,
                  height: _size.height,
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
                  child: Expanded(
                    child: Column(
                      children: [
                        userFullName(),
                        SizedBox(
                          height: 16,
                        ),
                        userDescription(),
                        accountInformation(),
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                heightFactor: 1,
                child: ProfilePicture(),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
