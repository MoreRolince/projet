# Utilisation de l'image officielle Python
FROM python:3.13.0-alpine3.20

# Définition du répertoire de travail
WORKDIR /app

# Copie du script sum.py dans le conteneur
COPY sum.py .

# Commande par défaut pour exécuter le script avec des arguments

ENTRYPOINT ["python", "sum.py"]

