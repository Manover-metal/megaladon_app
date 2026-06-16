enum AdvertType {
  none,
  service,
  advert;

  static AdvertType parse(String? value) {
    if (value == 'service') {
      return AdvertType.service;
    } else if (value == 'advert') {
      return AdvertType.advert;
    }
    return AdvertType.none;
  }
}
