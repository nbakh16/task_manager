class AssetsUtils {
  AssetsUtils._(); //singleton, private constructor, so can't create instance of the class

  static const String _imagesPath = 'assets/images';
  static const String backgroundSVG = '$_imagesPath/background.svg';
  static const String logoSVG = '$_imagesPath/logo.svg';

  static const String _iconsPath = 'assets/icons';
  static const String forwardPNG = '$_iconsPath/forward.png';
}