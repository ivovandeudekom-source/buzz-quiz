# Buzz Quiz

Buzz-achtige quizgame: één hostscherm (TV/laptop) + telefoons als controllers via een 4-lettercode.

- `index.html` — de volledige app (host + controller). Geen build-stap.
- Realtime: Supabase Realtime (broadcast + presence), project `kumksnqblhjgdhbvxcji` (eu-central-1). Geen database-tabellen nodig voor het spel.
- Hosting: GitHub Pages vanaf `main`.

## Spelen
1. Open de pagina op de TV/laptop → **Nieuw spel** → kies rondes → **Open de lobby**.
2. Spelers scannen de QR of gaan naar de pagina en vullen de code in.
3. Host drukt **Start**; Enter/spatie = volgende.

## Rondes
| Ronde | Mechaniek | Punten |
|---|---|---|
| Punten Bouwer | iedereen antwoordt, 12 s | +150 |
| Snelste Vinger | iedereen antwoordt, 10 s | 500 → 100, aflopend |
| Puntendief | buzzen, winnaar kiest antwoord (8 s) | +300 / −100, dan mogen de anderen |
| Final Countdown | iedereen antwoordt, 12 s | 400 → 100 aflopend, fout −200 |

## Vragen
`QUESTIONS` bovenin `index.html`: `{cat, d (1-3), q, a:[4 opties], c: index juiste optie}`.
