import 'package:geolocator/geolocator.dart';
import 'package:helpnest/features/home/data/models/ad_banner_model.dart';

abstract class AdBannerRepo {
  Future<List<AdBannerModel>> getAdBanner({required Position? position});
}
