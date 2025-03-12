import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_note/todo/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TextEditingController is used to control the text field.
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_2 = TextEditingController();

  //helper is the instance of the SqfliteHelper class.
  SqfliteHelper helper = SqfliteHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo Aplikasi")),
      body: FutureBuilder(
        //helper.getTasks() returns a Future<List<Map<String, dynamic>>>.
        future: helper.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //snapshot.data is the list of tasks that we get from the database.
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                print("snapshot.data");
                print(snapshot.data);
                print(snapshot.data?.length);
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Checkbox(
                      //We use 1 for true and 0 for false.
                      value:
                          snapshot.data?[index]['status'] == 1 ? true : false,
                      onChanged: (value) async {
                        //updateTask method takes the id of the task and the status to be updated.
                        await helper.updateTask(
                          snapshot.data?[index]['id'],
                          value!,
                        );
                        //setState is used to update the UI.
                        setState(() {});
                      },
                    ),
                    title: Column(
                      children: [
                        Text(snapshot.data?[index]['title']),
                        Text(snapshot.data?[index]['description']),
                      ],
                    ),
                    // subtitle: Text(snapshot.data?[index]['date']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            //showDialog is used to show a dialog box, it takes a context and a builder.
                            showDialog(
                              context: context,
                              builder: (context) {
                                //AlertDialog is a dialog box with a title, content, and actions.
                                return AlertDialog(
                                  title: const Text('Edit Task'),
                                  content: Container(
                                    height: 100,
                                    width: 200,
                                    child: Column(
                                      children: [
                                        TextField(
                                          //autofocus is used to focus the text field when the dialog box is shown.
                                          autofocus: true,
                                          //controller is used to control the text field.
                                          controller: _controller,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter Title',
                                          ),
                                        ),
                                        TextField(
                                          //autofocus is used to focus the text field when the dialog box is shown.
                                          autofocus: true,
                                          //controller is used to control the text field.
                                          controller: _controller_2,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter Description',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        //Navigator.pop is used to close the dialog box.
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        //updateTask method takes the id of the task and the new title.
                                        await helper.updateTitle(
                                          snapshot.data?[index]['id'],
                                          titleData: _controller.text,
                                          descriptionData: _controller_2.text,
                                        );
                                        //clear is used to clear the text field.
                                        _controller.clear();
                                        //here we are checking if the widget is mounted before popping the dialog box.
                                        //because we are using context in async functions.
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                        //setState is used to update the UI.
                                        setState(() {});
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            //deleteTask method takes the id of the task to be deleted.
                            await helper.deleteTask(
                              snapshot.data?[index]['id'],
                            );
                            //setState is used to update the UI.
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Lottie.asset('assets/animations/loading.json'));
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 35),
          FloatingActionButton(
            onPressed: () async {},
            child: const Icon(Icons.delete),
          ),
          SizedBox(width: 200),
          FloatingActionButton(
            onPressed: () {
              //showDialog is used to show a dialog box, it takes a context and a builder.
              showDialog(
                context: context,
                builder: (context) {
                  //AlertDialog is a dialog box with a title, content, and actions.
                  return AlertDialog(
                    title: const Text('Add Task'),
                    content: Container(
                      height: 100,
                      width: 200,
                      child: Column(
                        children: [
                          TextField(
                            //autofocus is used to focus the text field when the dialog box is shown.
                            autofocus: true,
                            //controller is used to control the text field.
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Enter title',
                            ),
                          ),
                          TextField(
                            //autofocus is used to focus the text field when the dialog box is shown.
                            autofocus: true,
                            //controller is used to control the text field.
                            controller: _controller_2,
                            decoration: const InputDecoration(
                              hintText: 'Enter description',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          //Navigator.pop is used to close the dialog box.
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          //insertTask method takes the title of the task and the status.
                          await helper.insertTask(
                            titleData: _controller.text,
                            statusData: false,
                            descriptionData: _controller_2.text,
                          );
                          //clear is used to clear the text field.
                          _controller.clear();
                          //here we are checking if the widget is mounted before popping the dialog box.
                          //because we are using context in async functions.
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                          //setState is used to update the UI.
                          setState(() {});
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
