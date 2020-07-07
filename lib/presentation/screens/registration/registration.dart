import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import '../../widgets/widgets.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _obscureText = true;

  void togglePasswordVisibility(){
    setState(() => _obscureText = !_obscureText);
  }

  Widget displayPasswordInput({String label, bool enableHint = true}){
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
          suffixIcon: GestureDetector(
            onTap: () {togglePasswordVisibility(); Future<void>.delayed(const Duration(seconds: 3), () => togglePasswordVisibility());},
            child: Icon(
              _obscureText ? Icons.lock_outline : Icons.lock_open,
              color: Colors.black,
            ),
          ),
          isDense: true,
          labelText: label ??= 'Password',
          hintText: enableHint ? 'Enter your password': '',
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          border: const OutlineInputBorder()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(children: <Widget>[
                  const SizedBox(height: 50,),
                  displayLogoIcon(context),
                  const SizedBox(height: 30,),
                  makeTitle(title: 'Sign up'),
                  const SizedBox(height: 30,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Column(
                          children: <Widget>[
                            displayEmailInput(),
                            const SizedBox(height: 20,),
                            displayPasswordInput(),
                            const SizedBox(height: 20,),
                            displayPasswordInput(label: 'Confirm Password', enableHint: false),
                            const SizedBox(height: 20,),
                            Text('By registering an account you agree blah blah',
                              textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[700]),),
                            const SizedBox(height: 30,),
                            authActionButton(text: 'Sign up'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],),
                accountAlreadyPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
