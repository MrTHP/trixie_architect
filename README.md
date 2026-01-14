🏗️ Trixie Architect - Ultimate Debian Setup
Trixie Architect est un script de post-installation tout-en-un conçu pour Debian Trixie (Testing). Il transforme une installation Debian minimale en une station de travail puissante pour le Gaming, le Développement et l'Intelligence Artificielle.

Inspiré par des projets comme Archinstall et WinUtil, ce script offre une interface graphique en terminal (TUI) simple, rapide et modulaire.

🚀 Fonctionnalités
Le script propose un menu interactif (basé sur whiptail) couvrant tous les besoins modernes :

🛠️ Système & Noyau :

Configuration automatique des dépôts sources.list pour Trixie (Testing) + Backports.

Mise à jour complète du système.

Installation du dernier noyau (Kernel) via les backports.

🎮 Gaming Ready :

Installation de Steam (avec support 32-bit).

Configuration complète Flatpak + Flathub.

Installation de ProtonPlus (gestionnaire de versions Proton/GE).

Optimisations pour le jeu sous Linux.

🖥️ Pilotes GPU (Détection & Installation) :

NVIDIA : Installation des pilotes propriétaires + CUDA Toolkit + NVIDIA Container Toolkit (pour l'IA).

AMD : Installation des pilotes libres (Mesa/Vulkan) + Support ROCm (pour l'IA) + bibliothèques 32-bit.

Intel : Pilotes Mesa standards.

🤖 AI Stack (Locale & Privée) :

Déploiement automatique via Docker d'une stack complète :

Ollama : Pour tourner les LLM (Llama3, Mistral, etc.) en local.

OpenWebUI : Une interface magnifique (style ChatGPT) pour vos modèles.

SearXNG : Moteur de recherche privé, connecté à l'IA pour la recherche web.

Configuration Hybride : Le script configure automatiquement Docker pour utiliser votre GPU (NVIDIA CUDA ou AMD ROCm) selon votre choix.

🌐 Navigateurs & Social :

Installation facile de Google Chrome, Firefox, Zen Browser et Tor.

Installation de Discord et Telegram.

📦 Logiciels Utiles :

OBS Studio (Version Flatpak optimisée).

VLC, GIMP, qBittorrent, VS Code, Fastfetch.

📥 Installation
Une seule ligne de commande suffit pour lancer l'installateur sur une Debian Trixie fraîchement installée :

Bash

wget -O - https://raw.githubusercontent.com/MrTHP/trixie_architect/main/trixie_architect_v6.sh | sudo bash

(Remplacez l'URL par le lien "Raw" de votre fichier sur GitHub)

Ou manuellement :

Bash

git clone https://github.com/MrTHP/trixie_architect/.git

cd trixie_architect/

chmod +x trixie_architect_v6.sh

sudo ./trixie_architect_v6.sh

🖼️ Aperçu
Le script utilise whiptail pour une navigation fluide au clavier :

Lancez le script avec sudo.

Naviguez avec les Flèches.

Sélectionnez avec Espace.

Validez avec Entrée.

⚠️ Avertissement
Ce script est conçu pour Debian Trixie (Testing). L'utilisation sur Debian Stable (Bookworm) ou Ubuntu peut causer des conflits de paquets, notamment au niveau du sources.list. Utilisez-le à vos propres risques.

🤝 Contribution
Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une "Issue" ou une "Pull Request" pour ajouter des fonctionnalités ou corriger des bugs.

Fait avec ❤️ pour la communauté Linux.
