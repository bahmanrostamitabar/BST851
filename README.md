# BST851

Course materials for BST851: Quarto (reveal.js) lecture slides, tutorials and datasets.

## Folder structure

| Path | Contents |
|------|----------|
| `lectures/` | Slide decks, one subfolder per lecture (`lecture1`, `lecture2`, ...) |
| `tutorials/` | Practical exercises: `R_tutorials/`, `R_solutions/` and `python/` |
| `data/` | Datasets used in lectures and tutorials (CSV/XLSX) |
| `img/` | Images and logos used in slides |
| `backgrounds/` | Slide background images |
| `figure/` | Generated figures |
| `_extensions/` | Quarto extensions used by the slides |
| `_quarto.yml` | Project-wide Quarto settings (reveal.js format, caching) |
| `pp.scss` | Custom slide theme |

## Requirements

- [Quarto](https://quarto.org/) (to render slides)
- R

## Usage

1. Clone the repository and open it in Positron or RStudio, or downlaod the zip file!
2. Render a lecture, e.g. `quarto render lectures/lecture1/<file>.qmd`, or use `quarto preview` while editing.
3. Open the tutorials in `tutorials/R_tutorials` or `tutorials/python`; compare against `tutorials/R_solutions` when done.
4. Load data using paths relative to the project root, e.g. `data/boston.csv`.
