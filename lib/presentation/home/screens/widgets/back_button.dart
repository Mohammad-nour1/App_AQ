import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

IconButton backButton(context) => IconButton(
  onPressed: () => GoRouter.of(context).pop(),
  icon: Icon(Icons.arrow_back),
);
