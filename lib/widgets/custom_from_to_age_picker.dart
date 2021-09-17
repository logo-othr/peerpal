import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/discover_wizard_flow/pages/discover_age/cubit/discover_age_cubit.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:provider/provider.dart';

class CustomFromToAgePicker extends StatefulWidget {
  CustomFromToAgePicker({Key? key, required this.fromMin, required this.fromMax, required this.toMin, required this.toMax, required this.fromController, required this.toController}) : super(key: key) {
    fromItems = [for (var i = fromMin; i <= fromMax; i++) i];
    toItems = [for (var i = toMin; i <= toMax; i++) i];
  }
  final  fromController;
  final  toController;
  final int fromMin;
  final int fromMax;
  final int toMin;
  final int toMax;
  List<int>? fromItems;
  List<int>? toItems;


  @override
  State<CustomFromToAgePicker> createState() => _CustomFromToAgePickerState();
}

class _CustomFromToAgePickerState extends State<CustomFromToAgePicker> {

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPeerPALHeading1("Ich suche von"),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                color: Colors.transparent,
                height: 120,
                width: 100,
                child: CupertinoPicker(
                  itemExtent: 30,
                  backgroundColor: Colors.transparent,
                  scrollController: widget.fromController,
                  onSelectedItemChanged: (int index) {
                    context.read<DiscoverAgeCubit>().ageChanged(widget.fromController.selectedItem, widget.toController.selectedItem);

                  },
                  children: <Widget>[
                    for (var i = widget.fromMin; i <= widget.fromMax; i++)
                      Text(i.toString())
                  ],
                ),
              ),
            ),
            CustomPeerPALHeading1("bis"),
            Center(
              child: Container(
                color: Colors.transparent,
                height: 100,
                width: 100,
                child: CupertinoPicker(
                  scrollController: widget.toController,
                  itemExtent: 30,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int index) {
                    context.read<DiscoverAgeCubit>().ageChanged(widget.fromController.selectedItem, widget.toController.selectedItem);
                  },
                  children: <Widget>[
                    for (var i = widget.toMin; i <= widget.toMax; i++)
                      Text(i.toString())
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        CustomPeerPALHeading1("Jahre"),
      ],
    );
  }
}
