import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/configMaps.dart';

class AssistantMethods
{
  // static Future<String> searchCoordinateAddress(Position position) =>
  //     GeolocatorPlatform.instance.requestPermission();

  //todo: 아래 Provider 를 위해 context 파라미터 추가
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    print("*******before RequestAssistant.getRequest");
    var response = await RequestAssistant.getRequest(url);
    print("*****after RequestAssistant.getRequest");
    if(response != "failed"){
      // print("*****response:");
      // print(response);
      // placeAddress = response["results"][0]["formatted_address"];
      placeAddress = response["results"][0]["address_components"][0];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    else{
      print("*****response == failed");
    }
    return placeAddress;
  }
}