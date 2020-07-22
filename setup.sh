#!/usr/bin/env bash

if [ -f installed ]; then
	echo "Scripts have already been installed."
	echo "To reinstall, delete the file called installed"
	echo "and make sure everything is in this folder"
	echo ""
	echo "Press Enter to close this window"
	exit 0
fi

echo 'Only run this script ONE TIME to set things up!'
echo 'You DO NOT need to run this before each session!'
echo ''
read -p 'Enter your username on the server: ' uname
read -p 'Enter the domain of the server: ' domain

#SCRIPTS:

#CREATE HOOK SCRIPT
touch hook.sh
echo '#!/usr/bin/env bash' > hook.sh
echo scp /share/.session/nginx.conf $uname@$domain:/etc/nginx/zTu.conf >> hook.sh
echo '' >> hook.sh
echo ssh $uname@$domain sudo systemctl enable nginx >> hook.sh
echo ssh $uname@$domain sudo systemctl start nginx >> hook.sh
echo ssh $uname@$domain sudo systemctl restart nginx >> hook.sh

#CREATE VPN CONFIGURATION STARTER
touch configure_wg.sh
echo '#!/usr/bin/env bash' > configure_wg.sh
echo scp /home/lab/scripts/wg/Thin_server/wg_zu.conf $uname@$domain:/etc/wireguard/wg_zu.conf >> configure_wg.sh
echo ssh $uname@$domain sudo systemctl enable wg-quick@wg_zu >> configure_wg.sh
echo ssh $uname@$domain sudo systemctl start wg-quick@wg_zu >> configure_wg.sh
echo ssh $uname@$domain sudo systemctl enable rh-php73-php-fpm >> configure_wg.sh
echo ssh $uname@$domain sudo systemctl start rh-php73-php-fpm >> configure_wg.sh
echo ssh $uname@$domain sudo systemctl restart wg-quick@wg_zu >> configure_wg.sh
echo 'echo ""' >> configure_wg.sh
echo 'echo "Server session started successfully!"' >> configure_wg.sh
echo 'echo ""' >> configure_wg.sh
echo 'echo "Press Enter to close this window"' >> configure_wg.sh

chmod +x configure_wg.sh

#POINT THIN_HOOKS TO HOOK.SH
touch /home/lab/scripts/thin_hooks.sh
echo '#!/usr/bin/env bash' > /home/lab/scripts/thin_hooks.sh
echo source ~/Desktop/XSFS_Scripts/hook.sh >> /home/lab/scripts/thin_hooks.sh

#CREATE POST-SESSION SCRIPTS
touch systemd_kill.sh
echo '#!/usr/bin/env bash' > systemd_kill.sh
echo ssh $uname@$domain sudo systemctl stop nginx >> systemd_kill.sh
echo ssh $uname@$domain sudo systemctl disable nginx >> systemd_kill.sh
echo ssh $uname@$domain sudo systemctl stop wg-quick@wg_zu >> systemd_kill.sh
echo ssh $uname@$domain sudo systemctl disable wg-quick@wg_zu >> systemd_kill.sh
echo ssh $uname@$domain sudo systemctl stop rh-php73-php-fpm >> systemd_kill.sh
echo ssh $uname@$domain sudo systemctl disable rh-php73-php-fpm >> systemd_kill.sh
echo 'echo ""' >> systemd_kill.sh
echo 'echo "Server session ended successfully!"' >> systemd_kill.sh
echo 'echo ""' >> systemd_kill.sh
echo 'echo "Press Enter to close this window"' >> systemd_kill.sh

chmod +x systemd_kill.sh

#CREATE OPENSSH SETUP SCRIPT
touch openssh_setup.sh
echo '#!/usr/bin/env bash' > openssh_setup.sh
echo rm /home/lab/.ssh/id_ed25519 >> openssh_setup.sh
echo rm /home/lab/.ssh/id_ed25519.pub >> openssh_setup.sh
echo ssh $uname@$domain mkdir /home/$uname/.ssh >> openssh_setup.sh
echo ssh-keygen -t ed25519 >> openssh_setup.sh
echo scp ~/.ssh/id_ed25519.pub $uname@$domain:/home/$uname/.ssh/authorized_keys >> openssh_setup.sh
chmod +x openssh_setup.sh

#LAUNCHERS:

#CREATE PRE-SESSION LAUNCHER
touch PRE-SESSION.desktop
echo [Desktop Entry] > PRE-SESSION.desktop
echo Version=1.0 >> PRE-SESSION.desktop
echo Type=Application >> PRE-SESSION.desktop
echo Name=PRE-SESSION >> PRE-SESSION.desktop
echo Comment= >> PRE-SESSION.desktop
echo Exec=bash -c '"./configure_wg.sh; read"' >> PRE-SESSION.desktop
echo Icon=preferences-desktop-remote-desktop >> PRE-SESSION.desktop
echo Path=/home/lab/Desktop/XSFS_Scripts >> PRE-SESSION.desktop
echo Terminal=true >> PRE-SESSION.desktop
echo StartupNotify=false >> PRE-SESSION.desktop
echo Name[en_US]=PRE-SESSION >> PRE-SESSION.desktop
chmod +x PRE-SESSION.desktop
mv PRE-SESSION.desktop ~/Desktop

#CREATE POST-SESSION LAUNCHER
touch POST-SESSION.desktop
echo [Desktop Entry] > POST-SESSION.desktop
echo Version=1.0 >> POST-SESSION.desktop
echo Type=Application >> POST-SESSION.desktop
echo Name=POST-SESSION >> POST-SESSION.desktop
echo Comment= >> POST-SESSION.desktop
echo Exec=bash -c '"./systemd_kill.sh; read"' >> POST-SESSION.desktop
echo Icon=system-hibernate >> POST-SESSION.desktop
echo Path=/home/lab/Desktop/XSFS_Scripts >> POST-SESSION.desktop
echo Terminal=true >> POST-SESSION.desktop
echo StartupNotify=false >> POST-SESSION.desktop
echo Name[en_US]=POST-SESSION >> POST-SESSION.desktop
chmod +x POST-SESSION.desktop
mv POST-SESSION.desktop ~/Desktop

#OPENSSH SETUP LAUNCHER
touch OPENSSH-SETUP.desktop
echo [Desktop Entry] > OPENSSH-SETUP.desktop
echo Version=1.0 >> OPENSSH-SETUP.desktop
echo Type=Application >> OPENSSH-SETUP.desktop
echo Name=OPENSSH-SETUP >> OPENSSH-SETUP.desktop
echo Comment= >> OPENSSH-SETUP.desktop
echo Exec=bash -c '"./openssh_setup.sh; rm OPENSSH-SETUP.desktop;"' >> OPENSSH-SETUP.desktop
echo Icon=gcr-key-pair >> OPENSSH-SETUP.desktop
echo Path=/home/lab/Desktop/XSFS_Scripts >> OPENSSH-SETUP.desktop
echo Terminal=true >> OPENSSH-SETUP.desktop
echo StartupNotify=false >> OPENSSH-SETUP.desktop
echo Name[en_US]=OPENSSH ONE-TIME SETUP >> OPENSSH-SETUP.desktop
chmod +x OPENSSH-SETUP.desktop

touch installed
echo "Success!"
echo ""
echo "Press Enter to close this window"

