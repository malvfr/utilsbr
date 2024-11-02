import gleam/list
import gleam/regex
import gleam/string

pub fn formatted_cpf_regex() -> regex.Regex {
  let assert Ok(cpf_regex) =
    regex.from_string("^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}$")

  cpf_regex
}

pub fn unformatted_cpf_regex() -> regex.Regex {
  let assert Ok(unfomatted_cpf_regex) =
    regex.from_string("^[0-9]{3}\\.?[0-9]{3}\\.?[0-9]{3}\\-?[0-9]{2}$")

  unfomatted_cpf_regex
}

pub fn unformatted_cnpj_regex() -> regex.Regex {
  let assert Ok(unformatted_cnpj_regex) =
    regex.from_string("^\\d{2}\\.?\\d{3}\\.?\\d{3}/?\\d{4}-?\\d{2}$")
  unformatted_cnpj_regex
}

pub fn formatted_cnpj_regex() -> regex.Regex {
  let assert Ok(formatted_cnpj_regex) =
    regex.from_string("^\\d{2}.\\d{3}.\\d{3}/\\d{4}-\\d{2}$")
  formatted_cnpj_regex
}

pub fn format_cpf(cpf: String) -> String {
  let first_three_digits = string.slice(cpf, 0, 3)
  let second_three_digits = string.slice(cpf, 3, 3)
  let third_three_digits = string.slice(cpf, 6, 3)
  let last_two_digits = string.slice(cpf, 9, 2)

  string.concat([
    first_three_digits,
    ".",
    second_three_digits,
    ".",
    third_three_digits,
    "-",
    last_two_digits,
  ])
}

pub fn all_characteres_are_equal(str: String) {
  str
  |> string.split("")
  |> list.all(fn(elm) { elm == string.slice(str, 0, 1) })
}
