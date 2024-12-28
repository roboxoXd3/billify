import 'package:billify/UI/binding/business_binding.dart';
import 'package:billify/UI/binding/home_binding.dart';
import 'package:billify/UI/binding/profile_binding.dart';
import 'package:billify/UI/binding/splash_binding.dart';
import 'package:billify/UI/binding/template_binding.dart';
import 'package:billify/UI/view/business_create.dart';
import 'package:billify/UI/view/home.dart';
import 'package:billify/UI/view/profile.dart';
import 'package:billify/UI/view/splash_view.dart';
import 'package:billify/UI/view/template_form.dart';
import 'package:get/get.dart';

part 'routes.dart';

class AppPages {
  static var transitionDuration = const Duration(milliseconds: 250);
  static const initial = Routes.splashPage;

  static final pages = [
    GetPage<dynamic>(
        name: _Paths.splashPage,
        page: SplashView.new,
        binding: SplashBinding(),
        transition: Transition.fadeIn,
        transitionDuration: transitionDuration),
    GetPage<dynamic>(
        name: _Paths.homePage,
        page: HomeView.new,
        binding: HomeBinding(),
        transition: Transition.fadeIn,
        transitionDuration: transitionDuration),
    GetPage<dynamic>(
        name: _Paths.templateForm,
        page: TemplateFormView.new,
        binding: TemplateFormBinding(),
        transition: Transition.fadeIn,
        transitionDuration: transitionDuration),
    GetPage<dynamic>(
        name: _Paths.businessCreate,
        page: BusinessCreateView.new,
        binding: BusinessBinding(),
        transition: Transition.fadeIn,
        transitionDuration: transitionDuration),
    GetPage<dynamic>(
        name: _Paths.profile,
        page: ProfileScreen.new,
        binding: ProfileBinding(),
        transition: Transition.fadeIn,
        transitionDuration: transitionDuration),
  ];
}
