import 'package:dashboard/classes/driver.dart';
import 'package:dashboard/globalVariables.dart';
import 'package:dashboard/pages/item_reviews_page.dart';
import 'package:dashboard/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AllDrivers extends StatefulWidget {
  @override
  _AllDriversState createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {
  List<Driver> drivers = new List<Driver>();

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
        'Loading drivers...',
      ),
    );
    DatabaseReference productsRef =
        FirebaseDatabase.instance.reference().child('drivers');
    DateFormat format = DateFormat("yyyy-MM-dd");
    //final format = DateFormat('yyyy-M-d H:m:s:S');
    if (user != null) {
      productsRef.once().then((DataSnapshot snapshot) {
        driversList.clear();

        Map<dynamic, dynamic> snap = snapshot.value;
        //Navigator.pop(context);
        snap.forEach((key, value) {
          //Map<dynamic, dynamic> snappp = snap.values
          final newProduct = Driver(
            name: value['fullname'].toString(),
            email: value['email'].toString(),
            vehicle: value['vehicle_details']['car_model'].toString(),
            vehicleColor: value['vehicle_details']['car_color'].toString(),
            vehicleNumber:
                value['vehicle_details']['vehicle_number'].toString(),
            totalEarning: value['earnings'].toString(),
            image: (value['image'] != null) ? value['image'].toString() : null,
            driverId: value['id'].toString(),
            //totalTrips: value['history'],
          );

          drivers.add(newProduct);
        });
        setState(() {
          driversList = drivers;
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
            Text('Order drivers   ',
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
          itemCount: driversList.length, //phoneProducts.length,
          itemBuilder: (context, position) {
            return ShopItem(driversList[position]);
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
  final Driver productItem;
  ShopItem(this.productItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          String img;

          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ItemReviewsPage(productItem)));
        },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      /// Title and rating
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(productItem.email,
                                              style: TextStyle(
                                                  color: Colors.blueAccent)),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                  productItem.name
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 25.0)),
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
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Overall Earning',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                  'Rs. ${productItem.totalEarning}',
                                                  style: TextStyle()),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Vehicle',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(productItem.vehicle,
                                                  style: TextStyle()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Item image
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(54.0),
                            child: Material(
                                elevation: 20.0,
                                shadowColor: Color(0x802196F3),
                                shape: CircleBorder(),
                                child: Container(
                                  width: 100.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    color: Colors.white,
                                  ),
                                  child: (productItem.image != null)
                                      ? Image.network(
                                          productItem.image,
                                          height: 130.0,
                                          width: 120.0,
                                        )
                                      : Image.asset(
                                          'images/profiile.png',
                                          height: 130.0,
                                          width: 120.0,
                                        ),
                                )
                                //: Image.asset('res/shoes1.png'),
                                ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class BadShopItem extends StatelessWidget {
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
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Color(0xFFDA4453),
                            Color(0xFF89216B)
                          ])),
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /// Title and rating
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Nike Jordan III',
                                        style: TextStyle(color: Colors.white)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('1.3',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 34.0)),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 24.0),
                                      ],
                                    ),
                                  ],
                                ),

                                /// Infos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text('Bought',
                                        style: TextStyle(color: Colors.white)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Text('3',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Text('times for a profit of',
                                        style: TextStyle(color: Colors.white)),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.green,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text('\$ 363',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Item image
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(54.0),
                          child: Material(
                            elevation: 20.0,
                            shadowColor: Color(0x802196F3),
                            shape: CircleBorder(),
                            child: Image.asset('res/shoes1.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          /// Review
          Padding(
            padding: EdgeInsets.only(
              top: 160.0,
              right: 32.0,
            ),
            child: Material(
              elevation: 12.0,
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text('AI'),
                  ),
                  title: Text('Ivascu Adrian ★☆☆☆☆'),
                  subtitle: Text(
                      'The shoes that arrived weren\'t the same as the ones in the image...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewShopItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Align(
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
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Title and rating
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('[New] Nike Jordan III',
                                  style: TextStyle(color: Colors.blueAccent)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text('No reviews',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 34.0)),
                                ],
                              ),
                            ],
                          ),

                          /// Infos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text('Bought', style: TextStyle()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text('0',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              Text('times for a profit of', style: TextStyle()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.green,
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('\$ 0',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Item image
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(54.0),
                      child: Material(
                        elevation: 20.0,
                        shadowColor: Color(0x802196F3),
                        shape: CircleBorder(),
                        child: Image.asset('res/shoes1.png'),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
