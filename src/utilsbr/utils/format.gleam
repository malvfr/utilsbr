import gleam/list
import gleam/regexp
import gleam/string

pub fn formatted_cpf_regex() -> regexp.Regexp {
  let assert Ok(cpf_regex) =
    regexp.compile(
      "^[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}-[0-9]{2}$",
      regexp.Options(False, False),
    )

  cpf_regex
}

pub fn unformatted_cpf_regex() -> regexp.Regexp {
  // Note: the hyphen is written literally (`-?`), not escaped (`\-?`). Under
  // the JavaScript target's unicode regex mode, `\-` outside a character class
  // is an "Invalid escape" and fails to compile, breaking the JS target.
  let assert Ok(unfomatted_cpf_regex) =
    regexp.compile(
      "^[0-9]{3}\\.?[0-9]{3}\\.?[0-9]{3}-?[0-9]{2}$",
      regexp.Options(False, False),
    )

  unfomatted_cpf_regex
}

pub fn unformatted_cnpj_regex() -> regexp.Regexp {
  let assert Ok(unformatted_cnpj_regex) =
    regexp.compile(
      "^\\d{2}\\.?\\d{3}\\.?\\d{3}/?\\d{4}-?\\d{2}$",
      regexp.Options(False, False),
    )
  unformatted_cnpj_regex
}

pub fn formatted_cnpj_regex() -> regexp.Regexp {
  let assert Ok(formatted_cnpj_regex) =
    regexp.compile(
      "^\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}-\\d{2}$",
      regexp.Options(False, False),
    )
  formatted_cnpj_regex
}

pub fn formatted_alphanumeric_cnpj_regex() -> regexp.Regexp {
  let assert Ok(regex) =
    regexp.compile(
      "^[A-Z0-9]{2}\\.[A-Z0-9]{3}\\.[A-Z0-9]{3}/[A-Z0-9]{4}-[0-9]{2}$",
      regexp.Options(False, False),
    )
  regex
}

pub fn unformatted_alphanumeric_cnpj_regex() -> regexp.Regexp {
  let assert Ok(regex) =
    regexp.compile("^[A-Z0-9]{12}[0-9]{2}$", regexp.Options(False, False))
  regex
}

pub fn format_cpf(cpf: String) -> String {
  let first_three_digits = string.slice(cpf, 0, 3)
  let second_three_digits = string.slice(cpf, 3, 3)
  let third_three_digits = string.slice(cpf, 6, 3)
  let last_two_digits = string.slice(cpf, 9, 2)

  first_three_digits
  <> "."
  <> second_three_digits
  <> "."
  <> third_three_digits
  <> "-"
  <> last_two_digits
}

pub fn format_cnpj(cnpj: String) -> String {
  let first_two_digits = string.slice(cnpj, 0, 2)
  let second_three_digits = string.slice(cnpj, 2, 3)
  let third_three_digits = string.slice(cnpj, 5, 3)
  let fourth_four_digits = string.slice(cnpj, 8, 4)
  let last_two_digits = string.slice(cnpj, 12, 2)

  first_two_digits
  <> "."
  <> second_three_digits
  <> "."
  <> third_three_digits
  <> "/"
  <> fourth_four_digits
  <> "-"
  <> last_two_digits
}

pub fn all_characteres_are_equal(str: String) -> Bool {
  case string.first(str) {
    Ok(first_char) -> {
      string.to_graphemes(str)
      |> list.all(fn(char) { char == first_char })
    }
    Error(_) -> True
  }
}
