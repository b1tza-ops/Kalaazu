# AGENTS Guidelines for the Kalaazu Project

This document provides guidelines for developers and AI assistants working on the Kalaazu project. Adhering to these
guidelines ensures a smooth and consistent development workflow.

## 1. Project Overview

**Kalaazu** is a private server for the game DarkOrbit. It is a multi-module Java project built with the Spring Boot
framework.

### 1.1. Project Architecture

The project is a monolith composed of several key modules:

* **`Launcher`**: The main entry point of the application. It starts a **JavaFX** dashboard for server management and
  initializes all other modules.
* **`Server`**: Contains the core game server logic. It uses **Netty** for socket communication and an *
  *Entity-Component-System (ECS)** architecture with **Artemis-ODB**. Key services include `MapService`,
  `GameLoopService`, and `ChannelManager`.
* **`Persistence`**: Manages database interaction using **Spring JPA** and **Hibernate**. It also contains the raw SQL
  files for the database schema.
* **`CMS`**: Contains a **Vue.js** frontend (`src/main/www`) and its corresponding Java API (`src/main/java`) for
  user-facing features like registration.
* **`Utils`**: A shared module for cross-cutting concerns and utility functions.

### 1.2. Inter-Module Communication

Modules communicate in a decoupled manner using the **Spring Event Bus**. For example, a UI action in the `Launcher`
module can publish an event (e.g., `StartServer`) that the `Server` module listens for to trigger an action. When
contributing, please follow this event-driven pattern.

* **Event Publishing Example**: `com.kalaazu.ui.presenter.MainLayout` publishes a `com.kalaazu.event.StartServer` event.
* **Event Handling Example**: The `start(StartServer event)` method in `com.kalaazu.server.Server` listens for this
  event.

## 2. Technology Stack & Prerequisites

To work on this project, you will need the following installed:

* **JDK**: Version 25.
* **Gradle**: Use the included Gradle 9.1 wrapper.
* **Database**: MariaDB.
* **Node.js**: Required for frontend development (version is flexible).

## 3. Development Setup

### 3.1. Running the Application

The primary way to run the project for development is by executing the main class from your IDE:

* **Main Class**: `com.kalaazu.Launcher`

This will start the Spring Boot context and launch the JavaFX server dashboard.

### 3.2. Database Setup

The project uses a **MariaDB** database. Schema management is currently a manual process.

**Initial Setup Steps:**

1. Ensure you have a running MariaDB instance.
2. Create an empty database named `kalaazu`.
3. The database schema is defined in multiple SQL files within the `Persistence/database/` directory. These are compiled
   into a single file.
    * **Note**: The `Persistence/database/compiler.php` script was previously used for this. This is being migrated to a
      Gradle task. For now, you can use the pre-compiled `Persistence/database/dump.sql` file.
4. Import the `Persistence/database/dump.sql` file into your `kalaazu` database using a tool like phpMyAdmin, DBeaver,
   or the command line.
5. Configure your database connection credentials in `Launcher/src/main/resources/application.yml`. You can use a
   profile-specific file (e.g., `application-dev.yml`) or set the values using environment variables as defined in the
   default file.

**Making Schema Changes:**

* There is no automated migration tool like Flyway or Liquibase.
* To add or modify a table, edit the corresponding files in `Persistence/database/<table_name>/`.
* After editing, you must **manually apply the SQL changes** to your local database.

## 4. Core Gameplay & Networking

### 4.1. Networking & Packet Flow

* **Incoming Packets**:
    1. Netty decodes raw data into a version-specific `InCommand` object.
    2. The `ChannelManager` receives the command.
    3. In its `processPacket` method, it iterates through a list of `PacketHandler`s for the current client version and
       invokes the handler that matches the incoming command.
* **Outgoing Packets**:
    1. To send data to clients, publish a Spring `ApplicationEvent`.
    2. The `ChannelManager` listens for these events and sends the commands to the appropriate `GameSession`(s).
    3. **Key Events**: `SendCommand` (to one session), `SendCommands` (multiple commands to one session),
       `SendCommandToSessions` (one command to many sessions), `BroadcastCommand` (to all sessions).

### 4.2. Gameplay Implementation Details

#### User Registration & Account Creation

1. The process starts in the Vue.js frontend within the `CMS` module.
2. The frontend calls a registration API endpoint in the `CMS` module's Java backend.
3. This endpoint utilizes the `Persistence` module to create a new `User` record.
4. It then creates the necessary associated entries in the `accounts`, `accounts_hangars`, `accounts_ships`, and other
   `accounts_*` tables.
5. When the user later chooses a faction, the `factions_id` column in their `accounts` table record is updated.

#### World & Map Initialization

1. When the `Server` module starts, the `MapService` is initialized.
2. `MapService` retrieves all `MapsEntity` records from the database.
3. For each map, it creates a dedicated game world, which is an instance of `com.artemis.World` (Artemis-ODB).
4. `MapService` then queries the database for all entities belonging to that map (e.g., `maps_npcs`, `maps_portals`,
   `maps_collectables`).
5. The `GameLoopService` is then called to populate the world. It creates an entity for each object (NPC, portal, etc.)
   and attaches the necessary components (e.g., `PositionComponent`, `IdComponent`, `NpcComponent`).
6. Finally, `GameLoopService` manages a `GameLoop` instance for each map. This `Runnable` is scheduled to run at a fixed
   rate, calling `world.process()` to update the game state for that specific map.

#### Combat System

1. **Target Selection**:
    * The client sends a `SelectShipCommand` with the target's public ID (from `IdComponent`).
    * The `SelectShipHandler` receives this and adds an action to the `GameLoopService` to update the player's
      `TargetComponent` in the ECS world before the next game tick.

2. **Initiating Attack** (To be implemented):
    * With a target selected, the client will send an `AttackCommand`.
    * A new `AttackHandler` will process this, likely by adding an `AttackingComponent` to the player's entity, which a
      new `AttackSystem` will then process.

3. **Damage & Stats**:
    * To optimize performance, ship stats like laser damage, health, and shield are pre-calculated and stored in the
      `AccountsConfigurationsEntity`.
    * Game systems should read from this configuration rather than calculating stats from raw equipment data on the fly.

4. **Projectiles & Visuals**:
    * Projectile physics are **not** simulated on the server.
    * The server's role is to validate an attack, calculate damage, and then notify the client.
    * It sends commands like `AttackStartedCommand` or `RocketFiredCommand` containing visual information (e.g., laser
      GFX ID). The client is responsible for rendering the animations.

5. **Entity Destruction** (To be implemented):
    * When an entity's health reaches zero, a system will need to handle its destruction.
    * This process will involve removing the entity from the world and triggering a reward calculation and distribution
      process (for experience, currency, honor, etc.).

#### Data Model & Core Entities

The database schema (`dump.sql`) is the single source of truth for the game's data structures. Understanding these
relationships is critical for implementing new features.

##### 1. Player & Account Structure

* **`users`**: Stores the master login credentials (`name`, `password`, `email`).
* **`accounts`**: Represents a single in-game character. A `user` can have multiple `accounts`. This table is the
  central hub for a player's state, linking to their faction, level, rank, and clan.
* **`accounts_hangars`**: Each `account` has one or more hangars. The `accounts` table points to the currently active
  hangar via `accounts_hangars_id`.
* **`accounts_ships`**: Stores the ships owned by an account. It tracks the ship's current state, including `health`,
  `shield`, `position`, and `maps_id`.

##### 2. Ship Configuration and Stats (Critical for Combat)

* **`accounts_configurations`**: This is a crucial performance optimization. Each hangar has two configurations (config
  1 and 2). This table stores the **pre-calculated, denormalized stats** (`damage`, `health`, `shield`, `speed`) for
  each configuration.
    * **Guideline**: Combat systems should **always** read these final stats from the `AccountsConfigurationsEntity`. *
      *Do not** recalculate stats from individual items during the game loop.
* **`accounts_items`**: The player's master inventory of all owned items (lasers, shields, generators, etc.).
* **`accounts_configurations_accounts_items`**: This is the join table that defines which items from `accounts_items`
  are equipped in a specific configuration (`accounts_configurations_id`), ship, drone, or P.E.T.

##### 3. Master Data & Catalogs

* **`items`**: The master catalog for every item in the game. The `category` and `type` columns are essential for
  logic (e.g., `category=4` for generators, `type=16` for lasers).
* **`ships`**: Defines the base stats for each ship type (base health, speed, cargo, and slot counts).
* **`npcs`**: Defines the base stats for all alien types (health, shield, damage, speed, AI type).
* **`rewards`**: A master list of all possible reward packages (e.g., 100 Uridium, 2000 Credits).

##### 4. Rewards and Loot System

The reward system is highly normalized:

* **`rewards_npcs`**: Links an `npcs` ID to one or more `rewards` IDs. This defines the loot table for each alien.
* **`rewards_galaxygates`**: Links a `galaxygates` ID to its completion rewards.
* **`rewards_collectables`**: Links a `collectables` ID (e.g., a bonus box) to its potential rewards.

##### 5. Game World Definition

* **`maps`**: Defines all maps, their names, and whether they are PvP enabled.
* **`maps_portals`**: Defines the jump gates on each map, including their position and target map/position.
* **`maps_stations`**: Defines the positions of faction bases on the maps.
* **`maps_npcs`**: Defines which NPCs spawn on which map and in what quantity. This is used by the `MapService` to
  populate the game world.

##### 6. Other Core Systems

* **Clans**: `clans`, `clans_roles`, `clans_diplomacies`, `permissions`. This structure supports a rich social system
  with roles, permissions, and diplomacy (War, NAP, Alliance).
* **Galaxy Gates**: `galaxygates`, `galaxygates_waves`, `galaxygates_spawns`. Defines the structure for the wave-based
  PvE system. The `galaxygates_spins` and `galaxygates_probabilities` tables define the materializer/spinner rewards.
* **Skill Tree**: `skilltree_skills` and `skilltree_levels` define the available skills and their upgrade progression.
  `accounts_skills` stores the player's progress.
* **Skylab & Techfactory**: `skylab_modules`, `techfactory_items`, and `techfactory_costs` define the data for the
  long-term resource production and item crafting systems.

---

## 5. Backend Development (Java)

* **Build Tool**: The project is built using **Gradle**. Dependencies are managed in the `build.gradle` file of each
  module.
* **ORM**: Database entities (ORMs) are located in the `Persistence/src/main/java` directory. When you modify the
  schema, ensure the corresponding JPA entity is updated.
* **Game Logic**: The core game logic resides in the `Server` module. It uses Netty for networking and Artemis-ODB for
  the ECS architecture.

## 6. Frontend Development (Vue.js)

* **Location**: The frontend source code is located at `CMS/src/main/www`.
* **Development Server**: To work on the frontend, navigate to the `CMS/src/main/www` directory and use standard npm
  commands:
    * `npm install` to install dependencies.
    * `npm run dev` (or similar) to start the local development server.
* **Build Integration**: The Gradle build for the `CMS` module (`CMS/build.gradle`) is configured to build the frontend
  assets, but this step is currently disabled to speed up backend development.

## 7. Coding Conventions

* **Language**: The primary backend language is **Java 25**.
* **Code Style**: Please adhere to the default code style and conventions for the language you are working with (Java,
  Vue.js). Maintain consistency with the existing codebase.
* **ORM Entities**: JPA entities are located in the `Persistence` module. Ensure they are kept in sync with the database
  schema.

## 8. Useful Commands Recap

| Command                                 | Purpose                                                         |
|-----------------------------------------|-----------------------------------------------------------------|
| Run `com.kalaazu.Launcher` from IDE     | Starts the entire application, including the JavaFX dashboard.  |
| `./gradlew build`                       | Compiles and builds all modules.                                |
| `./gradlew run`                         | Runs the application using Gradle.                              |
| `cd CMS/src/main/www && npm run serve`  | Starts the frontend development server.                         |
| `php Persistence/database/compiler.php` | (Legacy) Compiles database schema files into a single SQL file. |

---

Following these practices ensures that the development workflow remains efficient and consistent.
