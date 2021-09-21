import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_activities/cubit/discover_activitiess_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_circle_list_icon.dart';
import 'package:peerpal/widgets/custom_from_to_age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverActivitiesContent extends StatelessWidget {
  final bool isInFlowContext;

  TextEditingController searchBarController = TextEditingController();

  DiscoverActivitiesContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext) ? false : true;
    return BlocBuilder<DiscoverActivitiesCubit, DiscoverActivitiesState>(
      builder: (context, state) {
        // ignore: always_declare_return_types
        searchQueryChangedListener() => context
            .read<DiscoverActivitiesCubit>()
            .searchQueryChanged(searchBarController.value.text);

        if (state is DiscoverActivitiesLoaded ||
            state is DiscoverActivitiesSelected) {
          searchBarController.addListener(searchQueryChangedListener);
        } else {
          searchBarController.removeListener(searchQueryChangedListener);
        }
        return Scaffold(
            appBar: CustomAppBar(
              'Alter',
              hasBackButton: hasBackButton,
            ),
            body: BlocBuilder<DiscoverActivitiesCubit, DiscoverActivitiesState>(
                builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 40,
                    ),
                    CustomPeerPALHeading1("Interessen"),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      child: CupertinoSearchTextField(
                        enabled: (state is DiscoverActivitiesLoaded ||
                            state is DiscoverActivitiesSelected),
                        controller: searchBarController,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            children: state.activities
                                .map(
                                  (activity) => (activity.name
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(
                                              state.searchQuery.toLowerCase()))
                                      ? Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 20, 0),
                                          child: GestureDetector(
                                              onTap: () {
                                                if (state.selectedActivities
                                                    .contains(activity)) {
                                                  context
                                                      .read<
                                                          DiscoverActivitiesCubit>()
                                                      .removeActivity(activity);
                                                } else {
                                                  context
                                                      .read<
                                                          DiscoverActivitiesCubit>()
                                                      .addActivity(activity);
                                                }
                                              },
                                              child: CustomCircleListItem(
                                                  label:
                                                      activity.name.toString(),
                                                  icon: Icons.directions_bike,
                                                  active: state
                                                      .selectedActivities
                                                      .contains(activity))),
                                        )
                                      : Container(),
                                )
                                .toList())),
                    const Spacer(),
                    Container(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CustomPeerPALButton(text: 'Weiter'),
                          ],
                        ))
                  ],
                ),
              );
            }));
      },
    );
  }
}
