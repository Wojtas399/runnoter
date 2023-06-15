part of 'run_status_creator_screen.dart';

class _Comment extends StatefulWidget {
  const _Comment();

  @override
  State<StatefulWidget> createState() => _CommentState();
}

class _CommentState extends State<_Comment> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = context.read<RunStatusCreatorBloc>().state.comment ?? '';
    _controller.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldComponent(
      label: Str.of(context).runStatusCreatorComment,
      maxLength: 100,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      displayCounterText: true,
      controller: _controller,
    );
  }

  void _onChanged() {
    context.read<RunStatusCreatorBloc>().add(
          RunStatusCreatorEventCommentChanged(
            comment: _controller.text,
          ),
        );
  }
}
