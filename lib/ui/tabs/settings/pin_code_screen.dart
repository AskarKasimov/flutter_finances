import 'package:flutter/material.dart';
import 'package:flutter_finances/domain/usecases/get_pin_code_usecase.dart';
import 'package:flutter_finances/domain/usecases/save_pin_code_usecase.dart';
import 'package:go_router/go_router.dart';

enum PinCodeMode { set, enter }

class PinCodeScreen extends StatefulWidget {
  final PinCodeMode mode;
  final SavePinCodeUseCase savePinCodeUseCase;
  final GetPinCodeUseCase getPinCodeUseCase;

  const PinCodeScreen({
    super.key,
    required this.mode,
    required this.savePinCodeUseCase,
    required this.getPinCodeUseCase,
  });

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final _pinController = TextEditingController();
  String? _error;
  String? _savedPin;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  Future<void> _loadSavedPin() async {
    final pin = await widget.getPinCodeUseCase.call();
    setState(() {
      _savedPin = pin;
      _loading = false;
    });
  }

  void _onSubmit() async {
    final pin = _pinController.text;
    if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
      setState(() {
        _error = 'Пин-код должен быть 4 цифры';
      });
      return;
    }

    if (widget.mode == PinCodeMode.set) {
      await widget.savePinCodeUseCase.call(pin);
      Navigator.pop(context, true);
    } else {
      if (_savedPin == pin) {
        context.replace('/expenses');
      } else {
        setState(() {
          _error = 'Неверный пин-код';
        });
      }
    }
  }

  Future<void> _onDeletePin() async {
    await widget.savePinCodeUseCase.call('');
    setState(() {
      _savedPin = null;
      _error = null;
      _pinController.clear();
    });
    Navigator.pop(context, true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Пин-код удалён')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isPinSet = _savedPin != null && _savedPin!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == PinCodeMode.set
              ? 'Установить Пин-код'
              : 'Введите Пин-код',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              maxLength: 4,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Пин-код',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPinSet ? 'Пин-код установлен' : 'Пин-код не задан',
              style: TextStyle(
                color: isPinSet ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _onSubmit,
              child: Text(
                widget.mode == PinCodeMode.set ? 'Сохранить' : 'Войти',
              ),
            ),
            if (widget.mode == PinCodeMode.set && isPinSet)
              TextButton(
                onPressed: _onDeletePin,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Удалить пинкод'),
              ),
          ],
        ),
      ),
    );
  }
}
