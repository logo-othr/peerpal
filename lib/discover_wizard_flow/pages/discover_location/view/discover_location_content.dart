import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_location/cubit/discover_location_cubit.dart';
import 'package:peerpal/repository/models/location.dart';
import 'package:peerpal/repository/models/user_information.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_from_to_age_picker.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverLocationContent extends StatelessWidget {
  final bool isInFlowContext;
  TextEditingController searchBarController = TextEditingController();

  DiscoverLocationContent({Key? key, required this.isInFlowContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var hasBackButton = (isInFlowContext) ? false : true;

    return Scaffold(
        appBar: CustomAppBar(
          'Standorte',
          hasBackButton: hasBackButton,
        ),
        body: BlocBuilder<DiscoverLocationsCubit, DiscoverLocationState>(
            builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 40,
                  ),
                  CustomPeerPALHeading1("Ich suche Freunde in"),
                  _LocationSearchBar(searchBarController: searchBarController,),
                  const Spacer(),
                  context
                          .read<DiscoverLocationsCubit>()
                          .state
                          .filteredLocations
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
                      : const _LocationSearchBox(),
                  const Spacer(),
                  Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          CustomPeerPALButton(
                            text: "Weiter",
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        }));
  }
}

class _LocationSearchBox extends StatelessWidget {
  const _LocationSearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationsCubit, DiscoverLocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 170, minHeight: 170),

            child: ListView.builder(
              shrinkWrap: true,
              itemCount: context
                  .read<DiscoverLocationsCubit>()
                  .state
                  .filteredLocations
                  .length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: _LocationListItem(
                      location: context
                          .read<DiscoverLocationsCubit>()
                          .state
                          .filteredLocations[index],
                      isSelected: false,
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
  const _LocationListItem({required this.location, required this.isSelected});

  final Location location;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _LocationSearchBar extends StatefulWidget {
  _LocationSearchBar({Key? key, required this.searchBarController}) : super(key: key);
  final TextEditingController searchBarController;

  @override
  State<_LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<_LocationSearchBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverLocationsCubit, DiscoverLocationState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: CupertinoSearchTextField(
            controller: widget.searchBarController,
            placeholder: "PLZ oder Ort eingeben",
            onChanged: (text) {

                context.read<DiscoverLocationsCubit>().searchQueryChanged(text);
            },
          ),
        );
      },
    );
  }
}
