# Snippet animazioni Vektora

Usare questi snippet SOLO dopo aver seguito la procedura in SKILL.md §4.
Non copiare snippets senza aver ricevuto conferma esplicita dall'utente.

---

## prefers-reduced-motion (obbligatorio in ogni progetto)

```css
/* Accessibilità: rispetta la preferenza di sistema per il movimento ridotto */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## Piano Standard — fade-in-load

Dissolvenza degli elementi principali al caricamento (CSS puro).

```css
/* Fade-in al caricamento — Piano Standard */
.fade-in {
  opacity: 0;
  animation: fadeIn 0.6s ease forwards;
}

@keyframes fadeIn {
  to { opacity: 1; }
}

.fade-in-delay-1 { animation-delay: 0.1s; }
.fade-in-delay-2 { animation-delay: 0.2s; }
.fade-in-delay-3 { animation-delay: 0.3s; }
```

```html
<!-- Applicare la classe agli elementi che devono apparire in dissolvenza -->
<h1 class="fade-in">Titolo</h1>
<p class="fade-in fade-in-delay-1">Sottotitolo</p>
```

---

## Piano Standard — button-hover-scale

Ingrandimento leggero dei bottoni su hover (Tailwind + CSS).

```html
<!-- Classe Tailwind — nessun CSS aggiuntivo richiesto -->
<a href="#" class="transition-transform duration-200 hover:scale-105 hover:shadow-md">
  Contattaci
</a>
```

---

## Piano Standard — smooth-scroll

```css
/* Scroll fluido nativo — Piano Standard */
html {
  scroll-behavior: smooth;
}
```

---

## Piano Pro — reveal-on-scroll (Intersection Observer nativo)

Elementi che appaiono mentre l'utente scrolla. Nessuna libreria esterna.

```css
/* Stato iniziale degli elementi da rivelare */
.reveal {
  opacity: 0;
  transform: translateY(24px);
  transition: opacity 0.5s ease, transform 0.5s ease;
}

.reveal.visible {
  opacity: 1;
  transform: translateY(0);
}
```

```js
// Reveal on scroll — Intersection Observer nativo
// Piano Pro — nessuna libreria esterna
document.addEventListener('DOMContentLoaded', () => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        observer.unobserve(entry.target); // osserva una sola volta
      }
    });
  }, { threshold: 0.15 });

  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
});
```

```html
<!-- Aggiungere la classe .reveal agli elementi da animare -->
<section class="reveal">...</section>
<div class="reveal">...</div>
```

---

## Piano Pro — AOS via CDN

**Aggiungere solo dopo aver ricevuto conferma esplicita dall'utente.**
AOS è una dipendenza CDN esterna (~13 KB gzip).

```html
<!-- Nel <head> -->
<link rel="stylesheet" href="https://unpkg.com/aos@2.3.4/dist/aos.css" />

<!-- Prima di </body> -->
<script src="https://unpkg.com/aos@2.3.4/dist/aos.js"><\/script>
<script>
  AOS.init({
    duration: 600,
    once: true,       // anima una sola volta
    offset: 80
  });
<\/script>
```

```html
<!-- Utilizzo sugli elementi -->
<div data-aos="fade-up">Contenuto</div>
<div data-aos="fade-right" data-aos-delay="100">Contenuto</div>
```

---

## Piano Premium — parallax leggero (CSS + scroll event)

```css
.parallax-hero {
  background-attachment: fixed;
  background-position: center;
  background-size: cover;
}
```

> Nota: `background-attachment: fixed` non funziona su iOS Safari.
> Per supporto mobile completo usare la versione JS qui sotto.

```js
// Parallasse leggero JS — Piano Premium
// Segnalare impatto performance prima di usare
const hero = document.querySelector('.parallax-hero-js');
if (hero) {
  window.addEventListener('scroll', () => {
    const offset = window.scrollY;
    hero.style.backgroundPositionY = `${offset * 0.4}px`;
  }, { passive: true });
}
```

---

## Piano Premium — avviso GSAP

Prima di aggiungere GSAP comunicare sempre:

> "GSAP aggiunge circa 70 KB (gzip) al peso della pagina. Su connessioni
> lente o mobile può influire sui tempi di caricamento. Vuoi procedere
> ugualmente o preferisci l'approccio più leggero con Intersection Observer?"

```html
<!-- GSAP via CDN — solo dopo conferma esplicita -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"><\/script>
<!-- ScrollTrigger (opzionale, +30 KB gzip) — chiedere conferma separata -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"><\/script>
```
