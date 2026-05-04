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
                return _buildErrorState(viewModel);
              }
              if (viewModel.errorType == ErrorType.notFound ||
                  (viewModel.isFilterLoading && viewModel.characters.isEmpty)) {
                return _buildEmptyState(viewModel);
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

  /// Retorna o ícone para cada tipo de erro.
  IconData _iconForErrorType(ErrorType? type) {
    switch (type) {
      case ErrorType.noInternet:
        return Icons.wifi_off_rounded;
      case ErrorType.timeout:
        return Icons.timer_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.tooManyRequests:
        return Icons.hourglass_empty_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.unknown:
      case null:
        return Icons.error_outline_rounded;
    }
  }

  /// Tela de erro com ícone, mensagem e botão de tentar novamente.
  Widget _buildErrorState(CharacterViewmodel viewModel) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgAside.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForErrorType(viewModel.errorType),
                  size: 72,
                  color: AppColors.bgAside.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _errorTitle(viewModel.errorType),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                viewModel.error!,
                style: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgAside,
                  foregroundColor: AppColors.bgColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppColors.borderRadiusCard,
                  ),
                  elevation: 2,
                ),
                onPressed: () => viewModel.fetchCharacters(),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Tentar Novamente',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Título contextual para cada tipo de erro.
  String _errorTitle(ErrorType? type) {
    switch (type) {
      case ErrorType.noInternet:
        return 'Sem Conexão';
      case ErrorType.timeout:
        return 'Tempo Esgotado';
      case ErrorType.server:
        return 'Servidor Indisponível';
      case ErrorType.tooManyRequests:
        return 'Limite de Requisições';
      case ErrorType.notFound:
        return 'Não Encontrado';
      case ErrorType.unknown:
      case null:
        return 'Algo deu errado';
    }
  }

  /// Tela de resultado vazio (filtros sem match).
  Widget _buildEmptyState(CharacterViewmodel viewModel) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgAside.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 72,
                  color: AppColors.bgAside.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nenhum Resultado',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Nenhum personagem encontrado com os filtros selecionados.',
                style: TextStyle(
                  color: AppColors.primaryColor.withValues(alpha: 0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppColors.borderRadiusCard,
                  ),
                ),
                onPressed: () => viewModel.clearFilter(),
                icon: const Icon(Icons.filter_alt_off_rounded, size: 20),
                label: const Text(
                  'Limpar Filtros',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
