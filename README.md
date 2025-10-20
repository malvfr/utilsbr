# utilsbr

[![Package Version](https://img.shields.io/hexpm/v/utilsbr)](https://hex.pm/packages/utilsbr)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/utilsbr/)
[![Total Download](https://img.shields.io/hexpm/dt/utilsbr)](https://hex.pm/packages/utilsbr)
[![License](https://img.shields.io/hexpm/l/utilsbr)](https://hex.pm/packages/utilsbr)
![Last Updated](https://img.shields.io/github/last-commit/malvfr/utilsbr)

A Gleam library for Brazilian documents utilities. It provides functions to validate and generate CPF and CNPJ documents.

## Features

- CPF validation, generation, formatting and stripping
- CNPJ validation (numeric and alphanumeric), generation, formatting and stripping
- Support for both traditional numeric CNPJs (14 digits) and new alphanumeric CNPJs (12 alphanumeric + 2 digit checksum)
- Flexible and strict validation modes

# Installation

Run the following command in your project directory:

```sh
gleam add utilsbr@0.6.0
```

Then run `gleam build` to download and compile the dependencies.

````

# Basic usage

### Import the module

Import the module and use the functions to validate and generate CPF and CNPJ documents.

```gleam
import utilsbr/cpf
import utilsbr/cnpj

pub fn main() {
  // Validate CPF
  cpf.validate("873.220.050-15")

}
````

### CPF functions

```gleam
import utilsbr/cpf

pub fn main() {
  // Validate CPF
  assert True = cpf.validate("873.220.050-15")
  assert False = cpf.validate("123.456.789-09")

  // Strict Validate CPF

  assert True = cpf.strict_validate("873.220.050-15")
  assert False = cpf.strict_validate(" 873.220.050-15 ")
  assert False = cpf.strict_validate(" 873.220.050-15")

  // Generate CPF

  let cpf = cpf.generate()
  > "873.220.050-15"

  // Format CPF

  let cpf = cpf.format("87322005015")

  > "873.220.050-15"
  // Strip CPF

  let cpf = cpf.strip("873.220.050-15")
  > "87322005015"
}
```

### CNPJ functions

```gleam
import utilsbr/cnpj

pub fn main() {
  // Validate CNPJ (numeric)
  assert True = cnpj.validate("84.980.771/0001-82")
  assert False = cnpj.validate("12.345.678/0001-09")

  // Validate CNPJ (alphanumeric) - New feature!
  assert True = cnpj.validate("12.ABC.345/01DE-35")
  assert True = cnpj.validate("12ABC34501DE35")

  // Strict Validate CNPJ

  assert True = cnpj.strict_validate("84.980.771/0001-82")
  assert False = cnpj.strict_validate(" 84.980.771/0001-82 ")
  assert False = cnpj.strict_validate(" 84.980.771/0001-82")

  // Generate CNPJ (numeric)

  let cnpj = cnpj.generate(True)
  > "84.980.771/0001-82"

  // Format CNPJ

  let cnpj = cnpj.format("84980771000182")
  > "84.980.771/0001-82"

  // Strip CNPJ

  let cnpj = cnpj.strip("84.980.771/0001-82")
  > "84980771000182"
}
```

### Alphanumeric CNPJ Support

Starting from version 0.6.0, utilsbr supports the new alphanumeric CNPJ format announced by Receita Federal, which will be implemented from July 2026. The alphanumeric CNPJ has 12 alphanumeric positions (A-Z and 0-9) followed by 2 numeric verification digits.

```gleam
import utilsbr/cnpj
import cnpj/alphanumeric

pub fn main() {
  // Validate alphanumeric CNPJ
  cnpj.validate("12.ABC.345/01DE-35")  // True

  // Clean alphanumeric CNPJ
  alphanumeric.clean_alphanumeric("12.ABC.345/01DE-35")  // "12ABC34501DE35"

  // Format alphanumeric CNPJ
  alphanumeric.format_alphanumeric("12ABC34501DE35")  // "12.ABC.345/01DE-35"

  // Check if CNPJ is alphanumeric
  alphanumeric.is_alphanumeric("12ABC34501DE35")  // True
  alphanumeric.is_alphanumeric("12345678901234")  // False
}
```

Further documentation can be found at <https://hexdocs.pm/utilsbr>.
