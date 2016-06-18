#
# decrypts production boot logs.  Works for all DC's
#

/usr/bin/openssl aes-256-cbc -d -k c4ntS33MeN0w -salt -in /var/log/boot.aes -out /var/log/boot.decrypted.log
