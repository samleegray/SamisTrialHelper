# Sami's Potion Helper

An Elder Scrolls Online addon that automatically manages consumables in your backpack. When you open your inventory, it scans your bag and marks non-crafted, sellable items as junk based on your enabled filters (potions always, with optional food/drink, poisons, and merchant items). It can also auto-sell junk when you open a store.

## Features

- **Auto-junk non-crafted potions** — Any sellable potion that was not player-crafted is automatically marked as junk when you open your inventory.
- **Optional food & drink filtering** — When enabled, non-crafted sellable food and drink are also marked as junk.
- **Optional poison filtering** — When enabled, non-crafted sellable poisons are also marked as junk.
- **Optional merchant item filtering** — When enabled, non-crafted sellable merchant trash/priority-sell items are also marked as junk.
- **Optional stolen item junking** — When enabled, stolen items can be marked as junk; disable to always keep stolen items out of junk.
- **Optional auto-sell at merchants** — When enabled, all junk is sold automatically when opening a store.
- **Settings panel** — Configurable via LibAddonMenu-2.0, including debug, filter, and auto-sell toggles.
- **Optional stolen item junking** — When enabled, stolen items can be marked as junk; disable to always keep stolen items out of junk.

## Dependencies

| Library | Version |
|---|---|
| [LibAddonMenu-2.0](https://www.esoui.com/downloads/info7-LibAddonMenu.html) | ≥ 41 |

## Settings

Open **Settings → Addons → SamisPotionHelper** to access:

| Option | Default | Description |
|---|---|---|
| Enable Debug | Off | Print debug messages to the chat window |
| Filter Food & Drink | On | Also junk non-crafted, sellable food and drink |
| Filter Poisons | On | Also junk non-crafted, sellable poisons |
| Filter Merchant Items | On | Also junk non-crafted, sellable merchant trash items |
| Flag Stolen Items As Trash | On | If Off, stolen items are never marked as junk |
| Auto Sell Trash Items | Off | Automatically sell junk items when opening a merchant store |

## How It Works

1. When the inventory scene opens, the addon iterates through every slot in `BAG_BACKPACK`.
2. Each item is checked against enabled filters:
   - **Potions** are always considered.
   - **Food & Drink** are considered when the setting is enabled.
   - **Poisons** are considered when the setting is enabled.
   - **Merchant Items** are considered when the setting is enabled.
   - **Stolen items** are skipped when "Flag Stolen Items As Trash" is disabled.
3. Matching items are marked junk only if they are **non-crafted and sellable**.
4. If **Auto Sell Trash Items** is enabled, opening a merchant store will sell all junk automatically.

## Version

`1.1.0`

## Author

samihaize

## License

See [LICENSE.md](LICENSE.md).
