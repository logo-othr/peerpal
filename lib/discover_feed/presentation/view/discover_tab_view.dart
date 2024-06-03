import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/activity/domain/repository/activity_repository.dart';
import 'package:peerpal/app/data/resources/colors.dart';
import 'package:peerpal/app/data/support_videos/resources/support_video_links.dart';
import 'package:peerpal/app/domain/support_videos/support_video_enum.dart';
import 'package:peerpal/chatv2/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/discover_feed/domain/peerpal_user.dart';
import 'package:peerpal/discover_feed/presentation/cubit/discover_feed_cubit.dart';
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
  late DiscoverFeedCubit discoverFeedCubit;

  final _focusNode = FocusNode();
  final String _loadUsersErrorMessage =
      'Die Nutzer konnten nicht geladen werden.';
  final String _loadingMessage = "Versuche die Daten zu laden...";

  @override
  void initState() {
    super.initState();
    discoverFeedCubit = context.read<DiscoverFeedCubit>();
    _focusNode.addListener(_onSearchFieldFocusChange);
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
      onTap: _dismissKeyboard,
      child: Scaffold(
        appBar: _buildCustomAppBar(),
        body: _buildBodyContent(),
      ),
    );
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  CustomAppBar _buildCustomAppBar() {
    return CustomAppBar(
      'Entdecken',
      hasBackButton: false,
      actionButtonWidget: CustomSupportVideoDialog(
        supportVideo: SupportVideos.links[VideoIdentifier.discover]!,
      ),
    );
  }

  Widget _buildBodyContent() {
    return BlocBuilder<DiscoverFeedCubit, DiscoverFeedState>(
      builder: (context, state) {
        return state is DiscoverFeedLoaded
            ? _buildDiscoverFeedContent(
                state.isSearchEmpty, state.isSearchFocused)
            : CircularProgressIndicator();
      },
    );
  }

  Widget _buildDiscoverFeedContent(bool isSearchEmpty, bool isSearchFocused) {
    return Column(
      children: [
        _buildSearchBar(isSearchEmpty),
        isSearchEmpty
            ? _buildDiscoverStream(isSearchFocused)
            : _buildSearchResult(),
      ],
    );
  }

  Widget _buildSearchBar(bool isSearchEmpty) {
    return Container(
      decoration: _searchBarDecoration(),
      child: Column(
        children: [
          _buildCustomSearchBar(),
          _displaySearchButtonIfSearchIsNotEmpty(isSearchEmpty),
        ],
      ),
    );
  }

  BoxDecoration _searchBarDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
        bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
      ),
    );
  }

  Widget _buildCustomSearchBar() {
    return CustomCupertinoSearchBar(
      focusNode: _focusNode,
      enabled: true,
      heading: 'Personensuche',
      searchBarController: _searchFieldController,
    );
  }

  Widget _displaySearchButtonIfSearchIsNotEmpty(bool isSearchEmpty) {
    return isSearchEmpty ? Container() : _buildSearchButton();
  }

  Widget _buildSearchResult() {
    return Column(
      children: [
        _buildSearchResultList(discoverFeedCubit.state.searchResults),
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

  Widget _buildDiscoverStream(bool isSearchFocused) {
    return Expanded(
      child: StreamBuilder<List<PeerPALUser>>(
        stream: discoverFeedCubit.state.userStream,
        builder: (context, snapshot) =>
            _buildStreamContent(snapshot, isSearchFocused),
      ),
    );
  }

  Widget _buildStreamContent(
      AsyncSnapshot<List<PeerPALUser>> snapshot, bool isSearchFocused) {
    if (snapshot.hasData) {
      return _handleSnapshotWithData(snapshot, isSearchFocused);
    }

    return snapshot.connectionState == ConnectionState.waiting
        ? CustomLoadingIndicator(text: _loadingMessage)
        : CircularProgressIndicator();
  }

  Widget _handleSnapshotWithData(
      AsyncSnapshot<List<PeerPALUser>> snapshot, bool isSearchFocused) {
    final users = snapshot.data!;
    return users.isNotEmpty
        ? _buildUserList(users, isSearchFocused)
        : _noUsersFound();
  }

  Widget _buildUserListHeader() {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: _userListHeaderDecoration(),
      child: _buildUserListHeaderText(),
    );
  }

  BoxDecoration _userListHeaderDecoration() {
    return BoxDecoration(
      color: Colors.grey[100],
      border: Border(
        bottom: BorderSide(width: 1, color: PeerPALAppColor.secondaryColor),
      ),
    );
  }

  Widget _buildUserListHeaderText() {
    return Column(
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
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomPeerPALButton(
        text: "Suchen",
        onPressed: () async => {
          discoverFeedCubit.searchUser(
              searchQuery: _searchFieldController.text.toString())
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
          ).then((value) => discoverFeedCubit.loadUsers())
        },
      ),
    );
  }

  Widget _buildUserList(List<PeerPALUser> users, bool isSearchFocused) {
    return Column(
      children: [
        _buildUserListHeader(),
        _buildUserListView(users),
        _conditionallyShowDiscoverCriteriaButton(isSearchFocused),
      ],
    );
  }

  Widget _buildUserListView(List<PeerPALUser> users) {
    return Expanded(
      child: Scrollbar(
        //isAlwaysShown: true,
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) => _buildUser(users[index]),
            itemCount: users.length,
            controller: _controller,
          ),
        ),
      ),
    );
  }

  Widget _conditionallyShowDiscoverCriteriaButton(isSearchFocused) {
    return isSearchFocused ? Container() : _buildChangeDiscoverCriteriaButton();
  }

  Widget _buildUser(PeerPALUser user) {
    if (!_isValidUser(user)) return Container();

    return DiscoverUserListItem(
      onPressed: () => _navigateToUserInformationPage(user),
      imageLink: user.imagePath,
      header: user.name,
      locations: _extractLocations(user),
      activities: _extractActivities(user),
    );
  }

  bool _isValidUser(PeerPALUser user) {
    return user.discoverLocations != null &&
        user.discoverActivitiesCodes != null &&
        user.name != null &&
        user.id != null;
  }

  void _navigateToUserInformationPage(PeerPALUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInformationPage(user.id!),
      ),
    );
  }

  List<String>? _extractLocations(PeerPALUser user) {
    return user.discoverLocations?.map((e) => e.place).toList();
  }

  List<String>? _extractActivities(PeerPALUser user) {
    return user.discoverActivitiesCodes
        ?.map((e) =>
            context.read<ActivityRepository>().getActivityNameFromCode(e))
        .toList();
  }

  Widget _noUsersFound() {
    return Column(
      children: [
        _buildNoUsersFoundHeader(),
        _buildNoUsersFoundMessage(),
      ],
    );
  }

  Widget _buildNoUsersFoundHeader() {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: _noUsersFoundHeaderDecoration(),
      child: Center(
        child: CustomPeerPALHeading3(
          text: 'Personen die deinen\nSuchkriterien entsprechen',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  BoxDecoration _noUsersFoundHeaderDecoration() {
    return BoxDecoration(
      color: Colors.grey[100],
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: PeerPALAppColor.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildNoUsersFoundMessage() {
    return SizedBox(
      height: 100,
      child: const Center(
        child: Text('Es konnten keine Nutzer gefunden werden'),
      ),
    );
  }

  void _onSearchFieldFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() {
        discoverFeedCubit.setSearchFocused(true);
      });
    } else {
      setState(() {
        discoverFeedCubit.setSearchFocused(false);
      });
    }
  }

  ScrollController _controller = ScrollController();

  void _onSearchFieldTextChange() {
    if (_searchFieldController.text.length > 0) {
      setState(() {
        discoverFeedCubit.setSearchEmpty(false);
      });
    } else {
      setState(() {
        discoverFeedCubit.setSearchEmpty(true);
      });
    }
  }
}
