import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/data/activity_icon_data..dart';
import 'package:peerpal/discover_setup/pages/discover_activities/cubit/discover_activities_cubit.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/strings.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_circle_list_icon.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';

class DiscoverActivitiesContent extends StatelessWidget {
  final bool isInFlowContext;

  TextEditingController searchBarController = TextEditingController();

  DiscoverActivitiesContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.4;
    final double itemWidth = size.width / 2;

    var hasBackButton = (isInFlowContext) ? false : true;
    searchBarController.text = Strings.searchDisabled;
    return BlocBuilder<DiscoverActivitiesCubit, DiscoverActivitiesState>(
      builder: (context, state) {
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
              'PeerPAL',
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
                      height: 30,
                    ),
                    /*        Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: CupertinoSearchTextField(
                       // enabled: (state is DiscoverActivitiesLoaded ||
                      //      state is DiscoverActivitiesSelected),
                        enabled: false,
                        controller: searchBarController,
                      ),
                    ),*/
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: GridView.count(
                            childAspectRatio: (itemWidth / itemHeight),
                            primary: true,
                            crossAxisCount: 3,
                            children: state.activities
                                .map(
                                  (activity) => (activity.name
                                          .toString()
                                          .toLowerCase()
                                          .startsWith(
                                              state.searchQuery.toLowerCase()))
                                      ? GestureDetector(
                                          onTap: () {
                                            if (state.selectedActivities
                                                        .length >=
                                                    10 &&
                                                !state.selectedActivities
                                                    .contains(activity)) {
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(SnackBar(
                                                    content: Text(
                                                        ("Es können maximal 10 Interessen ausgewählt werden."))));
                                            } else {
                                              context
                                                  .read<
                                                      DiscoverActivitiesCubit>()
                                                  .toggleData(activity);
                                            }
                                          },
                                          child: CustomCircleListItem(
                                              label: activity.name.toString(),
                                              icon: ActivityIconData
                                                  .icons[activity.code],
                                              active: state.selectedActivities
                                                  .contains(activity)))
                                      : Container(),
                                )
                                .toList()),
                      ),
                    ),
                    /*     Expanded(
                      child: SingleChildScrollView(
                        child:    Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                      alignment: WrapAlignment.start,
                                    children: state.activities.map((activity) => (activity.name.toString().toLowerCase().startsWith(state.searchQuery.toLowerCase()))
                                          ? GestureDetector(
                                          onTap: () {
                                            context
                                                .read<
                                                DiscoverActivitiesCubit>()
                                                .toggleData(activity);
                                          },
                                          child: CustomCircleListItem(
                                              label:
                                              activity.name.toString(),
                                              icon: ActivityIconData
                                                  .icons[activity.code],
                                              active: state
                                                  .selectedActivities
                                                  .contains(activity)))
                                          : Container(),
                                    )
                                        .toList()
                                  ))),
                          ],
                        ),
                      ),
                    ),*/
                    (state is DiscoverActivitiesPosting)
                        ? const CircularProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: CompletePageButton(
                                isSaveButton: isInFlowContext,
                                onPressed: () async {
                                  _update(state, context);
                                }),
                          ),
                  ],
                ),
              );
            }));
      },
    );
  }

  Future<void> _update(
      DiscoverActivitiesState state, BuildContext context) async {
    if (isInFlowContext) {
      await context.read<DiscoverActivitiesCubit>().postData();
      context.flow<PeerPALUser>().complete((s) => s.copyWith(
          discoverActivities:
              state.selectedActivities.map((e) => e.code!).toList()));
    } else {
      await context.read<DiscoverActivitiesCubit>().postData();
      Navigator.pop(context);
    }
  }
}
