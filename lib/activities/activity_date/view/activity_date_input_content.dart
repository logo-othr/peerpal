import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activities/activity_date/cubit/activity_date_cubit.dart';
import 'package:peerpal/repository/activity_icon_data..dart';
import 'package:peerpal/repository/models/activity.dart';
import 'package:peerpal/widgets/custom_activity_header_card.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:peerpal/widgets/custom_picker.dart';
import '../../../colors.dart';
import 'package:flow_builder/flow_builder.dart';

class DateInputContent extends StatelessWidget {
  final bool isInFlowContext;

  DateInputContent({Key? key, required this.isInFlowContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Aktivität planen",
        hasBackButton: true,
      ),
      body: BlocBuilder<DateInputCubit, DateInputState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                (state is DateInputLoaded)
                    ? CustomActivityHeaderCard(
                        activity: state.activityName,
                        icon: ActivityIconData.icons[state.activityCode]!)
                    : CircularProgressIndicator(),
                SizedBox(
                  height: 40,
                ),
                CustomPeerPALHeading1("Datum und Zeit"),
                SizedBox(height: 30),
                Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child: _DatePicker(),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                      child: _TimePicker(),
                    ),
                  ],
                ),
                Spacer(),
                CustomPeerPALButton(
                  text: "Weiter",
                  onPressed: () async  {
                    var cubit = context.read<
                        DateInputCubit>();
                    if (isInFlowContext) {
                      var activity = await cubit.postData();
                      context.flow<Activity>().update(
                              (s) => activity);
                    } else {
                      await cubit.postData();
                      Navigator.pop(context);
                    }
                  }
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DatePicker extends StatefulWidget {
  @override
  State<_DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<_DatePicker> {
  var dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(DateTime.now()).toString());

  String? datePickerText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateInputCubit, DateInputState>(
        builder: (context, state) {
      return TextFormField(
        autofocus: false,
        readOnly: true,
        showCursor: false,
        controller: dateController,
        style: TextStyle(fontSize: 22),
        maxLines: 1,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () => {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      String formattedDate =
                          DateFormat('dd.MM.yyyy').format(date);
                      dateController.text = formattedDate;
                      context
                          .read<DateInputCubit>()
                          .dataChanged(formattedDate, state.time);
                    }, currentTime: DateTime.now(), locale: LocaleType.de)
                  },
              icon: Icon(Icons.edit)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primaryColor,
                width: 3,
              )),
        ),
      );
    });
  }
}

class _TimePicker extends StatefulWidget {
  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  TextEditingController timeController = TextEditingController(
      text: '${DateFormat('kk:mm').format(DateTime.now())} Uhr');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateInputCubit, DateInputState>(
      builder: (context, state) {
        return TextFormField(
          autofocus: false,
          readOnly: true,
          showCursor: false,
          controller: timeController,
          style: TextStyle(fontSize: 22),
          maxLines: 1,
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => {
                      DatePicker.showPicker(context, showTitleActions: true,
                          onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        String formattedTime = DateFormat('HH:mm').format(date);
                        var array = formattedTime.split(":");
                        if (array[1] == "01") {
                          array[1] = "15";
                        }
                        if (array[1] == "02") {
                          array[1] = "30";
                        }
                        if (array[1] == "03") {
                          array[1] = "45";
                        }
                        formattedTime = '${array[0]}:${array[1]}';
                        context
                            .read<DateInputCubit>()
                            .dataChanged(state.date, formattedTime);
                        timeController.text = '$formattedTime Uhr';
                      },
                          pickerModel:
                              CustomPicker(currentTime: DateTime.now()),
                          locale: LocaleType.de)
                    },
                icon: Icon(Icons.edit)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 3,
                )),
          ),
        );
      },
    );
  }
}
