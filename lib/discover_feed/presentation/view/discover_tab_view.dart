import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/data/repository/activity_repository.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/data/resources/colors.dart';
import 'package:peerpal/data/resources/support_video_links.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_feed/presentation/bloc/discover_feed_bloc.dart';
import 'package:peerpal/discover_setup/pages/discover_interests_overview/view/discover_interests_overview_page.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_loading_indicator.dart';
import 'package:peerpal/widgets/custom_peerpal_button.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/discover_user_list_item.dart';
import 'package:peerpal/widgets/support_video_dialog.dart';

class DiscoverTabView extends StatefulWidget {
  @override
  _DiscoverTabViewState createState() => _DiscoverTabViewState();
}

class _DiscoverTabViewState extends State<DiscoverTabView> {
  final _searchFieldController = TextEditingController();
  late DiscoverTabBloc _discoverTabBloc;
  bool _isSearchEmpty = true;
  bool _isSearchFocused = false;
  final _focusNode = FocusNode();
  final String _loadUsersErrorMessage =
      'Die Nutzer konnten nicht geladen werden.';
  final String _loadingMessage = "Versuche die Daten zu laden...";

  @override
  void initState() {
    super.initState();
    _discoverTabBloc = context.read<DiscoverTabBloc>();
    _focusNode.addListener(_onSearchFieldFocusChange);
    /*_controller.addListener(() {
      _scrollFetch();
    });*/
    _searchFieldController.addListener(_onSearchFieldTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    _searchFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar('Entdecken',
            hasBackButton: false,
            actionButtonWidget: CustomSupportVideoDialog(
                supportVideo: SupportVideos.links[VideoIdentifier.discover]!)),
        body: BlocBuilder<DiscoverTabBloc, DiscoverTabState>(
          builder: (context, state) {
            switch (state.status) {
              case DiscoverTabStatus.error:
                return Center(child: Text(_loadUsersErrorMessage));
              case DiscoverTabStatus.success:
                return Column(
                  children: [
                    _buildSearchBar(),
                    _isSearchEmpty
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
                top:
                    BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
                bottom: BorderSide(
                    width: 1, color: PeerPALAppColor.secondaryColor))),
        child: Column(
          children: [
            CustomCupertinoSearchBar(
                focusNode: _focusNode,
                enabled: true,
                heading: 'Personensuche',
                searchBarController: this._searchFieldController),
            _isSearchEmpty ? Container() : _buildSearchButton(),
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
            border: Border(
                bottom: BorderSide(
                    width: 1, color: PeerPALAppColor.secondaryColor))),
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
              .add(SearchUser(_searchFieldController.text.toString()))
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
          ).then((value) => context.read<DiscoverTabBloc>().add(LoadUsers()))
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
              controller: _controller,
            ),
          ),
        ),
        _isSearchFocused ? Container() : _buildChangeDiscoverCriteriaButton()
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
                    bottom: BorderSide(
                        width: 1, color: PeerPALAppColor.secondaryColor))),
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

  void _onSearchFieldFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        _isSearchFocused = true;
      });
    } else {
      setState(() {
        _isSearchFocused = false;
      });
    }
  }

  ScrollController _controller = ScrollController();

  /* void _scrollFetch() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      _discoverTabBloc.fetchUser();
    }
  }*/

  void _onSearchFieldTextChange() {
    if (_searchFieldController.text.length > 0) {
      setState(() {
        _isSearchEmpty = false;
      });
    } else {
      setState(() {
        _isSearchEmpty = true;
      });
    }
  }
}
