import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yeetfit/core/theme/app_colors.dart';
import 'package:yeetfit/core/theme/app_spacing.dart';
import 'package:yeetfit/shared/widgets/glass_icon_button.dart';
import 'package:yeetfit/shared/widgets/yeet_text_field.dart';
import '../providers/explore_provider.dart';

class ExploreHeader extends ConsumerStatefulWidget {
  const ExploreHeader({super.key});

  @override
  ConsumerState<ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends ConsumerState<ExploreHeader> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    ref.read(exploreSearchActiveProvider.notifier).setActive(true);
  }

  void _closeSearch() {
    ref.read(exploreSearchQueryProvider.notifier).clear();
    ref.read(exploreSearchActiveProvider.notifier).setActive(false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(exploreSearchActiveProvider, (previous, next) {
      if (next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focusNode.requestFocus();
        });
      } else {
        _controller.clear();
        _focusNode.unfocus();
      }
    });

    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final searchActive = ref.watch(exploreSearchActiveProvider);
    final favoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final tab = ref.watch(exploreTabProvider);
    final hint = tab == ExploreTab.diet
        ? 'Search diet plans'
        : 'Search workout plans';

    final favoritesButton = GlassIconButton(
      icon: favoritesOnly ? Icons.favorite : Icons.favorite_border,
      color: favoritesOnly ? colors.error : colors.onBackground,
      tooltip: favoritesOnly ? 'Show all plans' : 'Show favourites only',
      onPressed: () => ref.read(showFavoritesOnlyProvider.notifier).toggle(),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenEdge,
        AppSpacing.sm,
        AppSpacing.screenEdge,
        0,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: searchActive
            ? KeyedSubtree(
                key: const ValueKey('explore-search'),
                child: Row(
                  children: [
                    Expanded(
                      child: YeetTextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        hintText: hint,
                        prefixIcon: Icons.search_rounded,
                        suffixIcon: Icons.close_rounded,
                        suffixTooltip: 'Close search',
                        onSuffixTap: _closeSearch,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => ref
                            .read(exploreSearchQueryProvider.notifier)
                            .setQuery(value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    favoritesButton,
                  ],
                ),
              )
            : KeyedSubtree(
                key: const ValueKey('explore-title'),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Plans',
                            style: textTheme.headlineLarge!.copyWith(
                              color: colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Find your next workout',
                            style: textTheme.bodyMedium!.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    favoritesButton,
                    const SizedBox(width: AppSpacing.sm),
                    GlassIconButton(
                      icon: Icons.search_rounded,
                      color: colors.onBackground,
                      tooltip: 'Search',
                      onPressed: _openSearch,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
