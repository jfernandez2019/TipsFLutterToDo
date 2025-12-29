import 'package:flutter/material.dart';
import 'package:app_practice/widgets/task_item.dart';
import 'package:app_practice/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //debo instanciar el controlador del campo de texto
  //pongo final p
  final TextEditingController _tareaController = TextEditingController();
  final List<Task> _tareas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarTareas();
  }

  //guardar en almacenamiento local
  Future<void> _guardarTareas() async {
    final pref = await SharedPreferences.getInstance();
    final tareasJson = _tareas.map((tarea) => tarea.toJson()).toList();
    await pref.setStringList('tareas', tareasJson);
  }

  //Cargar tareas al iniciar la app
  Future<void> _cargarTareas() async {
    final pref = await SharedPreferences.getInstance();
    final tareasJson = pref.getStringList('tareas');

    if (tareasJson == null) return;

    setState(() {
      _tareas.clear();
      _tareas.addAll(tareasJson.map((json) => Task.fromJson(json)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla con widget'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _tareaController,
              decoration: const InputDecoration(
                labelText: 'NuevaTarea',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            //con expanded utilizo correctamente todo el espacio en
            //pantalla

            //Como la coleccion aun esta vacia,
            //debo manejar ese escenario con lo siguiente
            child: _tareas.isEmpty
                ? const Center(child: Text('Aun no hay tareas'))
                : ListView.builder(
                    itemCount: _tareas.length,
                    /*itemBuilder: (context, index) {
                      final tarea = _tareas[index];

                      //Utilizo el widget que cree y como en el constructor
                      //agregue el valor final Title
                      //flutter ya sabe que el widget debe recibir ese valor
                      return TaskItem(
                        title: tarea.title, 
                        completed: tarea.completed, 
                        onChanged: (value){
                          setState(() {
                            _tareas[index]=tarea.copyWith(completed: value ?? false);
                          });
                        });
                    },*/
                    itemBuilder: (context, index) {
                      final tarea = _tareas[index];

                      return Dismissible(
                        key: ValueKey('${tarea.title}-$index'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 12),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final tareaEliminada = tarea;
                          final posicion = index;
                          setState(() {
                            _tareas.removeAt(index);
                          });
                          _guardarTareas();
                          //FEDBACK VISUAL
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Tarea eliminada"),
                              action: SnackBarAction(
                                label: 'DESHACER',
                                onPressed: () {
                                  setState(() {
                                    _tareas.insert(posicion, tareaEliminada);
                                  });
                                  _guardarTareas();
                                },
                              ),
                            ),
                          );
                        },
                        //el widget que se muestra
                        child: TaskItem(
                          title: tarea.title,
                          completed: tarea.completed,
                          onChanged: (value) {
                            setState(() {
                              _tareas[index] = tarea.copyWith(
                                completed: value ?? false,
                              );
                            });
                            _guardarTareas();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarTarea,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _agregarTarea() {
    final texto = _tareaController.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _tareas.add(Task(title: texto));
    });
    _guardarTareas();
    _tareaController.clear();
  }

  @override
  void dispose() {
    _tareaController.dispose();
    super.dispose();
  }
}
