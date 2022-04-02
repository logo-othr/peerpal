import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_location/cubit/activity_location_cubit.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/custom_peerpal_text.dart';
import 'package:peerpal/widgets/peerpal_complete_page_button.dart';

class LocationInputContent extends StatelessWidget {
  final bool isInFlowContext;
  TextEditingController streetController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();
  TextEditingController searchBarController = TextEditingController();

  LocationInputContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          'Standorte',
          hasBackButton: isInFlowContext,
        ),
        body: BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
            builder: (context, state) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 40,
                        ),
                        CustomPeerPALHeading1("Treffpunkt"),
                        _LocationSearchBar(
                          searchBarController: searchBarController,
                        ),
                        context
                            .read<ActivityLocationCubit>()
                            .state
                            .filteredLocations
                            .isEmpty &&
                            context
                                .read<ActivityLocationCubit>()
                                .state
                                .selectedLocations
                                .isEmpty
                            ? SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                        )
                            : Container(),
                        context
                            .read<ActivityLocationCubit>()
                            .state
                            .filteredLocations
                            .isEmpty &&
                            context
                                .read<ActivityLocationCubit>()
                                .state
                                .selectedLocations
                                .isEmpty
                            ? Column(
                          children: [
                            Icon(Icons.location_on,
                                color: secondaryColor, size: 60),
                            SizedBox(height: 20),
                            CustomPeerPALHeading2(
                              "Es wurde noch kein\nOrt ausgewählt",
                              color: secondaryColor,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                            : Container(),
                        context
                            .read<ActivityLocationCubit>()
                            .state
                            .filteredLocations
                            .isEmpty ||
                            context
                                .read<ActivityLocationCubit>()
                                .state
                                .selectedLocations
                                .length >
                                0
                            ? _LocationResultBox(
                          streetController: streetController,
                          streetNumberController: streetNumberController,)
                            : const _LocationSearchBox(),
                        const Spacer(),
                        (state is ActivityLocationPosting)
                            ? const CircularProgressIndicator()
                            : CompletePageButton(
                            disabled: (state.selectedLocations.isEmpty),
                            isSaveButton: isInFlowContext,
                            onPressed: () async {
                              context.read<ActivityLocationCubit>()
                                  .updateSelectedLocation(state
                                  .selectedLocations[0].copyWith(
                                  street: streetController.text, streetNumber: streetNumberController.text));
                              _update(state, context);
                            }),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Future<void> _update(ActivityLocationInputState state,
      BuildContext context) async {
    var cubit = context.read<ActivityLocationCubit>();
    if(streetController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text(("Es muss eine Straße angegeben werden."))));
            return;
    }
    if (isInFlowContext) {
      var activity = await cubit.postActivityLocations();
      context.flow<Activity>().update((s) => activity);
    } else {
      await cubit.postActivityLocations();
      Navigator.pop(context);
    }
  }
}

class _LocationResultBox extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController streetNumberController;

  const _LocationResultBox(
      {Key? key, required this.streetController, required this.streetNumberController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
        builder: (context, state) {
          if (context
              .read<ActivityLocationCubit>()
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
                      .read<ActivityLocationCubit>()
                      .state
                      .selectedLocations
                      .length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {},
                        child: _LocationListItem(
                          streetController: streetController,
                          streetNumberController: streetNumberController,
                          location: context
                              .read<ActivityLocationCubit>()
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
        });
  }
}

class _LocationSearchBox extends StatelessWidget {
  const _LocationSearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 170, minHeight: 170),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: context
                  .read<ActivityLocationCubit>()
                  .state
                  .filteredLocations
                  .length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: _LocationSearchListItem(
                      location: context
                          .read<ActivityLocationCubit>()
                          .state
                          .filteredLocations[index],
                    ));
              },
            ),
          ),
        );
      },
    );
  }
}


class _LocationListItem extends StatefulWidget {
  final Location location;

  TextEditingController streetController;
  TextEditingController streetNumberController;

  _LocationListItem(
      {required this.location, required this.streetController, required this.streetNumberController});

  @override
  State<_LocationListItem> createState() => _LocationListItemState();
}

class _LocationListItemState extends State<_LocationListItem> {


  @override
  void initState() {
    if (widget.location.street != null && widget.location.street!.isNotEmpty)
      widget.streetController.text = widget.location.street!;
    if (widget.location.streetNumber != null &&
        widget.location.streetNumber!.isNotEmpty)
      widget.streetNumberController.text = widget.location.streetNumber!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
      builder: (context, state) {
        var cubit = context.read<ActivityLocationCubit>();
        return GestureDetector(
          onTap: () {
            context.read<ActivityLocationCubit>().removeLocation(
                widget.location);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(("${widget.location.place} entfernt."))),
              );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  child: Icon(
                    Icons.place,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: secondaryColor))),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomPeerPALText(
                              text: widget.location.place,
                              fontSize: 20,
                            ),
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                      TextField(
                          controller: widget.streetController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Straße',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.name),
                      TextField(
                          controller: widget.streetNumberController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 15),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Hausnummer',
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number),
                    ],
                  ),
                ),
              ]),
          ),
        );
      },
    );
  }
}

class _LocationSearchListItem extends StatelessWidget {
  const _LocationSearchListItem({required this.location});

  final Location location;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<ActivityLocationCubit>().addLocation(location);

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(("${location.place} hinzugefügt."))),
              );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.place,
                  color: primaryColor,
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(width: 1, color: secondaryColor))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomPeerPALHeading3(text: location.place),
                        const Icon(
                          Icons.add,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
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
    return BlocBuilder<ActivityLocationCubit, ActivityLocationInputState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: CupertinoSearchTextField(
            controller: widget.searchBarController,
            placeholder: "PLZ oder Ort eingeben",
            onChanged: (text) {
              context.read<ActivityLocationCubit>().searchQueryChanged(text);
            },
          ),
        );
      },
    );
  }
}
