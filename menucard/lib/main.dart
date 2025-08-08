import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Colors.black, elevation: 0),
      ),
      home: FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  bool showAnswer = false;
  final List<Map<String, String>> flashcards = [
    {"question": "What is the primary function of an operating system?", "answer": "Manages hardware and software resources"},
    {"question": "What does CPU stand for?", "answer": "Central Processing Unit"},
    {"question": "What is a binary number system?", "answer": "A base-2 number system using 0 and 1"},
    {"question": "What is the time complexity of linear search?", "answer": "O(n)"},
    {"question": "What is an array in programming?", "answer": "A collection of elements with the same data type"},
    {"question": "What does HTML stand for?", "answer": "HyperText Markup Language"},
    {"question": "What is a linked list?", "answer": "A linear data structure where elements are linked using pointers"},
    {"question": "What is the purpose of a firewall?", "answer": "To protect a network by filtering traffic"},
    {"question": "What is polymorphism in OOP?", "answer": "Ability of different classes to be treated as instances of the same class"},
    {"question": "What is a primary key in a database?", "answer": "A unique identifier for each record"},
    {"question": "What is the full form of SQL?", "answer": "Structured Query Language"},
    {"question": "What is recursion?", "answer": "A process where a function calls itself"},
    {"question": "What is a stack data structure?", "answer": "A LIFO (Last In, First Out) structure"},
    {"question": "What does API stand for?", "answer": "Application Programming Interface"},
    {"question": "What is the purpose of a compiler?", "answer": "To translate source code into machine code"},
    {"question": "What is a queue data structure?", "answer": "A FIFO (First In, First Out) structure"},
    {"question": "What is the time complexity of binary search?", "answer": "O(log n)"},
    {"question": "What is encapsulation in OOP?", "answer": "Bundling data and methods that operate on that data"},
    {"question": "What is a subnet mask?", "answer": "A 32-bit number used to divide an IP network"},
    {"question": "What is a virtual machine?", "answer": "Software that emulates a physical computer"},
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      _controller.reset();
      _controller.forward();
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No more cards!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      _controller.reset();
      _controller.forward();
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('First card!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    }
  }

  void addFlashcard(String question, String answer) {
    if (question.isNotEmpty && answer.isNotEmpty) {
      setState(() {
        flashcards.add({"question": question, "answer": answer});
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard added!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question and answer cannot be empty!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    }
  }

  void editFlashcard(int index, String question, String answer) {
    if (question.isNotEmpty && answer.isNotEmpty) {
      setState(() {
        flashcards[index] = {"question": question, "answer": answer};
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard updated!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question and answer cannot be empty!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
      );
    }
  }

  void deleteFlashcard(int index) {
    setState(() {
      if (flashcards.isNotEmpty) {
        flashcards.removeAt(index);
        if (currentIndex >= flashcards.length) currentIndex = flashcards.length - 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Flashcard deleted!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red[900]),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/netflix_logo.png', height: 30), // Add Netflix logo asset
            SizedBox(width: 10),
            Text('CSE Flashcards', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (context) => ManageFlashcardSheet(
                  onAdd: addFlashcard,
                  onEdit: (index, q, a) => editFlashcard(index, q, a),
                  onDelete: deleteFlashcard,
                  currentIndex: currentIndex,
                  flashcards: flashcards,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Center(
          child: flashcards.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'No flashcards available. Add some to start!',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 400,
                      child: Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    flashcards[currentIndex]["question"]!,
                                    style: Theme.of(context).textTheme.headlineLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  AnimatedOpacity(
                                    opacity: showAnswer ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 500),
                                    child: Text(
                                      flashcards[currentIndex]["answer"]!,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: previousCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () => setState(() => showAnswer = !showAnswer),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text(showAnswer ? 'Hide' : 'Show', style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: nextCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15),
                          ),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ManageFlashcardSheet extends StatefulWidget {
  final Function(String, String) onAdd;
  final Function(int, String, String) onEdit;
  final Function(int) onDelete;
  final int currentIndex;
  final List<Map<String, String>> flashcards;

  ManageFlashcardSheet({
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.currentIndex,
    required this.flashcards,
  });

  @override
  _ManageFlashcardSheetState createState() => _ManageFlashcardSheetState();
}

class _ManageFlashcardSheetState extends State<ManageFlashcardSheet> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool isEditing = false;
  int editIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.currentIndex >= 0 && widget.currentIndex < widget.flashcards.length) {
      _questionController.text = widget.flashcards[widget.currentIndex]["question"]!;
      _answerController.text = widget.flashcards[widget.currentIndex]["answer"]!;
      isEditing = true;
      editIndex = widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      color: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEditing ? 'Edit Flashcard' : 'Add New Flashcard',
            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _questionController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Question',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _answerController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Answer',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    widget.onEdit(editIndex, _questionController.text, _answerController.text);
                  } else {
                    widget.onAdd(_questionController.text, _answerController.text);
                  }
                  _questionController.clear();
                  _answerController.clear();
                  setState(() => isEditing = false);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text(isEditing ? 'Update' : 'Add', style: TextStyle(color: Colors.white)),
              ),
              if (isEditing)
                ElevatedButton(
                  onPressed: () {
                    widget.onDelete(widget.currentIndex);
                    _questionController.clear();
                    _answerController.clear();
                    setState(() => isEditing = false);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundCologitr: Colors.grey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                ),
              ElevatedButton(
                onPressed: () {
                  _questionController.clear();
                  _answerController.clear();
                  setState(() => isEditing = false);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}