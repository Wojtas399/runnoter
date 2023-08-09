import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/clients_search/clients_search_bloc.dart';
import '../../component/text_field_component.dart';

class ClientsSearchInput extends StatefulWidget {
  const ClientsSearchInput({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientsSearchInput> {
  final TextEditingController _controller = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    _controller.addListener(_manageCleanButtonVisibility);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_manageCleanButtonVisibility);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _onSubmitted(context),
      icon: Icons.person_search,
      hintText: 'Search...',
      suffixIcon: _showClearButton
          ? IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.close),
            )
          : null,
    );
  }

  void _manageCleanButtonVisibility() {
    context.read<ClientsSearchBloc>().add(
          ClientsSearchEventSearchTextChanged(searchText: _controller.text),
        );
    if (_controller.text.isEmpty && _showClearButton) {
      setState(() {
        _showClearButton = false;
      });
    } else if (_controller.text.isNotEmpty && !_showClearButton) {
      setState(() {
        _showClearButton = true;
      });
    }
  }

  void _onSubmitted(BuildContext context) {
    context.read<ClientsSearchBloc>().add(
          const ClientsSearchEventSearch(),
        );
  }
}
