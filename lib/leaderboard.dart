import 'package:flutter/material.dart';
import 'package:mad2_db_dataobjects/API.dart';
import 'package:mad2_db_dataobjects/user_data.dart';
import 'package:mad2_browsepage/browse_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<UserData>> users;
  late Future<UserData> currentUser;

  @override
  void initState() {
    super.initState();
    users = API().getUserList();
    currentUser = API().getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: CircularProgressIndicator(),
    );
    Widget header = Container(
      height: 200,
      color: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Add the "Leaderboard" title and trophy icon
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Leaderboard",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  MdiIcons.crownCircle,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            margin: EdgeInsets.only(bottom: 15),
          ),
        ],
      ),
    );
    Widget userListContainer = Container(
      padding: EdgeInsets.only(top: 190),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );

    return Scaffold(
        body: FutureBuilder(
            future: Future.wait([users, currentUser]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return content;
              } else {
                List<UserData> userList = snapshot.data?[0] as List<UserData>;
                UserData currentUserData = snapshot.data?[1] as UserData;
                userList.sort((a, b) => b.points.compareTo(a.points));

                // Create a list of the top 10 users from the userList
                List<UserData> topUsers = userList.take(10).toList();

                header = Container(
                  height: 200,
                  color: Colors.purple,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Leaderboard",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            MdiIcons.crownCircle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      // Add the current user's ranking to the white box
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: Image.network(currentUserData.profilePic),
                            ),
                            Text(currentUserData.name.split(" ")[0]),
                            Text(currentUserData.grade.toString()),
                            Text(currentUserData.points.toString()),
                          ],
                        ),
                      ),
                      Center(
                        child: Text(
                          "You are ranked #${userList.indexOf(currentUserData) + 1} out of ${userList.length} users",
                        ),
                      ),
                    ],
                  ),
                );

                userListContainer = Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.only(top: 190),
                  child: ListView.builder(
                    itemCount: topUsers.length,
                    itemBuilder: (context, index) {
                      UserData user = topUsers[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.network(user.profilePic),
                              ),
                              Text(user.name.split(" ")[0]),
                              Text(user.grade.toString()),
                              Text(user.points.toString()),
                            ],
                          ),
                          // Only display a divider if this is not the last item in the list
                          if (index < topUsers.length - 1)
                            Divider(color: Colors.black45),
                        ],
                      );
                    },
                  ),
                );

                return Stack(
                  children: [
                    header,
                    userListContainer,
                  ],
                );
              }
            }));
  }
}
