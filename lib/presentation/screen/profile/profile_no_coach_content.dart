import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/coaching_request.dart';
import '../../../domain/additional_model/coaching_request_short.dart';
import '../../../domain/cubit/profile/coach/profile_coach_cubit.dart';
import '../../../domain/entity/person.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
import '../../formatter/person_formatter.dart';
import '../../service/dialog_service.dart';

class ProfileNoCoachContent extends StatelessWidget {
  const ProfileNoCoachContent({super.key});

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleMedium(str.profileNoCoachTitle),
        const Gap8(),
        BodyMedium(
          str.profileNoCoachMessage,
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.outline,
        ),
        const Gap16(),
        FilledButton(
          onPressed: () => _onFindCoachPressed(),
          child: Text(str.profileFindCoach),
        ),
        const Gap24(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleMedium(str.sentRequests),
          ],
        ),
        const Gap8(),
        const _SentCoachingRequests(),
        const Gap16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleMedium(str.receivedRequests),
            const GapHorizontal8(),
            const _ReceivedCoachingRequestsBadge(),
          ],
        ),
        const Gap8(),
        const _ReceivedCoachingRequests(),
      ],
    );
  }

  void _onFindCoachPressed() {
    showDialogDependingOnScreenSize(
      const PersonsSearchDialog(
        requestDirection: CoachingRequestDirection.clientToCoach,
      ),
    );
  }
}

class _SentCoachingRequests extends StatelessWidget {
  const _SentCoachingRequests();

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestShort>? requests = context.select(
      (ProfileCoachCubit cubit) => cubit.state.sentRequests,
    );

    return _RequestsList(
      requests: requests,
      requestDirection: CoachingRequestDirection.clientToCoach,
    );
  }
}

class _ReceivedCoachingRequests extends StatelessWidget {
  const _ReceivedCoachingRequests();

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestShort>? requests = context.select(
      (ProfileCoachCubit cubit) => cubit.state.receivedRequests,
    );

    return _RequestsList(
      requests: requests,
      requestDirection: CoachingRequestDirection.coachToClient,
    );
  }
}

class _ReceivedCoachingRequestsBadge extends StatelessWidget {
  const _ReceivedCoachingRequestsBadge();

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestShort>? requests = context.select(
      (ProfileCoachCubit cubit) => cubit.state.receivedRequests,
    );

    return Badge(
      isLabelVisible: requests != null && requests.isNotEmpty,
      label: Text('${requests?.length}'),
    );
  }
}

class _RequestsList extends StatelessWidget {
  final List<CoachingRequestShort>? requests;
  final CoachingRequestDirection requestDirection;

  const _RequestsList({
    required this.requests,
    required this.requestDirection,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return switch (requests) {
      null => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(),
        ),
      [] => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: BodyMedium(
            switch (requestDirection) {
              CoachingRequestDirection.clientToCoach => str.noSentRequests,
              CoachingRequestDirection.coachToClient => str.noReceivedRequests,
            },
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      [...] => Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: requests!.map(
              (request) => _CoachingRequestItem(request, requestDirection),
            ),
          ).toList(),
        ),
    };
  }
}

class _CoachingRequestItem extends StatelessWidget {
  final CoachingRequestShort request;
  final CoachingRequestDirection requestDirection;

  const _CoachingRequestItem(this.request, this.requestDirection);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(request.personToDisplay.toFullName()),
      subtitle: Text(request.personToDisplay.email),
      trailing: switch (requestDirection) {
        CoachingRequestDirection.clientToCoach => IconButton(
            onPressed: () => _onDelete(context),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        CoachingRequestDirection.coachToClient => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _onAccept(context),
                icon: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () => _onDelete(context),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
      },
    );
  }

  void _onAccept(BuildContext context) {
    context.read<ProfileCoachCubit>().acceptRequest(request.id);
  }

  Future<void> _onDelete(BuildContext context) async {
    bool isDeletionAccepted = true;
    final cubit = context.read<ProfileCoachCubit>();
    if (requestDirection == CoachingRequestDirection.clientToCoach) {
      isDeletionAccepted = await _askForRequestDeletionConfirmation(context);
    }
    if (isDeletionAccepted) {
      cubit.deleteRequest(
        requestId: request.id,
        requestDirection: requestDirection,
      );
    }
  }

  Future<bool> _askForRequestDeletionConfirmation(
    BuildContext context,
  ) async {
    final Person person = request.personToDisplay;
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final str = Str.of(context);

    return askForConfirmation(
      title: Text(str.undoRequestConfirmationDialogTitle),
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.undoRequestConfirmationDialogMessage,
              style: textStyle,
            ),
            TextSpan(
              text: person.toFullNameWithEmail(),
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      confirmButtonLabel: str.undo,
      displayConfirmationButtonAsFilled: true,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
