import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kinopoisk/core/config/localization_service.dart';

class LocalizationProvider extends StatefulWidget {
  final Widget child;
  const LocalizationProvider({required this.child, Key? key}) : super(key: key);

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();
}

class _LocalizationProviderState extends State<LocalizationProvider> {
  final LocalizationService _service = LocalizationService();


  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _service,
      child: widget.child,
    );
  }
}
