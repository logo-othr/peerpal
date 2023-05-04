import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            CustomPeerPALHeading3(
              text: "Herausgeber",
              color: PeerPALAppColor.primaryColor,
            ),
            SizedBox(height: 20),
            normalText("Ostbayerische Technische Hochschule Regensburg (OTH)"),
            normalText("Seybothstr. 2"),
            normalText("93053 Regensburg"),
            SizedBox(height: 10),
            Text("und"),
            SizedBox(height: 10),
            normalText("Katholische Hochschule Mainz (KH)"),
            normalText("Saarstr. 3"),
            normalText("55122 Mainz"),
            SizedBox(height: 10),
            CustomPeerPALHeading3(
              text: "Förderkennzeichen",
              color: PeerPALAppColor.primaryColor,
            ),
            SizedBox(height: 10),
            normalText("13FH515SB7 – OTH Regensburg"),
            normalText("13FH515SA7 – KH Mainz"),
            SizedBox(height: 20),
            CustomPeerPALHeading3(
              text: "Verantwortliche Personen",
              color: PeerPALAppColor.primaryColor,
            ),
            SizedBox(height: 20),
            normalText("Frau Prof.in Dr. Norina Lauer"),
            normalText("Tel.: +49 941 943-1087"),
            normalText("Fax: +49 941 943-1468"),
            normalText("E-Mail: norina.lauer@oth-regensburg.de "),
            normalText("Ostbayerische Technische Hochschule Regensburg (OTH)"),
            normalText("Seybothstr. 2"),
            normalText("93053 Regensburg"),
            SizedBox(height: 10),
            Text("und"),
            SizedBox(height: 10),
            normalText("Frau Prof.in Dr. Sabine Corsten"),
            normalText("Tel.: 06131 – 289 44 540"),
            normalText("Fax: 06131 – 289 44 8 540"),
            normalText("E-Mail: sabine.corsten@kh-mz.de "),
            normalText("Katholische Hochschule Mainz (KH)"),
            normalText("Saarstr. 3"),
            normalText("55122 Main"),
          ],
        ),
      ),
    );
  }

  Widget normalText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13),
    );
  }
}
