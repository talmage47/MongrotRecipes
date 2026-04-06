# MongrotRecipes

A recipe manager for iPhone and Mac. Dark, minimal, and native-feeling — visually inspired by Apple Photos.

---

## Features

- **Recipes tab** — searchable, sortable list with prep time, servings, and group labels
- **Categories tab** — horizontally scrolling sections (Pinned, Groups) in an Apple Photos-style layout
- **Recipe detail** — ingredients, step-by-step instructions, and a live servings scaler that adjusts ingredient amounts
- **Settings** — user-selectable accent color (8 presets)
- **Multiplatform** — runs on iPhone and Mac

---

## Tech Stack

- SwiftUI (iOS 18+ / macOS 15+)
- Core Data (local persistence)
- MVVM architecture
- iCloud sync ready (see below)

---

## Project Structure

```
MongrotRecipes/
├── MongrotRecipes.xcdatamodeld/   Core Data model
├── CoreData/                       NSManagedObject subclasses
├── Core/
│   ├── Persistence/                PersistenceController
│   ├── Theme/                      AccentColorOption
│   └── Extensions/                 Cross-platform helpers
├── Features/
│   ├── Root/                       RootTabView + tab routing
│   ├── Recipes/                    Recipes list + row
│   ├── Collections/                Categories tab
│   ├── RecipeDetail/               Detail view + servings scaler
│   └── Settings/                   Accent color picker
├── Components/                     Reusable UI (cards, tab bar, section headers)
└── Preview/                        Seed data for Xcode previews
```

---

## Data Model

| Entity | Key fields |
|---|---|
| `Recipe` | title, summary, servings, prep/cook time, nutrition, image |
| `Ingredient` | name, amount, unit, baseAmount (used for scaling) |
| `InstructionStep` | text, sortOrder |
| `CollectionGroup` | title, isPinned, sortOrder |

Relationships: Recipe ↔ Ingredients (1-to-many), Recipe ↔ Steps (1-to-many), Recipe ↔ CollectionGroup (many-to-many).

> **Naming note:** The category entity is called `CollectionGroup` in code (not "Category") to keep the door open for shared groups, featured collections, and other future collection types.

---

## Enabling iCloud Sync

The app currently uses `NSPersistentContainer` (local only). To enable iCloud sync:

1. Xcode target → **Signing & Capabilities** → **+** → **iCloud**
2. Check **CloudKit** and create a container (e.g. `iCloud.com.yourname.MongrotRecipes`)
3. In `Core/Persistence/PersistenceController.swift`, follow the TODO steps to switch to `NSPersistentCloudKitContainer`

Requires a paid Apple Developer Program account.

---

## Planned Features

- Add / edit recipes
- Shared groups via CloudKit sharing
- Shopping list export to Reminders
- Recipe variants (e.g. spicy vs. mild)
- Paste / import recipe from text or YouTube description
- Nutrition calculation from ingredient data
