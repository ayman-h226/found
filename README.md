# Rapport du Projet : Application de Gestion des Objets Trouvés (API SNCF)

## 1. Introduction

### Contexte du Projet

Ce projet s'inscrit dans le cadre du module de développement mobile avec Flutter,
dont l'objectif est de mettre en pratique les concepts appris en utilisant une **API REST** réelle. 
Nous avons développé une application mobile permettant à un voyageur de consulter la liste des objets trouvés dans les trains. 
L'application exploite l'API SNCF des objets trouvés, disponible [ici](https://data.sncf.com/explore/dataset/objets-trouves-restitution/api/).

L'objectif principal est de nous faire comprendre comment effectuer des requetes asynchrone avec flutter.

### Objectif du Projet

Le projet consiste à développer une application permettant aux utilisateurs de consulter les objets trouvés dans les trains et non encore restitués. 
Cette application permet de filtrer les objets par **gare d'origine**, par **catégorie** (téléphone portable, sac à dos, etc.), et par **date**.


## 2. Objectifs Pédagogiques Atteints

Ce projet a permis d'atteindre plusieurs objectifs pédagogiques clés :

- Apprendre à consommer une API REST et à manipuler des données complexes.
- Créer une interface utilisateur dynamique avec Flutter.
- Gérer la persistance des données utilisateur par exemple la sauvegarde de la date de dernière connexion.
- Mettre en œuvre la programmation asynchrone (`async/await`) pour une gestion efficace des requêtes réseau.
- Comprendre l'utilisation de la bibliothèque `Intl` pour gérer la localisation et le formatage des dates afin d'adapter l'application aux préférences locales.
- Développer la capacité d'analyser et de structurer des données pour créer des filtres pertinents pour la recherche d'objets.


## 3. Technologies Utilisées

- **Flutter** : Utilisé pour la création de l'interface utilisateur.
- **Dart** : Langage de programmation utilisé par Flutter, permettant de développer à la fois la logique de l'application et l'interface.
- **HTTP** : Bibliothèque utilisée pour les appels API REST, facilitant l'envoi de requêtes réseau.
- **Intl** : Pour la gestion de la localisation et le formatage des dates, afin d'offrir une expérience adaptée aux préférences locales de l'utilisateur.
- **SharedPreferences** : Pour le stockage local des préférences utilisateur, comme la date de dernière connexion.


## 4. Architecture de l'Application

### Arborescence du Projet

- **lib/main.dart** : Point d'entrée de l'application, incluant la gestion du thème et l'initialisation des routes.
- **lib/services/api_service.dart** : Contient les fonctions pour interagir avec l'API SNCF, encapsulant la logique des requêtes réseau.
- **lib/views/home_page.dart** : Page d'accueil qui permet de lancer une recherche et d'afficher les nouveaux objets trouvés.
- **lib/views/search_results_page.dart** : Page pour afficher les résultats de la recherche, en fonction des critères spécifiés par l'utilisateur.

### Diagramme de l'Architecture

L'architecture de l'application est organisée selon le principe de la **séparation des préoccupations**. Chaque fichier remplit une fonction spécifique, ce qui facilite la maintenance et l'évolution du projet. 

## 5. Appels d'API et Intégration des Données

### Consommation de l'API SNCF

L'application consomme l'API REST de la SNCF pour récupérer la liste des objets trouvés. Nous utilisons **`http.get()`** pour envoyer des requêtes réseau de manière asynchrone.
Les mots-clés **`async` et `await`** permettent d'attendre la réponse de la requête sans bloquer l'interface utilisateur, garantissant ainsi une expérience fluide.

Chaque appel à l'API est construit dynamiquement en fonction des paramètres sélectionnés par l'utilisateur, tels que la gare, la catégorie, et la date. 
Ces paramètres sont ajoutés à l'URL de la requête pour obtenir des résultats filtrés. 

### Gestion des Erreurs

Pour garantir une expérience utilisateur sans interruption, nous avons implémenté des blocs **`try-catch`** pour gérer les erreurs potentielles, telles que les erreurs de connexion réseau ou de formatage de date (`FormatException`).

### Logique de Filtrage des Requêtes

Les requêtes à l'API sont paramétrées avec des **filtres dynamiques** (gare d'origine, catégorie, date). Nous avons construit le paramètre **`q`** afin d'ajouter des mots-clés spécifiques pour affiner les résultats selon les critères définis par l'utilisateur. 

## 6. Gestion des Données Locales et Suivi de Connexion

### Stockage des Préférences Utilisateur

Nous avons utilisé **`SharedPreferences`** pour **sauvegarder la date de la dernière connexion**. Grâce à ce stockage local, nous pouvons déterminer si l'utilisateur se connecte pour la première fois et afficher un message de bienvenue approprié.

Cette fonctionnalité permet également d'afficher un message indiquant le nombre d'objets trouvés depuis la dernière connexion de l'utilisateur. 

### Affichage des Nouveaux Objets Trouvés

La méthode `fetchLostItemsSinceDate()` est utilisée pour récupérer les objets trouvés après la dernière connexion de l'utilisateur. Un message personnalisé est construit dynamiquement, indiquant le nombre d'objets trouvés depuis la dernière visite (par exemple, "X objets trouvés depuis votre dernière visite").


### Formatage des Dates et Localisation

Pour assurer un bon affichage des dates, nous avons utilisé la bibliothèque **`Intl`** qui permet de convertir les dates entre le format de l'utilisateur (par exemple, "08 octobre 2024") et le format ISO 8601 requis par l'API. Cette conversion garantit la compatibilité des données entre l'application et l'API


## 7. Programmation Asynchrone et Gestion de l'État

### Gestion de l'Asynchronisme avec `async` et `await`

La programmation asynchrone est essentielle pour la gestion des tâches qui peuvent être longues, comme les appels réseau. 
Avec **`async` et `await`**, nous avons pu attendre les réponses sans bloquer l'interface utilisateur.
Le modèle asynchrone permet également de gérer plusieurs requêtes simultanément.

### Gestion de l'État avec Stateful Widgets

Nous avons utilisé des **`StatefulWidget`** pour gérer les éléments nécessitant un changement d'état dynamique, comme l'affichage des résultats de recherche. 

L'utilisation appropriée des Stateful Widgets permet une bonne gestion de l'état.

## 8. Logique de Recherche et Suggestion des Gares

### Recherche des Gares en Fonction de l'Entrée de l'Utilisateur

L'application propose des **suggestions de gares** en fonction de l'entrée de l'utilisateur. Cette fonctionnalité est mise en œuvre à l'aide du widget **`SearchField`**, qui envoie des requêtes à l'API SNCF pour obtenir des suggestions en temps réel.


### Filtres de Recherche

L'application offre plusieurs options de recherche :

- **Recherche exacte par date** : Utilisation du format ISO 8601 pour une date précise.
- **Recherche approximative (±1 heure)** : Recherche élargie pour inclure les objets trouvés autour de l'heure spécifiée.
- **Recherche depuis la dernière connexion** : Permet de trouver des objets ajoutés depuis la dernière visite de l'utilisateur, les compte et affiche le message personnalisé.
- **Recherche des dernier éléments trouvé ** : Permet de trouver les dernier trouvé sans filtre.


## 9. Stratégie de Filtrage des Objets et Gestion des Catégories

### Utilisation de Dictionnaires de Catégories

Pour améliorer la recherche, nous avons créé des **dictionnaires de catégories** (`categoryDictionaries`). Chaque catégorie est associée à une liste de mots-clés, ce qui permet d'affiner la recherche en regroupant les objets aux descriptions variées. 
Ces dictionnaires ont été construits après une **analyse  des résultats de l'API** afin de maximiser la pertinence des résultats.


## 10. Navigation et Gestion de l'État

### Navigation entre les Pages

La navigation entre les pages a été facilitée par les **routes définies dans `MaterialApp`**.

### Sauvegarde et Restauration de l'État de l'Application

Les méthodes **`initState()`** et **`dispose()`** sont utilisées pour initialiser et libérer les ressources.

## 11. Optimisation et Bonnes Pratiques

### Réduction de la Redondance de Code

Nous avons optimisé le code en utilisant des **fonctions utilitaires** et des **méthodes génériques** telles que `_buildCategoryButton()`, afin d'éviter les répétitions. 

### Séparation des Préoccupations

L'architecture suit le principe de la **séparation des préoccupations** :

- **`ApiService`** gère toute la logique des appels à l'API.
- Les vues (comme `HomePage` et `SearchResultsPage`) sont responsables de l'affichage et de l'interaction avec l'utilisateur.

## 12. Challenges Rencontrés et Solutions Apportées

### Gestion des Formats de Dates et Localisation

La conversion des dates entre le format utilisateur et le format ISO 8601 a posé des défis en termes de compatibilité. 
Pour surmonter cela, nous avons utilisé la bibliothèque **`Intl`**, qui a permis ula **gestion  des différences de localisation** et une conversion des dates.

### Catégorisation des Objets

Le défi de la catégorisation des objets a été relevé en utilisant des **listes de mots-clés**. 

### Suggestion des Gares

Pour la suggestion des gares, nous avons implémenté une **recherche dynamique basée sur l'entrée utilisateur**. 
En utilisant un indicateur de chargement (`CircularProgressIndicator`), nous avons assuré une bonne interaction utilisateur pendant la récupération des suggestions. 

### Notification des Objets Trouvés

Pour informer l'utilisateur des objets trouvés depuis sa dernière connexion, nous avons utilisé **`SharedPreferences`** pour stocker la date de la dernière visite et une méthode qui récupère et compte les nouveaux objets.

## 13. Conclusion et Retours d'Expérience

### Ce que J'ai Appris

Ce projet a été l'occasion d'apprendre :

- L'utilisation d'une **API REST** pour enrichir une application mobile.
- Les **techniques de gestion de l'état** et l'asynchronisme avec `async`/`await`.
- L'optimisation des filtres de recherche pour garantir des résultats pertinents malgré des descriptions variées.
- L'importance de l'optimisation des requêtes réseau pour une bonne fluidité de l'application, même sur des réseaux plus lents.
- La mise en œuvre de suggestions dynamiques basées sur l'entrée utilisateur pour une expérience plus intuitive.


## 14. Annexes

### Liens Utiles

- Documentation de l'API SNCF : [API SNCF](https://data.sncf.com/explore/dataset/objets-trouves-restitution/api/)
- Documentation Flutter : [Flutter Docs](https://flutter.dev/docs)
- Documentation sur les bibliothèques utilisées : [Intl](https://pub.dev/packages/intl), [HTTP](https://pub.dev/packages/http), [SharedPreferences](https://pub.dev/packages/shared_preferences)
- Documentation sur le dataset de l'ensemble des gares : https://ressources.data.sncf.com/explore/?q=referentiel-gares-voyageurs&sort=modified

