import 'package:coursera_app/local_storage.dart';
import 'package:coursera_app/notifications_page.dart';
import 'package:flutter/material.dart';

import 'detail_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> toDoTasks = [
    'Task 1',
    'Task 2',
  ];

  List<String> doneTasks = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Hello User"),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(
            Icons.menu,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.person,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configure'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal Info'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.graphic_eq),
              title: Text('Reports'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LocalStorage.saveUserProfile({
            "name": "user",
            "username": "testUsername",
            "age": 25,
            "country": "United States",
            "selectedHabitsMap": {
              "habit1": true,
              "habit2": false,
            },
            "completedHabitsMap": {},
          });
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "To do",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.check_box_outline_blank)
              ],
            ),
            Flexible(
              child: ListView.builder(
                itemCount: toDoTasks.length,
                itemBuilder: (context, index) => Dismissible(
                  key: Key(toDoTasks[index]), // Chave única para cada item
                  direction: DismissDirection.startToEnd, // Apenas swipe da esquerda para direita
                  onDismissed: (direction) {
                    setState(() {
                      String task = toDoTasks[index];
                      doneTasks.add(task);
                      toDoTasks.removeAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$task marked as done')),
                      );
                    });
                  },
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(
                            task: toDoTasks[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text("${toDoTasks[index]} -${index + 1}"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.check_box)
              ],
            ),
            if (doneTasks.isEmpty) Text("Swipe a task to mark as done"),
            Flexible(
              child: ListView.builder(
                itemCount: doneTasks.length,
                itemBuilder: (context, index) => Card.filled(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(doneTasks[index]),
                        Icon(Icons.check_circle),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
