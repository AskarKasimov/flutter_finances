import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:flutter_finances/ui/tabs/settings/pin_code_screen.dart';
import 'package:go_router/go_router.dart';

class PinCheckScreen extends StatefulWidget {
  const PinCheckScreen({super.key});

  @override
  State<PinCheckScreen> createState() => _PinCheckScreenState();
}

class _PinCheckScreenState extends State<PinCheckScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final getPinUseCase = context.read<GetPinCodeUseCase>();

    getPinUseCase().then((pin) {
      if (pin == null || pin.isEmpty) {
        context.replace('/expenses');
      }
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return PinCodeScreen(
      mode: PinCodeMode.enter,
      getPinCodeUseCase: context.read<GetPinCodeUseCase>(),
      savePinCodeUseCase: context.read<SavePinCodeUseCase>(),
    );
  }
}
