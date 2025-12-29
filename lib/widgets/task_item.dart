//Este widget:
//No tiene estado
//Solo renderiza
//Es reutilizable
//Es testeable

import 'package:flutter/material.dart';

//Crearemos un widget reutilizable que representara una tarea
class TaskItem extends StatelessWidget {
  final String title; //Texto de la tarea
  final bool completed; //Marcar tarea como completada true
  //callback cuando cambia el estado
  final ValueChanged<bool?> onChanged;
  const TaskItem({
    super.key,
    required this.title,
    required this.completed,
    required this.onChanged,
  }); //El constructor debe llevar el titulo

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          //checkbox que refleja el estado
          Checkbox(value: completed, onChanged: onChanged),
          //Texto de la tarea
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                //si esta completada se tacha
                decoration: completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
