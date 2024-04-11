
import 'package:ct484_project/models/todo.dart';
import 'package:flutter/material.dart';

class EditToDoPage extends StatefulWidget {
  final ToDo todo;

  const EditToDoPage({super.key, required this.todo});

  @override
  // ignore: library_private_types_in_public_api
  _EditToDoPageState createState() => _EditToDoPageState();
}

class _EditToDoPageState extends State<EditToDoPage> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.todo.todoText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit ToDo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'ToDo',
              ),
            ),
            // Thêm các trường khác nếu cần
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateToDo();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateToDo() {
    final newToDoText = _textEditingController.text.trim();
    if (newToDoText.isNotEmpty) {
      final updatedToDo = widget.todo.copyWith(todoText: newToDoText);
      // Cập nhật ToDo và quay lại trang danh sách
      Navigator.pop(context, updatedToDo);
    } else {
      // Xử lý lỗi khi ToDo không hợp lệ
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
