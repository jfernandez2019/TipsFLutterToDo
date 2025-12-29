//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_practice/pages/home.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/',builder: (context, state) => Home(),)
  ]);


