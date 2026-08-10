# Guide des skills

Répertoire complet des 62 skills, avec entrées, sorties et usage recommandé.
Les quatre premières sections couvrent la suite d'écriture, la cinquième le
système d'ingénierie logicielle.

## core

| Skill | Ce qu'il fait | Entrées | Sorties |
|---|---|---|---|
| writing-constitution | règles communes non négociables | aucune | règles appliquées, rapport de conformité |
| novel-architect | construction globale d'un roman | prémisse, genre, longueur | bible, plan, arcs, révélations |
| chapter-architect | découpage en chapitres | plan général | fiches chapitre, titres |
| scene-builder | construction des scènes | fiche chapitre | scènes rédigées, fiches de scène |
| narrator | instance narrative et voix | bible | charte de narration |
| dialogue-master | dialogues aux normes françaises | fiches personnages | dialogues conformes |
| character-psychologist | personnages complexes | contexte, bible | fiches, arcs, relations |
| world-builder | univers cohérents | genre, dossier documentaire | bible du monde, lexique |
| immersion-director | immersion sensorielle et culturelle | bible du monde | dossiers sensoriels |
| research-director | direction documentaire | plan, époque, lieux | dossier documentaire, fiches sources |
| continuity-manager | cohérence globale | chapitres rédigés | registre, rapport d'incohérences |
| timeline-manager | temporalités et flashbacks | plan, chapitres | chronologies, table des flashbacks |
| saga-architect | oeuvres multi-tomes | bible du tome 1 | bible de saga, registre inter-tomes |
| screenwriter | écriture scénaristique | pitch ou roman source | traitement, séquencier, continuité |

## genres

| Skill | Contrat de lecture | Exigence dominante |
|---|---|---|
| thriller | menace, échéance, accélération | pression temporelle |
| mystery | énigme équitable | équité des indices |
| detective | méthode, milieu, coût de la vérité | exactitude procédurale |
| horror | perte de sécurité | économie de la monstration |
| fantasy | monde tenu, impossible cohérent | nécessité du fantastique |
| dark-fantasy | monde qui ne récompense pas la vertu | absence de complaisance |
| science-fiction | hypothèse menée jusqu'au bout | profondeur des conséquences |
| cyberpunk | asymétrie de pouvoir, corps, dette | densité matérielle |
| historical-fiction | époque tenue, mentalités justes | exactitude documentaire |
| romance | transformation par la rencontre | force de l'obstacle interne |
| adventure | territoire, attrition, retour | cohérence de l'attrition |
| dystopian | système qui fonctionne | crédibilité du système |
| political-fiction | fabrique de la décision | absence de manichéisme |
| espionage | loyautés et leur coût | cohérence de la trahison |
| magical-realism | merveilleux non expliqué | tenue du non-étonnement |

## poetry

| Skill | Objet | Exigence dominante |
|---|---|---|
| poet | prosodie française, image, son | justesse prosodique |
| sonnet | forme fixe en quatorze vers | volte à sa position |
| haiku | forme brève, saison, coupure | écart entre les images |
| free-verse | forme inventée et tenue | motivation des coupes |
| prose-poetry | bloc de prose sans progression | tenue rythmique et clôture |

## quality

| Skill | Rôle | Position |
|---|---|---|
| self-critique-protocol | auto-évaluation en onze axes | après chaque production |
| story-doctor | diagnostic structurel | après un premier jet complet |
| rewriting-engine | réécriture méthodique | après diagnostic |
| literary-editor | style, phrase, paragraphe | après structure validée |
| proofreader | orthographe et typographie | après édition |
| beta-reader | simulation de lecture réelle | sur manuscrit complet |
| literary-critic | jugement éditorial sévère | avant décision |
| publication-review | validation finale | en dernier |

## dev-skills

Système d'ingénierie logicielle, agnostique de la pile technique. Contenu en
anglais. Détail complet dans `engineering-system.md`.

| Skill | Ce qu'il fait | Entrées | Sorties |
|---|---|---|---|
| engineering-core | règles communes non négociables | aucune | règles appliquées, rapport de conformité |
| project-exploration | cartographie d'un repository inconnu | le repository, la tâche | carte du projet, conventions, traces de flux |
| engineering-orchestrator | classification et plan d'exécution | la requête | classification, plan, portes, verdict |
| architecture-design | la plus petite architecture viable | carte du projet, contraintes | décision, contrats, modèle de panne |
| ui-ux-engineering | spécification de l'expérience rendue | design system existant | décisions, inventaire d'états, cibles d'accessibilité |
| dependency-selection | ajouter, remplacer ou refuser une bibliothèque | le besoin, l'arbre installé | décision, grille d'évaluation |
| frontend-engineering | implémentation client | spécification, conventions | composants, états, notes d'accessibilité |
| backend-engineering | implémentation serveur | architecture, contrat validé | handlers, services, migrations, contrat d'erreur |
| fullstack-engineering | la tranche verticale complète | la fonctionnalité demandée | contrat, matrice de complétude, vérification bout en bout |
| input-validation | validation à la frontière de confiance | le changement, la carte des frontières | schémas, rapport de frontières, tests |
| security-audit | balayage en vingt-quatre points | le diff ou le repository | constats, corrections, actions manuelles |
| debugging | cause racine d'un défaut | le rapport de défaut | cause, reproduction, correction, test de régression |
| testing-quality | stratégie et écriture des tests | le changement | plan de test, tests, lacunes, journal d'exécution |
| playwright-automation | vérification navigateur | la fonctionnalité implémentée | parcours, captures, rapport responsive |
| performance-engineering | mesure et optimisation | un symptôme ou une mesure | référence, analyse, écart mesuré |
| code-review-protocol | revue en cinq passes puis correction | un diff | constats, corrections appliquées, journal de vérification |
| technical-documentation | documentation conforme au code | le changement | readme, référence API, runbook, changelog |
| project-continuity | passation exploitable | les commits de la session | notes de continuité, liste de suites |
| git-workflow | identité, commits, historique | l'arbre de travail | commits, branches, pull request |
| release-readiness | porte finale avant livraison | la révision, le diff de version | rapport, verdict, plan de retour arrière |

## Choisir un skill

| Situation | Skill à ouvrir |
|---|---|
| Je démarre un projet | resources/templates/demarrage-de-projet.md, puis novel-architect |
| Je ne sais pas comment couper mes chapitres | chapter-architect |
| Ma scène est plate | scene-builder, puis self-critique-protocol |
| Mes dialogues se ressemblent | dialogue-master, test de voix |
| Mon milieu de roman n'avance pas | story-doctor |
| Je perds le fil des dates | timeline-manager |
| Je ne sais plus qui sait quoi | continuity-manager |
| Mon texte est correct mais fade | literary-editor, puis rewriting-engine |
| Je veux savoir si c'est publiable | literary-critic, puis publication-review |
| Je découvre une base de code | project-exploration |
| Je ne sais pas par quels skills passer | engineering-orchestrator |
| Une API renvoie une erreur inexpliquée | debugging |
| Je dois ajouter un endpoint | backend-engineering, puis input-validation |
| Je dois créer une page | ui-ux-engineering, puis frontend-engineering |
| Je me demande si c'est sûr | security-audit |
| C'est lent | performance-engineering, jamais sans mesure |
| Je veux ajouter une bibliothèque | dependency-selection |
| Je viens d'écrire du code | code-review-protocol |
| Je m'apprête à livrer | release-readiness |
| Je termine une session | project-continuity |
