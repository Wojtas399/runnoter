part of 'blood_test_creator_screen.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      title: const _AppBarTitle(),
      actions: const [
        _SubmitButton(),
        SizedBox(width: 16),
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = context.select(
      (BloodTestCreatorBloc bloc) => bloc.state.bloodTest != null,
    );
    final String title = switch (isEditMode) {
      true => Str.of(context).bloodTestCreatorScreenTitleEditMode,
      false => Str.of(context).bloodTestCreatorScreenTitleAddMode,
    };
    return Text(title);
  }
}
