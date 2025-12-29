//📌 Este archivo NO tiene UI
//📌 Solo lógica de datos

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskRepository {
  static const _key = 'tareas';

  //Obtiene todas las tareas
  Future<List<Task>> getTasks() async {

    final prefs = await SharedPreferences.getInstance();
    final tareasJson = prefs.getStringList(_key);

    if (tareasJson == null) return [];

    return tareasJson.map((json) => Task.fromJson(json)).toList();
  }

  //Guarda todas las tareas

  Future<void> saveTasks(List<Task> tareas) async {
    final prefs = await SharedPreferences.getInstance();
    final tareasJson = tareas.map((tareas) => tareas.toJson()).toList();

    await prefs.setStringList(_key, tareasJson);
  }
}
