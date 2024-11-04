# utilsbr

[![Package Version](https://img.shields.io/hexpm/v/utilsbr)](https://hex.pm/packages/utilsbr)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/utilsbr/)
[![Total Download](https://img.shields.io/hexpm/dt/utilsbr)](https://hex.pm/packages/utilsbr)
[![License](https://img.shields.io/hexpm/l/utilsbr)](https://hex.pm/packages/utilsbr)
![Last Updated](https://img.shields.io/github/last-commit/malvfr/utilsbr)

A Gleam library for Brazilian documents utilities. It provides functions to validate and generate CPF and CNPJ documents.

# Installation

Run the following command in your project directory:

```sh
gleam add utilsbr@1
```

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
```

### CPF functions

```gleam
import utilsbr/cpf

pub fn main() {
  // Validate CPF
  assert True = cpf.validate("873.220.050-15")
  assert False = cpf.validate("123.456.789-09")

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
  // Validate CNPJ
  assert True = cnpj.validate("84.980.771/0001-82")
  assert False = cnpj.validate("12.345.678/0001-09")

  // Generate CNPJ

  let cnpj = cnpj.generate()
  > "84.980.771/0001-82"

  // Format CNPJ

  let cnpj = cnpj.format("84980771000182")

  > "84.980.771/0001-82"

  // Strip CNPJ

  let cnpj = cnpj.strip("84.980.771/0001-82")

  > "84980771000182"
}
```

Further documentation can be found at <https://hexdocs.pm/utilsbr>.
