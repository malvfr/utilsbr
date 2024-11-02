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

```gleam
import utilsbr/cpf
import utilsbr/cnpj

pub fn main() {
  cpf.validate("123.456.789-09")
  cpf.strict_validate("123.456.789-09")
  cpf.generate(True)

  cnpj.validate("12.345.678/0001-09")
  cnpj.strict_validate("12.345.678/0001-09")
  cnpj.generate(True)
}
```

Further documentation can be found at <https://hexdocs.pm/utilsbr>.
