import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/coach/coach_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text/title_text_components.dart';

class CoachReceivedCoachingRequests extends StatelessWidget {
  const CoachReceivedCoachingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestInfo>? receivedCoachingRequests = context.select(
      (CoachBloc bloc) => bloc.state.receivedCoachingRequests,
    );

    if (receivedCoachingRequests == null) return const LoadingInfo();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _NoCoachInfo(),
        const Gap32(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: LabelLarge(Str.of(context).coachCoachingRequests),
        ),
        const Gap8(),
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: receivedCoachingRequests.map(
                (requestInfo) => _CoachingRequestItem(requestInfo),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class _NoCoachInfo extends StatelessWidget {
  const _NoCoachInfo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleMedium(Str.of(context).coachNoCoachTitle),
          const Gap8(),
          BodyMedium(Str.of(context).coachNoCoachMessage),
        ],
      ),
    );
  }
}

class _CoachingRequestItem extends StatelessWidget {
  final CoachingRequestInfo requestInfo;

  const _CoachingRequestItem(this.requestInfo);

  @override
  Widget build(BuildContext context) {
    final Person senderInfo = requestInfo.sender;

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8),
      title: Text('${senderInfo.name} ${senderInfo.surname}'),
      subtitle: Text(senderInfo.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: () => _onAccept(context),
            child: Text(Str.of(context).accept),
          ),
          IconButton(
            onPressed: () => _onDecline(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  void _onAccept(BuildContext context) {
    context.read<CoachBloc>().add(
          CoachEventAcceptRequest(requestId: requestInfo.id),
        );
  }

  void _onDecline(BuildContext context) {
    context.read<CoachBloc>().add(
          CoachEventDeleteRequest(requestId: requestInfo.id),
        );
  }
}
