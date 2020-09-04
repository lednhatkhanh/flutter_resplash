import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:re_splash/models/collection.model.dart';
import 'package:re_splash/models/photo.model.dart';
import 'package:re_splash/models/user.model.dart';
import 'package:re_splash/screens/user_details/providers/user_details.provider.dart';
import 'package:re_splash/utils/open_link.dart';
import 'package:re_splash/widgets/item_list.dart';

class UserDetailsContent extends StatefulWidget {
  final User user;

  const UserDetailsContent({Key key, @required this.user}) : super(key: key);

  @override
  _UserDetailsContentState createState() => _UserDetailsContentState();
}

class _UserDetailsContentState extends State<UserDetailsContent> {
  void _openInBrowser() async {
    final url = widget.user.links.html;
    openLink(context, url);
  }

  void _openPortfolio() {
    final url = widget.user.portfolioUrl;

    openLink(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: Theme.of(context).iconTheme,
          title: Text(
            widget.user.name,
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: [
            if (widget.user.portfolioUrl != null)
              IconButton(
                  icon: const Icon(Icons.public), onPressed: _openPortfolio),
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              onPressed: _openInBrowser,
            ),
          ],
        ),
        body: Column(
          children: [
            UserInfo(user: widget.user),
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Photos'),
                Tab(text: 'Collections'),
              ],
            ),
            Consumer<UserDetailsProvider>(
              builder: (context, userDetailsProvider, child) => Expanded(
                child: TabBarView(
                  children: [
                    ItemList<Photo>(
                      items: userDetailsProvider.photos,
                      loadMore: userDetailsProvider.loadMorePhotos,
                      isLoading: userDetailsProvider.isLoading,
                      canLoadMore: userDetailsProvider.canLoadMorePhotos,
                    ),
                    ItemList<Collection>(
                      items: userDetailsProvider.collections,
                      loadMore: userDetailsProvider.loadMoreCollections,
                      isLoading: userDetailsProvider.isLoading,
                      canLoadMore: userDetailsProvider.canLoadMoreCollections,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final User user;

  const UserInfo({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImage.large),
                ),
              ),
              Column(
                children: [
                  Text(user.totalPhotos.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('Photos', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              Column(
                children: [
                  Text(user.totalLikes.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('Likes', style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
              Column(
                children: [
                  Text(user.totalCollections.toString(),
                      style: Theme.of(context).textTheme.bodyText1),
                  Text('Collections',
                      style: Theme.of(context).textTheme.bodyText2),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(user.name, style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 4),
          if (user.location != null)
            Text(user.location, style: Theme.of(context).textTheme.caption),
          SizedBox(height: 6),
          if (user.bio != null) Text(user.bio),
        ],
      ),
    );
  }
}
