# Changelog

## [0.4.0] - 2026-05-02

### Added
- `TypedPrint.to_csv(data, only:, headers:, delimiter: ",")` — returns CSV string
- `TypedPrint.save(data, path, only:, headers:, delimiter: ",")` — writes CSV file with UTF-8 BOM (Excel-compatible)
- Custom delimiter support (`,` or `;` or any character)
- Fixed edge case: empty data no longer raises on `determine_headers`

## [0.3.0] - 2026-04-27

### Added
- Optional color support via `pastel` gem (runtime optional, dev dependency)
- `color: true` for automatic type-based coloring (headers cyan, numbers green, booleans green/red, nil gray)
- `colors: { col: :color }` for manual per-column color mapping
- Color support for both `:plain` and `:markdown` formats

## [0.2.0] - 2026-04-22

### Added
- Markdown table output with `format: :markdown` option
- New `TypedPrint.table` method returns string without printing
- Support for both plain and markdown formats

### Changed
- Internal refactoring to support multiple output formats

## [0.1.0] - 2026-04-21

### Added
- Initial release
- Basic table formatting for Ruby hashes
- Column alignment options (left, right, center)
- Column filtering with `only:` option
- Custom headers with `headers:` option
- Smart type formatting (booleans, nil, strings)
- Preserves original column order
- Zero dependencies
