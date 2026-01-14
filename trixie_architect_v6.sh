#!/bin/bash

# ==============================================================================
#  DEBIAN TRIXIE ARCHITECT - WHIPTAIL EDITION (v6.0 - Flatpak Update)
# ==============================================================================

# --- 1. INITIALISATION ---

if [ "$EUID" -ne 0 ]; then
  echo "Erreur : Lancez ce script avec sudo !"
  echo "Usage: sudo ./trixie_architect_v6.sh"
  exit 1
fi

REAL_USER=$SUDO_USER
if [ -z "$REAL_USER" ]; then REAL_USER=$(whoami); fi
REAL_HOME=$(getent passwd $REAL_USER | cut -d: -f6)

if ! command -v whiptail &> /dev/null; then
    apt-get update -qq && apt-get install -y whiptail wget curl git
fi

BACKTITLE="Debian Trixie Architect - V6 (User: $REAL_USER)"

# --- 2. FONCTIONS UTILITAIRES ---

function confirm_action() {
    if whiptail --title "$1" --backtitle "$BACKTITLE" --yesno "$2\n\nVoulez-vous procéder ?" 12 70; then
        return 0
    else
        return 1
    fi
}

function run_with_logs() {
    clear
    echo -e "\033[1;33m[ACTION] $1...\033[0m"
    echo "-----------------------------------------------------"
    eval "$2"
    STATUS=$?
    echo "-----------------------------------------------------"
    if [ $STATUS -eq 0 ]; then
        echo -e "\n\033[1;32m✅ Opération terminée.\033[0m"
    else
        echo -e "\n\033[1;31m❌ Erreur détectée.\033[0m"
    fi
    echo -e "Appuyez sur \033[1;37mENTRÉE\033[0m pour revenir au menu."
    read -r
}

# --- 3. MODULES ---

function module_system() {
    if confirm_action "Système de Base" "Mise à jour vers Debian Trixie (Testing) + Backports.\nCeci va modifier /etc/apt/sources.list."; then
        
        CMD="cp /etc/apt/sources.list /etc/apt/sources.list.bak_$(date +%s) && \
        cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
# Backports
deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware
EOF
        apt-get update && \
        apt-get install -y curl wget apt-transport-https software-properties-common build-essential git"
        
        run_with_logs "Mise à jour du Système" "$CMD"
    fi
}

function module_gpu() {
    CHOIX_GPU=$(whiptail --title "Installation GPU" --backtitle "$BACKTITLE" --menu "Choisissez votre driver :" 15 60 4 \
    "1" "NVIDIA (Propriétaire + CUDA)" \
    "2" "AMD (Mesa + Vulkan)" \
    "3" "INTEL (Mesa)" \
    "4" "Retour" 3>&1 1>&2 2>&3)
    
    if [ $? -eq 0 ]; then
        case $CHOIX_GPU in
            1)
                run_with_logs "Installation NVIDIA" "apt install -y extrepo linux-headers-$(uname -r) && extrepo enable nvidia-cuda && apt update && apt install -y nvidia-driver firmware-misc-nonfree"
                ;;
            2)
                run_with_logs "Installation AMD" "dpkg --add-architecture i386 && apt update && apt install -y firmware-amd-graphics libgl1-mesa-dri:i386 libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgbm1:i386"
                ;;
        esac
    fi
}

function module_gaming() {
    SELECTION=$(whiptail --title "Gaming Setup" --backtitle "$BACKTITLE" --checklist "Espace pour cocher :" 20 70 6 \
    "STEAM" "Steam Installer + Libs 32bit" ON \
    "FLATPAK" "Flatpak + Flathub Repo" ON \
    "PROTON" "ProtonPlus (Gestionnaire Proton)" OFF \
    "EASYFP" "EasyFlatpak (Settings Flatpak)" OFF \
    3>&1 1>&2 2>&3)

    CMD=""
    if [[ $SELECTION == *"STEAM"* ]]; then
        CMD="$CMD dpkg --add-architecture i386 && apt update && apt install -y steam-installer;"
    fi
    if [[ $SELECTION == *"FLATPAK"* ]]; then
        CMD="$CMD apt install -y flatpak plasma-discover-backend-flatpak gnome-software-plugin-flatpak && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;"
    fi
    if [[ $SELECTION == *"PROTON"* ]]; then
        CMD="$CMD flatpak install -y flathub com.vysp3r.ProtonPlus;"
    fi
    if [[ $SELECTION == *"EASYFP"* ]]; then
        CMD="$CMD flatpak install -y flathub org.dupot.easyflatpak;"
    fi

    if [ -n "$CMD" ]; then run_with_logs "Installation Gaming" "$CMD"; fi
}

function module_browsers() {
    SELECTION=$(whiptail --title "Navigateurs Web" --backtitle "$BACKTITLE" --checklist "Installation dans /home/$REAL_USER :" 20 75 5 \
    "CHROME" "Google Chrome (.deb officiel)" OFF \
    "FIREFOX" "Firefox Latest (Manuel/Tarball)" OFF \
    "ZEN" "Zen Browser (Manuel/Tarball)" OFF \
    "TOR" "Tor Browser Launcher" OFF \
    3>&1 1>&2 2>&3)
    
    # Chrome
    if [[ $SELECTION == *"CHROME"* ]]; then
         run_with_logs "Installation Chrome" "wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install -y /tmp/chrome.deb && rm /tmp/chrome.deb"
    fi

    # Zen
    if [[ $SELECTION == *"ZEN"* ]]; then
        run_with_logs "Installation Zen Browser" "sudo -u $REAL_USER bash -c \"wget -O /tmp/zen.tar.xz 'https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz' && rm -rf $REAL_HOME/zen-browser && tar -xJf /tmp/zen.tar.xz -C $REAL_HOME && mv $REAL_HOME/zen $REAL_HOME/zen-browser\"; \
        cat > $REAL_HOME/.local/share/applications/zen-browser.desktop <<EOL
[Desktop Entry]
Version=1.0
Name=Zen Browser
Exec=$REAL_HOME/zen-browser/zen %u
Icon=$REAL_HOME/zen-browser/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
Terminal=false
EOL
        chown $REAL_USER:$REAL_USER $REAL_HOME/.local/share/applications/zen-browser.desktop && chmod +x $REAL_HOME/.local/share/applications/zen-browser.desktop"
    fi

    # Firefox
    if [[ $SELECTION == *"FIREFOX"* ]]; then
        run_with_logs "Installation Firefox" "sudo -u $REAL_USER bash -c \"wget -O /tmp/firefox.tar.xz 'https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=fr' && rm -rf $REAL_HOME/firefox && tar -xJf /tmp/firefox.tar.xz -C $REAL_HOME\"; \
        cat > $REAL_HOME/.local/share/applications/firefox-manual.desktop <<EOL
[Desktop Entry]
Name=Firefox Manual
Exec=$REAL_HOME/firefox/firefox %u
Icon=$REAL_HOME/firefox/browser/chrome/icons/default/default128.png
Type=Application
Categories=Network;WebBrowser;
EOL
        chown $REAL_USER:$REAL_USER $REAL_HOME/.local/share/applications/firefox-manual.desktop"
    fi

    if [[ $SELECTION == *"TOR"* ]]; then
        run_with_logs "Installation Tor" "apt install -y torbrowser-launcher"
    fi
}

function module_social() {
    SELECTION=$(whiptail --title "Social Apps" --backtitle "$BACKTITLE" --checklist "Sélection :" 20 70 4 \
    "DISCORD" "Discord (Tarball)" OFF \
    "TELEGRAM" "Telegram (Tarball)" OFF \
    3>&1 1>&2 2>&3)

    if [[ $SELECTION == *"DISCORD"* ]]; then
        run_with_logs "Installation Discord" "sudo -u $REAL_USER bash -c \"wget -O /tmp/discord.tar.gz 'https://discord.com/api/download?platform=linux&format=tar.gz' && tar -xzvf /tmp/discord.tar.gz -C $REAL_HOME\"; \
        cat > $REAL_HOME/.local/share/applications/discord.desktop <<EOL
[Desktop Entry]
Name=Discord
Exec=$REAL_HOME/Discord/Discord
Icon=$REAL_HOME/Discord/discord.png
Type=Application
Categories=Network;InstantMessaging;
EOL
        chown $REAL_USER:$REAL_USER $REAL_HOME/.local/share/applications/discord.desktop"
    fi

    if [[ $SELECTION == *"TELEGRAM"* ]]; then
        run_with_logs "Installation Telegram" "sudo -u $REAL_USER bash -c \"wget -O /tmp/telegram.tar.xz 'https://telegram.org/dl/desktop/linux' && tar -xJvf /tmp/telegram.tar.xz -C $REAL_HOME\"; \
        cat > $REAL_HOME/.local/share/applications/telegram.desktop <<EOL
[Desktop Entry]
Name=Telegram
Exec=$REAL_HOME/Telegram/Telegram
Icon=$REAL_HOME/Telegram/Telegram.png
Type=Application
Categories=Network;InstantMessaging;
EOL
        chown $REAL_USER:$REAL_USER $REAL_HOME/.local/share/applications/telegram.desktop"
    fi
}

function module_software() {
    SELECTION=$(whiptail --title "Logiciels Utiles" --backtitle "$BACKTITLE" --checklist "Apps issues d'Architect :" 20 70 8 \
    "VLC" "Lecteur Média VLC (Apt)" OFF \
    "OBS" "OBS Studio (Flatpak)" OFF \
    "GIMP" "Editeur Image GIMP (Apt)" OFF \
    "QBIT" "qBittorrent (Apt)" OFF \
    "VSCODE" "Visual Studio Code (.deb)" OFF \
    "FASTFETCH" "Fastfetch (Apt)" OFF \
    3>&1 1>&2 2>&3)

    CMD=""
    
    # Paquets APT classiques
    PACKAGES=""
    if [[ $SELECTION == *"VLC"* ]]; then PACKAGES="$PACKAGES vlc"; fi
    if [[ $SELECTION == *"GIMP"* ]]; then PACKAGES="$PACKAGES gimp"; fi
    if [[ $SELECTION == *"QBIT"* ]]; then PACKAGES="$PACKAGES qbittorrent"; fi
    if [[ $SELECTION == *"FASTFETCH"* ]]; then PACKAGES="$PACKAGES fastfetch"; fi
    
    if [ -n "$PACKAGES" ]; then CMD="$CMD apt install -y $PACKAGES;"; fi
    
    # VS Code (.deb)
    if [[ $SELECTION == *"VSCODE"* ]]; then
        CMD="$CMD wget -O /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' && apt install -y /tmp/vscode.deb;"
    fi

    # OBS Studio (Flatpak)
    if [[ $SELECTION == *"OBS"* ]]; then
        # On s'assure d'abord que flatpak est installé, puis on ajoute le remote, puis on installe OBS
        CMD="$CMD apt install -y flatpak && flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install -y flathub com.obsproject.Studio;"
    fi

    if [ -n "$CMD" ]; then run_with_logs "Installation Logiciels" "$CMD"; fi
}

function module_ai_stack() {
    CHOIX_AI_GPU=$(whiptail --title "AI Stack Configuration" --backtitle "$BACKTITLE" --menu "Quel type d'accélération GPU utiliser ?" 15 60 2 \
    "1" "NVIDIA (CUDA via Nvidia-Toolkit)" \
    "2" "AMD (ROCm via mappage Device)" 3>&1 1>&2 2>&3)

    if [ $? -ne 0 ]; then return; fi # Annuler

    if confirm_action "Installation AI Stack" "Installation Docker, Ollama, OpenWebUI et SearXNG.\nVersion choisie : $([ "$CHOIX_AI_GPU" == "1" ] && echo "NVIDIA" || echo "AMD")"; then
        
        STACK_SCRIPT='
        set -e
        # A. Installation Docker
        if ! command -v docker &> /dev/null; then
            echo "[+] Installation Docker..."
            apt-get update && apt-get install -y ca-certificates curl gnupg
            install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            chmod a+r /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
            apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        fi
        
        usermod -aG docker '$REAL_USER'

        INSTALL_DIR="/opt/ai-stack"
        mkdir -p "$INSTALL_DIR/searxng" "$INSTALL_DIR/ollama" "$INSTALL_DIR/open-webui"
        
        # B. Configuration spécifique GPU
        '

        if [ "$CHOIX_AI_GPU" == "1" ]; then
            # === OPTION NVIDIA ===
            STACK_SCRIPT+='
            echo "[+] Configuration NVIDIA..."
            if ! dpkg -l | grep -q nvidia-container-toolkit; then
                 curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
                 && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
                 sed "s#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g" | \
                 tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
                 apt-get update && apt-get install -y nvidia-container-toolkit
                 nvidia-ctk runtime configure --runtime=docker
                 systemctl restart docker
            fi

            cat <<EOF > "$INSTALL_DIR/docker-compose.yml"
services:
  ollama:
    image: ollama/ollama:latest
    restart: always
    ports: ["11434:11434"]
    volumes: [ollama:/root/.ollama]
    deploy:
      resources:
        reservations:
          devices: [{driver: nvidia, count: 1, capabilities: [gpu]}]
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    restart: always
    ports: ["3000:8080"]
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - SEARXNG_QUERY_URL=http://searxng:8080/search?q=
    volumes: [open-webui:/app/backend/data]
    depends_on: [ollama, searxng]
  searxng:
    image: searxng/searxng:latest
    restart: always
    ports: ["8080:8080"]
    volumes: [./searxng:/etc/searxng]
    environment: [{BASE_URL: "http://localhost:8080/"}]
volumes: {ollama: {}, open-webui: {}}
EOF
            '
        else
            # === OPTION AMD (ROCm) ===
            STACK_SCRIPT+='
            echo "[+] Configuration AMD ROCm..."
            usermod -aG render,video '$REAL_USER'
            
            cat <<EOF > "$INSTALL_DIR/docker-compose.yml"
services:
  ollama:
    image: ollama/ollama:latest
    restart: always
    ports: ["11434:11434"]
    devices:
      - "/dev/kfd:/dev/kfd"
      - "/dev/dri:/dev/dri"
    volumes: [ollama:/root/.ollama]
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    restart: always
    ports: ["3000:8080"]
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - SEARXNG_QUERY_URL=http://searxng:8080/search?q=
    volumes: [open-webui:/app/backend/data]
    depends_on: [ollama, searxng]
  searxng:
    image: searxng/searxng:latest
    restart: always
    ports: ["8080:8080"]
    volumes: [./searxng:/etc/searxng]
    environment: [{BASE_URL: "http://localhost:8080/"}]
volumes: {ollama: {}, open-webui: {}}
EOF
            '
        fi

        # --- Fin du script commun ---
        STACK_SCRIPT+='
        # Config SearXNG
        echo "use_default_settings: true" > "$INSTALL_DIR/searxng/settings.yml"
        echo "server: {secret_key: \"$(openssl rand -hex 16)\"}" >> "$INSTALL_DIR/searxng/settings.yml"

        chown -R '$REAL_USER':docker "$INSTALL_DIR"
        cd "$INSTALL_DIR"
        echo "[+] Lancement des conteneurs..."
        docker compose up -d
        '

        run_with_logs "Déploiement AI Stack" "$STACK_SCRIPT"
        whiptail --msgbox "Installation Terminée !\n\nOpenWebUI: http://localhost:3000\nSearXNG: http://localhost:8080" 10 50
    fi
}

# --- 4. MENU PRINCIPAL ---

while true; do
    CHOIX=$(whiptail --title "MENU PRINCIPAL" --backtitle "$BACKTITLE" --menu "Flèches pour bouger, Entrée pour valider :" 24 75 10 \
    "1 SYSTEME" "Sources.list Trixie, Mise à jour" \
    "2 GPU" "Pilotes Graphiques (Nvidia/AMD)" \
    "3 GAMING" "Steam, Flatpak, ProtonPlus" \
    "4 NAVIGATEURS" "Chrome, Zen, Firefox, Tor" \
    "5 SOCIAL" "Discord, Telegram" \
    "6 LOGICIELS" "VLC, OBS(Flatpak), VSCode, Tools" \
    "7 AI STACK" "Docker + Ollama (Nvidia/AMD) + WebUI" \
    "8 KERNEL" "Upgrade via Backports" \
    "QUITTER" "Sortir du script" 3>&1 1>&2 2>&3)

    EXIT_STATUS=$?
    if [ $EXIT_STATUS -eq 0 ]; then
        case $CHOIX in
            "1 SYSTEME") module_system ;;
            "2 GPU") module_gpu ;;
            "3 GAMING") module_gaming ;;
            "4 NAVIGATEURS") module_browsers ;;
            "5 SOCIAL") module_social ;;
            "6 LOGICIELS") module_software ;;
            "7 AI STACK") module_ai_stack ;;
            "8 KERNEL") 
                run_with_logs "Kernel Upgrade" "apt -t trixie-backports install -y linux-image-amd64 linux-headers-amd64" 
                ;;
            "QUITTER") break ;;
        esac
    else
        break
    fi
done

clear
echo "Au revoir !"
