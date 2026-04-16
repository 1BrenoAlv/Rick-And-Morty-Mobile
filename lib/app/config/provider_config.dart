import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rick_and_morty_mobile/app/viewmodels/character_viewmodel.dart';

class ProviderConfig {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => CharacterViewmodel()),
  ];
}
