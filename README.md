# 🏗️ Trixie Architect - Ultimate Debian Setup

Trixie Architect est un script de post-installation tout-en-un conçu pour **Debian Trixie (Testing)**.  
Il transforme une installation Debian minimale en une station de travail puissante pour le **Gaming**, le **Développement** et l'**Intelligence Artificielle**.

Inspiré par des projets comme Archinstall et WinUtil, ce script offre une interface graphique en terminal (**TUI**) simple, rapide et modulaire.

## 🚀 Fonctionnalités

Le script propose un menu interactif (basé sur **whiptail**) couvrant tous les besoins modernes :

### 🛠️ Système & Noyau

- Configuration automatique des dépôts `sources.list` pour Trixie (Testing) + Backports.
- Mise à jour complète du système.
- Installation du dernier noyau (Kernel) via les backports.

### 🖥️ Pilotes GPU (Détection & Installation)

- **NVIDIA** : Installation des pilotes propriétaires + CUDA Toolkit + NVIDIA Container Toolkit (pour l'IA).
- **AMD** : Installation des pilotes libres (Mesa/Vulkan) + Support ROCm (pour l'IA) + bibliothèques 32-bit.
- **INTEL** : Support complet avec distinction architecturale :
  - Legacy (Gen 4-7 / Haswell / T440p) : Pilotes i965 et shaders pour l'accélération vidéo matérielle.
  - Moderne (Gen 8+ / Iris Xe) : Pilotes intel-media-driver (non-free).

### 🔋 Optimisation Laptop & ThinkPad

Module dédié pour prolonger la durée de vie de la batterie et réduire la chauffe :

- **TLP** : Gestion avancée de l'énergie (activé par défaut).
- **Intel Microcode** : Correctifs de sécurité et stabilité CPU cruciaux.
- **Thermald** : Régulation thermique intelligente pour processeurs Intel.

### 🎮 Gaming Ready

- Installation de **Steam** (avec support 32-bit).
- Configuration complète **Flatpak + Flathub**.
- Installation de **ProtonPlus** (gestionnaire de versions Proton/GE).
- Optimisations pour le jeu sous Linux.

### 🤖 AI Stack (Locale & Privée)

Déploiement automatique via **Docker** d'une stack complète pour l'IA générative :

- **Ollama** : Pour faire tourner les LLM (Llama3, Mistral, DeepSeek) en local.
- **OpenWebUI** : Une interface magnifique (style ChatGPT) pour vos modèles.
- **SearXNG** : Moteur de recherche privé, connecté à l'IA pour la recherche web.

**Configuration Hybride** : Le script détecte et configure automatiquement Docker pour utiliser l'accélération GPU (NVIDIA CUDA ou AMD ROCm) selon votre matériel.

### 🌐 Navigateurs & Social

- Installation facile de **Google Chrome**, **Firefox**, **Zen Browser** et **Tor**.
- Installation de **Discord** et **Telegram**.

### 📦 Logiciels Utiles

- **OBS Studio** (Version Flatpak officielle pour meilleurs codecs).
- **VS Code** (Version .deb officielle Microsoft).
- **VLC**, **GIMP**, **qBittorrent**, **Fastfetch**.

## 📥 Installation

Une seule ligne de commande suffit pour lancer l'installateur sur une Debian Trixie fraîchement installée.

### Méthode rapide (One-Liner)

Ouvrez un terminal et collez ces commandes :

```bash
wget -O - https://raw.githubusercontent.com/MrTHP/trixie_architect/main/trixie_architect.sh > trixie_architect.sh
chmod +x trixie_architect.sh
sudo ./trixie_architect.sh
=======
```wget -O trixie_architect.sh https://raw.githubusercontent.com/MrTHP/trixie_architect/main/trixie_architect.sh && chmod +x trixie_architect.sh && sudo ./trixie_architect.sh``` 


🖼️ Aperçu & Navigation

Le script utilise whiptail pour une navigation fluide et stable au clavier :

Lancez le script avec sudo.

Naviguez avec les Flèches (Haut/Bas).

Sélectionnez les options avec Espace (pour cocher/décocher).

Validez avec Entrée.

⚠️ Avertissement

Ce script est conçu spécifiquement pour Debian Trixie (Testing).

L'utilisation sur Debian Stable (Bookworm) ou Ubuntu peut causer des conflits majeurs (notamment via le remplacement du sources.list).

Utilisez-le à vos propres risques sur une machine de test ou une installation fraîche.

🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une "Issue" ou une "Pull Request" pour ajouter des fonctionnalités, supporter de nouveaux matériels ou corriger des bugs.

Fait avec ❤️ pour la communauté Linux.
