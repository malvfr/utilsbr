import gleam/regex

pub fn clean(cnpj: String) {
  let assert Ok(only_numbers_regex) = regex.from_string("[^0-9]")

  regex.replace(each: only_numbers_regex, in: cnpj, with: "")
}