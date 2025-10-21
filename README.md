# utilsbr

[![Package Version](https://img.shields.io/hexpm/v/utilsbr)](https://hex.pm/packages/utilsbr)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/utilsbr/)
[![Total Download](https://img.shields.io/hexpm/dt/utilsbr)](https://hex.pm/packages/utilsbr)
[![License](https://img.shields.io/hexpm/l/utilsbr)](https://hex.pm/packages/utilsbr)
![Last Updated](https://img.shields.io/github/last-commit/malvfr/utilsbr)

A Gleam library for Brazilian document validation and generation. Provides utilities for working with CPF and CNPJ documents, including support for the new alphanumeric CNPJ format.

## Features

- **CPF utilities**: validation, generation, formatting, and stripping
- **CNPJ utilities**: validation, generation, formatting, and stripping
- **Unified CNPJ handling**: all functions automatically work with both numeric and alphanumeric formats
- **Alphanumeric CNPJ support**: seamless support for the new format announced by Receita Federal (effective July 2026)
- **Flexible and strict validation modes**: choose between lenient or strict format validation
- **Type-safe**: leverages Gleam's type system for reliable document handling

## Installation

```sh
gleam add utilsbr
```

## Quick Start

```gleam
import utilsbr/cpf
import utilsbr/cnpj

pub fn main() {
  // Validate documents
  cpf.validate("873.220.050-15")  // True

  // Validate both numeric and alphanumeric CNPJs
  cnpj.validate("84.980.771/0001-82")  // True (numeric)
  cnpj.validate("12.ABC.345/01DE-35")  // True (alphanumeric)

  // Format and strip work automatically
  cnpj.format("12ABC34501DE35")  // Ok("12.ABC.345/01DE-35")
  cnpj.strip("84.980.771/0001-82")  // Ok("84980771000182")

  // Generate new documents
  let new_cpf = cpf.generate(True)  // "123.456.789-09"
  let new_cnpj = cnpj.generate(False)  // "12345678000195"
}
```

## API Reference

### CPF

```gleam
import utilsbr/cpf

// Validation - flexible mode (allows whitespace and special chars)
cpf.validate("873.220.050-15")  // True
cpf.validate("  873.220.050-15  ")  // True
cpf.validate("123.456.789-09")  // False

// Validation - strict mode (exact format required)
cpf.strict_validate("873.220.050-15")  // True
cpf.strict_validate(" 873.220.050-15 ")  // False

// Generation
cpf.generate(True)  // "873.220.050-15" (formatted)
cpf.generate(False)  // "87322005015" (unformatted)

// Formatting and stripping
cpf.format("87322005015")  // Ok("873.220.050-15")
cpf.strip("873.220.050-15")  // Ok("87322005015")
```

### CNPJ

All CNPJ functions work seamlessly with both numeric and alphanumeric formats. The library automatically detects the format and applies the appropriate validation and formatting rules.

**Alphanumeric CNPJ Support**: Starting from version 0.6.0, utilsbr supports the new alphanumeric CNPJ format announced by Receita Federal (effective July 2026). The alphanumeric CNPJ consists of 12 alphanumeric characters (A-Z and 0-9) followed by 2 numeric verification digits.

```gleam
import utilsbr/cnpj

// Validation - flexible mode (works with both formats)
cnpj.validate("84.980.771/0001-82")  // True (numeric)
cnpj.validate("12.ABC.345/01DE-35")  // True (alphanumeric)
cnpj.validate("12abc34501de35")     // True (case insensitive)
cnpj.validate("  84.980.771/0001-82  ")  // True
cnpj.validate("12.345.678/0001-09")  // False

// Validation - strict mode (works with both formats)
cnpj.strict_validate("84.980.771/0001-82")   // True (numeric formatted)
cnpj.strict_validate("84980771000182")        // True (numeric unformatted)
cnpj.strict_validate("12.ABC.345/01DE-35")   // True (alphanumeric formatted)
cnpj.strict_validate("12ABC34501DE35")        // True (alphanumeric unformatted)
cnpj.strict_validate("12.abc.345/01de-35")   // True (case insensitive)
cnpj.strict_validate(" 84.980.771/0001-82 ") // False (no spaces allowed)
cnpj.strict_validate("12*ABC*345*01DE*35")   // False (wrong separators)

// Generation (numeric only)
cnpj.generate(True)  // "84.980.771/0001-82" (formatted)
cnpj.generate(False)  // "84980771000182" (unformatted)

// Formatting - automatic detection
cnpj.format("84980771000182")    // Ok("84.980.771/0001-82")
cnpj.format("12ABC34501DE35")    // Ok("12.ABC.345/01DE-35")
cnpj.format("12abc34501de35")    // Ok("12.ABC.345/01DE-35")

// Stripping - automatic detection
cnpj.strip("84.980.771/0001-82")  // Ok("84980771000182")
cnpj.strip("12.ABC.345/01DE-35")  // Ok("12ABC34501DE35")
cnpj.strip("12.abc.345/01de-35")  // Ok("12ABC34501DE35")
```

## Compatibility

This library works on both the Erlang and JavaScript targets.

## Documentation

For detailed API documentation and more examples, visit [HexDocs](https://hexdocs.pm/utilsbr).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache-2.0 License.
