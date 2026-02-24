import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:icoc_admin_pannel/domain/helpers/extract_text_from_html.dart';
import 'package:icoc_admin_pannel/domain/model/bible_study/bible_study.dart';
import 'package:icoc_admin_pannel/ui/bloc/auth/auth_bloc.dart';
import 'package:icoc_admin_pannel/ui/bloc/bible_study/bible_study_bloc.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_button.dart';
import 'package:icoc_admin_pannel/ui/widget/my_text_field.dart';

class EditLessonScreen extends StatefulWidget {
  const EditLessonScreen({
    super.key,
  });

  @override
  State<EditLessonScreen> createState() => _EditLessonScreenState();
}

class _EditLessonScreenState extends State<EditLessonScreen> {
  // UI layout constants
  static const double _editorHeightOffset = 180;
  static const double _minEditorHeight = 420;

  static const List<Color> _primaryColors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.brown,
  ];
  Color _lastTextColor = Colors.black;
  Color _lastHighlightColor = Colors.yellow;

  final TextEditingController titleController = TextEditingController();
  final HtmlEditorController textController = HtmlEditorController();
  final _formKey = GlobalKey<FormState>();
  BibleStudy currentBibleStudy = BibleStudy.defaultBibleStudy;
  Lesson currentLesson = Lesson.defaultLesson;
  String? _editorError;
  String _initialLessonHtml = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;

    final state = context.read<BibleStudyBloc>().state;
    state.maybeWhen(
      success: (_) {},
      orElse: () {
        context.go('/bible-study');
        return;
      },
    );

    currentBibleStudy = context.read<BibleStudyBloc>().currentBibleStudy.value;
    currentLesson = context.read<BibleStudyBloc>().currentLesson.value;
    _initialLessonHtml = currentLesson.text;
    titleController.text = currentLesson.title;
    _isInitialized = true;
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editorHeight = _editorHeight(context);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Text('Lesson number: ${currentLesson.id + 1}'),
                const Spacer(),
                const Text(
                  'Edit lesson',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                _buttonsBlock(currentBibleStudy)
              ],
            ),
            MyTextField(
              controller: titleController,
              hint: 'Title',
              maxLength: 50,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            _toolbarRow(),
            if (_editorError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _editorError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: HtmlEditor(
                controller: textController,
                htmlEditorOptions: HtmlEditorOptions(
                  autoAdjustHeight: false,
                  hint: 'Lesson text',
                  shouldEnsureVisible: true,
                  initialText: _initialLessonHtml,
                  customOptions: 'tooltip: true,',
                  webInitialScripts: UnmodifiableListView<WebScript>([
                    WebScript(
                      name: 'copyStyle',
                      script: _copyStyleScript(),
                    ),
                    WebScript(
                      name: 'pasteStyle',
                      script: _pasteStyleScript(),
                    ),
                  ]),
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  allowImagePicking: false,
                  toolbarPosition: ToolbarPosition.aboveEditor,
                  toolbarType: ToolbarType.nativeScrollable,
                  defaultToolbarButtons: [
                    StyleButtons(),
                    FontSettingButtons(fontSizeUnit: false),
                    FontButtons(),
                    ListButtons(),
                    ParagraphButtons(
                        textDirection: false, caseConverter: false),
                    InsertButtons(
                      audio: false,
                      video: false,
                    ),
                    OtherButtons(
                      copy: false,
                      paste: false,
                      help: false,
                    ),
                  ],
                ),
                otherOptions: OtherOptions(
                  height: editorHeight,
                ),
                callbacks: Callbacks(
                  onChangeContent: (_) {
                    if (_editorError != null && mounted) {
                      setState(() => _editorError = null);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Row _buttonsBlock(
    BibleStudy currentBibleStudy,
  ) {
    return Row(
      children: [
        MyTextButton(
          onPressed: () {
            context.pop();
          },
          label: 'Cancel',
        ),
        const SizedBox(
          width: 16,
        ),
        MyTextButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final lessonHtml = await textController.getText();
            if (!mounted) return;
            if (!_hasLessonContent(lessonHtml)) {
              setState(
                () => _editorError = 'Please enter the text in HTML format',
              );
              return;
            }

            setState(() => _editorError = null);

            final updatedLesson = Lesson(
              title: titleController.text,
              text: lessonHtml,
              id: currentLesson.id,
            );

            final lessons = currentBibleStudy.lessons
                .map((lesson) =>
                    lesson.id == currentLesson.id ? updatedLesson : lesson)
                .toList()
              ..sort((a, b) => a.id.compareTo(b.id));

            final updatedBibleStudy = currentBibleStudy.copyWith(
              lessons: lessons,
            );

            context.read<BibleStudyBloc>().add(
                  BibleStudyEvent.editLesson(
                    user: context.read<AuthBloc>().icocUser,
                    bibleStudy: updatedBibleStudy,
                  ),
                );

            if (!mounted) return;
            context.pop();
          },
          label: 'Save',
        ),
      ],
    );
  }

  Widget _toolbarRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Copy/Paste Style buttons
          Tooltip(
            message: 'Copy style',
            child: IconButton(
              onPressed: _copyStyle,
              icon: const Icon(Icons.format_paint_outlined, size: 20),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          Tooltip(
            message: 'Paste style',
            child: IconButton(
              onPressed: _pasteStyle,
              icon: const Icon(Icons.format_color_fill_outlined, size: 20),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
          const SizedBox(width: 16),
          // Text color
          Text('Text:', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 4),
          ..._primaryColors.map((color) => _colorButton(
                color: color,
                isSelected: color.toARGB32() == _lastTextColor.toARGB32(),
                onTap: () => _applyTextColor(color),
              )),
          const SizedBox(width: 16),
          // Highlight color
          Text('Highlight:', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 4),
          ..._primaryColors.map((color) => _colorButton(
                color: color,
                isSelected: color.toARGB32() == _lastHighlightColor.toARGB32(),
                onTap: () => _applyHighlightColor(color),
              )),
        ],
      ),
    );
  }

  Widget _colorButton({
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade400,
              width: isSelected ? 2.5 : 1,
            ),
          ),
        ),
      ),
    );
  }

  void _applyTextColor(Color color) {
    textController.execCommand('foreColor', argument: _toCommandHex(color));
    setState(() => _lastTextColor = color);
  }

  void _applyHighlightColor(Color color) {
    textController.execCommand('hiliteColor', argument: _toCommandHex(color));
    setState(() => _lastHighlightColor = color);
  }

  String _toCommandHex(Color color) {
    return '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  bool _hasLessonContent(String html) {
    final text = FormatTextHelper.extractFormattedText(html).trim();
    final hasMedia = RegExp(
      r'<(img|iframe|video|audio|table|hr)\b',
      caseSensitive: false,
    ).hasMatch(html);
    return text.isNotEmpty || hasMedia;
  }

  double _editorHeight(BuildContext context) {
    final fullHeight = MediaQuery.of(context).size.height;
    final calculatedHeight = fullHeight - _editorHeightOffset;
    if (calculatedHeight < _minEditorHeight) {
      return _minEditorHeight;
    }
    return calculatedHeight;
  }

  Future<void> _copyStyle() async {
    final response = await _runWebScript(
      'copyStyle',
      hasReturnValue: true,
    );
    if (!mounted) return;
    final copied =
        response is Map<String, dynamic> && response['copied'] == true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          copied ? 'Style copied' : 'Select text first to copy style',
        ),
      ),
    );
  }

  Future<void> _pasteStyle() async {
    final response = await _runWebScript(
      'pasteStyle',
      hasReturnValue: true,
    );
    if (!mounted) return;
    final pasted =
        response is Map<String, dynamic> && response['applied'] == true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pasted ? 'Style applied' : 'Copy style first',
        ),
      ),
    );
  }

  Future<dynamic> _runWebScript(
    String scriptName, {
    bool hasReturnValue = false,
  }) async {
    if (!kIsWeb) return null;
    return textController.evaluateJavascriptWeb(
      scriptName,
      hasReturnValue: hasReturnValue,
    );
  }

  String _copyStyleScript() {
    return '''
      (function () {
        var selection = window.getSelection();
        if (!selection || selection.rangeCount === 0 || selection.isCollapsed) {
          window.parent.postMessage(JSON.stringify({'type': 'toDart: copyStyle', 'copied': false}), '*');
          return;
        }
        var node = selection.anchorNode;
        if (!node) {
          window.parent.postMessage(JSON.stringify({'type': 'toDart: copyStyle', 'copied': false}), '*');
          return;
        }
        var element = node.nodeType === Node.TEXT_NODE ? node.parentElement : node;
        if (!element) {
          window.parent.postMessage(JSON.stringify({'type': 'toDart: copyStyle', 'copied': false}), '*');
          return;
        }
        var computed = window.getComputedStyle(element);
        var styles = {};
        styles.color = computed.color;
        styles.backgroundColor = computed.backgroundColor;
        styles.fontFamily = computed.fontFamily;
        styles.fontSize = computed.fontSize;
        styles.fontWeight = computed.fontWeight;
        styles.fontStyle = computed.fontStyle;
        styles.textDecoration = computed.textDecoration;
        window._icocCopiedStyles = styles;
        window.parent.postMessage(JSON.stringify({'type': 'toDart: copyStyle', 'copied': true}), '*');
      })();
    ''';
  }

  String _pasteStyleScript() {
    return '''
      (function () {
        var styles = window._icocCopiedStyles;
        var selection = window.getSelection();
        if (!styles || !selection || selection.rangeCount === 0) {
          window.parent.postMessage(JSON.stringify({'type': 'toDart: pasteStyle', 'applied': false}), '*');
          return;
        }
        
        var range = selection.getRangeAt(0);
        if (!range || range.collapsed) {
          window.parent.postMessage(JSON.stringify({'type': 'toDart: pasteStyle', 'applied': false}), '*');
          return;
        }
        
        // Extract content and wrap in span with styles
        var fragment = range.extractContents();
        var span = document.createElement('span');
        
        // Apply styles
        if (styles.color) span.style.color = styles.color;
        if (styles.backgroundColor && styles.backgroundColor !== 'rgba(0, 0, 0, 0)') {
          span.style.backgroundColor = styles.backgroundColor;
        }
        if (styles.fontFamily) span.style.fontFamily = styles.fontFamily;
        if (styles.fontSize) span.style.fontSize = styles.fontSize;
        if (styles.fontWeight) span.style.fontWeight = styles.fontWeight;
        if (styles.fontStyle) span.style.fontStyle = styles.fontStyle;
        if (styles.textDecoration && styles.textDecoration !== 'none') {
          span.style.textDecoration = styles.textDecoration;
        }
        
        span.appendChild(fragment);
        range.insertNode(span);
        
        // Restore selection
        selection.removeAllRanges();
        var newRange = document.createRange();
        newRange.selectNodeContents(span);
        selection.addRange(newRange);
        
        window.parent.postMessage(JSON.stringify({'type': 'toDart: pasteStyle', 'applied': true}), '*');
      })();
    ''';
  }
}
