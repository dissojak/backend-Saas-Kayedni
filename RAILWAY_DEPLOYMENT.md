# Guide de Déploiement sur Railway

## Problème Résolu
L'erreur `DotEnvException: Could not find /.env on the classpath` a été corrigée en rendant le chargement du fichier `.env` optionnel avec `.ignoreIfMissing()`.

## Configuration des Variables d'Environnement sur Railway

### Étapes à suivre :

1. **Accédez à votre projet sur Railway**
   - Allez sur [railway.app](https://railway.app)
   - Sélectionnez votre projet

2. **Configurez les variables d'environnement**
   - Cliquez sur votre service
   - Allez dans l'onglet **Variables**
   - Ajoutez toutes les variables suivantes :

### Variables Requises :

```bash
# Google Gemini
GEMINI_API_KEY=AIzaSyDfYE_M-N7P6tbDS2bbcvETEo6-WI1a6Cw

# SMTP (Gmail App Password)
SPRING_MAIL_PASSWORD=jmnwfcjezsscpdkb
MAIL_USERNAME=dissojak@gmail.com

# Database
DB_URL=jdbc:mysql://bookify-mysql-dissojak-6554.a.aivencloud.com:24712/bookify_saas?sslMode=REQUIRED&serverTimezone=UTC
DB_USERNAME=avnadmin
DB_PASSWORD=AVNS_JV7jRfgpDz56cM4faQG

# JWT
JWT_SECRET=404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970

# Cloudinary
CLOUDINARY_CLOUD_NAME=duvougrqx
CLOUDINARY_API_KEY=513133278582537
CLOUDINARY_API_SECRET=0UgeZPnsrmRfbWu-u8eZxo-W0uk
CLOUDINARY_FOLDER=Bookify
CLOUDINARY_KEY_NAME=StoonProd

# Flouci API Keys
FLOUCI_WEBHOOK_SECRET=
FLOUCI_BASE_URL=https://developers.flouci.com
FLOUCI_APP_PUBLIC=d01440af-5a3b-4c9f-8567-6c0f964d1ef7
FLOUCI_APP_SECRET=dd3163a3-a4ad-4ec5-8875-e5658b3ef0ff
FLOUCI_APP_TOKEN=d01440af-5a3b-4c9f-8567-6c0f964d1ef7
FLOUCI_DEVELOPER_TRACKING_ID=a702c74a-9a4d-4f36-b18d-b76f63b7bef8

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DATABASE=0
```

### Important :

1. **Ne commitez JAMAIS le fichier `.env` dans Git** - Il contient des informations sensibles
2. **Le fichier `.env` est uniquement pour le développement local**
3. **Sur Railway, utilisez les variables d'environnement de la plateforme**

### Redis sur Railway :

Si vous utilisez Redis, vous devrez :
1. Ajouter un service Redis dans Railway
2. Mettre à jour les variables `REDIS_HOST`, `REDIS_PORT` et `REDIS_PASSWORD` avec les valeurs fournies par Railway

### Redéploiement :

Après avoir ajouté toutes les variables d'environnement :
1. Railway redéploiera automatiquement votre application
2. L'application utilisera les variables d'environnement système au lieu du fichier `.env`

## Comment ça fonctionne maintenant ?

Le code a été modifié pour :
- Charger le `.env` en **développement local** (si le fichier existe)
- Utiliser les **variables d'environnement système** en **production** (Railway)
- Ne plus planter si le fichier `.env` est absent

```java
// Avant (échouait sur Railway)
Dotenv dotenv = Dotenv.configure().load();

// Après (fonctionne partout)
Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
```

## Vérification

Une fois déployé, vérifiez les logs de Railway pour confirmer que l'application démarre correctement sans erreur `DotEnvException`.

