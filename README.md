# 🧊 Trixie Architect

<div align="center">

```
████████╗██████╗ ██╗██╗  ██╗██╗███████╗
╚══██╔══╝██╔══██╗██║╚██╗██╔╝██║██╔════╝
   ██║   ██████╔╝██║ ╚███╔╝ ██║█████╗  
   ██║   ██╔══██╗██║ ██╔██╗ ██║██╔══╝  
   ██║   ██║  ██║██║██╔╝ ██╗██║███████╗
   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝╚══════╝
        A R C H I T E C T  v9.x
```

**GUI de post-installation pour Debian Trixie**

[![Debian](https://img.shields.io/badge/Debian-Trixie-A81D33?style=for-the-badge&logo=debian&logoColor=white)](https://www.debian.org/)
[![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![Tkinter](https://img.shields.io/badge/GUI-Tkinter-FF6B35?style=for-the-badge)](https://docs.python.org/3/library/tkinter.html)
[![Licence](https://img.shields.io/badge/Licence-MIT-green?style=for-the-badge)](LICENSE)

*Un outil cyberpunk pour configurer Debian Trixie après installation — en un seul clic.*

</div>

---

## 📸 Aperçu

Trixie Architect est une interface graphique (GUI) Python/Tkinter conçue pour automatiser et simplifier la configuration post-installation de **Debian Trixie**. Il regroupe en un seul endroit tous les réglages essentiels : GPU, gaming, applications, stack IA, navigateurs, optimisations système et plus encore.

---

## ✨ Fonctionnalités

### 🎨 Thèmes visuels (6 thèmes intégrés)
| Thème | Description |
|-------|-------------|
| **Cyberpunk** | Neon cyan/magenta sur fond sombre |
| **Matrix** | Vert terminal classique |
| **Dracula** | Violet/rose pastel sombre |
| **Nord** | Bleu arctique épuré |
| **Gruvbox** | Tons chauds rétro |
| **Mocha** | Catppuccin Mocha doux |

### 🌐 Langue
- Interface disponible en **Français** et **Anglais** (bascule à la volée)
- Système de traduction à 159 clés

### 📦 Modules (9 panneaux)

| Panneau | Contenu |
|---------|---------|
| **🖥️ Système** | Mise à jour, outils de base, polices, codecs |
| **🎮 GPU** | Détection automatique NVIDIA/AMD/Intel, drivers, CUDA |
| **⚡ Optimisation** | `zram`, `preload`, `earlyoom`, réglages kernel |
| **🕹️ Gaming** | Steam, Lutris, Wine, MangoHud, GameMode, ProtonUp |
| **🌐 Navigateurs** | Firefox, Brave, Chromium, LibreWolf |
| **💬 Social** | Discord, Signal, Telegram, Element |
| **📱 Logiciels** | Flatpak, GNOME Software, Bazaar, apps courantes |
| **🤖 AI Stack** | Ollama, Open-WebUI, SearXNG, Perplexica |
| **🐧 Kernel** | Liquorix, XanMod, HWE |

---

## 🚀 Installation

### Prérequis

```bash
# Packages requis sur Debian Trixie
sudo apt install polkitd pkexec python3-tk
```

> ⚠️ **Note Debian Trixie** : `polkitd` et `pkexec` sont maintenant des paquets séparés (plus `polkit`/`policykit-1`).

### Binaire précompilé (recommandé)

Télécharge le binaire universel depuis les (https://github.com/MrTHP/trixie_architect/blob/80cdc2a6b31c2bf667630fd7fe804fd654e333db/trixie-architect-universal) :

```bash
# Rendre exécutable
chmod +x trixie-architect-universal

# Lancer
./trixie-architect-universal
```


## 🔧 Élévation de privilèges

Trixie Architect utilise `pkexec` pour les opérations nécessitant les droits root, avec correction automatique de `xhost` pour les environnements graphiques :

```bash
# Si nécessaire, autoriser X11 manuellement
xhost +SI:localuser:root
```

---

## 🖥️ Compatibilité

| Élément | Version |
|---------|---------|
| Debian | Trixie (13) |
| Python | 3.11+ |
| DE recommandé | GNOME (Xorg) |
| Architecture | x86_64 |

> Testé principalement sur **GNOME/Xorg** avec GPU NVIDIA (RTX).  
> AMD et Intel supportés via détection automatique GPU (`lspci`).

---

## 🤝 Contribution

Les PRs sont les bienvenues ! Pour les changements majeurs, ouvre d'abord une *issue* pour discuter.

1. Fork le projet
2. Crée ta branche (`git checkout -b feature/ma-fonctionnalite`)
3. Commit (`git commit -m 'Ajout de ma fonctionnalité'`)
4. Push (`git push origin feature/ma-fonctionnalite`)
5. Ouvre une Pull Request

---

## 📜 Licence

Distribué sous licence **MIT**. Voir [`LICENSE`](LICENSE) pour plus d'informations.

---

<div align="center">

Fait avec ☕ et 🐧 par **MrTHP** | Baie-Comeau, Québec

*"Configure once, install everywhere."*

</div>
