# L-Atelier-3D

Boutique statique GitHub Pages connectée à Supabase pour le catalogue et l'administration.

## Configuration Supabase

1. Créez un projet sur https://supabase.com/.
2. Dans **SQL Editor**, exécutez le contenu de `supabase/schema.sql`.
3. Dans **Project Settings > API**, copiez l'URL du projet et la clé **anon/public**.
4. Remplacez les deux valeurs dans `js/supabase-config.js`. N'utilisez jamais la clé `service_role` dans le site.
5. Dans **Authentication > Users**, créez votre compte administrateur avec votre vraie adresse e-mail et un mot de passe fort.
6. Dans le fichier SQL, remplacez `VOTRE-EMAIL-ADMIN` par cette adresse et exécutez la dernière requête pour attribuer les droits administrateur.
7. Publiez le dépôt via **Settings > Pages > Deploy from a branch > main / root**.

L'accès à l'administration se trouve en bas de la boutique, ou directement sur `/admin.html`.

## Fonctions disponibles

- Catalogue public synchronisé depuis Supabase.
- Connexion administrateur sécurisée par Supabase Auth et droits RLS.
- Ajout, modification, suppression et masquage de produits.
- Gestion des prix et des stocks.
- Enregistrement manuel des ventes et suivi de leur statut.
- Changement du mot de passe depuis l'administration.

## Limites actuelles

Le panier reste enregistré localement dans le navigateur. Il n'y a ni commande client, ni paiement, ni PayPal. Les ventes sont enregistrées manuellement par l'administrateur. Le mot de passe temporaire « Admin » n'est volontairement pas utilisé : choisissez un mot de passe robuste.
