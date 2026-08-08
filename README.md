# 🌌 Parallel Universe — AI-Powered Life Simulation Experience

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Vercel Deployment](https://img.shields.io/badge/Vercel-Live_Demo-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://web-one-pi-uacai8amfu.vercel.app)
[![Groq AI Engine](https://img.shields.io/badge/Groq-AI_Powered-F34B7D?style=for-the-badge)](https://groq.com)

**Parallel Universe** is a premium, state-of-the-art AI Life Simulation web and mobile experience that allows users to explore alternate versions of their own lives based on decisions, career paths, and personal choices.

---

## 🔗 Live Production Web Demo
🚀 **Try the Live App:** [https://web-one-pi-uacai8amfu.vercel.app](https://web-one-pi-uacai8amfu.vercel.app)

---

## ✨ Key Features

### 1. 📰 Personalized AI Feed
- **Message From Your Future Self:** Daily inspirational insights generated from future timelines.
- **Streak Tracker:** Encourages daily exploration of alternate realities.
- **Interactive Active Futures:** Dynamic cards that let you jump straight into chatting with specific future selves.
- **Achievement Badges:** Gamified milestone badges with interactive descriptions.

### 2. 🔍 Dynamic Explore Experience
- **Smart AI Search Bar:** Search any career, lifestyle, or scenario (e.g., *"Celebrity Chef"*, *"F1 Driver"*).
- **Category Filter Chips:** Instantly filter futures across Tech, Startup, Cooking, Sports, Space, and more.
- **Trending Futures:** Weekly curated alternate life paths with happiness scores and growth metrics.

### 3. 🧠 Real-Time AI Generation Engine
- Powered by **Groq LLaMA 3.3 AI Engine** for ultra-fast, structured parallel life outputs.
- **Dynamic CORS-Safe Image Engine:** Automatically matches generated scenarios with high-resolution, relevant photography.

### 4. 💬 Future Self Chat
- Converse with alternate versions of yourself in real-time to ask advice on career steps, daily routines, and life choices.

---

## 🏗️ Architecture & Tech Stack

This project strictly adheres to **Clean Architecture** and the **MVVM + Provider** pattern for maximum maintainability and scale:

```text
lib/
├── core/                   # Utilities, DI, Routing & Common Widgets
├── features/
│   ├── dashboard/          # Feed & Explore UI, Widgets & ViewModels
│   ├── universe_generation/# Groq AI Datasource, Entities & Details Screen
│   ├── future_self/        # Future Self Real-time Chat
│   ├── life_interview/     # Smart Memory & User Context
│   └── auth/               # Authentication Logic
└── main.dart               # Entry Point & Environment Loading
```

- **Frontend:** Flutter Web / Mobile (Clean Architecture, Provider State Management)
- **Backend AI:** Groq LLaMA 3.3 API / Gemini API
- **Deployment:** Vercel Production Web Hosting

---

## 🚀 How to Run Locally

1. **Clone the repository:**
   ```bash
   git clone https://github.com/crystaljain27/-parallel_universe.git
   cd parallel_universe
   ```

2. **Setup Environment Variables:**
   Create a `.env` file in the root directory:
   ```env
   GROQ_API_KEY=your_groq_api_key_here
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the App:**
   ```bash
   flutter run -d chrome
   ```

---

Designed & Developed for **Parallel Universe App** 🚀
