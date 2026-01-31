import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//true for dark mode, false for light mode
final themeProvider = StateProvider<bool>((ref) => false);