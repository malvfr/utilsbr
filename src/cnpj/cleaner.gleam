import gleam/regex

/// Cleans a CNPJ string by removing all non-numeric characters.
///
/// This function takes a CNPJ string and uses a regular expression to remove
/// any characters that are not digits (0-9). The cleaned CNPJ string is returned.
///
/// # Parameters
/// - `cnpj`: A string representing the CNPJ to be cleaned.
///
/// # Returns
/// A new string with only the numeric characters from the original CNPJ.
pub fn clean(cnpj: String) {
  let assert Ok(only_numbers_regex) = regex.from_string("[^0-9]")

  regex.replace(each: only_numbers_regex, in: cnpj, with: "")
}
