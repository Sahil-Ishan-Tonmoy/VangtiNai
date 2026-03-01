# VangtiChai (Assignment 01) Implementation Details

## 1. Implementation Overview
The VangtiChai app is a Flutter application that provides a custom numeric keypad and a reactive calculator capable of breaking down an entered Taka amount into standard Bangladeshi currency notes (500, 100, 50, 20, 10, 5, 2, 1). The application handles state management efficiently, recalculating the required change instantly upon every key press. Furthermore, the application listens to device orientation and dynamically adjusts its layout to provide an optimal experience on both portrait (e.g. phones) and landscape (e.g. tablets) screens.

## 2. Integration of Local Resources
Unlike apps that rely heavily on static local files (like images, videos, or external CSS/XML), this app is built purely programmatically in Dart, taking advantage of Flutter's rich widget tree. "Resources" in this context refer to:
* **Theming and Colors:** The app defines a central `ColorScheme` initialized with `Colors.teal`, and hardcodes particular hex colors for buttons and backgrounds (`Color(0xFFD6D7D9)`, `Color(0xFFE8F0FE)`) directly in the code, keeping the project lightweight.
* **Layout Metrics:** Padding, flex factors, and typography variables aren't stored in a `sizes.xml` like native Android; instead, they are passed as raw parameter arguments inside `main.dart` for fast initialization and direct application within Widget classes.

*(Note: No external `assets/` images or `res/raw` files were necessary to fulfill the Assignment 01 requirements.)*

## 3. Core Functions and Widgets

Here is a breakdown of the key functions that drive the app's functionality:

### State Variables
* `_amountString`: A reactive string holding the concatenated digit input.
* `_notes`: A constant list of integers representing available currency notes `[500, 100, 50, 20, 10, 5, 2, 1]`.

### `_onKeyPress(String value)`
Triggers whenever a keypad button is pressed. If the value is "CLEAR", `_amountString` resets. Otherwise, the method appends the digit, preventing leading zeros (unless it's a single zero). It is wrapped in a `setState()` to prompt UI regeneration seamlessly.

### `_calculateChange()`
Parses the current `_amountString` into an integer and then iterates over the `_notes` list in descending order, utilizing `~/` (integer division) to figure out how many notes fit into the amount, and `%` (modulo) to keep track of the remainder. Returns a mapped dictionary linking note values to their matching counts.

### Keypad Builder Methods
* **`_buildKeyButton(String label, {int flex = 1})`**: A reusable widget factory for individual keypad buttons featuring an `InkWell` for material ripple effects.
* **`_buildPortraitKeypad()`**: Arranges keys in a traditional numpad grid (4 rows of 3 columns) suitable for constrained widths.
* **`_buildLandscapeKeypad()`**: Redistributes the grid logically against wider viewports (3 rows of 4 buttons each). 
* **`_buildKeypad(bool isLandscape)`**: Decides which layout to serve based on the boolean orientation flag.

### Note List Builder Methods
* **`_buildNoteRow(int note, int count)`**: Outputs a structured two-column row representing a note label and its calculated amount.
* **`_buildNoteList(bool isLandscape)`**: Builds the dynamic table array. If landscape mode is engaged, it distributes the 8 standard notes evenly across two side-by-side columns to economize on vertical space.

### The `build(BuildContext context)` Lifecycle
Calculates an `isLandscape` boolean by querying the device screen settings (`MediaQuery.of(context).orientation`). It then dynamically sizes the main `Expanded` flex properties on the column splits that house the Note List and Keypad.
