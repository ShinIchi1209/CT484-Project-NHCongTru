import 'package:ct484_project/models/todo.dart';
import 'package:ct484_project/screens/todos/todos_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shared/app_drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final ToDosManager _toDosManager;
  final _todoController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _todoControllerE = TextEditingController();
  final _descriptionControllerE = TextEditingController();

  @override
  void initState() {
    super.initState();
    _toDosManager = Provider.of<ToDosManager>(context, listen: false);
    _fetchToDos();
  }

  Future<void> _fetchToDos() async {
    await _toDosManager.fetchToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 110, 138, 240),
        title: const Text('To-Do List'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SizedBox(
              height: 40,
              width: 65,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: Image.asset('assets/images/todo.png'),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _toDosManager.fetchToDos,
        child: Consumer<ToDosManager>(
          builder: (context, manager, child) {
            return _buildToDoList(manager.items);
          },
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddToDoDialog(context);
        },
        backgroundColor: const Color.fromARGB(255, 241, 138, 172),
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 5.0,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildToDoList(List<ToDo> toDos) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
      child: ListView.builder(
        itemCount: toDos.length,
        itemBuilder: (context, index) {
          final todo = toDos[index];
          return GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                onTap: () {
                  _showUpdateToDoDialog(context, todo);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                tileColor: const Color.fromARGB(255, 176, 200, 236),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (newValue) {
                    _toggleToDoStatus(todo, newValue ?? false);
                    //_toDosManager.toggleDoneStatus(todo);
                  },
                ),
                title: Text(
                  todo.todoText!,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF3A3A3A),
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  todo.todoDescription ?? '',
                  style: const TextStyle(
                    color: Color(0xFF757575),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDA4040),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    color: const Color(0xFFEEEFF5),
                    iconSize: 18,
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (todo.id != null) {
                        _deleteToDoItem(todo.id!);
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleToDoStatus(ToDo todo, bool newValue) async {
    final updatedToDo = todo.copyWith(isDone: newValue);
    await _toDosManager.updateToDo(updatedToDo);
  }

  Future<void> _showAddToDoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addNewToDo();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showUpdateToDoDialog(BuildContext context, ToDo todo) async {
    _todoControllerE.text = todo.todoText!;
    _descriptionControllerE.text = todo.todoDescription ?? '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoControllerE,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionControllerE,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateToDo(todo);
                //_toDosManager.updateToDo(todo);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateToDo(ToDo todo) async {
    final newToDoText = _todoControllerE.text.trim();
    final newToDoDescription = _descriptionControllerE.text.trim();
    if (newToDoText.isNotEmpty) {
      final updatedToDo = todo.copyWith(
        todoText: newToDoText,
        todoDescription: newToDoDescription,
      );
      await _toDosManager.updateToDo(updatedToDo);
    }
  }

  void _addNewToDo() async {
    final newToDoText = _todoController.text.trim();
    final newToDoDescription = _descriptionController.text.trim();
    if (newToDoText.isNotEmpty) {
      final newToDo = ToDo(
        todoText: newToDoText,
        todoDescription: newToDoDescription,
        isDone: false, id: '',
      );
      await _toDosManager.addToDo(newToDo);
      _todoController.clear();
      _descriptionController.clear();
    }
  }

  void _deleteToDoItem(String id) {
    _toDosManager.deleteToDo(id);
  }
}
