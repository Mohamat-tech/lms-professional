/* ============================================
   UI-UTILS.js - Utilitaires pour l'interface
   ============================================ */

class UIUtils {
  // ============================================
  // MODALS
  // ============================================

  static openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }

  static closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove('active');
      document.body.style.overflow = 'auto';
    }
  }

  static closeAllModals() {
    document.querySelectorAll('.modal-overlay.active').forEach(modal => {
      modal.classList.remove('active');
    });
    document.body.style.overflow = 'auto';
  }

  // ============================================
  // FORMS
  // ============================================

  static getFormData(formSelector) {
    const form = document.querySelector(formSelector);
    if (!form) return null;

    return Object.fromEntries(new FormData(form));
  }

  static resetForm(formSelector) {
    const form = document.querySelector(formSelector);
    if (form) form.reset();
  }

  static setFormValues(formSelector, data) {
    const form = document.querySelector(formSelector);
    if (!form) return;

    Object.keys(data).forEach(key => {
      const input = form.querySelector(`[name="${key}"]`);
      if (input) input.value = data[key];
    });
  }

  static disableForm(formSelector, disabled = true) {
    const form = document.querySelector(formSelector);
    if (!form) return;

    form.querySelectorAll('input, textarea, select, button').forEach(el => {
      el.disabled = disabled;
    });
  }

  // ============================================
  // TABLES
  // ============================================

  static createTableRow(data, columns) {
    const row = document.createElement('tr');

    columns.forEach(col => {
      const cell = document.createElement('td');
      cell.textContent = data[col] || '-';
      row.appendChild(cell);
    });

    return row;
  }

  static populateTable(tableSelector, data, columns) {
    const tbody = document.querySelector(`${tableSelector} tbody`);
    if (!tbody) return;

    tbody.innerHTML = '';
    data.forEach(item => {
      tbody.appendChild(this.createTableRow(item, columns));
    });
  }

  // ============================================
  // DROPDOWNS
  // ============================================

  static setupDropdowns() {
    document.querySelectorAll('.dropdown-toggle').forEach(toggle => {
      toggle.addEventListener('click', (e) => {
        e.preventDefault();
        const menu = toggle.nextElementSibling;
        if (menu && menu.classList.contains('dropdown-menu')) {
          menu.classList.toggle('hidden');
        }
      });
    });

    // Fermer les dropdowns en cliquant ailleurs
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.dropdown')) {
        document.querySelectorAll('.dropdown-menu').forEach(menu => {
          menu.classList.add('hidden');
        });
      }
    });
  }

  // ============================================
  // LOADING STATES
  // ============================================

  static showLoading(elementSelector, text = 'Chargement...') {
    const element = document.querySelector(elementSelector);
    if (!element) return;

    element.innerHTML = `
      <div class="flex-center" style="padding: 2rem;">
        <span class="spinner spinner-lg"></span>
        <span style="margin-left: 1rem;">${text}</span>
      </div>
    `;
  }

  static hideLoading(elementSelector) {
    const element = document.querySelector(elementSelector);
    if (element) {
      element.innerHTML = '';
    }
  }

  // ============================================
  // TABS
  // ============================================

  static setupTabs() {
    document.querySelectorAll('.tab-nav').forEach(nav => {
      nav.querySelectorAll('[data-tab]').forEach(tab => {
        tab.addEventListener('click', (e) => {
          e.preventDefault();
          const tabName = tab.dataset.tab;

          // Désactiver tous les onglets
          nav.querySelectorAll('[data-tab]').forEach(t => {
            t.classList.remove('active');
          });

          // Cacher tous les contenus
          document.querySelectorAll('[data-tab-content]').forEach(content => {
            content.classList.add('hidden');
          });

          // Activer l'onglet et afficher le contenu
          tab.classList.add('active');
          const content = document.querySelector(`[data-tab-content="${tabName}"]`);
          if (content) content.classList.remove('hidden');
        });
      });
    });
  }

  // ============================================
  // VALIDATION
  // ============================================

  static showFieldError(fieldName, message) {
    const field = document.querySelector(`[name="${fieldName}"]`);
    if (!field) return;

    field.classList.add('error');
    const errorEl = field.nextElementSibling;

    if (errorEl && errorEl.classList.contains('field-error')) {
      errorEl.textContent = message;
    } else {
      const error = document.createElement('div');
      error.className = 'field-error';
      error.textContent = message;
      field.parentNode.insertBefore(error, field.nextSibling);
    }
  }

  static clearFieldError(fieldName) {
    const field = document.querySelector(`[name="${fieldName}"]`);
    if (!field) return;

    field.classList.remove('error');
    const errorEl = field.nextElementSibling;
    if (errorEl && errorEl.classList.contains('field-error')) {
      errorEl.remove();
    }
  }

  // ============================================
  // ANIMATIONS
  // ============================================

  static fadeIn(element, duration = 300) {
    element.style.opacity = '0';
    element.style.transition = `opacity ${duration}ms ease-in`;
    
    setTimeout(() => {
      element.style.opacity = '1';
    }, 10);
  }

  static fadeOut(element, duration = 300) {
    element.style.opacity = '1';
    element.style.transition = `opacity ${duration}ms ease-out`;
    
    setTimeout(() => {
      element.style.opacity = '0';
    }, 10);
  }

  static slideDown(element, duration = 300) {
    element.style.height = '0';
    element.style.overflow = 'hidden';
    element.style.transition = `height ${duration}ms ease-in`;
    
    setTimeout(() => {
      element.style.height = element.scrollHeight + 'px';
    }, 10);
  }

  static slideUp(element, duration = 300) {
    element.style.height = element.scrollHeight + 'px';
    element.style.overflow = 'hidden';
    element.style.transition = `height ${duration}ms ease-out`;
    
    setTimeout(() => {
      element.style.height = '0';
    }, 10);
  }
}

// ============================================
// INITIALIZATION
// ============================================

document.addEventListener('DOMContentLoaded', () => {
  UIUtils.setupTabs();
  UIUtils.setupDropdowns();
});
