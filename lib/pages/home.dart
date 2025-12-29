import 'package:flutter/material.dart';
import 'package:app_practice/widgets/task_item.dart';
import 'package:app_practice/models/task.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_practice/repositories/task_repository.dart';

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
  final TaskRepository _repository = TaskRepository();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO LIST HECHO CON FLUTTER'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _tareaController,
              decoration: const InputDecoration(
                labelText: 'Nueva Tarea',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (_isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_error != null) {
                  return Center(child: Text(_error!));
                }

                if (_tareas.isEmpty) {
                  return Center(child: Text('Aun no hay tareas'));
                }
                return ListView.builder(
                  itemCount: _tareas.length,
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

                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              content: const Text("Tarea Eliminada"),
                              action: SnackBarAction(
                                label: "DESHACER",
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

  //**********************************************************
  // PROCEDIMIENTOS
  //******************************************************* */

  //guardar en almacenamiento local
  Future<void> _guardarTareas() async {
    await _repository.saveTasks(_tareas);
  }

  //Cargar tareas al iniciar la app
  Future<void> _cargarTareas() async {
    print('INICIO CARGA');
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 5));

      print('DESPUES DEL DELAY');
      final tareas = await _repository.getTasks();

      setState(() {
        _tareas
          ..clear()
          ..addAll(tareas);
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar tareas';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
