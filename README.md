# 📝 iPad Note App (Swift Playgrounds)

A modern, native note-taking application for iPad built with **Swift Playgrounds**, leveraging **PencilKit** for drawing and **SwiftData** for persistence.

[🇬🇧 English](#-english) | [🇹🇷 Türkçe](#-türkçe)

---

## 🇬🇧 English

### 🚀 Features

*   **✍️ Pencil & Drawing:** Low-latency drawing experience with Apple Pencil (or finger) using **PencilKit**.
*   **💾 Persistence (SwiftData):** Auto-save functionality ensuring your notes are safe even if the app closes.
*   **📄 Paper Templates:** Blank, Lined, and Grid paper options with a dynamic grid system.
*   **🔍 Zoom & Scroll:** Lossless zoom (up to 3x) and smooth scrolling navigation.
*   **📤 PDF Export:** Export your handwritten notes as high-quality PDF documents.
*   **↩️ Undo/Redo:** Full support for undo and redo operations.
*   **🖼️ Page Thumbnails:** Preview page contents within notebooks.
*   **🌑 Dark Mode:** Fully compatible with system-wide Dark Mode.

### 📸 Screenshots

<p align="center">
  <img src="screenshots/mockup.jpg" width="100%" alt="App Preview">
</p>

### 🛠️ Technical Details

This project acts as a standalone `.swiftpm` (Swift Playgrounds App) or can be run as an Xcode project.

*   **Language:** Swift 5.9+
*   **Frameworks:** SwiftUI, SwiftData, PencilKit, PDFKit
*   **Minimum Requirements:** iPadOS 17.0+ (iOS 17+)

### 📂 File Structure

The code is modularized for better maintainability:

*   `ContentView.swift`: Main app entry and navigation.
*   `Models.swift`: Data models (`Notebook`, `Page`).
*   `CanvasView.swift`: PencilKit integration and drawing logic.
*   `PaperView.swift`: Background patterns (Grid, Lined).
*   `PageEditorView.swift`: The main note-taking editor interface.
*   `NotebookDetailView.swift`: Page management and PDF export logic.
*   `ZoomableScrollView.swift`: `UIScrollView` wrapper for zoom functionality.
*   `Utils.swift`: Helper utilities (Hex color extension, etc.).

### 📦 Installation

1.  Download or clone this repository.
2.  Open the folder with **Swift Playgrounds** on iPad or Mac.
3.  Alternatively, open with **Xcode** on a Mac.
4.  Run and start taking notes!

---

## 🇹🇷 Türkçe

Bu proje, iPad üzerinde Swift Playgrounds kullanılarak geliştirilmiş, **PencilKit** ve **SwiftData** tabanlı modern bir not alma uygulamasıdır. Apple Pencil deneyimini, kalıcı veri depolama ve PDF dışa aktarma özellikleriyle birleştirir.

### 🚀 Özellikler

*   **✍️ Kalem & Çizim:** Apple Pencil (veya parmak) ile gecikmesiz çizim deneyimi (PencilKit).
*   **💾 Kalıcı Veri (SwiftData):** Notlarınızın otomatik kaydedilmesi ve uygulama kapansa bile saklanması.
*   **📄 Kağıt Şablonları:** Boş, Çizgili ve Kareli kağıt seçenekleri (Dinamik grid sistemi).
*   **🔍 Zoom & Scroll:** 3x'e kadar kayıpsız yakınlaştırma ve sayfada gezinme.
*   **📤 PDF Export:** Çizimlerinizi yüksek kaliteli PDF olarak paylaşma.
*   **↩️ Undo/Redo:** Geri alma ve yineleme desteği.
*   **🖼️ Sayfa Önizlemeleri:** Defter içinde sayfaların küçük resimlerini (thumbnails) görme.
*   **🌑 Dark Mode:** Sistem temasına uyumlu karanlık mod desteği.

### 📸 Ekran Görüntüleri

<p align="center">
  <img src="screenshots/mockup.jpg" width="100%" alt="Uygulama Önizlemesi">
</p>

### 🛠️ Teknik Detaylar

Bu proje tek bir `.swiftpm` (Swift Playgrounds App) veya Xcode projesi olarak çalıştırılabilir.

*   **Dil:** Swift 5.9+
*   **Framework:** SwiftUI, SwiftData, PencilKit, PDFKit
*   **Minimum Sürüm:** iPadOS 17.0+ (iOS 17+)

### 📂 Dosya Yapısı

Kod, daha iyi yönetilebilirlik için modüllere ayrılmıştır:

*   `ContentView.swift` - Uygulamanın ana ekranı ve navigasyon yapısı.
*   `Models.swift` - Veri modelleri (`Notebook`, `Page`).
*   `CanvasView.swift` - PencilKit entegrasyonu ve çizim alanı.
*   `PaperView.swift` - Arka plan desenleri (Kareli, Çizgili).
*   `PageEditorView.swift` - Ana not alma editörü.
*   `NotebookDetailView.swift` - Defter içi sayfa yönetimi ve PDF export Logic.
*   `ZoomableScrollView.swift` - Zoom ve kaydırma için `UIScrollView` wrapper.
*   `Utils.swift` - Yardımcı araçlar (Renk kodu çevirici vb.).

### 📦 Kurulum

1.  Bu projeyi indirin.
2.  Klasörü **Swift Playgrounds** (iPad veya Mac) ile açın.
3.  Veya **Xcode** ile açıp bir App projesi olarak çalıştırın.
4.  Çalıştırın ve not almaya başlayın!

---
*Developer / Geliştirici: Berkay Carı*
