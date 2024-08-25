import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/convert_languages_enum.dart';
import 'package:icoc_admin_pannel/domain/helpers/show_menu.dart';
import 'package:icoc_admin_pannel/domain/model/q&a/q&a_model.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/q&a_bloc/q&a_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/q_and_a/widget/q_and_a_card.dart';
import 'package:icoc_admin_pannel/ui/screens/q_and_a/widget/one_q_and_a.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';

class QandAScreen extends StatefulWidget {
  QandAScreen({super.key});

  @override
  State<QandAScreen> createState() => _QandAScreenState();
}

class _QandAScreenState extends State<QandAScreen> {
  final TextEditingController _searchController = TextEditingController();
  Languages activeLang = Languages.ru;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      final state = context.watch<QandABloc>().state;
      return state.when(
          initial: () {
            getIt<QandABloc>().add(QandAEvent.requested(lang: activeLang));
            return const SizedBox.shrink();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (message) => Center(child: Text(message)),
          success: (articles) {
            return Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildSearchBar(),
                          _buildLangsFilter(),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => getIt<QandABloc>()
                                    .currentQandA
                                    .value = articles[index],
                                onSecondaryTapDown: (TapDownDetails details) {
                                  showContextMenu(
                                      context,
                                      details.globalPosition,
                                      () => _deleteArticle(
                                          context, articles[index]));
                                },
                                child: ValueListenableBuilder(
                                  valueListenable:
                                      getIt<QandABloc>().currentQandA,
                                  builder: (context, article, _) {
                                    return QandACard(
                                      article: articles[index],
                                      currentQandAId: article.id,
                                    );
                                  },
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Flexible(
                    flex: 2,
                    child: ValueListenableBuilder(
                        valueListenable: context.read<QandABloc>().currentQandA,
                        builder: (context, article, _) {
                          return OneQandA(
                            article: article,
                          );
                        }))
              ],
            );
          });
    }));
  }

  Widget _buildSearchBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SearchBar(
          controller: _searchController,
          overlayColor: WidgetStateProperty.all(Theme.of(context).cardColor),
          onChanged: (value) {
            if (value.isEmpty) {
              getIt<QandABloc>().add(QandAEvent.requested(lang: activeLang));
            }
          },
          onSubmitted: (value) {
            _searchController.text = value;
            getIt<QandABloc>()
                .add(QandAEvent.requested(query: value, lang: activeLang));
          },
          leading: const Icon(Icons.search),
          shadowColor: WidgetStateColor.transparent,
          backgroundColor: WidgetStateColor.transparent,
          constraints: const BoxConstraints(maxHeight: 50),
          side: const WidgetStatePropertyAll(BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildLangsFilter() {
    final langs = getIt<QandABloc>().langs;
    return DropdownButton<String>(
      elevation: 0,
      underline: const SizedBox.shrink(),
      value: activeLang.name,
      onChanged: (String? newValue) {
        setState(() {
          activeLang = convertLanguagesEnum(newValue ?? '');
          getIt<QandABloc>().add(QandAEvent.requested(lang: activeLang));
        });
      },
      items: langs.map<DropdownMenuItem<String>>((Languages language) {
        return DropdownMenuItem<String>(
          value: language.name,
          child: Row(
            children: [
              CountryFlag.fromCountryCode(
                handleLanguage(language.name),
                width: 20,
                height: 15,
              ),
              const SizedBox(width: 8),
              Text(language.name),
            ],
          ),
        );
      }).toList(),
    );
  }

  String handleLanguage(String language) {
    if (language == 'uk') return 'ua';
    if (language == 'en') {
      return 'us';
    } else {
      return language;
    }
  }

  Future _deleteArticle(BuildContext context, QandAModel article) async {
    final result = await showAlertDialog(context,
        'Do you really want to delete  Q&A ${article.id}? Be carefull! ',
        showCancelButton: true);
    if (result) {
      getIt<QandABloc>().add(QandAEvent.delete(
          docReference: article.documentRef, user: getIt<AuthBloc>().icocUser));
      getIt<QandABloc>().currentQandA.value = QandAModel.defaultQandA;
    }
  }
}
