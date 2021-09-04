import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hopaut/config/injection.dart';
import 'package:hopaut/config/routes/application.dart';
import 'package:hopaut/data/models/user.dart';
import 'package:hopaut/data/repositories/user_repository.dart';
import 'package:hopaut/presentation/widgets/ui/simple_app_bar.dart';
import 'package:hopaut/services/authentication_service.dart';

class EditAccountDescription extends StatefulWidget {
  @override
  _EditAccountDescriptionState createState() => _EditAccountDescriptionState();
}

class _EditAccountDescriptionState extends State<EditAccountDescription> {
  TextEditingController _descriptionController;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    _descriptionController.text =
        GetIt.I.get<AuthenticationService>().user.description ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        context: context,
        text: 'Description',
        actionButtons: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () async => updateDescription(
                  _descriptionController.text.trim(), context))
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
              child: Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 192.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _descriptionController,
                onChanged: (v) {},
                maxLengthEnforced: true,
                maxLength: 250,
                maxLines: 4,
                inputFormatters: [LengthLimitingTextInputFormatter(250)],
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.all(12.0),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateDescription(
      String newDescription, BuildContext context) async {
    bool descriptionHasChanged =
        getIt<AuthenticationService>().user.description != newDescription;

    if (!descriptionHasChanged) {
      Application.router.pop(context);
    } else {
      final User tempUser = User(
          firstName: getIt<AuthenticationService>().user.firstName,
          lastName: getIt<AuthenticationService>().user.lastName,
          description: newDescription);
      var response = await getIt<UserRepository>().update(
          getIt<AuthenticationService>().currentIdentity.userId, tempUser);

      if (response is User) {
        getIt<AuthenticationService>().setUser(response);
        Application.router.pop(context);
      } else {}
    }
  }
}
