import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
 Future _simpan() async {
    final respone = await http.post(
        Uri.parse("http://localhost:8000/api/users"),
        body: {
          "email" :email.text,
          "name" : name.text,
          "adress": address.text,
        }
        );
        if (respone.statusCode == 200) {
          return true;
        }  return false;
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un utilisateur"),
      ),
      body: Form(
          key: formkey,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0),),
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email ne peut pas être vide";
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
                        return "Le nom ne peut pas être vide";
                      }
                    },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                    labelText: "address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "L'adresse ne peut pas être vide";
                      }
                    },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _simpan().then((value) {
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Les données ont été enregistrées avec succès.")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Échec de l'enregistrement.")));
                      }
                    });
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: ((context)=> HomePage())), (route) => false);
                }
                },child: const Text("Enregistrer"),
              )
            ]),
          )),
    );
  }
}
