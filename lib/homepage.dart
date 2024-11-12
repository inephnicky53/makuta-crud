import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:makuta/adddata.dart';

import 'editdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _listdata = [];

  Future _getdata() async {
    try {
      final response = await http.get(
          Uri.parse("http://192.168.0.104/flutterapi/crudflutter/conn.php"),
          headers: {"Access-Control-Allow-Origin": "*"});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _deletedata(String id) async {
    try {
      final response = await http.post(
          Uri.parse("http://192.168.0.104/flutterapi/crudflutter/delete.php"),
          body: {"email": id},
          headers: {"Access-Control-Allow-Origin": "*"});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    print(_listdata);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Acceuil"),
        ),
        body: ListView.builder(
            itemCount: _listdata.length,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => EditDataPage(
                              ListData: {
                                "id": _listdata[index]['id'],
                                "email": _listdata[index]['email'],
                                "name": _listdata[index]['name'],
                                "address": _listdata[index]['address'],
                              },
                            )),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(_listdata[index]['name']),
                    subtitle: Text(_listdata[index]['address']),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                  content: Text(
                                      "Êtes-vous sûr de vouloir supprimer les données de ${_listdata[index]['name']} ?"),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          _deletedata(_listdata[index]['email'])
                                              .then((value) {
                                            if (value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text("Les données ont été supprimées avec succès.")));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text("Échec de la suppression des données.")));
                                            }
                                          });
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      HomePage())),
                                              (route) => false);
                                        },
                                        child: Text("Oui")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Non")),
                                  ]);
                            }));
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddData()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
