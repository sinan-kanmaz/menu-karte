enum Flavor { dev, stage, prod }

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Qr Menu Dev';
      case Flavor.stage:
        return 'My Digi Menu Stage';
      case Flavor.prod:
        return 'Menu Karte';
      default:
        return 'title';
    }
  }

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.dev:
        return 'https://qrmenu-dev-36a5e.web.app';
      case Flavor.stage:
        return 'https://my-digi-menu-stage.web.app';
      case Flavor.prod:
        return 'https://app.menu-karte.de';
      default:
        return 'https://app.menu-karte.de';
    }
  }
}
