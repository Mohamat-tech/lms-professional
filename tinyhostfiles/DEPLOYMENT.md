# 🚀 Guide de Déploiement LMS Professionnel

## 📋 Table des Matières
1. [Déploiement Tiny.host](#déploiement-tinyhost)
2. [Déploiement Vercel](#déploiement-vercel)
3. [Déploiement Render](#déploiement-render)
4. [Configuration locale](#configuration-locale)

---

## 🌐 Déploiement Tiny.host

### Étape 1: Préparer les fichiers

```bash
cd ~/Desktop/lms-professionnel
# Les fichiers sont prêts dans tinyhostfiles/
```

### Étape 2: Créer l'archive

1. **Copier tous les fichiers frontend dans `tinyhostfiles/`:**
```bash
cp -r frontend/* tinyhostfiles/
cp -r backend/* tinyhostfiles/
cp database/schema.sql tinyhostfiles/
```

2. **Créer une archive ZIP:**
```bash
cd tinyhostfiles
zip -r ../lms-professional-tinyhost.zip .
```

### Étape 3: Upload sur Tiny.host

1. Visite [tiny.host](https://tiny.host)
2. Upload l'archive `lms-professional-tinyhost.zip`
3. Attends le traitement
4. Tu recevras un lien pour accéder à ton LMS!

### Configuration Tiny.host

- **PHP:** Supporté ✅
- **MySQL:** Non disponible (utilise MongoDB ou SQLite si nécessaire)
- **Alternative:** Déploie le backend sur Render, utilise une API externe

---

## 💻 Déploiement Vercel

### Étape 1: Setup GitHub

```bash
cd ~/Desktop/lms-professionnel

# Initialiser git
git init
git add .
git commit -m "Initial commit: LMS Professional Phase 1"

# Ajouter remote GitHub
git remote add origin https://github.com/YOUR_USERNAME/lms-professional.git
git push -u origin main
```

### Étape 2: Connecter à Vercel

1. Visite [vercel.com](https://vercel.com)
2. Login avec ton compte GitHub
3. Clique "New Project"
4. Sélectionne le repo `lms-professional`
5. Configure les variables d'environnement:

```
JWT_SECRET=your-secret-key-here
API_URL=https://your-render-backend.com
FRONTEND_URL=https://your-vercel-app.com
```

6. Click "Deploy"

### Résultat
Ton frontend sera accessible à: `https://lms-professional.vercel.app`

---

## 🔧 Déploiement Render

### Étape 1: Créer un service Backend

1. Visite [render.com](https://render.com)
2. Login / Signup
3. Clique "New +"
4. Sélectionne "Web Service"
5. Connecte ton repo GitHub
6. Configure:

```
Name: lms-professional-backend
Environment: PHP 8.2
Build Command: composer install
Start Command: php -S 0.0.0.0:3000
```

### Étape 2: Créer une base de données

1. Dans Render, clique "Databases"
2. Clique "New Database"
3. Configure:

```
Name: lms_professional
PostgreSQL Version: 15
```

### Étape 3: Variables d'environnement

```
DB_HOST=your_database_host
DB_USER=your_db_user
DB_PASS=your_db_password
DB_NAME=lms_professional
JWT_SECRET=your-secret-key
```

### Résultat
Ton backend sera accessible à: `https://lms-professional-backend.render.com`

---

## 🏠 Configuration Locale

### Prérequis

- PHP 8.0+
- MySQL 8.0+
- Node.js 16+

### Installation

1. **Clone le repo:**
```bash
git clone https://github.com/YOUR_USERNAME/lms-professional.git
cd lms-professional
```

2. **Crée la base de données:**
```bash
mysql -u root -p < database/schema.sql
```

3. **Configure la base de données:**
```bash
# Édite backend/config/database.php
nano backend/config/database.php
```

Mets à jour:
```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'your_password');
define('DB_NAME', 'lms_professional');
```

4. **Lance le serveur PHP:**
```bash
cd backend
php -S localhost:8000
```

5. **Dans un autre terminal, lance un serveur frontend:**
```bash
cd frontend
npx http-server . -p 3000
```

6. **Accès:**
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:8000`

---

## 🔐 Variables d'Environnement

Crée un fichier `.env` à la racine:

```
# Database
DB_HOST=localhost
DB_USER=root
DB_PASS=password
DB_NAME=lms_professional

# JWT
JWT_SECRET=your-super-secret-key-change-this

# API
API_URL=http://localhost:8000
FRONTEND_URL=http://localhost:3000

# Upload
MAX_FILE_SIZE=52428800
UPLOAD_DIR=/uploads

# Email (optional)
MAIL_FROM=noreply@lms.local
MAIL_HOST=smtp.example.com
MAIL_PORT=587

# Debug
DEBUG_MODE=true
```

---

## 📝 Premières Étapes

### Créer un Compte Admin

```bash
# Via API
curl -X POST http://localhost:8000/backend/api/auth.php \
  -H "Content-Type: application/json" \
  -d '{
    "action": "signup",
    "email": "admin@example.com",
    "password": "SecurePassword123!",
    "firstName": "Admin",
    "lastName": "User",
    "userType": "admin"
  }'
```

### Tester l'Authentification

1. Va à `http://localhost:3000/frontend/pages/login.html`
2. Crée un compte
3. Tu seras redirigé vers le dashboard
4. Consulte "Mes Cours" et les devoirs

---

## 🐛 Debugging

### Erreurs Courantes

**Erreur 1: Database Connection Failed**
```
Solution: Vérifie les credentials dans backend/config/database.php
```

**Erreur 2: CORS Policy Blocked**
```
Solution: Configure CORS dans backend/api/auth.php (déjà fait ✅)
```

**Erreur 3: JWT Token Invalid**
```
Solution: Change JWT_SECRET dans backend/config/database.php
```

---

## 📞 Support

- 📧 Email: ndaoba@example.com
- 🐙 GitHub: @NDAOBA
- 💬 Discord: Rejoins notre serveur

---

## ✅ Checklist Pré-Production

- [ ] JWT_SECRET changé
- [ ] Database sécurisée
- [ ] HTTPS activé
- [ ] Logs configurés
- [ ] Backups automati ques
- [ ] CDN configuré
- [ ] Rate limiting activé
- [ ] Monitoring en place

---

**Déploiement facile! 🚀**

*Développé par NDAOBA MOHAMAT 24G2687*
