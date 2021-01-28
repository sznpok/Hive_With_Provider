

import 'package:firstapp/hive_database/client/hive_names.dart';
import 'package:firstapp/hive_database/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoProvider with ChangeNotifier{

  List<Todo> _list = <Todo>[];
  List<Todo> get  getList=> _list;

  addItem(Todo todo) async{
    var box = Hive.box<Todo>(HiveBoxes.todo);
    box.add(todo);
    print('added');
    notifyListeners();
  }

  getItem() async{
    final box = Hive.box<Todo>(HiveBoxes.todo);
    _list = box.values.toList();
    print('all data fetched');
    //notifyListeners();
  }

  updateItem(int index, Todo todo) async{
    final box = Hive.box<Todo>(HiveBoxes.todo);
    box.putAt(index, todo);
    print('updated');
    notifyListeners();
  }

  deleteItem(int index){
    final box = Hive.box<Todo>(HiveBoxes.todo);
    box.deleteAt(index);
    print('deleted');
    getItem();
    notifyListeners();
  }
  deleteAll(List<Todo> todo){
    final box =Hive.box<Todo>(HiveBoxes.todo);
    box.clear();
    _list.clear();
    print('delete all');
    notifyListeners();
  }

  searchItem(String todo){
    final box =Hive.box<Todo>(HiveBoxes.todo);
    var t = box.values.where((item) {
      return ( item.title.contains(todo) || item.description.contains(todo) || item.name.contains(todo));
    }).toList();
    _list.clear();
    _list.addAll(t);
    notifyListeners();
  }

  void clearText(TextEditingController todo){
        todo.clear();
      print('clear');
      getItem();
      notifyListeners();

  }
}

