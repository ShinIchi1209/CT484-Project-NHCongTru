import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:myshop/ui/screens.dart';

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

  Future<void> fetchProducts() async {
    _items = await _todosService.fetchToDos();
    notifyListeners();
  }

  // Future<void> fetchUserProducts() async {
  //   _items = await _productsService.fetchProducts(
  //     filteredByUser: true,
  //   );
  //   notifyListeners();
  // }

  Future<void> addToDo(ToDo product) async {
    final newProduct = await _todosService.addToDo(product);
    if (newProduct != null){
      _items.add(newProduct);
      notifyListeners();
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<ToDo> get items {
    return [..._items]; 
  }

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

  // void addProduct (Product product){
  //   _items.add(
  //     product.copyWith(
  //       id: 'p${DateTime.now().toIso8601String()}'
  //     ),
  //   );
  //   notifyListeners();
  // }

  Future<void> updateToDo(ToDo todo) async{
    final index = _items.indexWhere((item) => item.id == todo.id);
    if(index >= 0){
      if (await _todosService.updateToDo(todo)) {
        _items[index] = todo;
        notifyListeners();
      }
    }
  }

  void toggleDoneStatus(ToDo product) async {
    final savedStatus = product.isDone;
    product.isDone = !savedStatus;
    if (!await _todosService.saveFavoriteStatus(product)) {
      product.isDone = savedStatus;
    }
  }

  Future<void> deleteToDo(String id) async{
    final index = _items.indexWhere((item) => item.id == id);
    ToDo? existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _todosService.deleteToDo(id)) {
      _items.insert(index, existingProduct);
      notifyListeners();
    }
  }
}
