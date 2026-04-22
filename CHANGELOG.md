# Changelog

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
