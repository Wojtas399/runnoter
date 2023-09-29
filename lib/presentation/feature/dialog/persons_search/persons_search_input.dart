import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/cubit/persons_search/persons_search_cubit.dart';
import '../../../service/utils.dart';

class PersonsSearchInput extends StatefulWidget {
  const PersonsSearchInput({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PersonsSearchInput> {
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
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _onSubmitted(context),
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: () => _onSubmitted(context),
          icon: const Icon(Icons.person_search),
        ),
        hintText: 'Search...',
        suffixIcon: _showClearButton
            ? IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => _controller.clear(),
                icon: const Icon(Icons.close),
              )
            : null,
      ),
      onTapOutside: (_) => unfocusInputs(),
    );
  }

  void _manageCleanButtonVisibility() {
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
    context.read<PersonsSearchCubit>().search(_controller.text);
  }
}
