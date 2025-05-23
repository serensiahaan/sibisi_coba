import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  String _detectedText = "Aku Makan Ayam";
  bool _isInferring = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
      });
      _initializeCamera();
    } else {
      setState(() {
        _hasPermission = false;
      });
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0], // Use front camera
          ResolutionPreset.medium,
        );
        
        await _cameraController!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
        
        // Simulate inference process
        _simulateInference();
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _simulateInference() {
    // Simulate inference for 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isInferring = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Widget _buildCameraView() {
    if (!_hasPermission) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
              SizedBox(height: 10),
              Text(
                'We need camera access...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _requestCameraPermission,
                child: Text('Grant Permission'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isCameraInitialized) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Initializing Camera...'),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          CameraPreview(_cameraController!),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD8D3F0),
              Color(0xFFC8C1E8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sibisi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A5A7A),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to settings or history
                        Navigator.pushNamed(context, '/history');
                      },
                      child: Icon(
                        Icons.settings,
                        size: 28,
                        color: Color(0xFF5A5A7A),
                      ),
                    ),
                  ],
                ),
              ),

              // Confidence score (simulated)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '86.78',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Camera view
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: _buildCameraView()),
              ),

              SizedBox(height: 20),

              // Inference status
              if (_isInferring)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5A5A7A)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Inferring...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF5A5A7A),
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 20),

              // Result text box
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isInferring)
                          Text(
                            _detectedText,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        // Additional lines for multiple results
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom navigation indicator
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Color(0xFF5A5A7A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
