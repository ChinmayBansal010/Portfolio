import 'package:flutter/material.dart';

const String skillSectionTitle =
    'Artificial intelligence, computer vision, backend systems, robotics, and intelligent product engineering.';

const String skillSectionDescription =
    'Focused on building scalable AI systems, multimodal applications, real-time inference pipelines, robotics workflows, and production-ready software products.';

const Map<String, ({IconData icon, String summary})> skillCategoryMeta = {
  'Programming Languages': (
    icon: Icons.code_rounded,
    summary:
        'Programming languages used across AI systems, backend engineering, robotics, and frontend development.',
  ),

  'Artificial Intelligence': (
    icon: Icons.psychology_alt_rounded,
    summary:
        'Machine learning, deep learning, LLM orchestration, local AI deployment, and intelligent systems.',
  ),

  'Computer Vision': (
    icon: Icons.visibility_rounded,
    summary:
        'Real-time vision systems, visual AI pipelines, inference optimization, and accelerated deployment.',
  ),

  'Frontend Engineering': (
    icon: Icons.web_rounded,
    summary:
        'Modern frontend development, responsive interfaces, component architectures, and cross-platform UI systems.',
  ),

  'Backend & Databases': (
    icon: Icons.storage_rounded,
    summary:
        'Backend architectures, APIs, cloud-integrated systems, relational databases, and scalable services.',
  ),

  'Robotics & Autonomous Systems': (
    icon: Icons.memory_rounded,
    summary:
        'Robotics middleware, autonomous systems, and hardware-integrated software engineering.',
  ),

  'Developer Tools & DevOps': (
    icon: Icons.precision_manufacturing_rounded,
    summary:
        'Version control, CI/CD pipelines, developer workflows, tooling, and engineering operations.',
  ),
};

const Map<String, List<Map<String, String>>> categorizedSkills = {
  'Programming Languages': [
    {'img': 'assets/skillIcons/python.svg', 'title': 'Python'},
    {'img': 'assets/skillIcons/c.svg', 'title': 'C'},
    {'img': 'assets/skillIcons/cpp.svg', 'title': 'C++'},
    {'img': 'assets/skillIcons/dart.svg', 'title': 'Dart'},
    {'img': 'assets/skillIcons/typescript.svg', 'title': 'TypeScript'},
    {'img': 'assets/skillIcons/javascript.svg', 'title': 'JavaScript'},
    {'img': 'assets/skillIcons/sql.svg', 'title': 'SQL'},
    {'img': 'assets/skillIcons/bash.svg', 'title': 'Bash'},
  ],

  'Artificial Intelligence': [
    {'img': 'assets/skillIcons/pytorch.svg', 'title': 'PyTorch'},
    {'img': 'assets/skillIcons/tensorflow.svg', 'title': 'TensorFlow'},
    {'img': 'assets/skillIcons/keras.svg', 'title': 'Keras'},
    {'img': 'assets/skillIcons/scikitlearn.svg', 'title': 'Scikit-learn'},
    {'img': 'assets/skillIcons/huggingface.svg', 'title': 'Hugging Face'},
    {'img': 'assets/skillIcons/ollama.svg', 'title': 'Ollama'},
    {'img': 'assets/skillIcons/langchain.svg', 'title': 'LangChain'},
    {'img': 'assets/skillIcons/langgraph.svg', 'title': 'LangGraph'},
  ],

  'Computer Vision': [
    {'img': 'assets/skillIcons/opencv.svg', 'title': 'OpenCV'},
    {'img': 'assets/skillIcons/mediapipe.svg', 'title': 'MediaPipe'},
    {'img': 'assets/skillIcons/yolo.svg', 'title': 'Ultralytics YOLO'},
    {'img': 'assets/skillIcons/onnx.svg', 'title': 'ONNX Runtime'},
    {'img': 'assets/skillIcons/tensorrt.svg', 'title': 'TensorRT'},
    {'img': 'assets/skillIcons/cuda.svg', 'title': 'CUDA'},
    {'img': 'assets/skillIcons/ffmpeg.svg', 'title': 'FFmpeg'},
    {'img': 'assets/skillIcons/deepstream.svg', 'title': 'NVIDIA DeepStream'},
    {'img': 'assets/skillIcons/dlib.svg', 'title': 'Dlib'},
  ],

  'Frontend Engineering': [
    {'img': 'assets/skillIcons/flutter.svg', 'title': 'Flutter'},
    {'img': 'assets/skillIcons/react.svg', 'title': 'React'},
    {'img': 'assets/skillIcons/reactnative.svg', 'title': 'React Native'},
    {'img': 'assets/skillIcons/kotlin.svg', 'title': 'Kotlin'},
    {'img': 'assets/skillIcons/tailwind.svg', 'title': 'Tailwind CSS'},
    {'img': 'assets/skillIcons/html.svg', 'title': 'HTML'},
    {'img': 'assets/skillIcons/css.svg', 'title': 'CSS'},
  ],

  'Backend & Databases': [
    {'img': 'assets/skillIcons/fastapi.svg', 'title': 'FastAPI'},
    {'img': 'assets/skillIcons/flask.svg', 'title': 'Flask'},
    {'img': 'assets/skillIcons/docker.svg', 'title': 'Docker'},
    {'img': 'assets/skillIcons/nginx.svg', 'title': 'Nginx'},
    {'img': 'assets/skillIcons/firebase.svg', 'title': 'Firebase'},
    {'img': 'assets/skillIcons/supabase.svg', 'title': 'Supabase'},
    {'img': 'assets/skillIcons/azure.svg', 'title': 'Microsoft Azure'},
    {'img': 'assets/skillIcons/postgresql.svg', 'title': 'PostgreSQL'},
    {'img': 'assets/skillIcons/mysql.svg', 'title': 'MySQL'},
    {'img': 'assets/skillIcons/sqlalchemy.svg', 'title': 'SQLAlchemy'},
    {'img': 'assets/skillIcons/websocket.svg', 'title': 'WebSockets'},
    {'img': 'assets/skillIcons/postman.svg', 'title': 'Postman'},
    {'icon': 'dns', 'title': 'REST APIs'},
  ],

  'Robotics & Autonomous Systems': [
    {'img': 'assets/skillIcons/ros.svg', 'title': 'ROS'},
    {'img': 'assets/skillIcons/gazebo.svg', 'title': 'Gazebo'},
    {'img': 'assets/skillIcons/raspberrypi.svg', 'title': 'Raspberry Pi'},
    {'img': 'assets/skillIcons/arduino.svg', 'title': 'Arduino'},
    {'img': 'assets/skillIcons/rviz.svg', 'title': 'RViz'},
    {'img': 'assets/skillIcons/autocad.svg', 'title': 'AutoCAD'},
  ],

  'Developer Tools & DevOps': [
    {'img': 'assets/skillIcons/git.svg', 'title': 'Git'},
    {'img': 'assets/skillIcons/github.svg', 'title': 'GitHub'},
    {'img': 'assets/skillIcons/githubactions.svg', 'title': 'GitHub Actions'},
    {'img': 'assets/skillIcons/figma.svg', 'title': 'Figma'},
    {'img': 'assets/skillIcons/linux.svg', 'title': 'Linux'},
    {'icon': 'sync', 'title': 'CI/CD'},
  ],
};
