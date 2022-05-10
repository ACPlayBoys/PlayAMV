import 'package:flutter/material.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/utils/routes.dart';
import 'package:playamv/utils/storage.dart';
import 'package:velocity_x/velocity_x.dart';

class GetVideos extends StatefulWidget {
  final UserAccount user;
  const GetVideos(this.user, {Key? key}) : super(key: key);

  @override
  State<GetVideos> createState() => _GetVideosState();
}

class _GetVideosState extends State<GetVideos> {
  @override
  void initState() {
    print(widget.user.first_name);
    Storage.getVideos(widget.user.id);
    //
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ValueListenableBuilder(
      valueListenable: Storage.myVideos,
      builder: (BuildContext context, List<Video> value, Widget? child) {
        print(value);
        if (value.isNotEmpty && Storage.myinit) {
          return GridView.builder(
            itemCount: value.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  child: Image.network(
                    value[index].thumb,
                    fit: BoxFit.fill,
                  ),
                ).p(3),
              ).onInkTap(() async {
                await Navigator.of(context).push(Routes.singleVideoRoute(
                  value[index],
                  widget.user,
                ));
              });
            },
          );
        } else {
          return CircularProgressIndicator().centered();
        }
      },
    ));
  }
}
