import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/ui/discovery/discovery.dart';
import 'package:capoo_tunes/ui/home/viewmodel.dart';
import 'package:capoo_tunes/ui/settings/settings.dart';
import 'package:capoo_tunes/ui/user/user.dart';
import 'package:capoo_tunes/utils/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = [
    HomeTab(),
    DiscoveryTab(),
    UserTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color(0xFF1C1B1B),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF343434),
        middle: Text('Capoo Tunes', style: TextStyle(color: Color(0xFF42C83C))),
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Color(0xFF343434),
          activeColor: Color(0xFF42C83C),
          inactiveColor: Color(0xFF737373),
          onTap: (index) {},
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.compactDisc, size: 24),
              label: 'Discovery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 36),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear, size: 24),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HomeTabState());
  }
}

class HomeTabState extends StatefulWidget {
  const HomeTabState({super.key});

  @override
  State<HomeTabState> createState() => _HomeTabStateState();
}

class _HomeTabStateState extends State<HomeTabState> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel = MusicAppViewModel();

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSong();
    observerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody(), backgroundColor: Color(0xFF1C1B1B));
  }

  Widget buildBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return buildProgressBar();
    }
    return buildListView();
  }

  Widget buildProgressBar() {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return buildRow(index);
      },
    );
  }

  Widget buildRow(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 29),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14), // Image border
            child: SizedBox.fromSize(
              size: Size.fromRadius(28), // Image radius
              child: Image.network(songs[index].image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  songs[index].title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE3E3E3),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  songs[index].artist,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFE3E3E3),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Center(
            child: Text(
              formatDuration(songs[index].duration),
              style: TextStyle(fontSize: 15, color: Color(0xFFE3E3E3)),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Color(0xFFE3E3E3)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void observerData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs = songList;
      });
    });
  }
}
