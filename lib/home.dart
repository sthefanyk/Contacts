import 'package:contact_crud_hive/common/box_user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/user.dart';
import 'form.dart';
import 'listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final telefoneUserControl = TextEditingController();
  final nameUserControl = TextEditingController();
  final emailUserControl = TextEditingController();

  @override
  void dispose() {
    telefoneUserControl.dispose();
    nameUserControl.dispose();
    emailUserControl.dispose();
    Hive.close(); // fechar as boxes
    super.dispose();
  }

  Future<void> addUser(String telefone, String name, String email) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = UserModel()
        ..telefone = telefone
        ..user_name = name
        ..email = email;

      // pega a caixa aberta
      final box = UserBox.getUsers();
      box.add(user).then((value) => _clearTextControllers());
    }
  }

  Future<void> editUser(UserModel user) async {
    telefoneUserControl.text = user.telefone;
    nameUserControl.text = user.user_name;
    emailUserControl.text = user.email;
  }

  void _clearTextControllers() {
    telefoneUserControl.clear();
    nameUserControl.clear();
    emailUserControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Contatos"),
          backgroundColor: Colors.deepPurple.shade700,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => FormContact()));
          },
          backgroundColor: Colors.deepPurple.shade700,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ValueListenableBuilder(
                valueListenable: UserBox.getUsers().listenable(),
                builder: (BuildContext context, Box userBox, Widget? child) {
                  final users = userBox.values.toList().cast<UserModel>();
                  if (users.isEmpty) {
                    return Center(
                      child: const Text(
                        'No Users Found',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return ContactListView(
                      users: users,
                      onEditContact: editUser,
                    );
                  }
                },
              ),
              //ContactListView(users: users)
            ],
          ),
        ),
      ),
    );
  }
}
