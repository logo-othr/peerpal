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
    return BlocBuilder<ActivitySelectionCubit,
        ActivitySelectionState>(
        builder: (context, state)
    {
      return Scaffold(
        appBar: CustomAppBar("Aktivität planen", hasBackButton: true,),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(width: 1, color: secondaryColor),
                            bottom: BorderSide(width: 1, color: secondaryColor))),
                    child: CustomCupertinoSearchBar()),
                Expanded(
                  child: (state is ActivitiesLoaded) ? Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: state.activities
                                      .map((activity) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 20, 0),
                                      child: GestureDetector(
                                          onTap: () async {
                                            if (isInFlowContext) {
                                              await context.read<ActivitySelectionCubit>().postData();
                                              context.flow<Activity>().update(
                                                      (s) => s.copyWith(code: activity.code, name: activity.name));
                                            } else {
                                              // ToDo: Implement outside flow context
                                              //await context.read<DiscoverActivitiesCubit>().postData();
                                              // Navigator.pop(context);
                                            }
                                          },
                                          child: CustomCircleListItem(
                                              label:
                                              activity.name.toString(),
                                              icon: ActivityIconData.icons[activity.code],
                                              active: false)),
                                    );
                                  })
                                      .toList())),
                        ],
                      ),
                    ),
                  ) : CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
