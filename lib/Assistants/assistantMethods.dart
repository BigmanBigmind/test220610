import 'package:geolocator/geolocator.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/configMaps.dart';

class AssistantMethods
{
  // static Future<String> searchCoordinateAddress(Position position) =>
  //     GeolocatorPlatform.instance.requestPermission();

  static Future<String> searchCoordinateAddress(Position position) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    print("*******before RequestAssistant.getRequest");
    var response = await RequestAssistant.getRequest(url);
    print("*****after RequestAssistant.getRequest");
    if(response != "failed"){
      print("*****response:");
      print(response);
      placeAddress = response["results"][0]["formatted_address"];
    }
    else{
      print("*****response == failed");
    }
    return placeAddress;
  }
}