import 'package:dashboard/classes/product.dart';
import 'package:dashboard/classes/trip.dart';
import 'package:dashboard/globalVariables.dart';
import 'package:dashboard/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'item_reviews_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AllTrips extends StatefulWidget {
  @override
  _AllTripsState createState() => _AllTripsState();
}

class _AllTripsState extends State<AllTrips> {
  List<Trip> trips = new List<Trip>();

  Future<void> update() async {
    setState(() {});
  }

  Future<int> fetchProductsData() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print('yaha pe firebase ka user get huwa ha ${user.uid}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        'Loading trips...',
      ),
    );
    DatabaseReference productsRef =
        FirebaseDatabase.instance.reference().child('rideRequest');
    DateFormat format = DateFormat("yyyy-MM-dd");
    //final format = DateFormat('yyyy-M-d H:m:s:S');
    if (user != null) {
      productsRef.once().then((DataSnapshot snapshot) {
        tripsList.clear();

        Map<dynamic, dynamic> snap = snapshot.value;
        //Navigator.pop(context);
        snap.forEach((key, value) {
          if (value['status'] == 'ended') {
            final newProduct = Trip(
              DriverName: value['driver_name'].toString(),
              vehicleName: value['car_details'].toString(),
              fairs: value['fares'].toString(),
              destinationAddress: value['destination_address'].toString(),
              dateTime: value['created_at'].toString(),
            );

            trips.add(newProduct);
            //print(newProduct);
          }
        });
        setState(() {
          tripsList = trips;
        });
        Navigator.pop(context);
      });

      return 1;
    } else {
      Navigator.pop(context);
    }
  }

  void fetchList() async {
    var x = await fetchProductsData().then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order Trips   ',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: <Widget>[Icon(Icons.arrow_drop_down, color: Colors.white)],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await update();
        },
        child: ListView.builder(
          itemCount: tripsList.length, //phoneProducts.length,
          itemBuilder: (context, position) {
            return ShopItem(tripsList[position]);
          },
        ),
      ),
      /*
       ListView
      (
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>
        [
          
          ShopItem(),
          BadShopItem(),
          NewShopItem()
        ],
      )
      */
    );
  }
}

class ShopItem extends StatelessWidget {
  final Trip productItem;
  ShopItem(this.productItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Stack(
        children: <Widget>[
          /// Item card
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox.fromSize(
                size: Size.fromHeight(172.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    /// Item description inside a material
                    Container(
                      margin: EdgeInsets.only(top: 24.0),
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(12.0),
                        shadowColor: Color(0x802196F3),
                        color: Colors.white,
                        child: InkWell(
                          /*
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => ItemReviewsPage())),
                                  */
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    /// Title and rating
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(productItem.destinationAddress,
                                            style: TextStyle(
                                                color: Colors.blueAccent)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text('Rs. ${productItem.fairs}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 30.0)),
                                          ],
                                        ),
                                      ],
                                    ),

                                    /// Infos
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            '${productItem.DriverName.toUpperCase()} ',
                                            style: TextStyle()),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text('${productItem.vehicleName}',
                                            style: TextStyle()),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 90,
                                  width: 90,
                                  child: Material(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Icon(
                                            Icons.emoji_transportation_outlined,
                                            color: Colors.white,
                                            size: 30.0),
                                      ))),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
