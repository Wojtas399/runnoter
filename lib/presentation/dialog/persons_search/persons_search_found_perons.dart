import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/persons_search/persons_search_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';

class PersonsSearchFoundPersons extends StatelessWidget {
  const PersonsSearchFoundPersons({super.key});

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (PersonsSearchBloc bloc) => bloc.state.status,
    );
    final List<FoundPerson>? foundUsers = context.select(
      (PersonsSearchBloc bloc) => bloc.state.foundPersons,
    );
    final str = Str.of(context);

    return blocStatus is BlocStatusLoading
        ? LoadingInfo(loadingText: str.personsSearchSearchingInfo)
        : switch (foundUsers) {
            null => Paddings24(
                child: EmptyContentInfo(title: str.personsSearchInstruction),
              ),
            [] => EmptyContentInfo(title: str.personsSearchNoResultsInfo),
            [...] => ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: foundUsers.map((FoundPerson user) => _UserItem(user)),
                ).toList(),
              ),
          };
  }
}

class _UserItem extends StatelessWidget {
  final FoundPerson foundUser;

  const _UserItem(this.foundUser);

  @override
  Widget build(BuildContext context) {
    final Person userInfo = foundUser.info;

    return ListTile(
      title: Text('${userInfo.name} ${userInfo.surname}'),
      subtitle: Text(userInfo.email),
      leading: Icon(userInfo.gender.toIconData()),
      trailing: switch (foundUser.relationshipStatus) {
        RelationshipStatus.notInvited => FilledButton(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(0)),
            onPressed: () => _inviteUser(context),
            child: const Icon(Icons.person_add),
          ),
        RelationshipStatus.pending => const Icon(Icons.access_time),
        RelationshipStatus.accepted => const Icon(Icons.check),
        RelationshipStatus.alreadyTaken => const Icon(
            Icons.do_not_disturb_on_outlined,
          ),
      },
    );
  }

  Future<void> _inviteUser(BuildContext context) async {
    final PersonsSearchBloc bloc = context.read<PersonsSearchBloc>();
    final bool confirmed = await _askForConfirmationToSendInvitation(context);
    if (confirmed) {
      bloc.add(PersonsSearchEventInvitePerson(personId: foundUser.info.id));
    }
  }

  Future<bool> _askForConfirmationToSendInvitation(
    BuildContext context,
  ) async {
    final str = Str.of(context);
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return askForConfirmation(
      title: Text(str.personsSearchSendInvitationConfirmationDialogTitle),
      displaySubmitButtonAsFilled: true,
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.personsSearchSendInvitationConfirmationDialogMessage,
              style: textStyle,
            ),
            TextSpan(
              text:
                  '${foundUser.info.name} ${foundUser.info.surname} (${foundUser.info.email})',
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '?', style: textStyle),
          ],
        ),
      ),
      confirmButtonLabel: str.submit,
    );
  }
}
