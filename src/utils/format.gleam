import gleam/list
import gleam/regexp
import gleam/string

/// Cache structure to hold precompiled regular expressions
/// This improves performance by avoiding recompilation on every validation
pub type RegexCache {
  RegexCache(
    formatted_cpf: regexp.Regexp,
    unformatted_cpf: regexp.Regexp,
    formatted_cnpj: regexp.Regexp,
    unformatted_cnpj: regexp.Regexp,
    formatted_alphanumeric_cnpj: regexp.Regexp,
    unformatted_alphanumeric_cnpj: regexp.Regexp,
  )
}

/// Build a cache with all precompiled regular expressions
/// This should be called once and reused for multiple validations
pub fn build_regex_cache() -> RegexCache {
  let assert Ok(formatted_cpf) =
    regexp.compile(
      "^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}$",
      regexp.Options(False, False),
    )

  let assert Ok(unformatted_cpf) =
    regexp.compile(
      "^[0-9]{3}\\.?[0-9]{3}\\.?[0-9]{3}\\-?[0-9]{2}$",
      regexp.Options(False, False),
    )

  let assert Ok(unformatted_cnpj) =
    regexp.compile(
      "^\\d{2}\\.?\\d{3}\\.?\\d{3}/?\\d{4}-?\\d{2}$",
      regexp.Options(False, False),
    )

  let assert Ok(formatted_cnpj) =
    regexp.compile(
      "^\\d{2}.\\d{3}.\\d{3}/\\d{4}-\\d{2}$",
      regexp.Options(False, False),
    )

  let assert Ok(formatted_alphanumeric_cnpj) =
    regexp.compile(
      "^[A-Z0-9]{2}\\.[A-Z0-9]{3}\\.[A-Z0-9]{3}/[A-Z0-9]{4}-[0-9]{2}$",
      regexp.Options(False, False),
    )

  let assert Ok(unformatted_alphanumeric_cnpj) =
    regexp.compile("^[A-Z0-9]{12}[0-9]{2}$", regexp.Options(False, False))

  RegexCache(
    formatted_cpf: formatted_cpf,
    unformatted_cpf: unformatted_cpf,
    formatted_cnpj: formatted_cnpj,
    unformatted_cnpj: unformatted_cnpj,
    formatted_alphanumeric_cnpj: formatted_alphanumeric_cnpj,
    unformatted_alphanumeric_cnpj: unformatted_alphanumeric_cnpj,
  )
}

pub fn formatted_cpf_regex() -> regexp.Regexp {
  let assert Ok(cpf_regex) =
    regexp.compile(
      "^[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}$",
      regexp.Options(False, False),
    )

  cpf_regex
}

pub fn unformatted_cpf_regex() -> regexp.Regexp {
  let assert Ok(unfomatted_cpf_regex) =
    regexp.compile(
      "^[0-9]{3}\\.?[0-9]{3}\\.?[0-9]{3}\\-?[0-9]{2}$",
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
      "^\\d{2}.\\d{3}.\\d{3}/\\d{4}-\\d{2}$",
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
