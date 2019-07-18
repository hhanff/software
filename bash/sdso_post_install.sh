# Update uC FW,
- Use Windows

# Flash SD Card
sudo dd if=/mnt/research/projects/ongoing/EIT-SDSO_18883/development/software/images/pi.img of=/dev/sdc bs=8M  & ddpid=$!
#while [ $(ps -ao pid | grep $ddpid) ]; do sudo kill -SIGUSR1 $ddpid; sleep 1; done

watch -n5 'sudo kill -USR1 $(pgrep ^dd)'

# Expand filesystem
sudo raspi-config --expand-rootfs
sudo shutdown -r now

# Set locale
sudo su
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
sudo locale-gen en_DE.UTF-8
sudo update-locale en_DE.UTF-8
echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
sudo locale-gen de_DE.UTF-8
sudo update-locale de_DE.UTF-8

# Turn off serial port for kernel messages
echo "dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait" > /boot/cmdline.txt
exit

sudo shutdown -r now

# Install latest software
cd ~/sdso/development/software
killall python
git reset --hard
cat ~/sdso/.git/config | grep "git@git.hb"
# Edit .git/config and change url to
#        url = git@git.hb.dfki.de:hhanff/sdso.git
# when asked for username/password
git pull

git checkout field_test_frech

# Disable ssh password authentication
cat ~/sdso/development/software/ssh/id_rsa_sdso.pub >> ~/.ssh/authorized_keys
sudo su
grep -q "ChallengeResponseAuthentication" /etc/ssh/sshd_config && sed -i "/^[^#]*ChallengeResponseAuthentication[[:space:]]yes.*/c\ChallengeResponseAuthentication no" /etc/ssh/sshd_config || echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config && sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
service ssh restart
exit

# Turn off static IP address
sudo cp /etc/network/interfaces /etc/network/interfaces.static_ip
sudo su
echo "# interfaces(5) file used by ifup(8) and ifdown(8)">/etc/network/interfaces
echo "auto lo">>/etc/network/interfaces
echo "iface lo inet loopback">>/etc/network/interfaces

## Install a cronjob to automatically deploy new versions of the sdso software
#sudo crontab -l > mycron
#echo "*/1 * * * * su -s /bin/sh pi -c 'cd ~/sdso && /usr/bin/git pull origin field_test_frech'" >> mycron
#echo "@reboot sh /home/pi/launcher.sh >/home/pi/logs/cronlog 2>&1" >> mycron
#crontab mycron
#rm mycron

"exit

# Test
sudo reboot

## Without Modbus
- Disable Modbus in xml file
- Restart
- Check if Script is running
- Enable Modbus

## With Modbus
cd /home/pi/sdso/development/software/Modbus
./updating-server.py


# Change LAN Cable for normal LAN
exit

# Print label
ifconfig
