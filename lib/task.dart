import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    TextEditingController txt = TextEditingController();

    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection(email.text).snapshots();

    addData() async {
      await FirebaseFirestore.instance.collection(email.text).add({
        'tasks': txt.text,
        'date':
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      });
      txt.clear();
      Navigator.pop(context);
    }

    Future signout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
    }

    add() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              backgroundColor: Colors.white,
              children: [
                TextField(
                  decoration: InputDecoration(
                      label: Text("Add Task"),
                      hintText: "Anything",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent))),
                  autofocus: true,
                  controller: txt,
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      elevation: 8,
                      child: const Icon(Icons.add, color: Colors.black),
                      onPressed: () {
                        addData();
                      },
                    ),
                  ],
                ),
              ],
            );
          });
    }

    TextEditingController taskCont = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.purple,
        body: Stack(alignment: Alignment.center, children: <Widget>[
          SizedBox(
            width: 400,
            height: 600,
            child: Image.asset(
              "assets/image.png",
              fit: BoxFit.contain,
            ),
          ),
          const Positioned(
            child: Text(
              "Tasks",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            top: 40,
            left: 20,
          ),
          Positioned(
            child: TextButton(
                onPressed: () => signout(),
                child: Text(
                  "LogOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
            top: 30,
            right: 10,
          ),
          Positioned(
            child: FloatingActionButton(
              child: const Icon(Icons.add, size: 20, color: Colors.white),
              backgroundColor: Colors.pinkAccent,
              onPressed: () {
                add();
              },
            ),
            top: 90,
            right: 10,
          ),
          DraggableScrollableSheet(
              maxChildSize: 0.85,
              builder:
                  (BuildContext context, ScrollController scrollcontianer) {
                return Stack(clipBehavior: Clip.none, children: <Widget>[
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: const Text(
                                "Loading",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ));
                            }

                            return ListView(
                              controller: scrollcontianer,
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return ListTile(
                                  title: Text(data['tasks']),
                                  subtitle: Text(data['date']),
                                  leading: IconButton(
                                      onPressed: () {
                                        document.reference.delete();
                                      },
                                      icon: const Icon(Icons.delete)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              // title: const Text('Update'),
                                              children: [
                                                TextField(
                                                  decoration: InputDecoration(
                                                      label:
                                                          Text("Edit Existing"),
                                                      hintText: "Edit",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .pinkAccent))),
                                                  autofocus: true,
                                                  controller: taskCont,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    FloatingActionButton(
                                                        elevation: 8,
                                                        onPressed: () {
                                                          document.reference
                                                              .update({
                                                            'tasks':
                                                                taskCont.text,
                                                            'date':
                                                                '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          taskCont.clear();
                                                        },
                                                        child: const Icon(
                                                            Icons.edit)),
                                                  ],
                                                )
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }))
                ]);
              }),
        ]));
  }
}
