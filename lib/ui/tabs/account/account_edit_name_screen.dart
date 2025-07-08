import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_bloc.dart';
import 'package:flutter_finances/ui/blocs/account/account_event.dart';
import 'package:flutter_finances/ui/blocs/account/account_state.dart';

class AccountEditNameScreen extends StatefulWidget {
  const AccountEditNameScreen({super.key});

  @override
  State<AccountEditNameScreen> createState() => _AccountEditNameScreenState();
}

class _AccountEditNameScreenState extends State<AccountEditNameScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<AccountBloc>().state;
    String? currentName;

    if (state case AccountBlocLoaded(:final account)) {
      currentName = account.name;
    }

    _controller = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AccountBloc>().add(
        ChangeAccountName(_controller.text.trim()),
      );
      Navigator.of(context).pop(); // возвращаемся назад
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать название'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Название счета',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Введите название';
              }
              return null;
            },
            autofocus: true,
          ),
        ),
      ),
    );
  }
}
