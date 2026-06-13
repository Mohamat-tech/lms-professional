/* ============================================
   DASHBOARD.js - Gestion du tableau de bord
   ============================================ */

class Dashboard {
  constructor() {
    this.currentUser = app.currentUser;
    this.init();
  }

  init() {
    if (!this.currentUser) {
      app.redirect('/frontend/pages/login.html');
      return;
    }

    this.loadStats();
    this.loadRecentCourses();
    this.loadUpcomingAssignments();
    this.setupSidebarNavigation();
  }

  loadStats() {
    // Simulated API call - replace with real API
    const statsData = {
      activeCourses: 5,
      pendingAssignments: 3,
      averageScore: 87,
      badgesEarned: 8
    };

    this.displayStats(statsData);
  }

  displayStats(data) {
    const statsContainer = document.querySelector('.stats-grid');
    if (!statsContainer) return;

    // Update existing stat cards
    const statCards = statsContainer.querySelectorAll('.stat-card');
    if (statCards[0]) {
      statCards[0].querySelector('.stat-value').textContent = data.activeCourses;
    }
    if (statCards[1]) {
      statCards[1].querySelector('.stat-value').textContent = data.pendingAssignments;
    }
    if (statCards[2]) {
      statCards[2].querySelector('.stat-value').textContent = data.averageScore + '%';
    }
    if (statCards[3]) {
      statCards[3].querySelector('.stat-value').textContent = data.badgesEarned;
    }
  }

  loadRecentCourses() {
    // Simulated API call
    const courses = [
      {
        id: 1,
        title: 'Introduction à Python',
        professor: 'Prof. Jean Dupont',
        progress: 65,
        icon: '📖'
      },
      {
        id: 2,
        title: 'Développement Web',
        professor: 'Prof. Marie Martin',
        progress: 42,
        icon: '💻'
      },
      {
        id: 3,
        title: 'Algorithmes Avancés',
        professor: 'Prof. Pierre Laurent',
        progress: 88,
        icon: '🎓'
      }
    ];

    console.log('Courses loaded:', courses);
  }

  loadUpcomingAssignments() {
    // Simulated API call
    const assignments = [
      {
        id: 1,
        title: 'TP 1: Variables et Boucles',
        course: 'Python',
        dueDate: '2026-06-15'
      },
      {
        id: 2,
        title: 'Projet Website',
        course: 'Web',
        dueDate: '2026-06-22'
      }
    ];

    console.log('Assignments loaded:', assignments);
  }

  setupSidebarNavigation() {
    const sidebarLinks = document.querySelectorAll('.sidebar-menu a');

    sidebarLinks.forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();

        // Remove active from all
        sidebarLinks.forEach(l => l.classList.remove('active'));

        // Add active to clicked
        link.classList.add('active');
      });
    });
  }
}

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
  if (window.location.pathname.includes('dashboard')) {
    const dashboard = new Dashboard();
  }
});
