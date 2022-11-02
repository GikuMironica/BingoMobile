import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class PermissionDialog extends StatelessWidget {
  final String asset;
  final String svgAsset;
  final String header;
  final String message;
  final String buttonText;

  Location _location;

  PermissionDialog(
      {this.asset,
        this.svgAsset,
        this.header,
        this.message,
        this.buttonText}){

    _location = Location();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.80),
        body: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                asset != null
                    ? Image.asset(
                  asset,
                  height: 300,
                  width: double.infinity,
                )
                    : SvgPicture.asset(
                  svgAsset,
                  height: 300,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  header,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Text(
                    message,
                    maxLines: 5,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Application.router.pop(context);
                  },
                  child: Container(
                    width: 400,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: HATheme.HOPAUT_PINK,
                    ),
                    child: Center(
                      child: Text(
                        buttonText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ));
  }
}
