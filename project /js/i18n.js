import i18next from 'i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import HttpBackend from 'i18next-http-backend';

i18next
  .use(HttpBackend)
  .use(LanguageDetector)
  .init({
    fallbackLng: 'ar',
    supportedLngs: ['ar', 'fr', 'en'],
    ns: ['common', 'home', 'hotels', 'flights', 'trains', 'destinations'],
    defaultNS: 'common',
    backend: {
      loadPath: '/locales/{{lng}}/{{ns}}.json'
    }
  });

export default i18next;

// Language switcher function
export function switchLanguage(lang) {
  i18next.changeLanguage(lang);
  document.documentElement.lang = lang;
  document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
  
  // Save language preference
  localStorage.setItem('preferred-language', lang);
  
  // Reload translations
  updateContent();
}

// Update page content with new translations
function updateContent() {
  document.querySelectorAll('[data-i18n]').forEach(element => {
    const key = element.getAttribute('data-i18n');
    element.textContent = i18next.t(key);
  });
}

// Initialize translations when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  updateContent();
});