part of 'profile_screen.dart';

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<StatefulWidget> createState() {
    return _DeleteAccountDialogState();
  }
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isSaveButtonDisabled = true;

  @override
  void initState() {
    _passwordController.addListener(_updateDeleteButtonDisableStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileIdentitiesBloc, ProfileIdentitiesState>(
      listener: (BuildContext context, ProfileIdentitiesState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusComplete &&
            blocStatus.info == ProfileInfo.accountDeleted) {
          navigateBack(context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Str.of(context).profileDeleteAccountDialogTitle,
          ),
          leading: IconButton(
            onPressed: () {
              navigateBack(context: context);
            },
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: _isSaveButtonDisabled
                  ? null
                  : () {
                      _onSaveButtonPressed(context);
                    },
              child: Text(
                Str.of(context).delete,
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              unfocusInputs();
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.transparent,
              child: Column(
                children: [
                  Text(
                    Str.of(context).profileDeleteAccountDialogMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  PasswordTextFieldComponent(
                    label: Str.of(context).password,
                    controller: _passwordController,
                    isRequired: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateDeleteButtonDisableStatus() {
    setState(() {
      _isSaveButtonDisabled = _passwordController.text.isEmpty;
    });
  }

  void _onSaveButtonPressed(BuildContext context) {
    context.read<ProfileIdentitiesBloc>().add(
          ProfileIdentitiesEventDeleteAccount(
            password: _passwordController.text,
          ),
        );
  }
}
