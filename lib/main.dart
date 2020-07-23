import 'dart:io';

import "package:circles_app/circles_app.dart";
import "package:circles_app/util/logger.dart";
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

void main() {
  configureLogger();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(CirclesApp());
}