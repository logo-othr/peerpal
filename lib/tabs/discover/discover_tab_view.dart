import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peerpal/app/bloc/app_bloc.dart';
import 'package:peerpal/tabs/discover/discover_tab_bloc.dart';
import 'package:peerpal/widgets/custom_bottom_indicator.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entdecken'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ],
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
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.users.length) {
                    return BottomIndicator();
                  } else {
                    var user = state.users[index];
                    return DiscoverUserListItem(
                        onPressed: () => print(user),
                        imageLink: user.imagePath,
                        header: user.name,
                        locations: user.discoverLocations
                            ?.map((e) => e.place)
                            .toList(),
                        activities: state.users[index].discoverActivities
                            ?.map((e) => e.name!)
                            .toList());
                  }
                },
                itemCount: state.hasNoMoreUsers
                    ? state.users.length
                    : state.users.length + 1,
                controller: _scrollController,
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
