import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/data/location/dto/location.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/discover_feed_v2/domain/peerpal_user.dart';
import 'package:peerpal/discover_setup/pages/discover_location/cubit/discover_location_cubit.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_location_item.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class DiscoverLocationContent extends StatelessWidget {
  final bool isInFlowContext;
  TextEditingController searchBarController = TextEditingController();

  DiscoverLocationContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar('Standorte',
            hasBackButton: isInFlowContext,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo:
                    SupportVideos.links[VideoIdentifier.settings_profile]!)),
        body: BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
            builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  CustomPeerPALHeading1("Ich suche Freunde in"),
                  _LocationSearchBar(
                    searchBarController: searchBarController,
                  ),
                  context
                              .read<DiscoverLocationCubit>()
                              .state
                              .filteredLocations
                              .isEmpty &&
                          context
                              .read<DiscoverLocationCubit>()
                              .state
                              .selectedLocations
                              .isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                        )
                      : Container(),
                  context
                              .read<DiscoverLocationCubit>()
                              .state
                              .filteredLocations
                              .isEmpty &&
                          context
                              .read<DiscoverLocationCubit>()
                              .state
                              .selectedLocations
                              .isEmpty
                      ? Column(
                          children: [
                            Icon(Icons.location_on,
                                color: PeerPALAppColor.secondaryColor,
                                size: 60),
                            SizedBox(height: 20),
                            CustomPeerPALHeading2(
                              "Es wurde noch kein\nOrt ausgewählt",
                              color: PeerPALAppColor.secondaryColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Container(),
                  context
                          .read<DiscoverLocationCubit>()
                          .state
                          .filteredLocations
                          .isEmpty
                      ? _LocationResultBox()
                      : _LocationSearchBox(
                          searchBarController: searchBarController),
                  const Spacer(),
                  (state is DiscoverLocationPosting)
                      ? const CircularProgressIndicator()
                      : CompletePageButton(
                          isSaveButton: isInFlowContext,
                          onPressed: () async {
                            _update(state, context);
                          }),
                ],
              ),
            ),
          );
        }));
  }

  Future<void> _update(
      DiscoverLocationState state, BuildContext context) async {
    if (context.read<DiscoverLocationCubit>().state.selectedLocations.length <
        1) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text("Es muss mindestens ein Ort ausgewählt sein.")));
      return;
    }
    if (isInFlowContext) {
      await context.read<DiscoverLocationCubit>().postLocations();
      context.flow<PeerPALUser>().update(
          (s) => s.copyWith(discoverLocations: state.selectedLocations));
    } else {
      await context.read<DiscoverLocationCubit>().postLocations();
      Navigator.pop(context);
    }
  }
}

class _LocationResultBox extends StatelessWidget {
  const _LocationResultBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
      builder: (context, state) {
        if (context
            .read<DiscoverLocationCubit>()
            .state
            .selectedLocations
            .isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 2.5,
                  minHeight: 0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: context
                    .read<DiscoverLocationCubit>()
                    .state
                    .selectedLocations
                    .length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {},
                      child: _LocationListItem(
                        location: context
                            .read<DiscoverLocationCubit>()
                            .state
                            .selectedLocations[index],
                      ));
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _LocationSearchBox extends StatelessWidget {
  const _LocationSearchBox({Key? key, required this.searchBarController})
      : super(key: key);
  final TextEditingController searchBarController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 170, minHeight: 170),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: context
                  .read<DiscoverLocationCubit>()
                  .state
                  .filteredLocations
                  .length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: _LocationSearchListItem(
                      location: context
                          .read<DiscoverLocationCubit>()
                          .state
                          .filteredLocations[index],
                      searchBarController: searchBarController,
                    ));
              },
            ),
          ),
        );
      },
    );
  }
}

class _LocationListItem extends StatelessWidget {
  final Location location;

  _LocationListItem({required this.location});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<DiscoverLocationCubit>().removeLocation(location);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(("${location.place} entfernt."))),
              );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Row(
              children: [
                Icon(
                  Icons.place,
                  color: PeerPALAppColor.primaryColor,
                  size: 30,
                ),
                Expanded(
                  child: LocationItem(
                      iconBehavior: Icons.cancel_outlined,
                      iconColor: Colors.black,
                      iconSize: 20,
                      location: location,
                      headingFontSize: 18,
                      headingFontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LocationSearchListItem extends StatelessWidget {
  const _LocationSearchListItem(
      {required this.location, required this.searchBarController});

  final TextEditingController searchBarController;

  final Location location;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (context
                    .read<DiscoverLocationCubit>()
                    .state
                    .selectedLocations
                    .length >=
                10) {
              var text = '';
              searchBarController.clear();
              context.read<DiscoverLocationCubit>().searchQueryChanged(text);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      content: Text(
                          ("Es können nicht mehr als 10 Orte hinzugefügt werden."))),
                );
            } else {
              var text = '';
              searchBarController.clear();
              context.read<DiscoverLocationCubit>().searchQueryChanged(text);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              context.read<DiscoverLocationCubit>().addLocation(location);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(("${location.place} hinzugefügt."))),
                );
            }
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.place,
                  color: PeerPALAppColor.primaryColor,
                ),
              ),
              Expanded(
                child: LocationItem(
                  iconBehavior: Icons.add,
                  iconColor: Colors.black,
                  location: location,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationSearchBar extends StatefulWidget {
  _LocationSearchBar({Key? key, required this.searchBarController})
      : super(key: key);
  final TextEditingController searchBarController;

  @override
  State<_LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<_LocationSearchBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationCubit, DiscoverLocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: CupertinoSearchTextField(
            controller: widget.searchBarController,
            placeholder: "PLZ oder Ort eingeben",
            onChanged: (text) {
              context.read<DiscoverLocationCubit>().searchQueryChanged(text);
            },
          ),
        );
      },
    );
  }
}
