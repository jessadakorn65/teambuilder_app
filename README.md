<<<<<<< HEAD
# pkm01
=======
# teambuilder_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# TeamBuilder App (Flutter + GetX)

แอป Flutter สำหรับสร้างทีม Pokémon โดยใช้ GetX จัดการ state  
ผู้ใช้สามารถเลือกโปเกม่อน ≥20 ตัวเพื่อจัดทีมทีมละ 3 ตัว  
พร้อมระบบธาตุ (ชนะทาง/แพ้ทาง), ความสามารถ, และการบันทึกทีมหลายชุด  

## Features
- เลือก Pokémon จาก ≥20 ตัว (พร้อมรูป official artwork)
- จำกัดการเลือกสูงสุด 3 ตัวต่อทีม
- Preview ทีม พร้อมข้อมูลธาตุที่ชนะ/แพ้ทาง
- บันทึกทีมที่จัดไว้ได้หลายชุด (Team Preset)
- ตั้งชื่อทีม / แก้ไขทีม / ลบทีม ได้
- โหลดทีมที่บันทึกไว้กลับมาใช้งานใหม่ได้

## Requirements
- Flutter SDK (>= 3.x)
- Dart SDK (>= 3.x)
- Packages:
  - [get](https://pub.dev/packages/get)
  - [get_storage](https://pub.dev/packages/get_storage)

## Installation & Run
```bash
flutter pub get
flutter run
>>>>>>> 60c5b3b (initial commit - TeamBuilder App)
