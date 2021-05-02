#!/bin/bash

# Paramètres pour l'envoi des alertes mail
EMAIL=""
EMAILPASSWORD=""
MAILSERVER=""
MAILSUBJECT="[ALERTE] Un fichier de sauvegarde vide a été détecté !"
MAILMESSAGE="Une vérification de l'état du serveur s'impose : un fichier de sauvegarde corrompu/invalide (0 bytes) a été détecté. La sauvegarde de ce jour a été abandonnée par sécurité."

# Recuperer la date du jour
TIMESTAMP=$(date +%F)

# Repertoire contenant la backup temporaire
TMPBACKUP="/var/www/backups/websites"

# Si le repertoire temporaire des backup n'existe pas, le creer
if [ ! -d "$TMPBACKUP" ]; then
        mkdir -p $TMPBACKUP
fi

# Vérifier si d'anciennes backups corrompues sont présentes
if test $(find "$TMPBACKUP" -type f -size 0 | wc -c) -ne 0
     then
          swaks -t $EMAIL -s $MAILSERVER -tls -au $EMAIL --ap $EMAILPASSWORD -f $EMAIL --h-Subject $MAILSUBJECT --body $MAILMESSAGE
          exit
fi

# Supprimer l'ancienne archive
rm $TMPBACKUP/*

# Creer une backup en local
tar czf $TMPBACKUP/dk-$TIMESTAMP.tar.gz /var/www/. /home/awa/clients/.
