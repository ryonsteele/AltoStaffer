import 'Specs.dart';

class SpecsList {
  List<Specs> specs;

  SpecsList(
      List<Specs> specs
      ){
    this.specs = specs;
  }

  List<Specs> get results => this.specs;
  set results(List<Specs> specs) => this.specs = specs;
}