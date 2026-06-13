/* ============================================
   AUTHENTICATION.js - Gestion de l'authentification
   ============================================ */

class AuthManager {
  constructor() {
    this.form = null;
    this.isLogin = window.location.pathname.includes('login');
  }

  init() {
    this.form = document.querySelector('.auth-form');
    if (!this.form) return;

    this.form.addEventListener('submit', (e) => this.handleSubmit(e));
    this.setupPasswordToggle();
  }

  async handleSubmit(e) {
    e.preventDefault();

    const submitBtn = this.form.querySelector('[type="submit"]');
    const originalText = submitBtn.textContent;
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<span class="spinner"></span>';

    try {
      const formData = new FormData(this.form);
      const data = Object.fromEntries(formData);

      if (this.isLogin) {
        await this.performLogin(data);
      } else {
        await this.performSignup(data);
      }
    } catch (error) {
      console.error('Auth error:', error);
      app.showNotification('Une erreur est survenue', 'error');
    } finally {
      submitBtn.disabled = false;
      submitBtn.textContent = originalText;
    }
  }

  async performLogin(data) {
    // Validation
    if (!this.validateEmail(data.email)) {
      app.showNotification('Email invalide', 'error');
      return;
    }

    if (data.password.length < 6) {
      app.showNotification('Mot de passe trop court', 'error');
      return;
    }

    // Appel API
    const success = await app.login(data.email, data.password);
    return success;
  }

  async performSignup(data) {
    // Validation
    if (!data.firstName || !data.lastName) {
      app.showNotification('Veuillez remplir tous les champs', 'error');
      return;
    }

    if (!this.validateEmail(data.email)) {
      app.showNotification('Email invalide', 'error');
      return;
    }

    if (data.password.length < 8) {
      app.showNotification('Le mot de passe doit contenir au moins 8 caractères', 'error');
      return;
    }

    if (data.password !== data.confirmPassword) {
      app.showNotification('Les mots de passe ne correspondent pas', 'error');
      return;
    }

    // Appel API
    const success = await app.signup(data);
    return success;
  }

  setupPasswordToggle() {
    const toggleBtns = document.querySelectorAll('.password-toggle');
    toggleBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const input = btn.previousElementSibling;
        const isPassword = input.type === 'password';

        input.type = isPassword ? 'text' : 'password';
        btn.textContent = isPassword ? '🙈' : '👁️';
      });
    });
  }

  validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }
}

// ============================================
// INITIALIZATION
// ============================================

let authManager;
document.addEventListener('DOMContentLoaded', () => {
  if (window.location.pathname.includes('login') || window.location.pathname.includes('signup')) {
    authManager = new AuthManager();
    authManager.init();
  }
});
