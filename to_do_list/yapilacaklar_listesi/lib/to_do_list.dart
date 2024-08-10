import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key});

  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  final TextEditingController _taskController = TextEditingController();
  List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    _user = _auth.currentUser;
    if (_user != null) {
      _getTasks();
    }
  }

  void _getTasks() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('to_do_lists').doc(_user!.uid).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _tasks = List.from(data['tasks'] ?? []);
      });
    }
  }

  void _addTask() async {
    if (_user != null) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
      await _firestore
          .collection('to_do_lists')
          .doc(_user!.uid)
          .set({'tasks': _tasks});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Enter task',
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
