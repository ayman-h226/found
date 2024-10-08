# Rapport du Projet : Application de Gestion des Objets Trouvés (API SNCF)

## 1. Introduction

### Contexte du Projet

Ce projet s'inscrit dans le cadre du module de développement mobile avec Flutter,
dont l'objectif est de mettre en pratique les concepts appris en utilisant une **API REST** réelle. 
Nous avons développé une application mobile permettant à un voyageur de consulter la liste des objets trouvés dans les trains. 
L'application exploite l'API SNCF des objets trouvés, disponible [ici](https://data.sncf.com/explore/dataset/objets-trouves-restitution/api/).

L'objectif principal est de proposer une solution pratique et accessible aux voyageurs pour retrouver leurs objets perdus grâce à une interface conviviale et intuitive. 
Ce projet permet de mettre en avant la synergie entre l'intégration d'une API externe, la gestion d'une interface utilisateur dynamique et la persistance des données utilisateur, 
tout en offrant une expérience utilisateur fluide.

### Objectif du Projet

Le projet consiste à développer une application permettant aux utilisateurs de consulter les objets trouvés dans les trains et non encore restitués. 
Cette application permet de filtrer les objets par **gare d'origine**, par **catégorie** (téléphone portable, sac à dos, etc.), et par **date**.

Une fonctionnalité importante est la capacité de suivre les objets trouvés depuis la **dernière connexion** de l'utilisateur, grâce à un système de **notification des nouveaux objets trouvés**. 
L'application vise à offrir une expérience efficace et intuitive permettant aux voyageurs de retrouver leurs objets perdus rapidement et facilement, tout en garantissant une navigation conviviale et des fonctionnalités pertinentes.

## 2. Objectifs Pédagogiques Atteints

Ce projet a permis d'atteindre plusieurs objectifs pédagogiques clés :

- Apprendre à consommer une API REST et à manipuler des données complexes.
- Créer une interface utilisateur dynamique et interactive avec Flutter.
- Gérer la persistance des données utilisateur pour améliorer l'expérience, par exemple la sauvegarde de la date de dernière connexion.
- Mettre en œuvre la programmation asynchrone (`async/await`) pour une gestion efficace des requêtes réseau.
- Comprendre l'utilisation de la bibliothèque `Intl` pour gérer la localisation et le formatage des dates afin d'adapter l'application aux préférences locales.
- Implémenter la gestion des sessions utilisateur, incluant un système de suivi des objets trouvés depuis la dernière connexion.
- Développer la capacité d'analyser et de structurer des données pour créer des filtres pertinents pour la recherche d'objets.

Ces objectifs permettent de maîtriser non seulement les aspects techniques, mais aussi les meilleures pratiques de développement mobile en termes d'expérience utilisateur et de performance.

## 3. Technologies Utilisées

- **Flutter** : Utilisé pour la création de l'interface utilisateur, offrant une expérience fluide et réactive.
- **Dart** : Langage de programmation utilisé par Flutter, permettant de développer à la fois la logique de l'application et l'interface.
- **HTTP** : Bibliothèque utilisée pour les appels API REST, facilitant l'envoi de requêtes réseau.
- **Intl** : Pour la gestion de la localisation et le formatage des dates, afin d'offrir une expérience adaptée aux préférences locales de l'utilisateur.
- **SharedPreferences** : Pour le stockage local des préférences utilisateur, comme la date de dernière connexion.

Ces technologies ont été choisies pour leur compatibilité, leur facilité d'intégration, ainsi que pour leur capacité à offrir une expérience utilisateur fluide et performante.

## 4. Architecture de l'Application

### Arborescence du Projet

- **lib/main.dart** : Point d'entrée de l'application, incluant la gestion du thème et l'initialisation des routes.
- **lib/services/api_service.dart** : Contient les fonctions pour interagir avec l'API SNCF, encapsulant la logique des requêtes réseau.
- **lib/views/home_page.dart** : Page d'accueil qui permet de lancer une recherche et d'afficher les nouveaux objets trouvés.
- **lib/views/search_results_page.dart** : Page pour afficher les résultats de la recherche, en fonction des critères spécifiés par l'utilisateur.

### Diagramme de l'Architecture

L'architecture de l'application est organisée selon le principe de la **séparation des préoccupations**. Chaque fichier remplit une fonction spécifique, ce qui facilite la maintenance et l'évolution du projet. 
Un diagramme illustrant les relations entre les différentes composantes de l'application est présenté en annexe. Cette structure garantit une bonne modularité, rendant le code plus facile à comprendre et à maintenir.

## 5. Appels d'API et Intégration des Données

### Consommation de l'API SNCF

L'application consomme l'API REST de la SNCF pour récupérer la liste des objets trouvés. Nous utilisons **`http.get()`** pour envoyer des requêtes réseau de manière asynchrone.
Les mots-clés **`async` et `await`** permettent d'attendre la réponse de la requête sans bloquer l'interface utilisateur, garantissant ainsi une expérience fluide.

Chaque appel à l'API est construit dynamiquement en fonction des paramètres sélectionnés par l'utilisateur, tels que la gare, la catégorie, et la date. Ces paramètres sont ajoutés à l'URL de la requête pour obtenir des résultats filtrés, offrant ainsi une recherche personnalisée. 
Cette capacité à interagir dynamiquement avec l'API est essentielle pour offrir une application flexible et adaptée aux besoins des utilisateurs.

### Gestion des Erreurs

Pour garantir une expérience utilisateur sans interruption, nous avons implémenté des blocs **`try-catch`** pour gérer les erreurs potentielles, telles que les erreurs de connexion réseau ou de formatage de date (`FormatException`). En cas d'erreur, l'utilisateur est informé par un message approprié et encouragé à réessayer, garantissant une meilleure compréhension de ce qui a pu échouer et une possibilité de correction.

### Logique de Filtrage des Requêtes

Les requêtes à l'API sont paramétrées avec des **filtres dynamiques** (gare d'origine, catégorie, date). Nous avons construit le paramètre **`q`** afin d'ajouter des mots-clés spécifiques pour affiner les résultats selon les critères définis par l'utilisateur. Ces filtres assurent que les objets affichés soient pertinents, rendant l'application plus utile et efficace. L'utilisation de filtres spécifiques améliore également les performances de l'application, en réduisant la quantité de données récupérées et en affinant les résultats.

## 6. Gestion des Données Locales et Suivi de Connexion

### Stockage des Préférences Utilisateur

Pour personnaliser l'expérience de l'utilisateur, nous avons utilisé **`SharedPreferences`** pour **sauvegarder la date de la dernière connexion**. Grâce à ce stockage local, nous pouvons déterminer si l'utilisateur se connecte pour la première fois et afficher un message de bienvenue approprié.

Cette fonctionnalité permet également d'afficher un message indiquant le nombre d'objets trouvés depuis la dernière connexion de l'utilisateur. Cela crée un sentiment de continuité et permet une meilleure interaction avec l'application, en rappelant à l'utilisateur l'intérêt de consulter régulièrement les mises à jour.

### Affichage des Nouveaux Objets Trouvés

La méthode `fetchLostItemsSinceDate()` est utilisée pour récupérer les objets trouvés après la dernière connexion de l'utilisateur. Un message personnalisé est construit dynamiquement, indiquant le nombre d'objets trouvés depuis la dernière visite (par exemple, "X objets trouvés depuis votre dernière visite").

Cette fonctionnalité a nécessité une gestion précise des données et des préférences de l'utilisateur afin d'assurer une continuité de l'expérience à travers chaque session. Cela ajoute également une dimension de suivi personnalisé, renforçant l'engagement de l'utilisateur vis-à-vis de l'application.

### Formatage des Dates et Localisation

Pour assurer un bon affichage des dates, nous avons utilisé la bibliothèque **`Intl`** qui permet de convertir les dates entre le format de l'utilisateur (par exemple, "08 octobre 2024") et le format ISO 8601 requis par l'API. Cette conversion garantit la compatibilité des données entre l'application et l'API, tout en offrant une expérience utilisateur adaptée à la localisation. La localisation est un aspect crucial pour rendre l'application accessible et facile à utiliser par une audience diversifiée.

## 7. Programmation Asynchrone et Gestion de l'État

### Gestion de l'Asynchronisme avec `async` et `await`

La programmation asynchrone est essentielle pour la gestion des tâches longues, comme les appels réseau. Avec **`async` et `await`**, nous avons pu attendre les réponses sans bloquer l'interface utilisateur, assurant ainsi une **fluidité de l'expérience**. Cela est particulièrement crucial dans une application mobile, où la réactivité est primordiale.

Le modèle asynchrone permet également de gérer plusieurs requêtes simultanément, assurant ainsi une utilisation optimale des ressources réseau et une meilleure réactivité de l'application.

### Gestion de l'État avec Stateful Widgets

Nous avons utilisé des **`StatefulWidget`** pour gérer les éléments nécessitant un changement d'état dynamique, comme l'affichage des résultats de recherche. Cela permet de garantir que l'interface utilisateur est mise à jour en temps réel en fonction des actions de l'utilisateur, assurant ainsi une cohérence visuelle et une meilleure expérience globale.

L'utilisation appropriée des Stateful Widgets permet une gestion efficace de l'état, réduisant les risques de bugs liés aux modifications de l'interface utilisateur en cours d'exécution.

## 8. Logique de Recherche et Suggestion des Gares

### Recherche des Gares en Fonction de l'Entrée de l'Utilisateur

Pour améliorer la convivialité, l'application propose des **suggestions de gares** en fonction de l'entrée de l'utilisateur. Cette fonctionnalité est mise en œuvre à l'aide du widget **`SearchField`**, qui envoie des requêtes à l'API SNCF pour obtenir des suggestions en temps réel, réduisant ainsi les erreurs de saisie et le temps de recherche.

Cette fonctionnalité offre une interaction plus fluide et conviviale, en anticipant les besoins de l'utilisateur et en lui permettant de sélectionner facilement la gare souhaitée sans avoir à saisir le nom complet.

### Filtres de Recherche

L'application offre plusieurs options de recherche :

- **Recherche exacte par date** : Utilisation du format ISO 8601 pour une date précise.
- **Recherche approximative (±1 heure)** : Recherche élargie pour inclure les objets trouvés autour de l'heure spécifiée.
- **Recherche depuis la dernière connexion** : Permet de trouver des objets ajoutés depuis la dernière visite de l'utilisateur.

Ces options offrent une grande flexibilité et facilitent la recherche des objets par les utilisateurs, leur permettant de retrouver leurs biens rapidement et efficacement.

## 9. Stratégie de Filtrage des Objets et Gestion des Catégories

### Utilisation de Dictionnaires de Catégories

Pour améliorer la recherche, nous avons créé des **dictionnaires de catégories** (`categoryDictionaries`). Chaque catégorie est associée à une liste de mots-clés, ce qui permet d'affiner la recherche en regroupant les objets aux descriptions variées. Ces dictionnaires ont été construits après une **analyse approfondie des résultats de l'API** afin de maximiser la pertinence des résultats.

En associant chaque objet à une catégorie pertinente à l'aide de mots-clés, nous avons rendu la recherche plus intuitive et efficace pour l'utilisateur, même lorsque les descriptions d'objets sont ambiguës ou imprécises.

### Défi des Descriptions Complexes

Certains objets avaient des descriptions qui ne correspondaient pas clairement à une catégorie. Pour surmonter ce défi, nous avons utilisé une approche basée sur **des mots-clés multiples**, ce qui a permis d'améliorer la précision des résultats et de mieux couvrir la diversité des descriptions d'objets. Cela permet de minimiser les risques d'erreurs lors de la recherche et d'assurer une meilleure couverture des différentes possibilités.

## 10. Navigation et Gestion de l'État

### Navigation entre les Pages

La navigation entre les pages a été facilitée par les **routes définies dans `MaterialApp`**. Les arguments (par exemple les résultats de recherche) sont passés entre les pages pour maintenir la continuité de l'expérience utilisateur, offrant ainsi une transition fluide entre les différentes fonctionnalités de l'application.

Cette méthode garantit que les données nécessaires sont toujours accessibles lors de la navigation, évitant ainsi la perte d'informations et assurant une expérience sans interruption pour l'utilisateur.

### Sauvegarde et Restauration de l'État de l'Application

Les méthodes **`initState()`** et **`dispose()`** sont utilisées pour initialiser et libérer les ressources de manière appropriée, garantissant ainsi une bonne gestion de la mémoire et des ressources. Cela permet à l'application de rester performante même après de longues périodes d'utilisation, assurant ainsi une meilleure efficacité et une réduction des bugs liés aux fuites de mémoire.

## 11. Optimisation et Bonnes Pratiques

### Réduction de la Redondance de Code

Nous avons optimisé le code en utilisant des **fonctions utilitaires** et des **méthodes génériques** telles que `_buildCategoryButton()`, afin d'éviter les répétitions. Cela améliore la lisibilité et facilite la maintenance du code, rendant le développement plus agile et les futures modifications plus simples à mettre en œuvre.

### Séparation des Préoccupations

L'architecture suit le principe de la **séparation des préoccupations** :

- **`ApiService`** gère toute la logique des appels à l'API.
- Les vues (comme `HomePage` et `SearchResultsPage`) sont responsables de l'affichage et de l'interaction avec l'utilisateur.

Cette séparation garantit une meilleure organisation du code et facilite les évolutions futures de l'application, tout en améliorant la testabilité de chaque composant.

### Programmation Asynchrone pour une Interface Fluide

Les appels réseau utilisant **`async` et `await`** ont permis de maintenir une interface fluide, en évitant que l'application ne se bloque pendant le chargement des données. Cela est essentiel pour garantir une **bonne expérience utilisateur**, surtout sur des réseaux à faible débit. L'asynchronisme permet de maintenir la réactivité de l'application, même en cas de connexion lente, ce qui est particulièrement important dans un contexte de mobilité.

## 12. Challenges Rencontrés et Solutions Apportées

### Gestion des Formats de Dates et Localisation

La conversion des dates entre le format utilisateur et le format ISO 8601 a posé des défis en termes de compatibilité. Pour surmonter cela, nous avons utilisé la bibliothèque **`Intl`**, qui a permis une **gestion appropriée des différences de localisation** et une conversion des dates sans erreurs. Cela assure une compatibilité totale entre les formats locaux et ceux requis par l'API, tout en garantissant une bonne compréhension par les utilisateurs.

### Catégorisation des Objets

Le défi de la catégorisation des objets a été relevé en utilisant des **listes de mots-clés**. Cette approche a permis de couvrir une grande variété de descriptions, améliorant ainsi la pertinence des résultats pour l'utilisateur. La catégorisation correcte est essentielle pour offrir une recherche précise, surtout lorsqu'il s'agit d'objets qui peuvent être décrits de manière variée.

### Suggestion des Gares

Pour la suggestion des gares, nous avons implémenté une **recherche dynamique basée sur l'entrée utilisateur**. En utilisant un indicateur de chargement (`CircularProgressIndicator`), nous avons assuré une bonne interaction utilisateur pendant la récupération des suggestions. Cela garantit une meilleure compréhension des actions en cours et améliore l'expérience de saisie.

### Notification des Objets Trouvés

Pour informer l'utilisateur des objets trouvés depuis sa dernière connexion, nous avons utilisé **`SharedPreferences`** pour stocker la date de la dernière visite et une méthode qui récupère les nouveaux objets. Cette fonctionnalité assure une **expérience personnalisée** qui incite l'utilisateur à revenir sur l'application, en leur fournissant des informations pertinentes à chaque nouvelle connexion.

## 13. Conclusion et Retours d'Expérience

### Ce que J'ai Appris

Ce projet a été l'occasion d'apprendre :

- L'utilisation d'une **API REST** pour enrichir une application mobile.
- Les **techniques de gestion de l'état** et l'asynchronisme avec `async`/`await`.
- L'optimisation des filtres de recherche pour garantir des résultats pertinents malgré des descriptions variées.
- La gestion efficace des préférences utilisateur pour personnaliser l'expérience.
- L'importance de l'optimisation des requêtes réseau pour une bonne fluidité de l'application, même sur des réseaux plus lents.
- La mise en œuvre de suggestions dynamiques basées sur l'entrée utilisateur pour une expérience plus intuitive.

### Améliorations Futures

Pour améliorer davantage l'application, nous envisageons :

- La mise en place d'un **système de notification** pour informer les utilisateurs des nouveaux objets trouvés.
- L'ajout de fonctionnalités telles que la possibilité de **marquer des objets comme favoris** ou d'avoir un **compte utilisateur**.
- L'utilisation de **techniques d'apprentissage automatique** pour améliorer la précision de la catégorisation des objets.
- L'optimisation des performances en utilisant des **stratégies de mise en cache** pour réduire les appels réseau redondants.
- L'amélioration de l'expérience utilisateur avec des **transitions animées** et des **retours haptiques** pour rendre l'application plus immersive.

## 14. Annexes

### Liens Utiles

- Documentation de l'API SNCF : [API SNCF](https://data.sncf.com/explore/dataset/objets-trouves-restitution/api/)
- Documentation Flutter : [Flutter Docs](https://flutter.dev/docs)
- Documentation sur les bibliothèques utilisées : [Intl](https://pub.dev/packages/intl), [HTTP](https://pub.dev/packages/http), [SharedPreferences](https://pub.dev/packages/shared_preferences)

### Exemples de Requêtes API

- Requêtes de recherche exacte et recherche approximative.
- Explication des **paramètres de requête** et de leur construction.

### Code Source

- Lien vers le dépôt GitHub si applicable.

Le code source est bien documenté et suit les meilleures pratiques de développement mobile avec Flutter, pour faciliter la compréhension et la maintenance du projet.