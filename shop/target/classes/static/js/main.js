// Toast notification
function showToast(msg, duration = 2800) {
  const existing = document.querySelector('.toast');
  if (existing) existing.remove();
  const toast = document.createElement('div');
  toast.className = 'toast';
  toast.textContent = msg;
  document.body.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity .3s';
    setTimeout(() => toast.remove(), 300);
  }, duration);
}

// Login required alert
document.addEventListener('DOMContentLoaded', () => {
  const params = new URLSearchParams(window.location.search);
  if (params.get('alert') === 'login') {
    showToast('🔒 로그인이 필요한 서비스입니다', 3500);
  }

  // Cart button intercept (requires login)
  document.querySelectorAll('[data-login-required]').forEach(el => {
    el.addEventListener('click', e => {
      const isLoggedIn = document.body.dataset.loggedIn === 'true';
      if (!isLoggedIn) {
        e.preventDefault();
        showToast('🔒 로그인이 필요합니다');
        setTimeout(() => { window.location.href = '/auth/login?alert=login'; }, 1200);
      }
    });
  });
});
