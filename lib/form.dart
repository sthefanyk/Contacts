import 'package:contact_crud_hive/filder.dart';
import 'package:contact_crud_hive/home.dart';
import 'package:contact_crud_hive/model/user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormContact extends StatefulWidget {
  const FormContact({super.key, this.user});
  final UserModel? user;

  @override
  State<FormContact> createState() => _FormContactState();
}

class _FormContactState extends State<FormContact> {
  final _formKey = GlobalKey<FormState>();

  final telefoneUserControl = TextEditingController();
  final nameUserControl = TextEditingController();
  final emailUserControl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      editUser(widget.user!);
    } else {
      _clearTextControllers();
    }
  }

  @override
  void dispose() {
    telefoneUserControl.dispose();
    nameUserControl.dispose();
    emailUserControl.dispose();
    Hive.close();
    super.dispose();
  }

  void _clearTextControllers() {
    telefoneUserControl.clear();
    nameUserControl.clear();
    emailUserControl.clear();
  }

  Future<void> editUser(UserModel user) async {
    telefoneUserControl.text = user.telefone;
    nameUserControl.text = user.user_name;
    emailUserControl.text = user.email;
  }

  UserModel editedUser() {
    return UserModel()
      ..telefone = telefoneUserControl.text
      ..user_name = nameUserControl.text
      ..email = emailUserControl.text;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            //title: const Text('Novo contato'),
            title: widget.user == null
                ? const Text("Novo contato")
                : Text(widget.user!.user_name),
            backgroundColor: Colors.deepPurple.shade700,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var newUser = editedUser();
              Box<UserModel> userBox = Hive.box<UserModel>("users");
              if (_formKey.currentState!.validate()) {
                if (widget.user != null) {
                  widget.user!.user_name = newUser.user_name;
                  widget.user!.telefone = newUser.telefone;
                  widget.user!.email = newUser.email;
                  widget.user!.save();
                } else {
                  await userBox.add(newUser);
                }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            backgroundColor: Colors.deepPurple.shade700,
            child: const Icon(Icons.save),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/person.png")),
                    ),
                  ),
                ),
                Filder(
                  controller: nameUserControl,
                  iconData: Icons.person_outline,
                  textInputType: TextInputType.name,
                  hintTextName: 'Nome',
                  mask: MaskTextInputFormatter(),
                ),
                const SizedBox(height: 10),
                Filder(
                  controller: telefoneUserControl,
                  iconData: Icons.phone,
                  textInputType: TextInputType.phone,
                  hintTextName: 'Telefone',
                  mask: MaskTextInputFormatter(mask: '(##) #####-####'),
                ),
                const SizedBox(height: 10),
                Filder(
                  controller: emailUserControl,
                  iconData: Icons.email_outlined,
                  textInputType: TextInputType.emailAddress,
                  hintTextName: 'E-mail',
                  mask: MaskTextInputFormatter(),
                ), //ContactListView(users: users)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    bool edited = false;

    if (widget.user != null) {
      if (widget.user!.user_name != nameUserControl.text) {
        edited = true;
      }
    } else {
      if ("" != nameUserControl.text) {
        edited = true;
      }
    }

    print(edited);

    if (edited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alteraçãoes serão perdidas."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Sim"))
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
