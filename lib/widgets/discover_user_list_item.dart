import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';

class DiscoverUserListItem extends StatelessWidget {
  String? header;
  String? imageLink;
  List<String>? locations;
  List<String>? activities;
  VoidCallback onPressed;

  DiscoverUserListItem(
      {required this.header,
      this.imageLink,
      required this.locations,
      required this.activities,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var locationString = locations!.join(", ");
    var activityString = activities!.join(", ");

    return GestureDetector(
      onTap: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  //top: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                  bottom: BorderSide(
                      width: 1, color: PeerPALAppColor.secondaryColor))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 13, 0, 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Avatar(imageLink!),
                _Content(locationString, activityString),
                Spacer(),
                _RightArrow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Content(String locationString, String activityString) {
    return Container(
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading(),
          SizedBox(height: 3),
          _WrappedText(title: "Ort: ", content: locationString),
          SizedBox(height: 2),
          _WrappedText(title: "Aktivitäten: ", content: activityString)
        ],
      ),
    );
  }

  Widget _WrappedText({required String title, required String content}) {
    var textStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      color: Colors.black,
    );
    return Row(
      children: [
        CustomPeerPALHeading3(
          text: title,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        Flexible(
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: content,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _Heading() {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CustomPeerPALHeading3(
              text: header!,
              color: PeerPALAppColor.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget _RightArrow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Icon(
        Icons.arrow_forward_ios,
        color: PeerPALAppColor.secondaryColor,
        size: 20,
      ),
    );
  }

  Widget _Avatar(String imageURL) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Container(
            child: CircleAvatar(
              radius: 30,
              child: ClipOval(
                  child: (imageLink == null || imageLink!.isEmpty)
                      ? Icon(
                          Icons.account_circle,
                          size: 60.0,
                          color: Colors.grey,
                        )
                      : CachedNetworkImage(
                          imageUrl: imageLink!,
                          errorWidget: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 60.0,
                              color: Colors.grey,
                            );
                          },
                        )),
              backgroundColor: Colors.white,
            ),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: PeerPALAppColor.primaryColor,
                width: 4,
              ),
            )));
  }
}
