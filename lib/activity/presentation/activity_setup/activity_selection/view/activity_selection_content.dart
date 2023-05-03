import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/resources/activity_icon_data.dart';
import 'package:peerpal/activity/domain/models/activity.dart';
import 'package:peerpal/activity/presentation/activity_setup/activity_selection/cubit/activity_selection_cubit.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/data/resources/strings.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_circle_list_icon.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class ActivitySelectionContent extends StatelessWidget {
  final bool isInFlowContext;
  bool invitation = false;

  ActivitySelectionContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 3.4;
    final double itemWidth = size.width / 2;

    var searchFieldController = TextEditingController();
    searchFieldController.text = Strings.searchDisabled;
    return BlocBuilder<ActivitySelectionCubit, ActivitySelectionState>(
        builder: (context, state) {
      return Scaffold(
        appBar: CustomAppBar("Aktivität planen", hasBackButton: true,
            onBackButtonPressed: () {
          if (isInFlowContext) {
            context.flow<Activity>().complete();
          } else {
            Navigator.pop(context);
          }
        },
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos.links[VideoIdentifier.activity]!)),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Scrollbar(
                    trackVisibility: true,
                    child: GridView.count(
                        childAspectRatio: (itemWidth / itemHeight),
                        primary: true,
                        crossAxisCount: 3,
                        children: state.activities.map((activity) {
                          return GestureDetector(
                              onTap: () async {
                                _itemBehavior(context, activity);
                              },
                              child: CustomCircleListItem(
                                  label: activity.name.toString(),
                                  icon: ActivityIconData.icons[activity.code],
                                  active: false));
                        }).toList()),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _itemBehavior(BuildContext context, Activity activity) async {
    {
      var cubit = context.read<ActivitySelectionCubit>();
      if (isInFlowContext) {
        var updatedActivity = (await cubit.getCurrentActivity())
            .copyWith(code: activity.code, name: activity.name);
        await cubit
            .postData(updatedActivity); // ToDo: Update data in shared prefs
        context.flow<Activity>().update(
            (s) => s.copyWith(code: activity.code, name: activity.name));
      } else {
        var currentActivity = await cubit.getCurrentActivity();
        var updatedActivity =
            currentActivity.copyWith(code: activity.code, name: activity.name);
        await cubit.postData(updatedActivity);
        Navigator.pop(context);
      }
    }
  }
}
