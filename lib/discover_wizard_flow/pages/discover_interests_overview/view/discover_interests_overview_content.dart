import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_activities/view/discover_activities_page.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/view/discover_age_page.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_communication/view/discover_communication_page.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_interests_overview/cubit/discover_interests_overview_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_location/view/discover_location_page.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/repository/models/enum/communication_type.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_single_table.dart';
import 'package:peerpal/widgets/custom_single_table_with_list_items.dart';

import 'package:provider/provider.dart';

class DiscoverInterestsOverviewContent extends StatefulWidget {
  @override
  _DiscoverInterestsOverviewContentState createState() =>
      _DiscoverInterestsOverviewContentState();
}

class _DiscoverInterestsOverviewContentState extends State<DiscoverInterestsOverviewContent> {
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverInterestsOverviewCubit, DiscoverInterestsOverviewState>(
          builder: (context, state) {
            if(state is DiscoverInterestsOverviewInitial) {
              return CircularProgressIndicator();
            }
            else if(state is  DiscoverInterestsOverviewLoaded){
              var communicationTypes= state.appUserInformation.discoverCommunicationPreferences;
              List<String> communicationTypesAsString = [];
              for(CommunicationType communicationType in communicationTypes!) {
                communicationTypesAsString.add(communicationType.toUIString);
              }

              return Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomPeerPALHeading1("Suchkriterien"),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomSingleTable(
                                heading: "ALTER",
                                text: '${state.appUserInformation.discoverFromAge!}-${state.appUserInformation.discoverToAge!}',
                                isArrowIconVisible: true,
                                  onPressed: () async => {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiscoverAgePage(isInFlowContext: false, /*pastName: state.appUserInformation.name!*/)),
                                    ).then((value) => context.read<DiscoverInterestsOverviewCubit>().loadData()),
                                  }
                              ),

                              CustomSingleTableWithListItems(
                                heading: "INTERESSEN",
                                list: state.appUserInformation.discoverActivitiesCodes
                                    ?.map((e) => ActivityRepository.getActivityNameFromCode(e))
                                    .toList(),
                                isArrowIconVisible: true,
                                onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiscoverActivitiesPage(isInFlowContext: false, /*pastName: state.appUserInformation.name!*/)),
                                  ).then((value) => context.read<DiscoverInterestsOverviewCubit>().loadData()),
                                },
                              ),
                              CustomSingleTableWithListItems(
                                heading: "KOMMUNIKATIONSART",
                                list: communicationTypesAsString,
                                isArrowIconVisible: true,
                                onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiscoverCommunicationPage(isInFlowContext: false,/*pastName: state.appUserInformation.name!*/)),
                                  ).then((value) => context.read<DiscoverInterestsOverviewCubit>().loadData()),
                                },
                              ),
                              CustomSingleTableWithListItems(
                                heading: "ORT",
                                list: state.appUserInformation.discoverLocations
                                    ?.map((e) => e.place)
                                    .toList(),
                                isArrowIconVisible: true,
                                onPressed: () async => {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiscoverLocationPage(isInFlowContext: false, /*pastName: state.appUserInformation.name!*/)),
                                  ).then((value) => context.read<DiscoverInterestsOverviewCubit>().loadData()),
                                },
                              ),

                            ],
                          ),
                        ),
                      ),


                      SizedBox(height: 20),
                      Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CustomPeerPALButton(
                                text: "Fertig",
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }
            else {
              return CircularProgressIndicator();
            }
        });
  }
}