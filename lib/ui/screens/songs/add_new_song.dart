import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icoc_admin_pannel/constants.dart';
import 'package:icoc_admin_pannel/domain/helpers/calculate_song_number.dart';
import 'package:icoc_admin_pannel/domain/model/notifications/notifications_model.dart';
import 'package:icoc_admin_pannel/domain/model/resources.dart';
import 'package:icoc_admin_pannel/domain/model/song_detail.dart';
import 'package:icoc_admin_pannel/injection.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/notifications/notifications_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/songs/songs_bloc.dart';
import 'package:icoc_admin_pannel/ui/screens/songs/widgets/add_song_block.dart';
import 'package:icoc_admin_pannel/ui/widget/alert_dialog.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';

class AddNewSongScreen extends StatefulWidget {
  const AddNewSongScreen({
    super.key,
  });

  @override
  State<AddNewSongScreen> createState() => _AddNewSongScreenState();
}

class _AddNewSongScreenState extends State<AddNewSongScreen> {
  final List<Map<String, dynamic>> _isOpen = [
    {'isOpen': true, 'key': GlobalKey<FormState>()}
  ];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController langController = TextEditingController()..text = 'en';
  TextEditingController textController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  SongDetail song = SongDetail.defaultSong();
  final ValueNotifier<bool> _sendNotificationNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    getIt<SongsBloc>().add(const SongsEvent.get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Builder(builder: (context) {
                      final state = context.watch<SongsBloc>().state;
                      state.whenOrNull(
                        initial: () =>
                            getIt<SongsBloc>().add(const SongsEvent.get()),
                        success: (songs) => song =
                            song.copyWith(id: calculateLastNumber(songs) + 1),
                      );
                      return Text('Song number: ${song.id}');
                    }),
                    _buildSendNotificationCheckBox(),
                    const Spacer(),
                    _buttonsBlock(context)
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _isOpen.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        initiallyExpanded: _isOpen[index]['isOpen'],
                        title: Text('Version ${index + 1}'),
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            height: _isOpen[index]['isOpen'] ? null : 0,
                            child: AddSongBlock(
                              formKey: _isOpen[index]['key'],
                              langController: langController,
                              titleController: titleController,
                              descriptionController: descriptionController,
                              textController: textController,
                              urlController: urlController,
                            ),
                          ),
                        ],
                        onExpansionChanged: (value) {
                          setState(() {
                            _isOpen[index]['isOpen'] = value;
                            _isOpen[index]['key'] = GlobalKey<FormState>();
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buttonsBlock(
    BuildContext context,
  ) {
    return Row(
      children: [
        MyTextButton(
          onPressed: () async {
            final currentKey =
                _isOpen.firstWhere((item) => item['isOpen'] == true)['key']
                    as GlobalKey<FormState>;
            if (currentKey.currentState!.validate()) {
              final res = await showAlertDialog(context,
                  'The language of the version is ${languagesCodes[langController.text]}, correct?',
                  showCancelButton: true);
              if (res) {
                _addToSong();
                // log(song.toJson());
                setState(
                  () {
                    _isOpen[_isOpen.length - 1]['isOpen'] = false;
                    _isOpen
                        .add({'isOpen': true, 'key': GlobalKey<FormState>()});
                    titleController.clear();
                    descriptionController.clear();
                    textController.clear();
                    urlController.clear();
                  },
                );
              }
            }
          },
          label: 'Add Version',
        ),
        const SizedBox(
          width: 16,
        ),
        MyTextButton(
          onPressed: () async {
            final currentKey =
                _isOpen.firstWhere((item) => item['isOpen'] == true)['key']
                    as GlobalKey<FormState>;
            if (currentKey.currentState!.validate()) {
              final res = await showAlertDialog(context,
                  'The language of the version is ${languagesCodes[langController.text]}, correct?',
                  showCancelButton: true);
              if (res) {
                _addToSong();
                getIt<SongsBloc>().add(SongsEvent.add(
                    user: context.read<AuthBloc>().icocUser, song: song));
                getIt<SongsBloc>().currentSong.value = song;
                if (_sendNotificationNotifier.value) {
                  _sendNotifications();
                }
                context.pop();
              }
            }
          },
          label: 'Save',
        ),
      ],
    );
  }

  void _addToSong() {
    List<Resources>? resources;
    final title = song.title..[langController.text] = titleController.text;
    final text = song.text..['${langController.text}1'] = textController.text;
    final description = song.description ?? {};
    description[langController.text] = descriptionController.text;

    if (urlController.text.isNotEmpty) {
      resources = song.resources ?? [];
      resources.add(Resources(
          lang: langController.text,
          title: titleController.text,
          link: urlController.text));
    }
    song = song.copyWith(
        title: title,
        text: text,
        description: description,
        resources: resources);
  }

  Widget _buildSendNotificationCheckBox() {
    return Row(
      children: [
        const SizedBox(width: 50),
        ValueListenableBuilder<bool>(
          valueListenable: _sendNotificationNotifier,
          builder: (context, value, child) {
            return Checkbox(
              value: value,
              onChanged: (newValue) {
                _sendNotificationNotifier.value = newValue!;
              },
            );
          },
        ),
        const Text('Send notifications.'),
        const SizedBox(width: 5),
        const Tooltip(
          message: 'Notify users about new song',
          child: Icon(Icons.help_outline, size: 16),
        ),
      ],
    );
  }

  void _sendNotifications() {
    final user = context.read<AuthBloc>().icocUser;
    //get languages from song
    final Set<String> allLanguages = {};
    allLanguages.addAll(song.getAllTitleKeys());

    final notification = NotificationsModel(
      id: DateTime.now().toString(),
      notifications: allLanguages.toList().asMap().entries.map((entry) {
        final translatedNotification =
            getTranslatedNotification(entry.value, song.title[entry.value]);
        return NotificationVersion(
          id: '${entry.key + 1}',
          title: translatedNotification['title']!,
          text: translatedNotification['text']!,
          lang: entry.value,
        );
      }).toList(),
    );
    getIt<NotificationsBloc>().add(NotificationsEvent.add(
        user: user, notification: notification, aditionalLanguages: []));
  }
}

Map<String, String> getTranslatedNotification(
    String languageCode, String songTitle) {
  switch (languageCode) {
    case 'en':
      return {
        'title': 'A new song added!',
        'text':
            'Hey! The song "$songTitle" has been added! Tap below to open it!'
      };
    case 'et':
      return {
        'title': 'Lisatud uus laul!',
        'text':
            'Hei! Laul "$songTitle" on lisatud! Puuduta allpool, et seda avada!'
      };
    case 'fr':
      return {
        'title': 'Une nouvelle chanson ajoutée !',
        'text':
            'Hé ! La chanson "$songTitle" a été ajoutée ! Appuyez ci-dessous pour l\'ouvrir !'
      };
    case 'de':
      return {
        'title': 'Ein neues Lied wurde hinzugefügt!',
        'text':
            'Hey! Das Lied "$songTitle" wurde hinzugefügt! Tippe unten, um es zu öffnen!'
      };
    case 'bg':
      return {
        'title': 'Добавена е нова песен!',
        'text':
            'Хей! Песента "$songTitle" беше добавена! Докоснете по-долу, за да я отворите!'
      };
    case 'it':
      return {
        'title': 'Una nuova canzone aggiunta!',
        'text':
            'Ehi! La canzone "$songTitle" è stata aggiunta! Tocca qui sotto per aprirla!'
      };
    case 'lv':
      return {
        'title': 'Pievienota jauna dziesma!',
        'text':
            'Hei! Dziesma "$songTitle" ir pievienota! Pieskarieties zemāk, lai to atvērtu!'
      };
    case 'lt':
      return {
        'title': 'Pridėta nauja daina!',
        'text':
            'Sveiki! Daina "$songTitle" buvo pridėta! Bakstelėkite žemiau, kad ją atidarytumėte!'
      };
    case 'no':
      return {
        'title': 'En ny sang lagt til!',
        'text':
            'Hei! Sangen "$songTitle" har blitt lagt til! Trykk nedenfor for å åpne den!'
      };
    case 'pl':
      return {
        'title': 'Dodano nową piosenkę!',
        'text':
            'Hej! Piosenka "$songTitle" została dodana! Kliknij poniżej, aby ją otworzyć!'
      };
    case 'ro':
      return {
        'title': 'O nouă melodie adăugată!',
        'text':
            'Hei! Melodia "$songTitle" a fost adăugată! Apasă mai jos pentru a o deschide!'
      };
    case 'ru':
      return {
        'title': 'Добавлена новая песня!',
        'text':
            'Привет! Песня "$songTitle" была добавлена! Нажмите ниже, чтобы открыть ее!'
      };
    case 'es':
      return {
        'title': '¡Se ha añadido una nueva canción!',
        'text':
            '¡Hola! ¡La canción "$songTitle" ha sido añadida! ¡Toca abajo para abrirla!'
      };
    case 'sv':
      return {
        'title': 'En ny sång har lagts till!',
        'text':
            'Hej! Sången "$songTitle" har lagts till! Tryck nedan för att öppna den!'
      };
    case 'uk':
      return {
        'title': 'Додано нову пісню!',
        'text':
            'Привіт! Пісню "$songTitle" було додано! Натисніть нижче, щоб відкрити її!'
      };
    case 'sk':
      return {
        'title': 'Pridaná nová pieseň!',
        'text':
            'Ahoj! Pieseň "$songTitle" bola pridaná! Klikni nižšie, aby si ju otvoril!'
      };
    case 'sl':
      return {
        'title': 'Dodana nova pesem!',
        'text':
            'Živjo! Pesem "$songTitle" je bila dodana! Tapnite spodaj, da jo odprete!'
      };
    case 'fi':
      return {
        'title': 'Uusi laulu lisätty!',
        'text':
            'Hei! Laulu "$songTitle" on lisätty! Napauta alla avataksesi sen!'
      };
    case 'al':
      return {
        'title': 'U shtua një këngë e re!',
        'text':
            'Përshëndetje! Kënga "$songTitle" është shtuar! Prekni më poshtë për ta hapur!'
      };
    case 'be':
      return {
        'title': 'Дададзена новая песня!',
        'text':
            'Прывітанне! Песня "$songTitle" была дададзена! Націсніце ніжэй, каб адкрыць яе!'
      };
    case 'bs':
      return {
        'title': 'Dodana nova pjesma!',
        'text':
            'Hej! Pjesma "$songTitle" je dodana! Dodirnite ispod da je otvorite!'
      };
    case 'ca':
      return {
        'title': 'S\'ha afegit una nova cançó!',
        'text':
            'Hola! La cançó "$songTitle" s\'ha afegit! Toca a sota per obrir-la!'
      };
    case 'hr':
      return {
        'title': 'Dodana je nova pjesma!',
        'text':
            'Hej! Pjesma "$songTitle" je dodana! Dodirnite ispod da je otvorite!'
      };
    case 'cz':
      return {
        'title': 'Přidána nová píseň!',
        'text':
            'Ahoj! Píseň "$songTitle" byla přidána! Klepněte níže pro její otevření!'
      };
    case 'nl':
      return {
        'title': 'Een nieuw lied toegevoegd!',
        'text':
            'Hé! Het lied "$songTitle" is toegevoegd! Tik hieronder om het te openen!'
      };
    case 'gr':
      return {
        'title': 'Προστέθηκε ένα νέο τραγούδι!',
        'text':
            'Γεια! Το τραγούδι "$songTitle" προστέθηκε! Πατήστε παρακάτω για να το ανοίξετε!'
      };
    case 'hu':
      return {
        'title': 'Új dal hozzáadva!',
        'text':
            'Szia! A "$songTitle" dal hozzá lett adva! Koppints alább, hogy megnyisd!'
      };
    case 'is':
      return {
        'title': 'Nýtt lag bætt við!',
        'text':
            'Hæ! Lagið "$songTitle" hefur verið bætt við! Ýttu hér fyrir neðan til að opna það!'
      };
    case 'ga':
      return {
        'title': 'Amhrán nua curtha leis!',
        'text':
            'Haigh! Cuireadh an t-amhrán "$songTitle" leis! Tapáil thíos chun é a oscailt!'
      };
    case 'lb':
      return {
        'title': 'En neit Lidd bäigesat!',
        'text':
            'Moien! D\'Lidd "$songTitle" gouf bäigesat! Dréckt hei drënner fir et opzemaachen!'
      };
    case 'mk':
      return {
        'title': 'Додадена е нова песна!',
        'text':
            'Здраво! Песната "$songTitle" е додадена! Допрете подолу за да ја отворите!'
      };
    case 'pt':
      return {
        'title': 'Uma nova música foi adicionada!',
        'text':
            'Olá! A música "$songTitle" foi adicionada! Toque abaixo para abri-la!'
      };
    case 'sr':
      return {
        'title': 'Додата је нова песма!',
        'text':
            'Здраво! Песма "$songTitle" је додата! Додирните испод да је отворите!'
      };
    default:
      return {
        'title': 'A new song added!',
        'text':
            'Hey! The song "$songTitle" has been added! Tap below to open it!'
      };
  }
}
