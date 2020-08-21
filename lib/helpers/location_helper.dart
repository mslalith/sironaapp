const YOUR_API_KEY = 'AIzaSyC8v3z7EnMhcOHjDxDV8Z955TMZZ5gxVog';

class LocationHelper {
  static String previewImage({
    double latitude,
    double longitude
  }){
    
return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x600&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$YOUR_API_KEY';
  }
}