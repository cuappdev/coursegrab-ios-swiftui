# CLAUDE.md (general iOS template)

A reusable conventions file for a SwiftUI iOS codebase using standard **MVVM**. Copy it into a
project as `CLAUDE.md` and fill in the app-specific names, paths, and backend choice. Patterns
are modeled on Cornell AppDev apps (Uplift, Resell).

The three layers at a glance:

- **Model** — inert data. `Codable` value types, no logic, no SDK imports.
- **View** — only draws. Decomposed into small sub-views; no business logic.
- **ViewModel** — owns all logic and state. `@Observable`, nested in its view, one per screen.

General: self-documenting names over comments; `///` on non-trivial symbols, `//` only for
genuinely non-obvious logic. No narration, no commented-out code, no dead files.

---

## Model

- Inert `struct`s conforming to `Codable` / `Identifiable` / `Hashable` as needed. **No SDK
  imports in a model** — auth/vendor mapping belongs in a service, not on the model.
- Keep request/response payloads as plain structs (grouped `let`s, no wordy mapping inits).
  Don't add response wrappers or endpoints until a feature actually uses them.
- When identity is by `id`, implement `==` / `hash(into:)` on `id` only.
- Keep models as clean **domain** types. If the backend's wire shape differs from what the app
  wants, map it in an `init(from:)` rather than leaking wire concerns into views/VMs.
  Doc-comment (`///`) non-obvious properties.
- Live in `Models/`.

---

## View

Views only draw — all logic lives in the ViewModel.

**Composition**
- Split `body` into small `private var …: some View` sub-views. A screen is many named
  sub-views, never one giant `body`.
- A `private func` is allowed only when it **returns a view** (a parameterized sub-view); it
  must never hold action or business logic.
- Button / `.onChange` closures are one-liners that call a VM method
  (`viewModel.signIn()`), not blocks of logic.
- No magic values — colors, fonts, spacing, and layout numbers come from a `Constants` enum.
- Every view file ends with a `#Preview` using dummy/fixture data — never a live network call.
- Sections: `// MARK: - Properties`, `// MARK: - UI`.

**State ownership**
- The owning view creates its VM with `@State private var viewModel = ViewModel()`.
- `@State` in a view is only for simple state tied directly to that view (a toggle, a local
  animation flag, a small filter selection). Once it grows logic or non-trivial use, move it to
  the ViewModel. When in doubt, it belongs in the VM.
- Use `@Bindable` on a receiving view only when it needs `$` bindings into a VM it doesn't own.

**Sharing a view model — pass the instance, don't use the environment**
- Avoid `@EnvironmentObject` / `@Environment` for view models: environment injection is
  invisible at the call site, has to be set up on every screen that might touch it, and a
  missed injection crashes at runtime.
- The view that needs another view's VM takes that owner's **existing instance** through its
  `init`, typed as the owner's nested `ViewModel`:
  ```swift
  struct RowCell: View {
      let item: Item
      var viewModel: ListView.ViewModel   // ListView's instance
  }

  RowCell(item: item, viewModel: viewModel)   // ListView hands over its own
  ```
  Works for cells, sheets, pushed detail screens — one instance, the owner holds it with
  `@State`, everyone else receives a reference. Add `@Bindable` only if `$` bindings are needed.
- **The environment is reserved for app-wide state** (auth/session, the tab bar) where passing
  it everywhere isn't practical — inject with `.environment(instance)`, read with
  `@Environment(SomeType.self)`. Be hesitant; default to passing the instance.

**Reuse & modifiers**
- Factor reusable behavior into `ViewModifier`s via `View` extensions instead of repeating
  overlay/presentation plumbing: `.loading(isLoading) { … }`, `.showModal($flag) { … }`,
  shadow/shimmer, etc.
- Buttons use a shared `ScaleButtonStyle` (scale + slight dim on press); tactile feedback via a
  `Haptics.shared.play(_:)` helper, not ad-hoc feedback generators.
- Shared, cross-feature components live in `Views/Components/`; a component used by only one
  feature lives in that feature's `Views/<Feature>/Components/`.

---

## ViewModel

- **`@Observable`, `@MainActor`, nested in the view it belongs to**, one per screen:
  ```swift
  extension LoginView {
      @MainActor
      @Observable
      final class ViewModel {
          var isLoading = false   // plain vars — no @Published / ObservableObject
      }
  }
  ```
  The file lives in `ViewModels/`, named `<Screen>ViewModel.swift`.
- **All complex logic lives here** — networking, image work, validation, navigation/session
  transitions. A child VM that advances app state takes the owner VM as a parameter.
- **Split animation out.** When a screen has meaningful animation state, keep it in a second,
  animation-only VM (e.g. `SignInAnimationViewModel`) separate from the logic VM.
- Sections: `// MARK: - Properties`, `// MARK: - Functions`, `// MARK: - Private`.

---

## Navigation

- **Top level** (auth/onboarding ↔ main): an app-level VM holds a `SessionState` enum; the
  `App` switches on it. No `Router`.
- **Inside the app** (push detail, profile, chat, …): each tab owns its own
  `NavigationStack(path:)`. Declare destinations **once** per stack with
  `.navigationDestination(for: Route.self)`, driven by a typed `Route` enum whose cases carry
  the `Hashable` model they need. Navigate by appending to the path (owned by the tab root, or
  the tab's VM when the VM drives navigation). Don't scatter `NavigationLink(destination:)`.

## Screen state & errors

- **Content screens use one state enum**, not a pile of bools:
  ```swift
  enum LoadState<Value> { case loading, loaded(Value), empty, error(String) }
  ```
  The VM exposes `var state: LoadState<[Item]>`; the view switches on it. A plain
  `var isLoading = false` is fine only for a single action (e.g. a submit button), never for
  content loading.
- **Errors reach the UI through the VM:** expose `var errorMessage: String?` and present it with
  a shared `.errorAlert($viewModel.errorMessage)` modifier — one implementation, every screen
  consistent. Don't hand-roll a bespoke error sheet per screen.

## Services

- Cross-cutting, app-lifetime concerns (networking, auth, session, keychain, haptics, logging)
  are the **one allowed singleton exception**: `static let shared` + `private init()`.
  ViewModels and feature state are never singletons; the owner creates them and passes the
  instance down.
- Auth/session work lives in dedicated services (e.g. `AuthManager`, `SessionManager`); don't
  manage tokens at call sites.

## Networking

Pick the section for the backend you're calling. Either way: **one client, centralized auth
(inject the token in one place, refresh-and-retry on expiry there), decode into clean domain
models, and never build a request in a feature.**

### REST

- All access goes through a single `NetworkManager` (`static let shared`) built on generic
  request templates behind an `APIClient` protocol (`get` / `post` / `delete`).
- Add an endpoint as a small `async` method that builds its URL with a `constructURL(endpoint:)`
  helper and delegates to a template — never assemble a `URLRequest` in a feature.
- Route every request through one `perform` executor that injects the `Bearer` token and, on a
  `401`, refreshes auth once and retries. Decode with a shared `JSONDecoder`; surface failures
  as a typed `ErrorResponse`.
- `async`/`await` only — no Combine.

### GraphQL (Apollo)

- Use **Apollo iOS with code generation.** Keep `.graphql` operation files in the networking
  folder and generate the types into a **separate SwiftPM module** via `apollo-ios-cli` — never
  hand-write response types.
- One `ApolloClient` wrapping a `RequestChainNetworkTransport`, a normalized cache
  (`ApolloStore` / `InMemoryNormalizedCache`), and an interceptor provider.
- **Auth is an `ApolloInterceptor`** that injects the `Bearer` token from the session manager,
  detects token-expired errors, and refreshes + retries **inside the request chain** — not per
  call site.
- Bridge Apollo's callbacks to Combine with `queryPublisher` / `mutationPublisher`; VMs consume
  with `.compactMap(\.data?…)` → `.sink {}` → `.store(in: &cancellables)`. Surface
  GraphQL-level errors (`result.errors`) as a typed error wrapper. Use cache policies
  (e.g. `.returnCacheDataAndFetch`) via the normalized cache.
- **Map generated fragments to clean domain models in `init(from: SomeFields)`.** Views and VMs
  never touch generated API types directly.
- GraphQL/Apollo is Combine-based — this is the one place Combine is expected; everywhere else
  prefer `async`/`await`.

## Concurrency

- Modern Swift concurrency (`async`/`await`, `Task`). Avoid new Combine pipelines or raw
  `DispatchQueue` in feature code (the Apollo/GraphQL layer, if used, is the exception).
- Prefer `.task {}` over `.onAppear { Task {} }`. Reset flags like `isLoading` with `defer`.
- Guard against concurrent submits (single-flight) and disable buttons while loading.
- **Keep heavy work off the main actor.** If default actor isolation is MainActor, JSON
  decoding and image work would run on the main thread unless opted out — mark those paths
  `nonisolated` and hop back to the `@MainActor` VM only to publish results.
- **Cancellation.** `.task {}` cancels when the view disappears. For search-as-you-type or
  debounced work, the VM stores the in-flight `Task` and cancels the previous one before
  starting the next.

## Data & media

- **Lists:** `List` / `LazyVStack` with stable `id`s. **Pagination:** the VM loads the next
  page when the last item appears (trigger from the last cell's `.onAppear` / `.task`); guard
  against overlapping page loads (single-flight).
- **Images:** scrolling/list images go through a caching library (Kingfisher or Nuke) via a
  shared `CachedImageView` — not raw `AsyncImage`, which re-fetches on scroll. `AsyncImage` is
  fine for a one-off, non-scrolling image.
- **Fixtures:** preview data lives in `Preview Content/` (a Development Asset, excluded from
  release) as `static` mocks — `Item.mock`, `[Item].mocks`. Only previews use them; never
  reference a mock from shipping code.

## Constants, config & secrets

- All colors, fonts, spacing, and per-screen layout numbers live in a `Constants` enum (nested
  per screen). No inline hex, font literal, or layout number.
- All URLs, client IDs, and secrets come from a single `Keys`/config helper that reads the
  bundle. Never hardcode them. Keep real secret files (xcconfig, service plists) git-ignored,
  referenced in the project so missing ones show as red placeholders.

## Logging

Use `Logger` (OSLog) with categories (e.g. `.services`, `.data`) — never `print`. Gate
debug-only logs behind `#if DEBUG`.

## Project layout

```
<App>/
  <App>App.swift         @main; switches on sessionState
  Models/                inert Codable value types + wire payloads
  Services/              auth, session, keychain, logging
    Networking/          APIClient + NetworkManager (REST) or Apollo client (GraphQL)
  Utils/
    Constants.swift      design tokens + per-screen layout enums
    Keys.swift           reads config/secrets from the bundle
    Extensions/          small focused extensions, one type per file
  ViewModels/            `extension <Screen> { ViewModel }`, one file per screen
  Views/
    Components/          ONLY components shared across multiple features
    <Feature>/           a feature's screens
      Components/         components used by only that feature
  Preview Content/       mock fixtures (Development Asset, not shipped)
```

## Common Xcode / Swift gotchas

- Prefer the **Observation framework** (`@Observable`) over `ObservableObject` / `@Published`
  for new ViewModels.
- If the project enables `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY`, any file still using
  `ObservableObject` / `@Published` needs an explicit `import Combine` (SwiftUI's transitive
  re-export no longer applies). `@Observable` needs no Combine import.
- If `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, remember heavy work needs `nonisolated` (see
  Concurrency).
- Modern projects use **file-system-synchronized groups** (objectVersion ≥ 70): files added to
  a synchronized folder auto-compile — no `project.pbxproj` edit needed for source files.
- Keep SPM `Package.resolved` and `contents.xcworkspacedata` tracked; only `xcuserdata` is
  per-user and git-ignored.

## File header

```swift
//
//  <FileName>.swift
//  <App>
//
//  Created by <Author> on <M/D/YY>.
//
```

## Before you commit

- [ ] **Model:** inert, no SDK imports; payloads plain; identity on `id` only.
- [ ] **View:** split into many `private var …: some View`; no action `private func`s; thin
      closures; `#Preview` present; values from `Constants`.
- [ ] **View state:** owner holds VM with `@State`; shared VMs passed by instance (not the
      environment); `@State` only for simple view-local state.
- [ ] **ViewModel:** `@Observable @MainActor`, nested `extension <Screen> { ViewModel }`, one
      per screen; all complex logic here.
- [ ] Navigation: top level via `sessionState`; in-app via a `Route` enum +
      `.navigationDestination` — no scattered `NavigationLink`s.
- [ ] Content screens use a `LoadState` enum; errors via `errorMessage` + `.errorAlert`.
- [ ] Network access via a single client + endpoint method; token injected/refreshed in one
      place; no inline requests; secrets from `Keys`.
- [ ] Heavy work (decode / image) is `nonisolated`; debounced tasks cancel the previous one.
- [ ] Reusable behavior factored into `ViewModifier`s; shared vs. feature-local components
      placed correctly; preview fixtures in `Preview Content/`.
- [ ] Errors logged via `Logger`, not `print`.
- [ ] Builds warning-free.
