import 'package:flutter/material.dart';

class ToDo {
  String? id;
  String? todoText;
  String? todoDescription;
  final ValueNotifier<bool> _isDone;

  ToDo(
      {required this.id,
      required this.todoText,
      required this.todoDescription,
      isDone = false})
      : _isDone = ValueNotifier(isDone);

  set isDone(bool newValue) {
    _isDone.value = newValue;
  }

  ValueNotifier<bool> get isDoneListenable {
    return _isDone;
  }

  bool get isDone {
    return _isDone.value;
  }

  ToDo copyWith({
    String? id,
    String? todoText,
    String? todoDescription,
    bool? isDone,
  }) {
    return ToDo(
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      todoDescription: todoDescription ?? this.todoDescription,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todoText': todoText,
      'todoDescription': todoDescription,
      'isDone': isDone
    };
  }

  static ToDo fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'],
      todoText: json['todoText'],
      todoDescription: json['todoDescription'],
      isDone: json['isDone'],
    );
  }

  // static List<ToDo> todoList() {
  //   return [
  //     ToDo(id: '01', todoText: 'Morning Excercise', isDone: true),
  //     ToDo(id: '02', todoText: 'Buy Groceries', isDone: true),
  //     ToDo(
  //       id: '03',
  //       todoText: 'Check Emails',
  //     ),
  //     ToDo(
  //       id: '04',
  //       todoText: 'Team Meeting',
  //     ),
  //     ToDo(
  //       id: '05',
  //       todoText: 'Work on mobile apps for 2 hour',
  //     ),
  //     ToDo(
  //       id: '06',
  //       todoText: 'Dinner with Jenny',
  //     ),
  //   ];
  // }
}
