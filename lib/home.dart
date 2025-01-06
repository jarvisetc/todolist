import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    try {
      var docs = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      setState(() {
        user = docs.data();
      });
    } on FirebaseException catch (e) {
      print(e);
      getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const CircleAvatar(
                        radius: 55,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${user?['name']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("${user?['email']}"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Logt",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text("Completed Task"),
                  ),
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text("Pending Task"),
                  ),
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text("Ongoing Task"),
                  ),
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const CreateTaskWidget());
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 130,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.add_box_sharp,
                  color: Colors.white,
                ),
                Text(
                  "Add Task",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        // );
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection("tasks")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple,
                  ),
                );
              } else if (snapshot.hasData) {
                var tasks = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index].data();
                      return Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.purple,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${task['Title']}",
                                      style: const TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "${task['Description']}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("Are You Sure"),
                                              content: Text(
                                                  "by pressing the delete button, the task will be delete and you will not be able to recover it. Are you sure you want to delete?"),
                                              actionsOverflowButtonSpacing: 10,
                                              actions: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors.purple,
                                                        )),
                                                    child: Center(
                                                        child: Text("Cancel")),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection("users")
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid)
                                                        .collection("tasks")
                                                        .doc(task["id"])
                                                        .delete();
                                                  },
                                                  child: Container(
                                                    height: 45,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.red,
                                                        border: Border.all(
                                                          color: Colors.red,
                                                        )),
                                                    child: Center(
                                                        child: Text("Delete")),
                                                  ),
                                                )
                                              ],
                                            ));
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Column(
                    children: [
                      Icon(Icons.no_accounts),
                      Text("No Task Found"),
                    ],
                  ),
                );
              }
            }));
  }
}

class CreateTaskWidget extends StatefulWidget {
  const CreateTaskWidget({
    super.key,
  });

  @override
  State<CreateTaskWidget> createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final titleEditingController = TextEditingController();
  final description = TextEditingController();
  final commentEditingController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  bool isLoading = false;
  DateTime? pickedDate;
  File? image;
  String status = "Pending";
  String Priority = "Low";
  final validationKey = GlobalKey<FormState>();
  List ListOfStatus = ["Pending", "Ongoing", "Completed"];
  List ListOfPriority = ["Low", "Medium", "High"];

  List<Map> todoList = [
    {
      "id": "",
      "title": "",
      "description": "",
      "status": "",
      "priority": "",
      "dueDate": "",
      "createdAt": "",
      "updatedAt": "",
      "completedAt": "",
      "progress": "",
      "comments": "",
      "attachments": "",
    }
  ];

  void pickingOfImage(ImageSource imageSource) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: imageSource);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    } else {
      print("The Operation is Closed By The User");
    }
  }

  Future<void> saveTaskToDb() async {
    try {
      if (validationKey.currentState!.validate()) {
        String taskId = Uuid().v4();
        setState(() {
          isLoading = true;
        });
        print(isLoading);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("tasks")
            .doc(taskId)
            .set({
          "id": taskId,
          "title": titleEditingController.text,
          "description": description.text,
          "status": status,
          "priority": Priority,
          "dueDate": pickedDate!.toIso8601String(),
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
          "completedAt": null,
          "progress": 0,
          "comments": commentEditingController.text,
          "attachments": ""
        });
      }
    } on FirebaseException catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.85,
        width: double.infinity,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create New Task",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.purple,
                              ),
                            ),
                            Text(
                              "Efficiently manage their time and responsibilities.",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Form(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Title",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Title is Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        hintText: "Enter your Task Title"),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextFormField(
                                    maxLines: 2,
                                    minLines: 2,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Description is Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        hintText:
                                            "Enter your Task Description"),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        const Text(
                                          "Status",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        DropdownButtonFormField(
                                            items: ListOfStatus.map(
                                                (staus) => DropdownMenuItem(
                                                      value: staus,
                                                      child: Text(staus),
                                                    )).toList(),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                hintText: "Select Status"),
                                            onChanged: (value) {
                                              setState(() {
                                                status = value as String;
                                              });
                                            })
                                      ])),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        const Text(
                                          "Priority",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        DropdownButtonFormField(
                                            items: ListOfPriority.map(
                                                (Priority) => DropdownMenuItem(
                                                      value: Priority,
                                                      child: Text(Priority),
                                                    )).toList(),
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                hintText: "Select Priority"),
                                            onChanged: (value) {
                                              setState(() {
                                                Priority = value as String;
                                              });
                                            })
                                      ]))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Due Date",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (pickedDate == null) {
                                        return "Kindly pick your Due Date";
                                      }
                                      if (value == null ||
                                          dateTimeController.text.isEmpty) {
                                        return "Date is Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: dateTimeController,
                                    readOnly: true,
                                    onTap: () async {
                                      pickedDate = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 730)));

                                      setState(() {
                                        dateTimeController.text =
                                            pickedDate == null
                                                ? " "
                                                : DateFormat("EEE, M/d/y")
                                                    .format(pickedDate!);
                                        pickedDate?.toIso8601String() ?? "";
                                      });
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        hintText: "Pick the Task Due Date"),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Note",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextFormField(
                                    maxLines: 5,
                                    minLines: 4,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        hintText: "Enter your Task Note"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple,
                            ),
                            image: image != null
                                ? DecorationImage(
                                    image: FileImage(image!), fit: BoxFit.cover)
                                : null),
                        child: image != null
                            ? Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            actionsOverflowButtonSpacing: 10,
                                            title: const Text("Pick Image"),
                                            actions: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  pickingOfImage(
                                                      ImageSource.gallery);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color:
                                                              Colors.purple)),
                                                  child: const Center(
                                                    child: Text("Gallery"),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  pickingOfImage(
                                                      ImageSource.camera);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.purple,
                                                      border: Border.all(
                                                          color:
                                                              Colors.purple)),
                                                  child: const Center(
                                                    child: Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.red,
                                                      border: Border.all(
                                                          color: Colors.red)),
                                                  child: const Center(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ));
                                },
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.purple[50],
                                        border:
                                            Border.all(color: Colors.purple)),
                                    child: const Text("Pick Image"),
                                  ),
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: saveTaskToDb,
                        child: Container(
                          height: 48,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Center(
                            child: Text("Create Task"),
                          ),
                        ),
                      )
                    ]),
              ));
  }
}
