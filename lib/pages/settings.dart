import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:it_project/providers/auth.dart';
import 'package:it_project/widgets/all_widgets.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        leading: CustomIconButton(
          icon: Icon(Icons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              _firstnameField(),
              _lastnameField(),
              _confirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstnameField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _firstname,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Name',
            icon: new Icon(
              Icons.text_format,
              color: Colors.grey,
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget _lastnameField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _lastname,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Last Name',
            icon: new Icon(
              Icons.text_format,
              color: Colors.grey,
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget _confirmButton() {
    return Padding(
      child: RaisedButton(
        padding: EdgeInsets.all(16.0),
        child: Text('Confirm Changes'),
        onPressed: () {
          Provider.of<Auth>(context, listen: false)
              .updateUser(_lastname.text, _firstname.text, context);
          FocusScope.of(context).unfocus();
        },
      ),
      padding: EdgeInsets.all(8.0),
    );
  }

  void updateUser(
      String lastname, String firstname, BuildContext context) async {
    if (lastname != null && firstname != null) {
      await FirebaseAuth.instance.currentUser().then((result) async {
        await Firestore.instance
            .collection('users')
            .document(result.uid)
            .setData({'displayName': firstname + ' ' + lastname});
        var userUpdateInfo = new UserUpdateInfo();
        userUpdateInfo.displayName = firstname + ' ' + lastname;
        result.updateProfile(userUpdateInfo);
        result.reload();

        Navigator.pop(context);
      });
    }
  }
}
