class AssetsUtils {
  AssetsUtils._(); //singleton, private constructor, so can't create instance of the class

  static const String _imagesPath = 'assets/images';
  static const String backgroundSVG = '$_imagesPath/background.svg';
  static const String logoSVG = '$_imagesPath/logo.svg';
  static const String ostadLogoSVG = '$_imagesPath/ostad-logo.svg';
  static const String appLogoPNG = '$_imagesPath/app-logo.png';
  static const String placeholderPNG = '$_imagesPath/no-pp.png';
}