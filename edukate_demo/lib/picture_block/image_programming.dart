import 'package:flutter/material.dart';

class ImageProgrammingPage extends StatefulWidget {
  const ImageProgrammingPage({super.key});

  @override
  _ImageProgrammingPageState createState() => _ImageProgrammingPageState();
}

class _ImageProgrammingPageState extends State<ImageProgrammingPage> with SingleTickerProviderStateMixin {
  List<String> commandImages = [];
  List<String> arrangedCommands = []; // Store commands that are arranged
  String selectedCategory = 'Move'; // Default category is "Move"
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  bool _isPreviewVisible = false; // Control visibility of the preview screen

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(
      begin: 0, // Initial value, preview screen not visible
      end: 1.0 / 3.0, // End value, preview screen occupies one-third of the screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    updateCommands(selectedCategory); // Load default command images on initialization
  }

  void updateCommands(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'Move') {
        commandImages = [
          'assets/move_down.png',
          'assets/move_up.png',
          'assets/move_left.png',
          'assets/move_right.png'
        ];
      } else if (category == 'Event') {
        commandImages = [
          'assets/event1.png',
        ];
      } else if (category == 'Control') {
        commandImages = [
          'assets/control1.png',
        ];
      } else if (category == 'Sound') {
        commandImages = [
          'assets/sound1.png',
        ];
      } else {
        commandImages = [];
      }
    });
  }

  void togglePreview() {
    setState(() {
      _isPreviewVisible = !_isPreviewVisible;
      if (_isPreviewVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Programming Interface'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: _isPreviewVisible ? 2 : 3,
            child: Column(
              children: [
                // Top button panel
                Row(
                  children: [
                    // Command selection button panel
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () => updateCommands('Move'),
                            child: const Text('Move'),
                          ),
                          ElevatedButton(
                            onPressed: () => updateCommands('Event'),
                            child: const Text('Event'),
                          ),
                          ElevatedButton(
                            onPressed: () => updateCommands('Control'),
                            child: const Text('Control'),
                          ),
                          ElevatedButton(
                            onPressed: () => updateCommands('Sound'),
                            child: const Text('Sound'),
                          ),
                        ],
                      ),
                    ),
                    // Run and Stop buttons panel
                    Container(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Run functionality
                            },
                            child: const Text('Run'),
                          ),
                          const SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Stop functionality
                            },
                            child: const Text('Stop'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Display command images
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: commandImages.length,
                    itemBuilder: (context, index) {
                      return Draggable<String>(
                        data: commandImages[index],
                        child: SizedBox(
                          width: 50, // Set width
                          height: 50, // Set height
                          child: Image.asset(
                            commandImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 50, // Set width
                            height: 50, // Set height
                            child: Image.asset(
                              commandImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        childWhenDragging: SizedBox(
                          width: 50, // Set width
                          height: 50, // Set height
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Dragging...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // User arrangement area
                Container(
                  height: 450,
                  color: Colors.grey[300],
                  child: DragTarget<String>(
                    onAccept: (data) {
                      setState(() {
                        arrangedCommands.add(data);
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6, // Adjust to fit your layout
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: arrangedCommands.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 50, // Set width
                            height: 50, // Set height
                            child: Image.asset(
                              arrangedCommands[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Preview screen
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * _widthAnimation.value,
                child: Container(
                  color: Colors.blueAccent,
                  child: const Center(child: Text('Preview Area')),
                ),
              );
            },
          ),
        ],
      ),
      // Floating action button for preview control
      floatingActionButton: FloatingActionButton(
        onPressed: togglePreview,
        child: const Icon(Icons.preview),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}