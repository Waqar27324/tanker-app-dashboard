import 'package:dashboard/classes/driver.dart';
import 'package:dashboard/widgets/progress_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ItemReviewsPage extends StatefulWidget {
  final Driver driver;

  ItemReviewsPage(this.driver);
  @override
  _ItemReviewsPageState createState() => _ItemReviewsPageState();
}

class _ItemReviewsPageState extends State<ItemReviewsPage> {
  int totalTrips = 0;

  void dymmyFuctionToFetchDriversData() async {
    int x = await fetchDriversTripHistoryAndRating().then((value) {
      setState(() {});
    });
  }

  Future<int> fetchDriversTripHistoryAndRating() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    // print('yaha pe firebase ka user get huwa ha ${user.uid}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        'Loading detail..',
      ),
    );
    DatabaseReference productsRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${widget.driver.driverId}/history');
    //DateFormat format = DateFormat("yyyy-MM-dd");
    //final format = DateFormat('yyyy-M-d H:m:s:S');
    List<String> keys = new List<String>();
    if (user != null) {
      productsRef.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> snap = snapshot.value;

        if (snap != null) {
          snap.forEach((key, value) {
            //Map<dynamic, dynamic> snappp = snap.values

            keys.add(key.toString());
          });

          print('${keys.length}');
          setState(() {
            totalTrips = keys.length;
          });
        }

        Navigator.pop(context);
      });

      return 1;
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dymmyFuctionToFetchDriversData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.driver.name.toUpperCase()),
              background: SizedBox.expand(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    (widget.driver.image != null)
                        ? Image.network(
                            widget.driver.image,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          )
                        : Image.asset(
                            'images/profiile.png',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fitWidth,
                          ),
                    Container(color: Colors.black26)
                  ],
                ),
              ),
            ),
            elevation: 2.0,
            forceElevated: true,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Personal Information:',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.driver.name),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Email Addess:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.driver.email),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vehicle Information:',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Vehicle name:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.driver.vehicle),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Vehicle number:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.driver.vehicleNumber),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Vehicle color:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(widget.driver.vehicleColor),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Deliveries Information:',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Overall earning:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Rs. ${widget.driver.totalEarning}'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            'Total completed trips:',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text((totalTrips != 0) ? '${totalTrips}' : '16'),
                        ],
                      ),
                    ],
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
