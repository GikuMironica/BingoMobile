import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/services/authentication_service.dart';

class EditAccountName extends StatefulWidget {
  @override
  _EditAccountNameState createState() => _EditAccountNameState();
}

class _EditAccountNameState extends State<EditAccountName> {
  TextEditingController _firstName;
  TextEditingController _lastName;

  RegExp _regExp = RegExp(
      r'^[^0-9\.\,\"\?\!\;\:\#\$\%\&\(\)\*\+\-\/\<\>\=\@\[\]\\\^\_\{\}\|\~]+$');

  bool _firstNameHasErrors;
  bool _lastNameHasErrors;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController();
    _lastName = TextEditingController();

    _firstNameHasErrors = false;
    _lastNameHasErrors = false;

    _firstName.text = getIt<AuthenticationService>().user.firstName;
    _lastName.text = getIt<AuthenticationService>().user.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        context: context,
        text: 'Name',
        actionButtons: _lastNameHasErrors || _firstNameHasErrors
            ? null
            : [
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async => updateUserName(
                        _firstName.text.trim(),
                        _lastName.text.trim(),
                        context)),
              ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Text(
                      'First Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                        visible: _firstNameHasErrors,
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                )),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 48.0,
              margin: EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: _firstNameHasErrors ? Colors.red[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _firstName,
                onChanged: (value) => checkFirstName(value),
                maxLengthEnforced: true,
                maxLength: 16,
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      'Last Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Visibility(
                        visible: _lastNameHasErrors,
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                )),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 48.0,
              margin: EdgeInsets.only(bottom: 24.0),
              decoration: BoxDecoration(
                color: _lastNameHasErrors ? Colors.red[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) => checkLastName(value),
                controller: _lastName,
                maxLengthEnforced: true,
                maxLength: 16,
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(16)],
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            Visibility(
              visible: _firstNameHasErrors,
              child: Text(
                'First Name must not be empty, or contain any symbols or numbers.',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Visibility(
              visible: _lastNameHasErrors,
              child: Text(
                'Last Name must not be empty, or contain any symbols or numbers.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  void checkFirstName(String value) {
    if (value.trim().length < 1) {
      setState(() {
        _firstNameHasErrors = true;
      });
    }
    if (!_firstNameHasErrors) {
      return;
    } else {
      if (value.trim().length > 0) {
        setState(() {
          _firstNameHasErrors = false;
        });
      }
    }
  }

  void checkLastName(String value) {
    if (value.trim().length < 1 || !_regExp.hasMatch(value)) {
      setState(() {
        _lastNameHasErrors = true;
      });
    }
    if (!_lastNameHasErrors) {
      return;
    } else {
      if (value.trim().length > 0 && _regExp.hasMatch(value)) {
        setState(() {
          _lastNameHasErrors = false;
        });
      }
    }
  }

  Future<void> updateUserName(
      String firstName, String lastName, BuildContext context) async {
    bool firstNameChanged =
        getIt<AuthenticationService>().user.firstName != firstName;
    bool lastNameChanged =
        getIt<AuthenticationService>().user.lastName != lastName;

    if (!firstNameChanged && !lastNameChanged) {
      Application.router.pop(context);
    } else {
      final User tempUser = User(
          firstName: firstName,
          lastName: lastName,
          description: getIt<AuthenticationService>().user.description);
      final String userId = getIt<AuthenticationService>().user.id;
      final User updatedUser =
          await getIt<UserRepository>().update(userId, tempUser);
      getIt<AuthenticationService>().setUser(updatedUser);
      Application.router.pop(context);
    }
  }
}
