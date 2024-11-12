import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class EditDataPage extends StatefulWidget {
  final Map ListData;
  const EditDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formkey = GlobalKey<FormState>();
    TextEditingController id = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  
 Future _update() async {
    final respone = await http.post(
        Uri.parse("http://192.168.0.104/flutterapi/crudflutter/update.php"),
        body: {
          "id" :id.text,
          "email" :email.text,
          "name" :name.text,
          "address": address.text,
        }
        );
        if (respone.statusCode == 200) {
          return true;
        }  return false;
 }
  @override
  Widget build(BuildContext context) {
    id.text = widget.ListData['id'];
    email.text = widget.ListData['email'];
    name.text = widget.ListData['name'];
    address.text = widget.ListData['address'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mettre à jour les données"),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                    labelText: "email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "L'adresse e-mail ne peut pas être vide";
                      }
                    },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                    labelText: "Nom",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "Le nom ne peut pas être vide.";
                      }
                      return null;
                    },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                    labelText: "Adresse",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "L'addresse ne peut pas être vide";
                      }
                      return null;
                    },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _update().then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Les données ont été mises à jour avec succès.")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Échec de la mise à jour des données.")));
                      }
                    });
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context)=>const HomePage())), (route) => false);
                }
                },child: const Text("Mettre à jour"),
              )
            ]),
          )),
    );
  }
}
