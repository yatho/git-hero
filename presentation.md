# Git Hero - Guide de Présentation Orale (1 heure)

Résumé des 18 démonstrations Git organisées pour une présentation thématique d'une heure.

---

## Introduction (5 min)

- Présentation du projet Git Hero
- Structure des démos interactives
- Objectif : Maîtriser Git au-delà des commandes basiques

---

## Bloc 1 : Quotidien du Développeur (15 min)

### 01 - STASH : Sauvegarder temporairement (3-4 min)

**Application :** Email Templates - Générateur de templates email

**Problématique :** Besoin de changer de contexte rapidement sans faire de commit

**Apprentissage :**
- Sauvegarder des modifications en cours sans commit
- Récupérer le travail sauvegardé
- Gérer plusieurs stash

**Commandes clés :**
```bash
git stash push -m "message"  # Sauvegarder avec description
git stash list               # Voir tous les stash
git stash pop                # Restaurer et supprimer
git stash apply              # Restaurer mais garder en stash
```

**Cas d'usage :** Interruption urgente, changement de branche, expérimentations temporaires

---

### 02 - MERGE : Résoudre les conflits (3-4 min)

**Application :** Shopping Cart - Calculateur de panier e-commerce

**Problématique :** Deux features modifient la même fonction
- `feature/tax-calculation` : Ajoute la TVA à 20%
- `feature/discount-system` : Ajoute les codes promo

**Apprentissage :**
- Comprendre les marqueurs de conflit diff3 (HEAD, ancêtre commun, incoming)
- Stratégies de résolution manuelle
- Tester après fusion

**Commandes clés :**
```bash
git merge <branch>                    # Fusionner une branche
git status                           # Voir les fichiers en conflit
git diff                             # Voir les détails du conflit
git add <file>                       # Marquer comme résolu
git merge --abort                    # Abandonner la fusion
git config merge.conflictstyle diff3 # Activer diff3
```

**Résolution :** Intégrer les deux features (discount d'abord, puis taxes)

---

### 03 - RESTORE : Opérations modernes sur fichiers (4-5 min)

**Application :** Modern File Restoration

**Problématique :** `git checkout` fait trop de choses (branches + fichiers)

**Apprentissage :**
- Commande moderne pour restaurer des fichiers (Git 2.23+)
- Annuler des modifications locales
- Unstage des fichiers proprement
- Restaurer depuis un commit spécifique

**Commandes clés :**
```bash
git restore <file>                    # Annuler les modifications
git restore --staged <file>           # Unstage (plus clair que reset HEAD)
git restore --source=<commit> <file>  # Restaurer depuis un commit
git restore --source=HEAD --staged --worktree . # Reset complet
```

**Migration :**
- `git checkout -- file` → `git restore file`
- `git reset HEAD file` → `git restore --staged file`
- `git checkout branch` → `git switch branch`

---

### 04 - REFLOG : Le filet de sécurité (3-4 min)

**Application :** Note Taker - Gestionnaire de notes

**Problématique :** Branche supprimée par erreur, commit "perdu"

**Apprentissage :**
- Git garde TOUT pendant 90 jours
- Récupérer des branches supprimées
- Récupérer des commits après reset --hard
- Historique de tous les mouvements de HEAD

**Commandes clés :**
```bash
git reflog                    # Voir tous les changements de référence
git reflog show HEAD          # Historique de HEAD
git checkout -b <branch> <hash> # Récupérer depuis reflog
```

**Message clé :** Git ne perd presque jamais rien, reflog est votre assurance vie!

---

## Bloc 2 : Historique Propre (15 min)

### 05 - REBASE INTERACTIVE : Nettoyer l'historique (4-5 min)

**Application :** Todo List - Gestionnaire de tâches

**Problématique :** Historique de commits désordonné avant de merger

**Apprentissage :**
- Nettoyer l'historique avant pull request
- Combiner, réordonner, modifier des commits
- Créer un historique lisible

**Commandes clés :**
```bash
git rebase -i HEAD~N          # Rebaser les N derniers commits
git rebase -i --autosquash    # Appliquer automatiquement les fixup
```

**Actions disponibles :**
- **pick** : conserver le commit
- **reword** : modifier le message
- **squash** : fusionner avec le précédent (garder les deux messages)
- **fixup** : fusionner avec le précédent (supprimer ce message)
- **drop** : supprimer le commit

**Attention :** Ne jamais rebaser des commits déjà pushés sur une branche partagée!

---

### 06 - FIXUP : Workflow de correction (3-4 min)

**Application :** Calculator - Calculatrice basique

**Problématique :** Petites corrections à apporter à des commits précédents

**Apprentissage :**
- Marquer automatiquement des commits pour fusion
- Workflow efficace pour les corrections
- Combinaison avec rebase --autosquash

**Commandes clés :**
```bash
git commit --fixup=<hash>           # Créer un commit fixup
git rebase -i --autosquash HEAD~N   # Réordonner automatiquement
```

**Workflow :**
1. Faire des modifications
2. `git commit --fixup=abc123` (hash du commit à corriger)
3. Continuer à travailler
4. `git rebase -i --autosquash` à la fin

---

### 07 - RESET : Comprendre les modes (4-5 min)

**Application :** Understanding --soft, --mixed, --hard

**Problématique :** Confusion entre les différents modes de reset

**Apprentissage :**
- Différences entre --soft, --mixed, --hard
- Impact sur HEAD, staging area, working directory
- Quand utiliser chaque mode

**Tableau comparatif :**

| Mode | HEAD bouge | Staging Area | Working Directory |
|------|-----------|--------------|-------------------|
| `--soft` | ✅ | Inchangé | Inchangé |
| `--mixed` | ✅ | Nettoyé | Inchangé |
| `--hard` | ✅ | Nettoyé | Nettoyé ⚠️ |

**Commandes clés :**
```bash
git reset --soft HEAD~1      # Annuler commit, garder changements staged
git reset HEAD~1             # Annuler commit, garder changements unstaged
git reset --hard HEAD~1      # Annuler commit et SUPPRIMER changements ⚠️
```

**Cas d'usage :**
- **--soft** : Refaire un commit, combiner plusieurs commits
- **--mixed** : Unstage des fichiers, réorganiser les commits
- **--hard** : Revenir à un état propre (DANGER: perte de données)

**Attention :** Ne JAMAIS reset des commits pushés!

---

### 08 - REVERT : Annuler proprement (4-5 min)

**Application :** Safe Undo Commits

**Problématique :** Besoin d'annuler un commit déjà pusté

**Apprentissage :**
- Annuler sans réécrire l'historique
- Sûr pour les branches partagées
- Parfait pour la production

**Commandes clés :**
```bash
git revert HEAD                      # Annuler le dernier commit
git revert <hash>                    # Annuler un commit spécifique
git revert --no-commit HEAD HEAD~1   # Annuler plusieurs commits
git revert --continue / --abort      # Gérer les conflits
```

**Reset vs Revert :**

| Feature | git reset | git revert |
|---------|-----------|------------|
| Réécrit l'historique | OUI ⚠️ | NON ✅ |
| Sûr pour branches partagées | NON ❌ | OUI ✅ |
| Crée nouveau commit | NON | OUI |
| Meilleur pour | Commits locaux | Commits pushés |

**Message clé :** Commits pushés = revert, commits locaux = reset

---

## Bloc 3 : Debugging & Investigation (15 min)

### 09 - BISECT : Trouver les bugs automatiquement (3-4 min)

**Application :** Number Guesser - Jeu de devinette

**Problématique :** Un bug est apparu mais on ne sait pas dans quel commit

**Bug simulé :** Calcul du point médian cassé (ajout de +5 par erreur)
```javascript
// Avant (commits 1-4)
Math.floor((low + high) / 2)
// Après (commits 5-8)
Math.floor((low + high) / 2) + 5  // ❌ BUG!
```

**Apprentissage :**
- Recherche binaire pour trouver le commit fautif
- Automatisation avec des tests
- Efficacité : log2(n) tests au lieu de n tests

**Commandes clés :**
```bash
git bisect start              # Démarrer bisect
git bisect bad                # Marquer commit actuel comme mauvais
git bisect good <commit>      # Marquer un commit connu bon (ex: v1.0.0)
git bisect run npm test       # AUTOMATISER avec tests!
git bisect reset              # Terminer et revenir à HEAD
```

**Puissance :**
- 8 commits → 3 tests
- 100 commits → 7 tests
- 1000 commits → 10 tests

---

### 10 - LOG : Recherche avancée dans l'historique (4-5 min)

**Application :** Git History Search

**Problématique :** Trouver des commits spécifiques dans un gros historique

**Apprentissage :**
- Filtrer par auteur, date, message
- Chercher dans le code modifié
- Créer des requêtes complexes

**Commandes clés :**
```bash
# Filtres basiques
git log --oneline --graph --all
git log --author="Alice"
git log --since="2024-01-01" --until="2024-12-31"

# Recherche dans les messages
git log --grep="fix" -i
git log --grep="CRITICAL\|URGENT"

# Recherche dans le code
git log -S "functionName"         # Chercher ajout/suppression
git log -G "regex.*pattern"       # Chercher avec regex
git log -S "text" -p              # Montrer les changements

# Fichiers spécifiques
git log -- app.js
git log --follow -- oldname.js    # Suivre les renommages

# Entre tags/commits
git log v1.0.0..v2.0.0

# Format personnalisé
git log --pretty=format:"%h - %an, %ar : %s"
```

**Cas pratiques :**
- Trouver quand un bug a été introduit
- Générer un changelog
- Voir qui a travaillé sur quoi

---

### 11 - DIFF : Inspecter les changements (4-5 min)

**Application :** Master Diff Viewing

**Problématique :** Voir précisément ce qui a changé, filtrer le bruit

**Apprentissage :**
- Différentes vues des changements
- Exclure des fichiers (lock files, etc.)
- Gérer les espaces blancs
- Comprendre working dir vs staging vs commits

**Commandes clés :**
```bash
# Basiques
git diff                 # Working directory vs staging
git diff --staged        # Staging vs HEAD
git diff HEAD            # Working directory vs HEAD

# Vues différentes
git diff --stat          # Statistiques
git diff --name-status   # Noms des fichiers + statut
git diff --compact-summary

# Exclure des fichiers
git diff -- . ':(exclude)package-lock.json'
git diff -- ':!*.lock'

# Espaces blancs
git diff --ignore-all-space        # Ignorer tous les espaces
git diff --ws-error-highlight=all  # Highlighter erreurs espaces

# Word-level
git diff --color-words   # Changements mot par mot
git diff --word-diff     # Format texte
```

**Astuces :**
- Toujours exclure les fichiers générés (lock, build artifacts)
- Utiliser word-diff après reformatage automatique
- Créer des aliases pour les vues fréquentes

---

## Bloc 4 : Workflows Avancés (10 min - optionnel)

### 12 - WORKTREE : Multitâche Git (4-5 min)

**Application :** API Docs - Générateur de documentation

**Problématique :** Besoin de travailler sur plusieurs branches simultanément

**Apprentissage :**
- Créer plusieurs répertoires de travail pour un même repo
- Travailler sur plusieurs branches en parallèle
- Pas besoin de stash ou commit pour changer de contexte

**Commandes clés :**
```bash
git worktree add <path> <branch>   # Créer nouveau worktree
git worktree list                  # Lister tous les worktrees
git worktree remove <path>         # Supprimer worktree
git worktree prune                 # Nettoyer références obsolètes
```

**Cas d'usage :**
- Review de PR pendant développement
- Hotfix urgent pendant feature
- Tester plusieurs approches en parallèle
- Build/deploy pendant développement

---

### 13 - CHERRY-PICK : Sélection précise (3-4 min)

**Application :** Weather CLI - Prévisions météo

**Problématique :** Besoin d'un commit spécifique sur une autre branche

**Apprentissage :**
- Appliquer des commits spécifiques d'une branche à une autre
- Sélection chirurgicale de changements
- Gérer les conflits potentiels

**Commandes clés :**
```bash
git cherry-pick <hash>              # Appliquer un commit
git cherry-pick <hash1> <hash2>     # Plusieurs commits
git cherry-pick --continue          # Après résolution conflit
git cherry-pick --abort             # Abandonner
```

**Cas d'usage :**
- Hotfix à appliquer sur plusieurs branches
- Feature développée sur mauvaise branche
- Extraction de commit spécifique d'une grosse PR

---

### Autres workflows avancés (mentions rapides)

**14 - SUBMODULES** : Version-pin external dependencies (4-5 min)
- Application : Plugin System
- Gestion de dépendances externes versionnées
- `git submodule add/update --init --recursive`

**15 - SUBTREE** : Alternative plus simple (4-5 min)
- Application : Shared Utils
- Plus simple que submodules, pas de --recursive
- `git subtree add/pull/push --prefix`

**16 - FILTER-BRANCH** : Réécrire l'historique (4-5 min)
- Application : Logger
- Supprimer fichiers/secrets de tout l'historique
- ⚠️ Destructif, uniquement sur branches non partagées
- Alternative moderne : `git filter-repo`

**17 - RERERE** : Réutiliser résolutions de conflits (4-5 min)
- Application : Recipe Book
- Enregistrer et réutiliser résolutions
- Utile pour rebases répétés

**18 - CHECKOUT** : Opérations fichiers (legacy) (3-4 min)
- Opérations au niveau fichier
- Remplacé par `git restore` et `git switch` (Git 2.23+)

---

## Conclusion & Q&A (5 min)

### Messages clés à retenir

1. **Sécurité** : Git ne perd presque jamais rien (reflog = 90 jours)
2. **Historique** : Reset pour local, Revert pour pushé
3. **Modernité** : Restore/Switch pour plus de clarté
4. **Debugging** : Bisect et Log sont vos meilleurs amis
5. **Propreté** : Rebase interactif avant de partager

### Ressources

- Git Hero : Démos interactives prêtes à l'emploi
- Chaque exemple : setup.sh → demo.sh → reset.sh
- Mode `--no-pause` pour tests rapides

### Commandes de survie

```bash
git reflog              # Tout récupérer
git stash               # Sauver rapidement
git revert HEAD         # Annuler proprement
git bisect run npm test # Trouver bugs automatiquement
git log --grep="fix"    # Chercher dans historique
```

---

## Ordre des exemples dans le dossier

Les exemples sont organisés dans l'ordre de présentation :

1. **01-stash** - Quotidien
2. **02-merge** - Quotidien
3. **03-restore** - Quotidien
4. **04-reflog** - Quotidien
5. **05-rebase-interactive** - Historique propre
6. **06-fixup** - Historique propre
7. **07-reset** - Historique propre
8. **08-revert** - Historique propre
9. **09-bisect** - Debugging
10. **10-log** - Debugging
11. **11-diff** - Debugging
12. **12-worktree** - Avancé
13. **13-cherry-pick** - Avancé
14. **14-submodules** - Avancé
15. **15-subtree** - Avancé
16. **16-filter-branch** - Avancé
17. **17-rerere** - Avancé
18. **18-checkout** - Avancé (legacy)

---

**Préparé pour NG Baguette Conf 2026 - Paris, 29 Mai 2026**
