enum AdvertType {
  service, advert;

  static AdvertType parse(value) {
    if(value == 'service') {
      return AdvertType.service;
    } else if(value == 'advert') {
      return AdvertType.advert;
    }
    return AdvertType.advert;
  }
}