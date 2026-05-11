import 'package:flutter/material.dart';

const String skillSectionTitle = 'The tools I use to design, build, and ship products.';
const String skillSectionDescription =
    'The stack is organized by delivery function so recruiters, collaborators, and clients can quickly understand where I contribute across UI, backend, and ML implementation.';

const Map<String, ({IconData icon, String summary})> skillCategoryMeta = {
  'Programming Languages': (
    icon: Icons.code_rounded,
    summary:
        'Core languages used for application logic, data handling, and systems work.',
  ),
  'App Development': (
    icon: Icons.phone_android_rounded,
    summary:
        'Cross-platform interface work focused on fluid, maintainable user experiences.',
  ),
  'Backend Development': (
    icon: Icons.dns_rounded,
    summary:
        'Lightweight service layers, API design, and integration-friendly backend tooling.',
  ),
  'AI / ML Frameworks': (
    icon: Icons.psychology_alt_rounded,
    summary:
        'Libraries used for training, inference, real-time detection, and experimentation.',
  ),
  'Databases & Platforms': (
    icon: Icons.storage_rounded,
    summary:
        'Persistence, managed services, and supporting cloud tools for product delivery.',
  ),
  'Deployment & Hosting': (
    icon: Icons.rocket_launch_rounded,
    summary:
        'Platforms used to ship builds, backend services, and working demos quickly.',
  ),
  'Design & Prototyping': (
    icon: Icons.design_services_rounded,
    summary:
        'Interface planning and iteration tools that support product polish and handoff.',
  ),
};

const Map<String, List<Map<String, String>>> categorizedSkills = {
  "Programming Languages": [
    {"img": "assets/skillIcons/python.svg", "title": "Python"},
    {"img": "assets/skillIcons/c.svg", "title": "C"},
    {"img": "assets/skillIcons/cpp.svg", "title": "C++"},
    {"img": "assets/skillIcons/dart.svg", "title": "Dart"},
    {"img": "assets/skillIcons/sql.svg", "title": "SQL"},
  ],
  "App Development": [
    {"img": "assets/skillIcons/flutter.svg", "title": "Flutter"},
  ],
  "Backend Development": [
    {"img": "assets/skillIcons/flask.svg", "title": "Flask"},
    {"img": "assets/skillIcons/fastapi.svg", "title": "FastAPI"},
  ],
  "AI / ML Frameworks": [
    {"img": "assets/skillIcons/pytorch.svg", "title": "PyTorch"},
    {"img": "assets/skillIcons/tensorflow.svg", "title": "TensorFlow"},
    {"img": "assets/skillIcons/keras.svg", "title": "Keras"},
    {"img": "assets/skillIcons/mediapipe.svg", "title": "Mediapipe"},
  ],
  "Databases & Platforms": [
    {"img": "assets/skillIcons/my-sql.svg", "title": "MySQL"},
    {"img": "assets/skillIcons/postgresql.svg", "title": "PostgreSQL"},
    {"img": "assets/skillIcons/firebase.svg", "title": "Firebase"},
    {"img": "assets/skillIcons/supabase.svg", "title": "Supabase"},
    {"img": "assets/skillIcons/cloudinary.svg", "title": "Cloudinary"},
  ],
  "Deployment & Hosting": [
    {"img": "assets/skillIcons/netlify.svg", "title": "Netlify"},
    {"img": "assets/skillIcons/render.svg", "title": "Render"},
  ],
  "Design & Prototyping": [
    {"img": "assets/skillIcons/figma.svg", "title": "Figma"},
  ],
};
