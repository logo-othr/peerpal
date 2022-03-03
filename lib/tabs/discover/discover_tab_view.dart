import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/chat/presentation/user_detail_page/user_detail_page.dart';
import 'package:peerpal/colors.dart';
import 'package:peerpal/repository/activity_repository.dart';
import 'package:peerpal/tabs/discover/discover_tab_bloc.dart';
import 'package:peerpal/widgets/custom_app_bar.dart';
import 'package:peerpal/widgets/custom_bottom_indicator.dart';
import 'package:peerpal/widgets/custom_cupertino_search_bar.dart';
import 'package:peerpal/widgets/custom_peerpal_heading.dart';
import 'package:peerpal/widgets/discover_user_list_item.dart';
import 'package:provider/src/provider.dart';

class DiscoverTabView extends StatefulWidget {
  @override
  _DiscoverTabViewState createState() => _DiscoverTabViewState();
}

class _DiscoverTabViewState extends State<DiscoverTabView> {
  final _scrollController = ScrollController();
  late DiscoverTabBloc _discoverTabBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _discoverTabBloc = context.read<DiscoverTabBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_hasReachedBottom) {
      _discoverTabBloc.add(UsersLoaded());
    }
  }

  bool get _hasReachedBottom {
    if (!_scrollController.hasClients) {
      return false;
    }
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScrollOffset = _scrollController.offset;
    return currentScrollOffset >= (maxScrollExtent * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    var personSearchFieldController = TextEditingController();
    personSearchFieldController.text = "Derzeit noch deaktiviert";
    return Scaffold(
      appBar: CustomAppBar(
        'Entdecken',
        hasBackButton: false,
      ),
      body: BlocBuilder<DiscoverTabBloc, DiscoverTabState>(
        builder: (context, state) {
          switch (state.status) {
            case DiscoverTabStatus.error:
              return const Center(
                  child: Text('Die Nutzer konnten nicht geladen werden.'));
            case DiscoverTabStatus.success:
              if (state.users.isEmpty) {
                return const Center(
                    child: Text('Es konnten keine Nutzer gefunden werden'));
              }
              return Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(width: 1, color: secondaryColor),
                              bottom:
                              BorderSide(width: 1, color: secondaryColor))),
                      child: CustomCupertinoSearchBar(
                          heading: 'Personensuche',
                          searchBarController: personSearchFieldController)),
                  Container(
                      width: double.infinity,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border(
                            //top: BorderSide(width: 1, color: secondaryColor),
                              bottom:
                              BorderSide(width: 1, color: secondaryColor))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomPeerPALHeading3(
                            text:
                            'Personen die deinen\nSuchkriterien entsprechen',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        if (index >= state.users.length) {
                          if (index >= limit) {
                            return BottomIndicator();
                          } else
                            return Container();
                        } else {
                          var user = state.users[index];
                          return DiscoverUserListItem(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserDetailPage(user.id!)));
                              },
                              imageLink: user.imagePath,
                              header: user.name,
                              locations: user.discoverLocations
                                  ?.map((e) => e.place)
                                  .toList(),
                              activities: state.users[index].discoverActivitiesCodes
                                  ?.map((e) => ActivityRepository.getActivityNameFromCode(e))
                                  .toList());
                        }
                      },
                      itemCount: state.hasNoMoreUsers
                          ? state.users.length
                          : state.users.length + 1,
                      controller: _scrollController,
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
