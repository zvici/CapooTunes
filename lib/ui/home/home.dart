import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/ui/discovery/discovery.dart';
import 'package:capoo_tunes/ui/home/viewmodel.dart';
import 'package:capoo_tunes/ui/now_playing/playing.dart';
import 'package:capoo_tunes/ui/settings/settings.dart';
import 'package:capoo_tunes/ui/user/user.dart';
import 'package:capoo_tunes/utils/app_colors.dart';
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
      backgroundColor: AppColors.background,
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Color(0xFF343434),
          activeColor: AppColors.primary,
          inactiveColor: Color(0xFF737373),
          onTap: (index) {},
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house, size: 20),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.compactDisc, size: 20),
              label: 'Discovery',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'User',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear, size: 20),
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
  State<HomeTabState> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabState> {
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        automaticBackgroundVisibility: true,
        backgroundColor: Color(0xFF343434),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Scaffold(
            body: Text(
              'Home',
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      child: Scaffold(body: buildBody(), backgroundColor: Color(0xFF1C1B1B)),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
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
    return _SongItemSection(song: songs[index], parent: this);
  }

  void observerData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs = songList;
      });
    });
  }

  void showBottomSheet(Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            height: 400,
            color: Color(0xFF1C1B1B),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Modal bottom sheet',
                    style: TextStyle(color: Color(0xFFE3E3E3)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void navigate(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NowPlaying(songs: songs, playingSong: song),
      ),
    );
  }
}

class _SongItemSection extends StatelessWidget {
  final Song song;
  final _HomeTabPageState parent;

  const _SongItemSection({required this.song, required this.parent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 29),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(28), // Image radius
                child: Image.network(song.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE3E3E3),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.artist,
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
                formatDuration(song.duration),
                style: TextStyle(fontSize: 15, color: Color(0xFFE3E3E3)),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Color(0xFFE3E3E3)),
                  onPressed: () {
                    parent.showBottomSheet(song);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () => {parent.navigate(song)},
    );
  }
}
