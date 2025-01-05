part of 'app_pages.dart';

abstract class Routes {
  static const splashPage = _Paths.splashPage;
  static const landingPage = _Paths.landingPage;
  static const homePage = _Paths.homePage;
  static const templateForm = _Paths.templateForm;
  static const businessCreate = _Paths.businessCreate;
  static const profile = _Paths.profile;
  static const inventory = _Paths.inventory;
  static const categories = _Paths.categories;
  static const bills = '/bills';
}

abstract class _Paths {
  static const splashPage = '/splashPage';
  static const landingPage = '/landing';
  static const homePage = '/homePage';
  static const templateForm = '/templateForm';
  static const businessCreate = '/businessCreate';
  static const profile = '/profile';
  static const inventory = '/inventory';
  static const categories = '/categories';
  static const bills = '/bills';
}
