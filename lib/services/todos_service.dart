import 'dart:convert';
import 'package:ct484_project/models/todo.dart';
import 'package:flutter/foundation.dart';

import '../models/auth_token.dart';
import 'firebase_service.dart';

class ToDosService extends FirebaseService {
  // ignore: use_super_parameters
  ToDosService([AuthToken? authToken]) : super(authToken);
  Future<List<ToDo>> fetchToDos() async {
    final List<ToDo> todos = [];
    try {
      String filters = 'orderBy="creatorId"&equalTo="$userId"';
      
      final todosMap = await httpFetch(
        '$databaseUrl/todos.json?auth=$token&$filters',
      ) as Map<String, dynamic>?;

      todosMap?.forEach((id, todo) {
        todos.add(ToDo.fromJson({
          'id': id,
          ...todo,
        }));
      });
      return todos;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return todos;
    }
  }

  Future<ToDo?> addToDo(ToDo todo) async {
    try {
      final newToDo = await httpFetch(
        '$databaseUrl/todos.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          todo.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      ) as Map<String, dynamic>?;
      await updateToDo(todo.copyWith(
        id: newToDo!['name'],
      ));
      return todo;

    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateToDo(ToDo todo) async {
    try {
      await httpFetch(
        '$databaseUrl/todos/${todo.id}.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(todo.toJson()),
      );
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }

  Future<bool> deleteToDo(String id) async {
    try {
      await httpFetch(
        '$databaseUrl/todos/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }

  Future<bool> saveDoneStatus(ToDo todo) async {
    try {
      await httpFetch(
        '$databaseUrl/todos/$userId/${todo.id}.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode(todo.isDone),
      );
      return true;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }
}
