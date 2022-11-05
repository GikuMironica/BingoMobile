import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hopaut/controllers/providers/location_provider.dart';
import 'package:location/location.dart';

class PermissionDialog extends StatefulWidget {
  final String asset;
  final String svgAsset;
  final String header;
  final String message;
  final String buttonText;
  bool isLocationPermissionGranted;
  bool isLocationEnabled;

  LocationServiceProvider _locationServiceProvider;

  PermissionDialog(
      {this.asset,
        this.svgAsset,
        this.header,
        this.message,
        this.buttonText,
        this.isLocationEnabled,
        this.isLocationPermissionGranted}){
    _locationServiceProvider = getIt<LocationServiceProvider>();
  }

  @override
  _PermissionDialogState createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.99),
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                widget.asset != null
                    ? Image.asset(
                  widget.asset,
                  height: 300,
                  width: double.infinity,
                )
                    : SvgPicture.asset(
                  widget.svgAsset,
                  height: 300,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.header,
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
                    widget.message,
                    maxLines: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: !widget.isLocationPermissionGranted,
                  child: InkWell(
                    onTap: () async {
                      var serviceEnabled = await widget._locationServiceProvider.requestLocationPermissionsAsync();

                      setState(() {
                        widget.isLocationPermissionGranted = serviceEnabled;
                      });
                      if(widget.isLocationPermissionGranted && widget.isLocationEnabled)
                        Application.router.pop(context);
                    },
                    child: Container(
                      width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: HATheme.HOPAUT_PINK,
                      ),
                      child: Center(
                        child: Text(
                          widget.buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !widget.isLocationEnabled,
                  child: InkWell(
                    onTap: () async {
                      var permissionGranted = await widget._locationServiceProvider.requestLocationEnablingAsync();

                      setState(() {
                        widget.isLocationEnabled = permissionGranted;
                      });
                      if(widget.isLocationPermissionGranted && widget.isLocationEnabled)
                        Application.router.pop(context);
                    },
                    child: Container(
                      width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: HATheme.HOPAUT_PINK,
                      ),
                      child: Center(
                        child: Text(
                          widget.buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
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
