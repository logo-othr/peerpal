import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/profile_wizard_flow/repository/profile_wizard_repository.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';

import 'profile_wizard_flow/pages/profile_wizard_flow.dart';

void main() {
  runApp(MyApp(profileWizardRepository: ProfileWizardRepository(),));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required ProfileWizardRepository profileWizardRepository})
      : _profileWizardRepository = profileWizardRepository,
        super(key: key);

  final ProfileWizardRepository _profileWizardRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _profileWizardRepository,
      child: MaterialApp(
        title: 'PeerPAL',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'PeerPAL App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: CustomPeerPALButton(
          text: "ProfileWizardFlow",
          onPressed: () async {
            await Navigator.of(context).push(ProfileWizardFlow.route());
          },
        ),
      ),
    );
  }
}
