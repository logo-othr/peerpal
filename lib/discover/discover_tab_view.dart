import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/discover/discover_tab_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/repository/models/peerpal_user.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/discover_user_list_item.dart';
import 'package:provider/src/provider.dart';

class DiscoverTabView extends StatefulWidget {
  @override
  _DiscoverTabViewState createState() => _DiscoverTabViewState();
}

class _DiscoverTabViewState extends State<DiscoverTabView> {
  final searchFieldController = TextEditingController();
  late DiscoverTabBloc _discoverTabBloc;
  bool isSearchEmpty = true;
  bool isSearchFocused = false;
  final _focusNode = FocusNode();

  final String _loadUsersErrorMessage =
      'Die Nutzer konnten nicht geladen werden.';
  final String _loadingMessage = "Versuche die Daten zu laden...";

  void onSearchFieldFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        isSearchFocused = true;
      });
    } else {
      setState(() {
        isSearchFocused = false;
      });
    }
  }

  void onSearchFieldTextChange() {
    if (searchFieldController.text.length > 0) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _discoverTabBloc = context.read<DiscoverTabBloc>();
    _focusNode.addListener(onSearchFieldFocusChange);
    searchFieldController.addListener(onSearchFieldTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    searchFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          'Entdecken',
          hasBackButton: false,
        ),
        body: BlocBuilder<DiscoverTabBloc, DiscoverTabState>(
          builder: (context, state) {
            switch (state.status) {
              case DiscoverTabStatus.error:
                return Center(child: Text(_loadUsersErrorMessage));
              case DiscoverTabStatus.success:
                return Column(
                  children: [
                    _buildSearchBar(),
                    isSearchEmpty
                        ? buildDiscoverStream()
                        : _buildSearchResult(),
                  ],
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(width: 1, color: secondaryColor),
                bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Column(
          children: [
            CustomCupertinoSearchBar(
                focusNode: _focusNode,
                enabled: true,
                heading: 'Personensuche',
                searchBarController: this.searchFieldController),
            isSearchEmpty ? Container() : _buildSearchButton(),
          ],
        ));
  }

  Widget _buildSearchResult() {
    return Column(
      children: [
        _buildSearchResultList(_discoverTabBloc.state.searchResults),
      ],
    );
  }

  Widget _buildSearchResultList(List<PeerPALUser> searchResults) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildUser(searchResults[index]);
        },
        itemCount: searchResults.length,
      ),
    );
  }

  Widget buildDiscoverStream() {
    return Expanded(
      child: StreamBuilder<List<PeerPALUser>>(
        stream: _discoverTabBloc.state.userStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PeerPALUser>> snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return _buildUserList(snapshot.data!);
          }
          if (snapshot.hasData && snapshot.data!.length == 0) {
            return _noUsersFound();
          }
          if (!snapshot.hasData) {
            return CustomLoadingIndicator(text: _loadingMessage);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildUserListHeader() {
    return Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            border:
                Border(bottom: BorderSide(width: 1, color: secondaryColor))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomPeerPALHeading3(
              text: 'Personen die deinen\nSuchkriterien entsprechen',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPeerPALButton(
        text: "Suchen",
        onPressed: () async => {
          _discoverTabBloc
              .add(SearchUser(searchFieldController.text.toString()))
        },
      ),
    );
  }

  Widget _buildChangeDiscoverCriteriaButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPeerPALButton(
        text: "Suchkriterien ändern",
        onPressed: () async => {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DiscoverInterestsOverviewPage()),
          ),
        },
      ),
    );
  }

  Widget _buildUserList(List<PeerPALUser> users) {
    return Column(
      children: [
        _buildUserListHeader(),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return _buildUser(users[index]);
              },
              itemCount: users.length,
            ),
          ),
        ),
        isSearchFocused ? Container() : _buildChangeDiscoverCriteriaButton()
      ],
    );
  }

  Widget _buildUser(PeerPALUser user) {
    return DiscoverUserListItem(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserDetailPage(user.id!)));
        },
        imageLink: user.imagePath,
        header: user.name,
        locations: user.discoverLocations?.map((e) => e.place).toList(),
        activities: user.discoverActivitiesCodes
            ?.map((e) => ActivityRepository.getActivityNameFromCode(e))
            .toList());
  }

  Widget _noUsersFound() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  //top: BorderSide(width: 1, color: secondaryColor),
                    bottom: BorderSide(width: 1, color: secondaryColor))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomPeerPALHeading3(
                  text: 'Personen die deinen\nSuchkriterien entsprechen',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                ),
              ],
            )),
        SizedBox(height: 100),
        const Center(child: Text('Es konnten keine Nutzer gefunden werden')),
      ],
    );
  }
}
