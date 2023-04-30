import 'package:contact_crud_hive/form.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/user.dart';

class ContactListView extends StatelessWidget {
  const ContactListView({
    super.key,
    required this.users,
    this.onEditContact,
  });

  final List<UserModel> users;
  final void Function(UserModel user)? onEditContact;

  Future<void> deleteUser(UserModel user) async {
    user.delete();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/person.png")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          users[index].user_name,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          users[index].telefone,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          users[index].email,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            _showOptions(context, index, users);
          },
        );
      },
    );
  }

  void _showOptions(BuildContext context, int index, List<UserModel> users) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        _launchUrl(users[index].telefone);
                      },
                      child: Text(
                        "Ligar",
                        style: TextStyle(
                            color: Colors.deepPurple.shade700, fontSize: 20.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => FormContact(user: users[index])));
                      },
                      child: Text(
                        "Editar",
                        style: TextStyle(
                            color: Colors.deepPurple.shade700, fontSize: 20.0),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteUser(users[index]);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Deletar",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> _launchUrl(String telefone) async {
    Uri _url = Uri.parse('tel:${telefone}');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
