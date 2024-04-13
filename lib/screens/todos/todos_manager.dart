import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/todo.dart';
import '../../models/auth_token.dart';
import '../../services/todos_service.dart';
class ToDosManager with ChangeNotifier {
  List<ToDo> _items = [];

  final ToDosService _todosService;

  ToDosManager([AuthToken? authToken])
    : _todosService = ToDosService(authToken);

  set authToken(AuthToken? authToken) {
    _todosService.authToken = authToken;
  }

  Future<void> fetchToDos() async {
    _items = await _todosService.fetchToDos();
    notifyListeners();
  }

  Future<void> addToDo(ToDo todo) async {
    final newToDo = await _todosService.addToDo(todo);
    if (newToDo != null){
      _items.add(newToDo);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<ToDo> get items {
    return [..._items]; 
  }

  // ignore: non_constant_identifier_names
  List<ToDo> get DoneToDo {
    return _items.where((item) => item.isDone).toList();
  }

  ToDo? findById(String id) {
    try{
      return _items.firstWhere((item) => item.id == id);
    }catch(error){
      return null;
    }
  }

  Future<void> updateToDo(ToDo todo) async{
    final index = _items.indexWhere((item) => item.id == todo.id);
    if(index >= 0){
      if (await _todosService.updateToDo(todo)) {
        _items[index] = todo;
        notifyListeners();
      }
    }
  }

  void toggleDoneStatus(ToDo todo) async {
    final savedStatus = todo.isDone;
    todo.isDone = !savedStatus;
    if (!await _todosService.saveDoneStatus(todo)) {
      todo.isDone = savedStatus;
    }
  }

  Future<void> deleteToDo(String id) async{
    final index = _items.indexWhere((item) => item.id == id);
    ToDo? existingToDo = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _todosService.deleteToDo(id)) {
      _items.insert(index, existingToDo);
      notifyListeners();
    }
  }
}
