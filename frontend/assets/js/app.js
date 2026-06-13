/* ============================================
   APP.js - LMS Sophistiqué
   Logique principale de l'application
   ============================================ */

class LMSApp {
  constructor() {
    this.currentUser = null;
    this.isDarkMode = this.getThemePreference();
    this.init();
  }

  init() {
    this.setupTheme();
    this.setupEventListeners();
    this.checkAuth();
    this.setupNotifications();
  }

  // ============================================
  // THEME MANAGEMENT
  // ============================================

  getThemePreference() {
    const saved = localStorage.getItem('lms-theme');
    if (saved) return saved === 'dark';

    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  }

  setupTheme() {
    if (this.isDarkMode) {
      document.documentElement.classList.add('dark-mode');
    }

    const themeToggle = document.querySelector('.theme-toggle');
    if (themeToggle) {
      themeToggle.addEventListener('click', () => this.toggleTheme());
      this.updateThemeIcon();
    }
  }

  toggleTheme() {
    this.isDarkMode = !this.isDarkMode;
    localStorage.setItem('lms-theme', this.isDarkMode ? 'dark' : 'light');

    if (this.isDarkMode) {
      document.documentElement.classList.add('dark-mode');
    } else {
      document.documentElement.classList.remove('dark-mode');
    }

    this.updateThemeIcon();
  }

  updateThemeIcon() {
    const icon = document.querySelector('.theme-toggle');
    if (icon) {
      icon.textContent = this.isDarkMode ? '☀️' : '🌙';
    }
  }

  // ============================================
  // AUTHENTICATION
  // ============================================

  checkAuth() {
    const token = localStorage.getItem('lms-token');
    const user = localStorage.getItem('lms-user');

    if (token && user) {
      this.currentUser = JSON.parse(user);
      this.updateNavigation();
    } else if (!window.location.pathname.includes('login')) {
      // Rediriger vers login si pas authentifié
      // this.redirect('/pages/login.html');
    }
  }

  async login(email, password) {
    try {
      const response = await fetch('https://lms-professional.onrender.com/backend/api/auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'login', email, password })
      });

      const data = await response.json();

      if (data.success) {
        localStorage.setItem('lms-token', data.token);
        localStorage.setItem('lms-user', JSON.stringify(data.user));
        this.currentUser = data.user;
        this.showNotification('Connexion réussie!', 'success');
        setTimeout(() => this.redirect('/pages/dashboard.html'), 1500);
        return true;
      } else {
        this.showNotification(data.message || 'Erreur de connexion', 'error');
        return false;
      }
    } catch (error) {
      console.error('Login error:', error);
      this.showNotification('Erreur serveur', 'error');
      return false;
    }
  }

  async signup(userData) {
    try {
      const response = await fetch('https://lms-professional.onrender.com/backend/api/auth.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'signup', ...userData })
      });

      const data = await response.json();

      if (data.success) {
        this.showNotification('Compte créé! Connexion...', 'success');
        await this.login(userData.email, userData.password);
        return true;
      } else {
        this.showNotification(data.message || 'Erreur lors de la création', 'error');
        return false;
      }
    } catch (error) {
      console.error('Signup error:', error);
      this.showNotification('Erreur serveur', 'error');
      return false;
    }
  }

  logout() {
    localStorage.removeItem('lms-token');
    localStorage.removeItem('lms-user');
    this.currentUser = null;
    this.showNotification('Déconnexion réussie', 'success');
    setTimeout(() => this.redirect('/pages/login.html'), 1000);
  }

  updateNavigation() {
    const navMenu = document.querySelector('.nav-menu');
    if (!navMenu || !this.currentUser) return;

    const userMenuHTML = `
      <li class="dropdown">
        <a href="#" class="dropdown-toggle">
          ${this.currentUser.firstName} ${this.currentUser.lastName}
        </a>
        <ul class="dropdown-menu hidden">
          <li><a href="/pages/profile.html">Profil</a></li>
          <li><a href="/pages/settings.html">Paramètres</a></li>
          <li><hr></li>
          <li><a href="#" onclick="app.logout(); return false;">Déconnexion</a></li>
        </ul>
      </li>
    `;

    const existingUserMenu = navMenu.querySelector('.dropdown');
    if (existingUserMenu) {
      existingUserMenu.remove();
    }

    navMenu.insertAdjacentHTML('beforeend', userMenuHTML);
  }

  // ============================================
  // NOTIFICATIONS
  // ============================================

  setupNotifications() {
    // Conteneur notifications
    if (!document.querySelector('.notifications-container')) {
      const container = document.createElement('div');
      container.className = 'notifications-container';
      document.body.appendChild(container);
    }
  }

  showNotification(message, type = 'info', duration = 3000) {
    const container = document.querySelector('.notifications-container');
    if (!container) return;

    const notification = document.createElement('div');
    notification.className = `notification notification-${type} animate-in`;
    notification.innerHTML = `
      <div class="notification-content">
        <span class="notification-icon">${this.getNotificationIcon(type)}</span>
        <span class="notification-message">${message}</span>
        <button class="notification-close">&times;</button>
      </div>
    `;

    container.appendChild(notification);

    notification.querySelector('.notification-close').addEventListener('click', () => {
      notification.remove();
    });

    setTimeout(() => {
      notification.style.opacity = '0';
      setTimeout(() => notification.remove(), 300);
    }, duration);
  }

  getNotificationIcon(type) {
    const icons = {
      success: '✓',
      error: '✕',
      info: 'ℹ',
      warning: '⚠'
    };
    return icons[type] || '●';
  }

  // ============================================
  // UTILITIES
  // ============================================

  redirect(path) {
    window.location.href = path;
  }

  formatDate(date) {
    return new Date(date).toLocaleDateString('fr-FR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  }

  formatTime(date) {
    return new Date(date).toLocaleTimeString('fr-FR', {
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  debounce(func, delay) {
    let timeoutId;
    return (...args) => {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => func(...args), delay);
    };
  }

  // ============================================
  // EVENT LISTENERS
  // ============================================

  setupEventListeners() {
    // Fermer les modales en cliquant sur l'overlay
    document.addEventListener('click', (e) => {
      if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('active');
      }
    });

    // Fermer les modales avec Escape
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
          modal.classList.remove('active');
        });
      }
    });
  }
}

// ============================================
// INITIALIZATION
// ============================================

let app;
document.addEventListener('DOMContentLoaded', () => {
  app = new LMSApp();
  console.log('🚀 LMS App initialized');
});
