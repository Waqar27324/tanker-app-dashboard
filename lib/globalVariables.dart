import 'package:dashboard/classes/consumer.dart';
import 'package:dashboard/classes/driver.dart';
import 'package:dashboard/classes/product.dart';
import 'package:dashboard/classes/trip.dart';
import 'package:dashboard/classes/user.dart';
import 'package:dashboard/classes/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseUser currentUser;

String imageurl;

User currentUserInfo;

List<Product> productsList = new List<Product>();

List<Consumer> consumersList = new List<Consumer>();
List<Driver> driversList = new List<Driver>();
List<Trip> tripsList = new List<Trip>();

List<Vehicles> vehiclesList = new List<Vehicles>();

Future<int> getCurrentUserInfo() async {
  currentUser = await FirebaseAuth.instance.currentUser();

  String userId = currentUser.uid;

  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('managers/$userId');
  dbRef.once().then((DataSnapshot snapshot) {
    if (snapshot.value != null) {
      currentUserInfo = User.fromSnapshot(snapshot);
      print(currentUserInfo.userName);
    }
  }).whenComplete(() {
    return 5;
  });
}
