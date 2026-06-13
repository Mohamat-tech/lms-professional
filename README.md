# LMS Professional - GitHub README

## 🎓 LMS Professionnel - Plateforme d'Apprentissage Sophisti quée

Une plateforme d'apprentissage en ligne complète et professionnelle avec design iOS26, thème jour/nuit dynamique, et fonctionnalités avancées d'IA.

**Développé par:** NDAOBA MOHAMAT 24G2687

### ✨ Fonctionnalités Principales

#### 👥 Gestion des Utilisateurs
- ✅ Authentification JWT sécurisée
- ✅ Roles multiples (Étudiant, Professeur, Admin)
- ✅ Gestion de profil complet
- ✅ Suivi de la progression

#### 📚 Gestion des Cours
- ✅ Création de cours par les professeurs
- ✅ Organisation par filières et niveaux
- ✅ Upload de PDF, vidéos, documents
- ✅ Ressources multimédias

#### 📝 Évaluation et Devoirs
- ✅ Création de devoirs et quiz
- ✅ Soumission de devoirs en PDF/Image
- ✅ Correction automatisée par IA (maison)
- ✅ Feedback détaillé et notation

#### 📊 Tableau de Bord Analytique
- ✅ Graphiques de progression (Chart.js)
- ✅ Historique de performance
- ✅ Compétences par pourcentage
- ✅ Évolution au fil de l'année

#### 🎥 Sessions de Live Streaming
- ✅ Lives interactifs (WebRTC simple)
- ✅ Chat en temps réel
- ✅ Activation micro/caméra
- ✅ Enregistrement des sessions

#### 👥 Études en Groupe
- ✅ Création de sessions d'études
- ✅ Collaboration en groupe
- ✅ Partage de ressources
- ✅ Calendrier des sessions

### 🎨 Design & Interface

- **Palette de Couleurs Vives:**
  - Bleu (`#0066FF`) - Primaire
  - Rouge (`#FF3333`) - Accent
  - Vert (`#00CC44`) - Succès
  - Citron (`#CCFF00`) - Attention
  - Mauve (`#9933FF`) - Accent
  - Bleu Ciel (`#00CCFF`) - Accent
  - Rose (`#FF3399`) - Accent

- **Thème Jour/Nuit:** Basculement automatique avec préférence système
- **Design iOS26:** Inspiré de l'interface Apple la plus moderne
- **Responsive:** Mobile-first, adaptatif sur tous les appareils

### 🏗️ Architecture Technique

#### Frontend
```
frontend/
├── index.html                 # Page d'accueil
├── pages/
│   ├── login.html            # Page de connexion
│   ├── signup.html           # Inscription
│   ├── dashboard.html        # Tableau de bord
│   ├── courses.html          # Gestion des cours
│   └── evaluation.html       # Système d'évaluation
├── assets/
│   ├── css/
│   │   ├── theme.css         # Design system
│   │   ├── main.css          # Styles principaux
│   │   ├── components.css    # Composants UI
│   │   └── responsive.css    # Media queries
│   └── js/
│       ├── app.js            # Logique main
│       ├── auth.js           # Authentification
│       ├── dashboard.js      # Dashboard
│       └── ui-utils.js       # Utilitaires UI
```

#### Backend
```
backend/
├── api/
│   ├── auth.php              # Authentification
│   ├── courses.php           # Gestion cours
│   ├── evaluations.php       # Système d'évaluation
│   ├── students.php          # Gestion étudiants
│   └── ai-correction.php     # Correction IA
├── config/
│   └── database.php          # Configuration DB
├── models/
│   ├── User.php              # Modèle utilisateur
│   ├── Course.php            # Modèle cours
│   ├── Evaluation.php        # Modèle évaluation
│   └── Student.php           # Modèle étudiant
└── utils/
    ├── auth-handler.php      # JWT management
    ├── file-upload.php       # Upload handler
    ├── ai-evaluator.php      # Correcteur IA
    └── response-formatter.php # Formatage réponses
```

#### Database
```
MySQL 8.0+
├── users              # Utilisateurs
├── courses            # Cours
├── courseContent      # Contenus cours
├── assignments        # Devoirs
├── submissions        # Remises devoirs
├── grades             # Grades/Notes
├── competencies       # Compétences
├── groupStudySessions # Sessions groupe
└── liveSessions       # Sessions live
```

### 🚀 Installation & Déploiement

#### Installation Locale

1. **Clone le repository**
```bash
git clone https://github.com/ndaoba/lms-professional.git
cd lms-professional
```

2. **Setup Base de Données**
```bash
mysql -u root -p < database/schema.sql
```

3. **Configure la base de données**
- Édite `backend/config/database.php`
- Renseigne tes identifiants MySQL

4. **Lance un serveur local**
```bash
php -S localhost:8000
```

#### Déploiement Tiny.host

1. Archive les fichiers du dossier `tinyhostfiles/`
2. Upload sur tiny.host
3. Configure les variables d'environnement

#### Déploiement Vercel

1. Push sur GitHub
2. Connecte le repo à Vercel
3. Configure les variables d'environnement
4. Deploy!

#### Déploiement Render

1. Push sur GitHub
2. Crée un nouveau service sur Render
3. Pointe vers le repo
4. Configure `render.yaml`
5. Deploy!

### 🔐 Sécurité

- JWT tokens avec expiration
- Password hashing avec bcrypt
- CORS configuré
- Validation des inputs
- Protection contre les injections SQL

### 📊 Technologies Utilisées

**Frontend:**
- HTML5 / CSS3 / JavaScript ES6+
- Vanilla JS (Pas de dépendances)
- Chart.js pour graphiques
- WebRTC pour lives

**Backend:**
- PHP 8.0+
- MySQL 8.0+
- JWT pour authentification

**Déploiement:**
- Tiny.host (Static hosting)
- Vercel (Frontend)
- Render (Backend)

### 📝 Utilisation

#### Créer un Compte
1. Clique sur "S'inscrire"
2. Remplis le formulaire
3. Choisis ton rôle (Étudiant/Professeur)
4. Connecte-toi!

#### Consultez les Cours
1. Accède au tableau de bord
2. Consulte "Mes Cours"
3. Clique sur un cours pour accéder au contenu
4. Complète les modules

#### Soumettre un Devoir
1. Va à "Devoirs"
2. Clique sur un devoir
3. Charge ton PDF/image
4. Soumet!

#### Voir ta Progression
1. Va à "Résultats"
2. Consulte tes graphiques de compétences
3. Vois ton évolution!

### 📧 Support

Pour toute question ou bug:
- Crée une issue sur GitHub
- Email: ndaoba@example.com

### 📄 Licence

MIT License - Voir LICENSE.md

### 👨‍💻 Auteur

**NDAOBA MOHAMAT**
- ID: 24G2687
- Développeur Full Stack
- Spécialiste en Plateforme d'apprentissage

---

**Made with ❤️ by NDAOBA MOHAMAT 24G2687**
