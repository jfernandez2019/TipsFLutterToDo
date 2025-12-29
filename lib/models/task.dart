//modelo de dominio o type en rnative para declarar el tipo de dato

import 'dart:convert';

class Task {
  //texto de la tarea
  final String title;
  //Indica si la tarea esta completada
  final bool completed;
  //Constructor de los datos que utiliza la tarea
  Task({required this.title, this.completed = false});

  //crear copia modificada pero inmutable
  //como final ya no cambia pero en realidad el estado si queremos cambiar
  //es necesario crear el copywith
  Task copyWith({String? title, bool? completed}) {
    return Task(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  //Convierte Task a Map
  //esto permitira hacer una persistencia local igual que rnative con asyncStorage
  Map<String, dynamic> toMap() {
    return {'title': title, 'completed': completed};
  }

  //convierte Map a Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(title: map['title'], completed: map['completed']);
  }

  //convierte Task a String(JSON)
  String toJson() => jsonEncode(toMap());

  //Convierte Task => String(JSON)

  factory Task.fromJson(String source) => Task.fromMap(jsonDecode(source));
}
