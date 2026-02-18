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

⚠️ **IMPORTANT** : Copiez les valeurs depuis votre fichier `.env` local. Ne commitez JAMAIS de vraies valeurs dans Git !

```bash
# Google Gemini
GEMINI_API_KEY=your_gemini_api_key_here

# SMTP (Gmail App Password)
SPRING_MAIL_PASSWORD=your_gmail_app_password_here
MAIL_USERNAME=your_email@gmail.com

# Database (Aiven MySQL)
DB_URL=jdbc:mysql://your-db-host:port/database_name?sslMode=REQUIRED&serverTimezone=UTC
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password

# JWT
JWT_SECRET=your_jwt_secret_key_here

# Cloudinary
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_FOLDER=Bookify
CLOUDINARY_KEY_NAME=StoonProd

# Flouci API Keys
FLOUCI_WEBHOOK_SECRET=your_flouci_webhook_secret
FLOUCI_BASE_URL=https://developers.flouci.com
FLOUCI_APP_PUBLIC=your_flouci_app_public
FLOUCI_APP_SECRET=your_flouci_app_secret
FLOUCI_APP_TOKEN=your_flouci_app_token
FLOUCI_DEVELOPER_TRACKING_ID=your_flouci_tracking_id

# Redis Configuration (si utilisé)
REDIS_HOST=your_redis_host
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
REDIS_DATABASE=0
```

💡 **Astuce** : Sur Railway, allez dans votre projet → Service → Variables et collez vos vraies valeurs depuis votre `.env` local.

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

