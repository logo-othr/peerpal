import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_selection/cubit/activity_selection_cubit.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_circle_list_icon.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

class ActivitySelectionContent extends StatelessWidget {
  final bool isInFlowContext;
  bool invitation = false;

  ActivitySelectionContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchFieldController = TextEditingController();
    searchFieldController.text = "Derzeit noch deaktiviert";
    return BlocBuilder<ActivitySelectionCubit, ActivitySelectionState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar(
          "Aktivität planen",
          hasBackButton: true,
          onBackButtonPressed: () {
            if (isInFlowContext) {
              context.flow<Activity>().complete();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          top: BorderSide(width: 1, color: secondaryColor),
                          bottom: BorderSide(width: 1, color: secondaryColor))),
                  child: CustomCupertinoSearchBar(
                    searchBarController: searchFieldController,
                    enabled: false,
                  )),
              Expanded(
                child: (state is ActivitiesLoaded)
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Wrap(
                                      runSpacing: 8,
                                      spacing: 10,
                                      alignment: WrapAlignment.start,
                                      children:
                                          state.activities.map((activity) {
                                        return GestureDetector(
                                            onTap: () async {
                                              var cubit = context.read<
                                                  ActivitySelectionCubit>();
                                              if (isInFlowContext) {
                                                var updatedActivity = (await cubit
                                                        .getCurrentActivity())
                                                    .copyWith(
                                                        code: activity.code,
                                                        name: activity.name);
                                                await cubit.postData(
                                                    updatedActivity); // ToDo: Update data in shared prefs
                                                context.flow<Activity>().update(
                                                    (s) => s.copyWith(
                                                        code: activity.code,
                                                        name: activity.name));
                                              } else {
                                                var currentActivity =
                                                    await cubit
                                                        .getCurrentActivity();
                                                var updatedActivity =
                                                    currentActivity.copyWith(
                                                        code: activity.code,
                                                        name: activity.name);
                                                await cubit
                                                    .postData(updatedActivity);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: CustomCircleListItem(
                                                label: activity.name.toString(),
                                                icon: ActivityIconData
                                                    .icons[activity.code],
                                                active: false));
                                      }).toList()),
                                )),
                          ],
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
