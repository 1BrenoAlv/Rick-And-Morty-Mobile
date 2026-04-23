import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_mobile/app/config/colors.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/widgets/character_card.dart';
import 'package:rick_and_morty_mobile/app/view/pages/home-page/widgets/drawer_home.dart';
import 'package:rick_and_morty_mobile/app/viewmodels/character_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharacterViewmodel>().fetchCharacters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoSize = (size.width * 0.13).clamp(40.0, 65.0);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Row(
            children: [
              SizedBox(
                width: logoSize,
                height: logoSize,
                child: ClipRRect(
                  borderRadius: AppColors.borderRadiusCard,
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Flexible(
                child: Text(
                  'Rick And Morty Explorer',
                  style: TextStyle(
                    fontSize: (size.width * 0.052).clamp(18.0, 24.0),
                    color: AppColors.bgColor,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu, color: AppColors.bgColor),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: (size.width * 0.80).clamp(250.0, 360.0),
        child: const DrawerHome(),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => context.read<CharacterViewmodel>().fetchCharacters(),
        child: Container(
          color: AppColors.bgMain,
          child: Consumer<CharacterViewmodel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.bgAside),
                );
              }

              if (viewModel.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          size: 80,
                          color: AppColors.colorBorder,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          viewModel.error!,
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgAside,
                            foregroundColor: AppColors.bgColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppColors.borderRadiusCard,
                            ),
                          ),
                          onPressed: () => viewModel.fetchCharacters(),
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Tentar Novamente',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (viewModel.isFilterLoading && viewModel.characters.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 80,
                          color: AppColors.colorBorder,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nenhum personagem encontrado com esses filtros.',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryColor,
                            side: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppColors.borderRadiusCard,
                            ),
                          ),
                          onPressed: () => viewModel.clearFilter(),
                          icon: const Icon(Icons.filter_alt_off),
                          label: const Text(
                            'Limpar Filtros',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildBody(viewModel),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppColors.colorBorder, width: 1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed:
                              (viewModel.isLoading || viewModel.prevBtn == null)
                              ? null
                              : () => viewModel.previousPage(),
                          icon: Icon(
                            Icons.arrow_back,
                            color:
                                (viewModel.isLoading ||
                                    viewModel.prevBtn == null)
                                ? AppColors.colorBorder
                                : AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          'Página ${viewModel.currentPage} de ${viewModel.pageTotal ?? ''} ',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed:
                              (viewModel.isLoading || viewModel.nextBtn == null)
                              ? null
                              : () => viewModel.nextPage(),
                          icon: Icon(
                            Icons.arrow_forward,
                            color:
                                (viewModel.isLoading ||
                                    viewModel.nextBtn == null)
                                ? AppColors.colorBorder
                                : AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CharacterViewmodel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int crossAxisCount = (width / 180).floor();
        if (crossAxisCount < 2) crossAxisCount = 2;

        final double totalSpacing = (crossAxisCount - 1) * 12.0;
        final double itemWidth = (width - totalSpacing) / crossAxisCount;

        final double itemHeight = itemWidth + 84.0;
        final double aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemCount: viewModel.characters.length,
          itemBuilder: (context, index) {
            return CharacterCard(character: viewModel.characters[index]);
          },
        );
      },
    );
  }
}
