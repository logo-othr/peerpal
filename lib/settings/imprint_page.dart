import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class ImprintPage extends StatefulWidget {
  @override
  _ImprintPageState createState() => _ImprintPageState();
}

class _ImprintPageState extends State<ImprintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Impressum",
        hasBackButton: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomPeerPALHeading3(
                text: "Herausgeber",
                color: PeerPALAppColor.primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                  "Ostbayerische Technische Hochschule Regensburg (OTH), Seybothstr. 2, 93053 Regensburg"),
              SizedBox(height: 20),
              Text("und"),
              SizedBox(height: 10),
              Text(
                  "Katholische Hochschule Mainz (KH), Saarstr. 3, 55122 Mainz"),
              SizedBox(height: 10),
              Text("Förderkennzeichen:"),
              SizedBox(height: 10),
              Text("13FH515SA7 – KH Mainz"),
              Text("13FH515SB7 – OTH Regensburg"),
              SizedBox(height: 20),
              Text("Verantwortliche Personen"),
              Column(
                children: [
                  Text("Frau Prof.in Dr. Norina Lauer"),
                  Text("Tel.: +49 941 943-1087"),
                  Text("Fax: +49 941 943-1468"),
                  Text("E-Mail: norina.lauer@oth-regensburg.de "),
                  Text("Ostbayerische Technische Hochschule Regensburg (OTH)"),
                  Text("Seybothstr. 2"),
                  Text("93053 Regensburg"),
                ],
              ),
              SizedBox(height: 10),
              Text("und"),
              SizedBox(height: 10),
              Column(
                children: [
                  Text("Frau Prof.in Dr. Sabine Corsten"),
                  Text("Tel.: 06131 – 289 44 540"),
                  Text("Fax: 06131 – 289 44 8 540"),
                  Text("E-Mail: sabine.corsten@kh-mz.de "),
                  Text("Katholische Hochschule Mainz (KH)"),
                  Text("Saarstr. 3"),
                  Text("55122 Main"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
