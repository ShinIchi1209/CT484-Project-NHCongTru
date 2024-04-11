import 'package:ct484_project/models/todo.dart';
import 'package:ct484_project/screens/todos/EditToDoPage.dart';
import 'package:ct484_project/services/todos_service.dart';
import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDosService = ToDosService();
  List<ToDo> _toDos = [];
  final _todoController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _todoControllerE = TextEditingController();
  final _descriptionControllerE = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchToDos();
  }

  Future<void> _fetchToDos() async {
    final List<ToDo> toDos = await _toDosService.fetchToDos();
    setState(() {
      _toDos = toDos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddToDoDialog(context);
            },
          ),
        ],
      ),
      body: _buildToDoList(),
      drawer: const AppDrawer(),
    );
  }

  Widget _buildToDoList() {
    return ListView.builder(
      itemCount: _toDos.length,
      itemBuilder: (context, index) {
        final todo = _toDos[index];
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
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (newValue) {
                _toggleToDoStatus(todo, newValue ?? false);
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
              todo.todoDescription ??
                  '', // Hiển thị mô tả, nếu không có thì là chuỗi rỗng
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
        ));
      },
    );
  }

  Future<void> _toggleToDoStatus(ToDo todo, bool newValue) async {
    final updatedToDo = todo.copyWith(isDone: newValue);
    final success = await _toDosService.updateToDo(updatedToDo);
    if (success) {
      setState(() {
        todo.isDone = newValue;
      });
    } else {
      // Handle error
    }
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
                controller: _descriptionController, // Gán controller
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
                controller: _descriptionControllerE, // Gán controller
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
    final newToDoDescription = _descriptionController.text.trim();
    if (newToDoText.isNotEmpty) {
      final updatedToDo = todo.copyWith(
        todoText: newToDoText,
        todoDescription: newToDoDescription,
      );
      final success = await _toDosService.updateToDo(updatedToDo);
      if (success) {
        setState(() {
          final index = _toDos.indexWhere((element) => element.id == todo.id);
          if (index != -1) {
            _toDos[index] = updatedToDo;
          }
        });
      } else {
        // Handle error
      }
    } else {
      // Xử lý lỗi khi ToDo không hợp lệ
    }
  }

// Thêm ToDo mới
  void _addNewToDo() async {
    final newToDoText = _todoController.text.trim();
    final newToDoDescription =
        _descriptionController.text.trim(); // Lấy mô tả từ controller
    if (newToDoText.isNotEmpty) {
      final newToDo = ToDo(
        id: '', // ID sẽ được tạo tự động
        todoText: newToDoText,
        todoDescription: newToDoDescription, // Gán mô tả từ controller
      );
      final addedToDo = await _toDosService.addToDo(newToDo);
      if (addedToDo != null) {
        setState(() {
          _toDos.add(addedToDo);
        });
      } else {
        // Xử lý lỗi
      }
      _todoController.clear();
      _descriptionController
          .clear(); // Xóa nội dung trong controller mô tả sau khi thêm ToDo
    }
  }

// Xóa ToDo
  void _deleteToDoItem(String id) {
    setState(() {
      _toDos.removeWhere((todo) => todo.id == id);
    });
    if (id != null) {
      _toDosService.deleteToDo(id); // Gọi hàm xóa ToDo từ service
    }
  }

// Hủy trình điều khiển khi widget được hủy bỏ
  @override
  void dispose() {
    _descriptionController.dispose(); // Hủy trình điều khiển
    super.dispose();
  }
}
